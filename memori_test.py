import os
from memori import Memori
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables (expecting OPENAI_API_KEY)
load_dotenv()

def main():
    print("Initializing Memori...")
    
    # Check for API Key
    if not os.getenv("OPENAI_API_KEY"):
        print("WARNING: OPENAI_API_KEY not found in environment. Memori requires an LLM provider.")
        print("Please set OPENAI_API_KEY in a .env file.")
        return

    # Initialize Memori
    # conscious_ingest=True enables short-term working memory injection
    try:
        memori = Memori(conscious_ingest=True)
        memori.enable()
        print("Memori enabled successfully.")
    except Exception as e:
        print(f"Failed to initialize Memori: {e}")
        return

    client = OpenAI()

    print("\n--- Interaction 1: Teaching Memori ---")
    user_input = "My name is Andre and I am building Project Apollo, a cyber-sport fitness app."
    print(f"User: {user_input}")
    
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": user_input}]
        )
        print(f"AI: {response.choices[0].message.content}")
    except Exception as e:
        print(f"Error during interaction 1: {e}")

    print("\n--- Interaction 2: Testing Recall ---")
    user_input_2 = "What is the name of my project?"
    print(f"User: {user_input_2}")
    
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": user_input_2}]
        )
        print(f"AI: {response.choices[0].message.content}")
    except Exception as e:
        print(f"Error during interaction 2: {e}")

if __name__ == "__main__":
    main()
