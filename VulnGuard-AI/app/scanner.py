import subprocess
import json
import shutil

# ✅ Trivy ka exact path find karo, agar nahi mile to default '/usr/local/bin/trivy'
TRIVY_PATH = shutil.which("trivy") or "/usr/local/bin/trivy"

def run_scan(path: str) -> dict:
    """Run Trivy scan on given path"""
    try:
        # Trivy filesystem scan
        result = subprocess.run(
            [TRIVY_PATH, "fs", "--quiet", "--format", "json", path],
            capture_output=True,
            text=True,
            check=True
        )
        # Agar empty string aaye to empty dict return kare
        if not result.stdout.strip():
            return {"Results": []}

        return json.loads(result.stdout)

    except subprocess.CalledProcessError as e:
        # Errors ko consistent JSON format me return kare
        return {"error": e.stderr or str(e)}

    except json.JSONDecodeError as je:
        return {"error": f"JSON parse error: {str(je)}"}

    except Exception as ex:
        return {"error": str(ex)}
