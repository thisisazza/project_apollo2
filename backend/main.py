from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
import json
import os
from typing import List, Dict, Any

app = FastAPI()

# Directory where drill JSONs are stored
DRILLS_DIR = "drills"

@app.get("/")
def read_root():
    return {"message": "Project Apollo Backend is running"}

@app.get("/drills")
def get_drills() -> List[Dict[str, Any]]:
    drills = []
    if not os.path.exists(DRILLS_DIR):
        return []
    
    for filename in os.listdir(DRILLS_DIR):
        if filename.endswith(".json"):
            file_path = os.path.join(DRILLS_DIR, filename)
            try:
                with open(file_path, "r") as f:
                    data = json.load(f)
                    # Extract the inner "drill" object if it exists, otherwise use the whole object
                    drill_data = data.get("drill", data)
                    drills.append(drill_data)
            except Exception as e:
                print(f"Error reading {filename}: {e}")
    return drills

@app.get("/drills/{drill_id}")
def get_drill(drill_id: str):
    file_path = os.path.join(DRILLS_DIR, f"{drill_id}.json")
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="Drill not found")
    
    try:
        with open(file_path, "r") as f:
            data = json.load(f)
            return data.get("drill", data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error reading drill: {str(e)}")

# Optional: Serve static assets if needed
# app.mount("/static", StaticFiles(directory="static"), name="static")

from pydantic import BaseModel
from agent.generator import DrillGenerator

class DrillRequest(BaseModel):
    category: str
    difficulty: str

@app.post("/generate_drill")
def generate_drill(request: DrillRequest):
    generator = DrillGenerator()
    drill_json = generator.generate_drill(request.category, request.difficulty)
    
    # Save to file
    filename = f"{drill_json['id']}.json"
    file_path = os.path.join(DRILLS_DIR, filename)
    
    # Ensure directory exists
    os.makedirs(DRILLS_DIR, exist_ok=True)
    
    with open(file_path, "w") as f:
        json.dump(drill_json, f, indent=2)
        
    return drill_json

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
