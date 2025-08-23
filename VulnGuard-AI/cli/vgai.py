import click
from app.scanner import run_scan
from app.ai_fixer import suggest_fixes

@click.command()
@click.option("--path", required=True, help="Path to scan")
@click.option("--dockerfile", help="Path to Dockerfile")
@click.option("--requirements", help="Path to requirements.txt")
@click.option("--apply", is_flag=True, help="Apply fixes automatically")
def cli(path, dockerfile, requirements, apply):
    """CLI tool for VulnGuard-AI"""
    report = run_scan(path)
    fixes = suggest_fixes(report, dockerfile, requirements, apply)
    click.echo(f"Report: {report}")
    click.echo(f"Fixes: {fixes}")

if __name__ == "__main__":
    cli()
