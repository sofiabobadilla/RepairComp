### Files description

- `<filename>.sol`: source file (aka the original contract) "cleaned", the input that is included in the prompt.
- `<filename>_vulns.json`: slither report for `<filename>.sol`
- `<filename>_vulns_Medium.json`: filtered slither report with just the vulnerabilities taken into consideration.

- `<filename><n>round.sol`: patch for the contract with `filename` and generated at round number `n`.
- `<filename><n>round_vulns.json`: slither report for patch `<filename><n>round.sol`
- `<filename><n>round_vulns_Medium.json`: filtered slither report with just the vulnerabilities taken into consideration.