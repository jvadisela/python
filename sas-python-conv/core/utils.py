import os
import yaml

# parse YAML file
def read_yaml(file_path):
    with open(file_path, "r") as f:
        return yaml.safe_load(f)

def root_dir() -> str:
    root_dir = os.path.abspath(os.curdir)
    return root_dir
