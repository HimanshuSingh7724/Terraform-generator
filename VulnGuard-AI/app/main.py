# app/main.py

from fastapi import FastAPI
from pydantic import BaseModel

# ✅ Absolute imports for better Windows/uvicorn compatibility
from app.scanner import run_scan
from app.ai_fixer import suggest_fixes

app = FastAPI(title="VulnGuard-AI")

class ScanRequest(BaseModel):
    path: str
    dockerfile: str | None = None
    requirements: str | None = None
    apply: bool = False


# ✅ Root health-check endpoint
@app.get("/")
def read_root():
    return {"message": "VulnGuard-AI API running!"}


# ✅ Main scan endpoint
@app.post("/scan")
def scan_code(req: ScanRequest):
    """Scan the container/app and auto-fix if enabled"""
    try:
        report = run_scan(req.path)
        fixes = suggest_fixes(report, req.dockerfile, req.requirements, apply=req.apply)
        return {"report": report, "fixes": fixes}
    except Exception as e:
        # ✅ Catch exceptions to avoid Internal Server Error
        return {"error": str(e)}
