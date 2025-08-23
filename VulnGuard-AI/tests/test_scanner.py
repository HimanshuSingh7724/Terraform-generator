from app.scanner import run_scan

def test_scanner_no_path():
    result = run_scan("non_existing_path")
    assert "error" in result
