import re
from pathlib import Path
from typing import List, Dict, Union

def suggest_fixes(report: dict, dockerfile: str | None, requirements: str | None, apply=False) -> List[Dict]:
    fixes = []

    if "Results" not in report or not report["Results"]:
        return [{"msg": "No vulnerabilities found"}]

    for res in report.get("Results", []):
        for vuln in res.get("Vulnerabilities", []):
            pkg = vuln.get("PkgName")
            fixed = vuln.get("FixedVersion")

            if not pkg or not fixed:
                continue

            if dockerfile and Path(dockerfile).exists():
                fix = fix_dockerfile(dockerfile, pkg, fixed, apply)
                if fix:
                    fixes.append(fix)

            if requirements and Path(requirements).exists():
                fix = fix_requirements(requirements, pkg, fixed, apply)
                if fix:
                    fixes.append(fix)

    return fixes

def fix_dockerfile(dockerfile: str, pkg: str, fixed: str, apply: bool) -> Union[Dict, None]:
    path = Path(dockerfile)
    text = path.read_text()
    pattern = rf"{pkg}[:=]?\S*"
    replacement = f"{pkg}={fixed}"

    if re.search(pattern, text):
        fixed_text = re.sub(pattern, replacement, text)
        if apply:
            path.write_text(fixed_text)
        return {"file": dockerfile, "pkg": pkg, "fix": replacement}
    return None

def fix_requirements(requirements: str, pkg: str, fixed: str, apply: bool) -> Union[Dict, None]:
    path = Path(requirements)
    text = path.read_text()
    pattern = rf"{pkg}==\S+"
    replacement = f"{pkg}=={fixed}"

    if re.search(pattern, text):
        fixed_text = re.sub(pattern, replacement, text)
        if apply:
            path.write_text(fixed_text)
        return {"file": requirements, "pkg": pkg, "fix": replacement}
    return None
