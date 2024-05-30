import csv
import json
import os

directory = "."
without_bugs = []
with_bugs = []
total = 0
for root, _, filenames in os.walk(directory):
    for filename in filenames:
        print(os.path.join(root, filename))
        if filename.endswith(".bug.json"):
            with open(os.path.join(root, filename), 'r') as f:
                data = json.load(f)
                filtered = [x for x in data if x["operator"] != "inheritance:single"]
                bugs = len(data)
                if bugs == 0:
                    without_bugs.append([os.path.join(root, filename), bugs])
                else:
                    total += bugs
                    with_bugs.append([os.path.join(root, filename), bugs])

with open("og_without_bugs.csv", 'w') as f:
    writer = csv.writer(f)
    for path, bugs in without_bugs:
        writer.writerow([path, bugs])

with open("og_with_bugs.csv", 'w') as f:
    writer = csv.writer(f)
    for path, bugs in with_bugs:
        writer.writerow([path, bugs])

print(total)