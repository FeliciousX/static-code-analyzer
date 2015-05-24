This repository contains the code used to analyze C++ code for an assignment.

The repository being analyzed was [nodejs](https://github.com/joyent/node)

## The steps taken:-

1. Clone [nodejs](https://github.com/joyent/com/node)
2. `cd` to the `nodejs` repository
3. Copy my `static-code-analyzer` files here
4. Run `git for-each-ref --sort='*authordate' --format='%(tag)' refs/tags > versions` to get all the releases sorted by date into a file called versions.
5. Run `git for-each-ref --sort='*authordate' --format='%(tag) %(*authordate:iso8601)' refs/tags > nodejs-dates` to get all the releases with the date as well.
5. Run `analyze.sh versions` which takes the first argument as the file. It will read the file and go through everyline while `git checkout` to that specific version in the `nodejs` repository and run `cccc` static code analyzer on it, creating folders in `analyze/%version` for every checkout.
6. Move all the data to another folder for analyzing (including the `static-code-analyzer` files.
7. Run `node main.js versions > data.csv` that will parse the XML data from the `analyze` folders into a .csv format
8. Run `node date.js nodejs-dates > age.csv` that will sort the date by date with the age as well.
9. Use R to plot graph using `data.csv` and `age.csv`

TODO:-
- [ ] Write the R code for plotting graph

Data obtained is the total of:-

- Number of modules
- Lines of code
- Cyclomatic complexity
- Number of methods
- Number of private methods

## Dependency
- [nodejs](https://github.com/joyent/com/node)
- [npm](https://github.com/npm/npm)
