import cv2
import numpy as np
import json
import os

def analyze_map(image_path, output_path):
    print(f"Analyzing {image_path}...")
    img = cv2.imread(image_path)
    if img is None:
        print("Error: Could not read image.")
        return

    height, width = img.shape[:2]
    print(f"Image dimensions: {width}x{height}")

    # Convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # Blur to reduce noise
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # Canny edge detection
    edges = cv2.Canny(blurred, 50, 150)

    # Find contours
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    print(f"Found {len(contours)} contours.")

    drill_zones = []
    
    debug_img = img.copy()

    for cnt in contours:
        # Approximate contour to polygon
        peri = cv2.arcLength(cnt, True)
        approx = cv2.approxPolyDP(cnt, 0.02 * peri, True)
        
        # Bounding rect
        x, y, w, h = cv2.boundingRect(approx)
        
        # Calculate area
        area = w * h
        
        # Filter by area (squares should be substantial)
        # Based on previous run, main squares are ~7000 pixels
        if 4000 < area < 12000:
            # Check aspect ratio (square-ish)
            aspect_ratio = w / float(h)
            if 0.8 < aspect_ratio < 1.2:
                # Calculate center
                center_x = x + w / 2
                center_y = y + h / 2
                
                # Store normalized data
                drill_zones.append({
                    "id": 0, # Placeholder
                    "center_x": center_x / width,
                    "center_y": center_y / height,
                    "width": w / width,
                    "height": h / height,
                    "raw_x": x,
                    "raw_y": y,
                    "raw_w": w,
                    "raw_h": h
                })

    # Remove duplicates (nested contours often appear for thick lines)
    unique_zones = []
    for zone in drill_zones:
        is_duplicate = False
        for existing in unique_zones:
            dist = np.sqrt((zone["center_x"] - existing["center_x"])**2 + 
                           (zone["center_y"] - existing["center_y"])**2)
            if dist < 0.02: # Threshold for duplicate
                is_duplicate = True
                # Keep the larger one
                if zone["raw_w"] * zone["raw_h"] > existing["raw_w"] * existing["raw_h"]:
                    existing.update(zone)
                break
        if not is_duplicate:
            unique_zones.append(zone)

    print(f"Filtered to {len(unique_zones)} potential zones.")

    # Sort by Y first (rows), then X (columns).
    unique_zones.sort(key=lambda z: z["center_y"])
    
    # Group into rows
    rows = []
    current_row = []
    if unique_zones:
        current_row.append(unique_zones[0])
        
        for i in range(1, len(unique_zones)):
            zone = unique_zones[i]
            prev_zone = unique_zones[i-1]
            
            # If Y difference is small, same row
            if abs(zone["center_y"] - prev_zone["center_y"]) < 0.1:
                current_row.append(zone)
            else:
                # Sort current row by X
                current_row.sort(key=lambda z: z["center_x"])
                rows.append(current_row)
                current_row = [zone]
        
        # Append last row
        current_row.sort(key=lambda z: z["center_x"])
        rows.append(current_row)

    # Assign IDs
    final_zones = []
    current_id = 1
    
    for row in rows:
        for zone in row:
            zone["id"] = current_id
            final_zones.append(zone)
            
            # Draw debug info
            cv2.rectangle(debug_img, (zone["raw_x"], zone["raw_y"]), 
                          (zone["raw_x"] + zone["raw_w"], zone["raw_y"] + zone["raw_h"]), (0, 255, 0), 2)
            cv2.putText(debug_img, str(current_id), (zone["raw_x"], zone["raw_y"] - 5), 
                        cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
            
            current_id += 1

    # Save debug image
    cv2.imwrite("debug_map.jpg", debug_img)
    print("Saved debug_map.jpg")

    # Output JSON
    config = {
        "image_width": width,
        "image_height": height,
        "zones": [{
            "id": z["id"],
            "center": [z["center_x"], z["center_y"]],
            "size": [z["width"], z["height"]]
        } for z in final_zones]
    }

    with open(output_path, 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"Saved config to {output_path} with {len(final_zones)} zones.")

if __name__ == "__main__":
    analyze_map("map_image.jpg", "map_config.json")
