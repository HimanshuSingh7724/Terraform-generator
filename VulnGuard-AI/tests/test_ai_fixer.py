from app.ai_fixer import suggest_fixes

def test_ai_fixer_empty():
    report = {}
    fixes = suggest_fixes(report, None, None)
    assert fixes[0]["msg"] == "No vulnerabilities found"
