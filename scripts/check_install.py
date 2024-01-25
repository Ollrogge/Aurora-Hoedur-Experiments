#!/usr/bin/env python3

import os
import subprocess

from pathlib import Path

DIR = Path(os.path.dirname(os.path.realpath(__file__)))


def check_fuzzware():
    print('Checking fuzzer install...')

    subprocess.check_output([
        DIR / 'fuzzware' / 'run_fuzzware_docker.sh',
        'fuzzware',
        'model',
        '-h',
    ])


def check_hoedur():
    print('Checking hoedur docker...')

    # verify uid/gid matching in docker
    subprocess.check_output([
        DIR / 'run_in_docker.sh',
        'git',
        'status'
    ])

    # verify hoedur is available
    subprocess.check_output([
        DIR / 'run_in_docker.sh',
        'hoedur-arm',
        '--help'
    ])


def main():
    #check_fuzzware()
    check_hoedur()

if __name__ == "__main__":
    main()