import sys
import yaml
from pathlib import Path
from jinja2 import Environment, FileSystemLoader

def generate_template_for_1(values):
    p = Path.cwd() / ".." / "1-preprovision"

    template_dir = 'templates'
    env = Environment(
        loader=FileSystemLoader(template_dir),
    )

    one_template = env.get_template('1.tmpl')
    output = p / "terraform.tfvars.generated" # TODO: This should be terraform.tfvars when done.

    output.write_text(one_template.render(values))
