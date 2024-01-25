#!/usr/bin/env python3

import argparse
import os
import subprocess
from urllib.error import ContentTooShortError, HTTPError
from urllib.request import urlretrieve

from pathlib import Path

DIR = Path(os.path.dirname(os.path.realpath(__file__)))

def build_docker_containers():
    # Fuzzware docker container
    subprocess.check_call([DIR.joinpath("scripts", "build_fuzzware_docker.sh")])

    # Hoedur docker container
    subprocess.check_call([DIR.joinpath("scripts", "build_hoedur_docker.sh")])

def check_install():
    # Run install check script
    subprocess.check_call([DIR / "scripts" / "check_install.py"])

def main():
    build_docker_containers()


    '''
    try:
        check_install()
    except subprocess.CalledProcessError as err:
        print(f"[ERROR] Installation ran to completion, but install check failed.\nError: {err}")
    '''

if __name__ == "__main__":
    main()
