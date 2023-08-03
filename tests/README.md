This directory contains the testing framework of the Markdown package. Tests
act as an ensurance that changes to the package did not introduce new bugs.

The `test.sh` shell script is used to run the individual tests. To run one or
more tests, execute the `test.sh` script with the pathnames of one or more test
files as the arguments. Test files can be recognized by the `.test` suffix and
reside inside the `testfiles/` directory. The Markdown package needs to be
[installed][install] before running the tests.

 [install]:  http://mirrors.ctan.org/macros/generic/markdown/markdown.html#installation "Markdown Package User Manual"

Each time a commit is made to the Git repository of the project, this test
suite is ran by a continuous integration service.  
The current status is:
[![ci](https://github.com/Witiko/markdown/workflows/Test/badge.svg)][ci]

 [ci]:       https://github.com/Witiko/markdown/actions "GitHub Actions"

For a more detailed description of the testing framework, see
[the description in pull request #316][pr-316].

 [pr-316]: https://github.com/Witiko/markdown/pull/316#issuecomment-1663868646 "Implement batching to unit tests"
