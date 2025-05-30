
import os
import sys


def different_content(file_path1, file_path2):
    try:
        with open(file_path1, 'rb') as file1, open(file_path2, 'rb') as file2:
            data1 = file1.read()
            data2 = file2.read()

            if data1 == data2:
                return False
            else:
                return True
    except FileNotFoundError as e:
        print(f"Error: {e}")
        return False
    
def get_files(smartbugs, results, max_depth=3):
    smartbugs = os.path.join(smartbugs, "dataset")
    files = []
    for root, _, filenames in os.walk(results):
        depth = root.count(os.sep) - results.count(os.sep)
        if depth > max_depth:
            continue
        for filename in filenames:
                if filename.endswith(".sol"):
                    pair = []
                    patch = os.path.join(root, filename)
                    pair.append(patch)
                    path_elements = patch.split("/")[-3:-1]
                    source = os.path.join(smartbugs, *path_elements) + ".sol"
                    pair.append(source)
                    files.append(pair)

    return files

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 check_diff_patches.py <smartbugs_directory> <results>")
        sys.exit(1)
    smartbugs = os.path.abspath(sys.argv[1])
    results = os.path.abspath(sys.argv[2])
    l = get_files(smartbugs, results)
    results_file = os.path.join(results, "patches_diff.csv")
    with open(results_file, "w") as f:
        f.write("file1,file2,diff\n")
        for pair in l:
            if len(pair) == 2:
                source = pair[1].split("/")[-4:]
                source = os.path.join(*source)
                f.write(f"{pair[0]},{source},{different_content(pair[0], pair[1])}\n")
            else:
                print(f"Error: {pair} does not have 2 files.")
        print("Done.")
