import csv
import os
import subprocess
import sys
import json
import time
from multiprocessing import Pool
import shutil

def get_mid_dir(path):
    path_components = path.split(os.path.sep)
    filename = path_components[-1]
    return path_components[-2], filename.split(".")[0]

def run_slither(path, outdir):
    outpath = os.path.join(outdir, os.path.basename(path).replace(".sol", ".patch.slither.json"))
    if os.path.exists(outpath):
        return 0, outpath
    command = f"slither {path} --json {outpath}"
    # print(command)
    try:
        result = subprocess.run(command, shell=True, timeout=60*10)
        print(result.stdout.decode('utf-8'))
        print(result.stderr.decode('utf-8'))
    except subprocess.TimeoutExpired:
        return -1, outpath
    return result.returncode, outpath

def write_results(results_csv, res):
    with open(results_csv, 'w', newline='') as csvfile:
        for r in res:
            fieldnames = ['path', 'return_code']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writerow({
                    'path': r[0],
                    'return_code': r[1]
                })

def use_solc(version):
    install = f"solc-select install {version}"
    use = f"solc-select use {version}"
    try:
        process = subprocess.run(install, shell=True, check=True)
        process = subprocess.run(use, shell=True, check=True)

        return process.returncode == 0
    except:
        return False

def generate_defect_list(path, report_path, output_dir):
    contract_name = os.path.basename(path)

    defectList = []
    try:
        print(contract_name)
        vdict = {}
        vdict['name'] = contract_name
        vdict['defect'] = []
        with open(report_path) as fd:
            content = json.loads(fd.read())
            unchecked_line = []
            reentrancy_line = []
            ac_line = []
            greedy_line = []
            strictb_line = []
            for item in content['results']['detectors']:
                if item['check'] == 'locked-ether':
                    location = item['elements'][0]
                    contractline = location['type'] + ' ' + location['name']
                    lineno = 1
                    with open(os.path.join(path)) as contract:
                        ccontent = contract.readlines()
                        for line in ccontent:
                            if contractline in line:
                                greedy_line.append(lineno)
                                break
                            lineno+=1
                elif item['check'] == 'incorrect-equality':
                    location  = item['elements'][1]
                    if 'this.balance' in location['name']:
                        vtype = 'strict_balance'
                        strictb_line.append(location['source_mapping']['lines'][0])
                elif item['check'] == 'tx-origin':
                    location  = item['elements'][1]
                    ac_line.append(location['source_mapping']['lines'][0])
                    vtype = 'access_control'
                elif item['check'] == 'unchecked-lowlevel' or item['check'] == 'unchecked-send' or item['check'] == 'unused-return':
                    vtype = 'unchecked_low_level_calls'
                    location = item['elements'][1]
                    # contractline = location['name']
                    unchecked_line.append(int(location['source_mapping']['lines'][0]))
                elif item['check'] == 'reentrancy-eth' or item['check'] == 'reentrancy-no-eth':
                    vtype = 'reentrancy'
                    location = item['elements'][1]
                    #  contractline = location['name']
                    reentrancy_line.append(int(location['source_mapping']['lines'][0]))
            
            if len(greedy_line) > 0:
                cdict = {}
                cdict['lines'] = greedy_line
                cdict['category'] = 'greedy'
                vdict['defect'].append(cdict)
            
            if len(strictb_line) > 0:
                cdict = {}
                cdict['lines'] = strictb_line
                cdict['category'] = 'strict_balance'
                vdict['defect'].append(cdict)
            
            if len(ac_line) > 0:
                cdict = {}
                cdict['lines'] = ac_line
                cdict['category'] = 'access_control'
                vdict['defect'].append(cdict)
            
            if len(reentrancy_line) > 0:
                cdict = {}
                cdict['lines'] = reentrancy_line
                cdict['category'] = 'reentrancy'
                vdict['defect'].append(cdict)
            
            if len(unchecked_line) > 0:
                cdict = {}
                cdict['lines'] = unchecked_line
                cdict['category'] = 'unchecked_low_level_calls'
                vdict['defect'].append(cdict)
        defectList.append(vdict)
    except Exception as e:
        defectList.append('failed ' + str(e))
    print(defectList)

    with open(os.path.join(output_dir, contract_name.replace(".sol", "") + '.defectList.json'), 'w+') as outf:
        outf.write(json.dumps(defectList))

def process_entry(path, outdir):

    print(path)

    els = path.split(os.path.sep)
    file = els[-1].replace(".sol", '')
    mid = els[-3:-1]
    mid = os.path.join(*mid)
    outdir = os.path.join(outdir, mid)
    print("Making...", outdir)
    os.makedirs(outdir, exist_ok=True)

    try:
        return_code, report_path = run_slither(path, outdir)
        # print("running defect list... ")
        generate_defect_list(path, report_path, outdir)
    except Exception as e:
        print(e)
        return_code = -1
        report_path = None

    return path, return_code

def get_args(patches_dir, output_dir):
    args = []

    patches = os.path.join(patches_dir, "valid_patches.csv")
    with open(patches, 'r') as file:
        data = csv.reader(file)
        next(data)

        for row in data:
            args.append((os.path.join(patches_dir, row[0].strip()), output_dir))

    return args

# def write_log(res, output_dir):
#     for r in res:
#         stdout = r[4]
#         stderr = r[5]
#         path = r[0]
#         mid, file = get_mid_dir(path)
#         outdir = os.path.join(output_dir, mid)
#         outdir = os.path.join(outdir, file)
#         os.makedirs(outdir, exist_ok=True)
#         stdout_file = os.path.join(outdir, file+ ".out")
#         print(stdout_file)
#         stderr_file = os.path.join(outdir, file+ ".log")
#         print(stderr_file)
#         with open(stdout_file, 'w') as file:
#             file.write(stdout)
#         with open(stderr_file, 'w') as file:
#             file.write(stderr)


def main():

    if len(sys.argv) != 4:
        print("Usage: python run_on_smartbugs.py <patches_directory> <output_directory> <processes>")
        sys.exit(1)

    patches_dir = sys.argv[1]
    output_dir = sys.argv[2]
    processes = int(sys.argv[3])

    with Pool(processes) as pool:
        res = pool.starmap(process_entry, get_args(patches_dir, output_dir))
    
    csv_file = os.path.join(output_dir, 'results.csv')
    write_results(csv_file, res)
    

if __name__ == "__main__":
    main()
