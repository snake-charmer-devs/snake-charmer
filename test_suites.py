# Run this with the appropriate version of Python that's just been installed

import sys

def check_nose(result):
    if not result.wasSuccessful():
        sys.exit(1)

print('Testing NumPy...')
import numpy
check_nose(numpy.test('full'))

print('Testing Matplotlib...')
import matplotlib
check_nose(matplotlib.test())

print('Testing PyMC...')
import pymc
check_nose(pymc.test())

print('Testing scikit-learn...')
import sklearn
check_nose(sklearn.test())

print('Testing Theano...')
import theano
check_nose(theano.test())

print('Testing IPython...')
import IPython
check_nose(IPython.test())

print('Testing Pandas...')
import pandas
check_nose(pandas.test())

# Temporarily moved to end as it's failing one

print('Testing SciPy...')
import scipy
check_nose(scipy.test('full'))

