import os
import re
import subprocess
import sys

def use_solc_version(version):
    solc_version = f"solc-select use --always-install {version}"
    process = subprocess.run(solc_version, shell=True)
    return process.returncode

def compile_contract(file_path):
    compile = f"solc {file_path}"
    process = subprocess.run(compile, shell=True)
    return process.returncode

def check_compilability(file_path):
    temp = file_path.replace('.sol', '_temp.sol')
    if not os.path.exists(temp):
        try:
            with open(file_path, 'r') as file:
                content = file.readlines()
        except FileNotFoundError:
            print(f"File not found: {file_path}")
            return

        pragma_pattern = re.compile(r'^\s*pragma\s+solidity\s+\^?\d+\.\d+\.\d+;')
        new_content = []
        for line in content:
            if not pragma_pattern.match(line):
                new_content.append(line)
        with open(temp, 'w') as file:
            for line in new_content:
                file.write(line)
    return compile_contract(temp)

def get_files(directory):
    files = []
    for root, _, file_names in os.walk(directory):
        for file_name in file_names:
            if file_name.endswith('.sol') and not file_name.endswith('_temp.sol'):
                files.append(os.path.join(root, file_name))
    print(files)
    return files

def compile_all(directory, version):
    files = get_files(directory)
    results = os.path.join(directory, f'compilation_results_{version}.csv')
    with open(results, 'w') as file:
        for file_path in files:
            file.write(f"{file_path}")
            ret = check_compilability(file_path)
            file.write(f",{ret}\n")

def remove_all_temp_files(directory):
    for root, _, file_names in os.walk(directory):
        for file_name in file_names:
            if file_name.endswith('_temp.sol'):
                os.remove(os.path.join(root, file_name))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: python {sys.argv[0]} <pragma_version> <directory>")
        sys.exit(1)

    pragma_version = sys.argv[1]

    ret = use_solc_version(pragma_version)

    directory = sys.argv[2]
    compile_all(directory, pragma_version)
    remove_all_temp_files(directory)


