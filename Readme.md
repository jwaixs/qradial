== Install ==
With miniconda
```
conda create -n qradial python=3.6
source activate qradial
conda install pytest
```

== For development ==
```
export PYTHONPATH=/path/to/qradial:${PYTHONPATH}
```
Code checker
```
conda install pycodestyle pylint
pip install yapf mypy pydocstyle
```
