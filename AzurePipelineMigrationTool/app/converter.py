def azure_to_github(azure_yaml: str) -> str:
    lines = azure_yaml.splitlines()
    github_lines = [
        "name: Migrated Azure Pipeline",
        "on: [push]",
        "jobs:",
        "  build:",
        "    runs-on: ubuntu-latest",
        "    steps:"
    ]
    
    for line in lines:
        if "script:" in line:
            command = line.strip().split("script:")[-1].strip()
            github_lines.append(f"      - run: {command}")

    return "\n".join(github_lines)
