from fastapi import FastAPI, WebSocket, WebSocketDisconnect, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from src.core.config import get_settings
from contextlib import asynccontextmanager
import logging
from ultralytics import YOLO
import cv2
import numpy as np
from pydantic import BaseModel
from typing import List, Optional

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

settings = get_settings()

class Keypoint(BaseModel):
    x: float
    y: float
    confidence: Optional[float] = None

class PoseResponse(BaseModel):
    keypoints: List[Keypoint]

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Load Models & Memori
    logger.info("Starting up Project Apollo Backend...")
    try:
        # Load YOLOv8 Pose model
        # Using 'yolov8n-pose.pt' (nano) for speed, or 'yolov8s-pose.pt' for better accuracy
        import os
        model_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'yolov8n-pose.pt')
        if not os.path.exists(model_path):
             # Fallback to current directory if not found in expected location (e.g. if running from root)
             model_path = 'yolov8n-pose.pt'
        
        logger.info(f"Loading model from: {model_path}")
        app.state.model = YOLO(model_path)
        logger.info("YOLOv8 Pose model loaded successfully.")
    except Exception as e:
        logger.error(f"Failed to load YOLO model: {e}")
        raise e

    yield
    # Shutdown
    logger.info("Shutting down...")

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    lifespan=lifespan
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to Project Apollo API", "status": "active"}

@app.post("/analyze-pose/", response_model=PoseResponse)
async def analyze_pose(file: UploadFile = File(...)):
    """
    Analyzes a single image frame for pose estimation.
    Returns a list of 17 keypoints (COCO format).
    """
    if not hasattr(app.state, "model"):
         return {"error": "Model not loaded"}

    try:
        # Read image file
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Run inference
        results = app.state.model(img)
        
        # Extract keypoints
        # results[0].keypoints.xy is a tensor of shape (N, 17, 2)
        # We assume single person for now or take the first one
        keypoints_list = []
        if results and len(results) > 0 and results[0].keypoints is not None:
            # Get the first person detected
            kpts = results[0].keypoints.data[0].tolist() # (17, 3) usually x, y, conf
            
            for kp in kpts:
                # YOLOv8 pose returns x, y, conf (if available)
                # Check dimensions
                x, y = kp[0], kp[1]
                conf = kp[2] if len(kp) > 2 else None
                keypoints_list.append(Keypoint(x=x, y=y, confidence=conf))

        return PoseResponse(keypoints=keypoints_list)

    except Exception as e:
        logger.error(f"Error analyzing pose: {e}")
        return {"error": str(e)}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            # Echo for now, but this is where we'd stream real-time analysis results
            await websocket.send_text(f"Message received: {data}")
    except WebSocketDisconnect:
        logger.info("Client disconnected")
