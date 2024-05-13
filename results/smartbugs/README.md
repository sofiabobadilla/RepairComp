# APR on Smartbugs-curated overview

## Results from runnning the APR tools
|Tool\Return code                    |0 (success)|1 (errors)|timeout (20min)|134(heap out of memory)|139 (segfault: core dump)|251 (compilation)|253|Notes                                                             |
|------------------------------------|-----------|----------|---------------|-----------------------|-------------------------|-----------------|---|------------------------------------------------------------------|
|Elysium                             |126        |15        |0              |0                      |0                        |1                |1  |1: run_oyente breaks, only mythril is used for these cases in eval|
|sGuard                              |129        |0         |3              |11                     |0                        |0                |0  |                                                                  |
|sGuardPlus                          |111        |32        |0              |0                      |0                        |0                |0  |Exceptions in revert2src.js                                       |
|SmartFix                            |140        |0         |3              |0                      |0                        |0                |0  |                                                                  |
|Aroc                                |135        |0         |0              |0                      |8                        |0                |0  |                                                                  |
|TIPS                                |141        |2         |0              |0                      |0                        |0                |0  |1: code errors in parsing json objects                            |
|Smartshield                         |134        |9         |0              |0                      |0                        |0                |0  |1: code errors                                                    |


## Patches overview
| Tool        | #patches |
|-------------|----------|
| Elysium     |      126 |
| sGuard      |      102 |
| sGuardPlus  |       78 |
| SmartFix    |      564 |
| Aroc        |       96 |
| TIPS        |      231 |
| Smartshield |      134 |
