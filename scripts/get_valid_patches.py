import csv
import os
import sys


def get_valid_patches_bin(diff, returncodes):
    # read csv file and get the first column of each row
    diff_patches = []
    with open(diff, 'r') as f:
        reader = csv.reader(f)
        # skip the header
        next(reader)
        for row in reader:
            if row[-1] == 'False':
                continue
            elms = row[0].split('/')
            source = os.path.join(elms[0], elms[-1])
            diff_patches.append([source, row[0]])
    valid = []
    with open(returncodes, 'r') as f:
        reader = csv.reader(f)
        # skip the header
        next(reader)
        for row in reader:
            elms = row[0].split('/')[-2:]
            source = os.path.join(elms[0], elms[-1].replace('.sol', '.bin'))
            print(source)
            # source = os.path.join(*elms).replace('.sol', '.bin')
            for patch, path in diff_patches:
                # print(patch)
                if source == patch:
                    valid.append([path, row[1]])
                    break
    
    return valid

def get_valid_patches(diff, returncodes, compiled):
    # read csv file and get the first column of each row
    diff_patches = []
    with open(diff, 'r') as f:
        reader = csv.reader(f)
        # skip the header
        next(reader)
        for row in reader:
            if row[-1] == 'False':
                continue
            elms = row[0].split('/')
            source = os.path.join(elms[0], elms[-1])
            diff_patches.append([source, row[0]])
    print('diff:', len(diff_patches))
    diff_compiled = []
    with open(compiled, 'r') as f:
        reader = csv.reader(f)
        # skip the header
        next(reader)
        for row in reader:
            if int(row[-1]) != 0:
                continue
            for patch, path in diff_patches:
                if row[0] == path:
                    diff_compiled.append([patch, row[0]])
                    break
    print('diff_compiled:', len(diff_compiled))
    valid = []
    ret = []
    with open(returncodes, 'r') as f:
        reader = csv.reader(f)
        # skip the header
        next(reader)
        for row in reader:
            elms = row[0].split('/')[2:]
            source = os.path.join(*elms)
            ret.append([source, row[1]])
    
    for patch, path in diff_compiled:
        for source, main in ret:
            if source.replace('.sol', '') in patch:
                valid.append([path, main])
                break
    
    return valid

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Usage: python get_valid_patches.py diff.csv returncodes.csv [compiled.csv]')
        sys.exit(1)
    diff = sys.argv[1]
    returncodes = sys.argv[2]
    compiled = sys.argv[3] if len(sys.argv) == 4 else None
    if compiled is None:
        valid = get_valid_patches_bin(diff, returncodes)
    else:
        valid = get_valid_patches(diff, returncodes, compiled)

    with open('valid_patches.csv', 'w') as f:
        writer = csv.writer(f)
        writer.writerow(['patch', 'main contract'])
        writer.writerows(valid)
        