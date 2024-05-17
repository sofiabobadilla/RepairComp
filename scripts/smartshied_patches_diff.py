
import os


def compare_files(file_path1, file_path2):
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
    
def get_files(directory):
    files = []
    for root, _, filenames in os.walk(directory):
        for filename in filenames:
                if filename.endswith(".bin"):
                    pair = []
                    pair.append(os.path.join(root, filename))
                    pair.append(os.path.join(root, filename.replace(".bin", ".rt.hex")))
                    files.append(pair)
    return files

if __name__ == "__main__":
    smartshields_dir = "../results/smartbugs/SmartShield"
    l = get_files(smartshields_dir)    
    with open(os.path.join(smartshields_dir, "patches_diff.csv"), "w") as f:
        f.write("file1,file2,diff\n")
        for pair in l:
            if len(pair) == 2:
                f.write(f"{pair[0]},{pair[1]},{compare_files(pair[0], pair[1])}\n")
            else:
                print(f"Error: {pair} does not have 2 files.")
        print("Done.")
