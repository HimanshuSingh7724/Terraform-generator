import os, json
from dotenv import load_dotenv
import google.generativeai as genai
import speech_recognition as sr
import pyttsx3
from flask import Flask, request, render_template
from PyPDF2 import PdfReader

# === Load API Key ===
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), ".env"))
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise Exception("❌ GEMINI_API_KEY not found in .env file.")

# === Configure Gemini ===
genai.configure(api_key=api_key)
MODEL_NAME = 'models/gemini-2.5-pro'
model = genai.GenerativeModel(MODEL_NAME)

# === Voice & TTS Setup ===
tts = pyttsx3.init()
recognizer = sr.Recognizer()

HISTORY_FILE = os.path.join(os.path.dirname(__file__), 'chat_history.json')
history = []

# === Load Previous Chat History ===
if os.path.exists(HISTORY_FILE):
    try:
        history = json.load(open(HISTORY_FILE, 'r'))
    except:
        history = []

# === Speak Function ===
def speak(text):
    try:
        tts.say(text)
        tts.runAndWait()
    except:
        print("🔇 TTS error")

# === Listen from Microphone ===
def listen():
    with sr.Microphone() as mic:
        print("🎙️ Listening...")
        try:
            audio = recognizer.listen(mic, timeout=5)
            return recognizer.recognize_google(audio)
        except sr.WaitTimeoutError:
            return "Listening timed out."
        except sr.UnknownValueError:
            return "Sorry, I didn't understand."
        except Exception as e:
            return f"Error: {e}"

# === PDF File Handling ===
def handle_file(path):
    if not os.path.exists(path):
        return "❌ File not found."
    text = ""
    try:
        reader = PdfReader(path)
        for page in reader.pages:
            text += page.extract_text() or ""
        return text or "⚠️ No readable text found in PDF."
    except Exception as e:
        return f"❌ Error reading file: {e}"

# === Query Gemini ===
def query_gemini(prompt):
    try:
        response = model.generate_content(prompt)
        answer = response.text.strip()
        history.append({"user": prompt, "bot": answer})
        with open(HISTORY_FILE, 'w') as f:
            json.dump(history, f, indent=2)
        return answer
    except Exception as e:
        return f"❌ Gemini API error: {e}"

# === Terminal Chat ===
def terminal_run():
    print(f"🤖 Gemini Copilot Ready (model: {MODEL_NAME})\nCommands: 'exit', 'voice', 'file <path>'\n")
    while True:
        cmd = input("You: ").strip()
        use_voice = False

        if cmd.lower() in ['exit', 'quit']:
            print("👋 Goodbye!")
            break
        elif cmd.lower() == 'voice':
            cmd = listen()
            print(f"You (voice): {cmd}")
            use_voice = True
        elif cmd.startswith('file '):
            path = cmd.split(' ',1)[1].strip()
            cmd = handle_file(path)
            print("📄 File content loaded.")

        if not cmd:
            continue

        result = query_gemini(cmd)
        print("🤖 Copilot:", result)

        if use_voice:
            speak(result)

# === Flask Web Interface ===
app = Flask(__name__, template_folder='templates')

@app.route("/", methods=["GET", "POST"])
def index():
    ui, resp = "", ""
    if request.method == "POST":
        ui = request.form.get("user_input", "")
        if ui.startswith("file:"):
            prompt = handle_file(ui.split("file:", 1)[1].strip())
        else:
            prompt = ui.strip()
        resp = query_gemini(prompt)
    return render_template("index.html", user_input=ui, response=resp)

def run_server():
    app.run(host="0.0.0.0", port=5000, debug=True)

# === Entry Point ===
if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "web":
        run_server()
    else:
        terminal_run()
