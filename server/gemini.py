"""
Install the Google AI Python SDK

$ pip install google-generativeai
"""

def ai_summary(message):
  import os
  from dotenv import load_dotenv
  import google.generativeai as genai
  import get_info
  from google.ai.generativelanguage_v1beta.types import content
  # Load environment variables from .env file
  load_dotenv()

  genai.configure(api_key=os.environ["GEMINI_API_KEY"])

  # Create the model
  generation_config = {
    "temperature": 0.75,
    "top_p": 0.95,
    "top_k": 64,
    "max_output_tokens": 8192,
    "response_schema": content.Schema(
      type = content.Type.OBJECT,
      properties = {
        "response": content.Schema(
          type = content.Type.STRING,
        ),
      },
    ),
    "response_mime_type": "application/json",
  }

  model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config,
    # safety_settings = Adjust safety settings
    # See https://ai.google.dev/gemini-api/docs/safety-settings
    system_instruction="you are an assistant of an investigation officer and he is creating a report of suspects instagram account and you have to give a summary of the report. Be concise and use official language, try to write atleast 4-5 lines of summary.",
  )

  chat_session = model.start_chat(
    history=[]
  )
  messgage = message

  response = chat_session.send_message(messgage)
  text = response._result.candidates[0].content.parts[0].text
  return text


