import json
import random
import uuid
from typing import Dict, Any

class DrillGenerator:
    """
    A mock content agent that generates football drills by randomizing templates.
    In a real implementation, this would call an LLM.
    """

    def __init__(self):
        self.templates = {
            "Passing": [
                {
                    "title_prefix": "Precision Passing",
                    "description": "Focus on accuracy and timing.",
                    "steps": [
                        {"instruction": "Pass to target A", "action": "pass", "target": "A"},
                        {"instruction": "Receive from rebounder", "action": "receive", "target": "self"},
                        {"instruction": "Pass to target B", "action": "pass", "target": "B"},
                    ]
                },
                {
                    "title_prefix": "Triangle Passing",
                    "description": "Quick one-touch passing in a triangle.",
                    "steps": [
                        {"instruction": "Pass to cone 1", "action": "pass", "target": "1"},
                        {"instruction": "Move to space", "action": "move", "target": "space"},
                        {"instruction": "Receive and pass to cone 2", "action": "pass", "target": "2"},
                    ]
                }
            ],
            "Dribbling": [
                {
                    "title_prefix": "Cone Weave",
                    "description": "Tight control through cones.",
                    "steps": [
                        {"instruction": "Dribble through cones", "action": "dribble", "target": "cones"},
                        {"instruction": "Sprint to finish", "action": "sprint", "target": "finish"},
                    ]
                },
                {
                    "title_prefix": "1v1 Simulation",
                    "description": "Beat the defender simulation.",
                    "steps": [
                        {"instruction": "Approach defender", "action": "dribble", "target": "defender"},
                        {"instruction": "Perform skill move", "action": "skill", "target": "defender"},
                        {"instruction": "Accelerate past", "action": "sprint", "target": "space"},
                    ]
                }
            ],
            "Shooting": [
                {
                    "title_prefix": "Power Strike",
                    "description": "Shooting with power from distance.",
                    "steps": [
                        {"instruction": "Touch ball forward", "action": "dribble", "target": "forward"},
                        {"instruction": "Strike at goal", "action": "shoot", "target": "goal"},
                    ]
                }
            ]
        }

    def generate_drill(self, category: str, difficulty: str) -> Dict[str, Any]:
        """Generates a drill JSON based on category and difficulty."""
        
        # Default to Passing if category not found
        cat_templates = self.templates.get(category, self.templates["Passing"])
        template = random.choice(cat_templates)
        
        drill_id = str(uuid.uuid4())
        title = f"{difficulty} {template['title_prefix']} {random.randint(1, 100)}"
        
        # Adjust duration based on difficulty
        duration_map = {"Beginner": 300, "Intermediate": 600, "Advanced": 900}
        duration = duration_map.get(difficulty, 600)

        steps = []
        for i, step_template in enumerate(template["steps"]):
            step = {
                "id": f"step_{i+1}",
                "instruction": step_template["instruction"],
                "voice_command": step_template["instruction"],
                "action_type": step_template["action"],
                "target_zone": step_template["target"],
                "timeout_seconds": 10,
                "next_step_delay_seconds": 2
            }
            steps.append(step)

        drill_json = {
            "id": drill_id,
            "title": title,
            "description": template["description"],
            "difficulty": difficulty,
            "category": category,
            "duration_seconds": duration,
            "author": "AI Coach (Mock)",
            "steps": steps
        }
        
        return drill_json
