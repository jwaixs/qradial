#!/bin/sh

echo "Yapf: code-style rewrite."
yapf --style='{based_on_style: pep8}' -d ${1}
yapf --style='{based_on_style: pep8}' -i ${1}

echo "Code-style verification."
pycodestyle --first ${1}
pylint ${1}

echo "Python hints."
mypy --ignore-missing-imports ${1}

echo "Documentation style verification."
pydocstyle ${1}
