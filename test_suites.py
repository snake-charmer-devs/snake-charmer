# Run this with the appropriate version of Python that's just been installed

import system

def check_nose(result):
    if not result.wasSuccessful():
        system.exit(1)

print('Testing NumPy...')
import numpy
check_nose(numpy.test('full'))

print('Testing SciPy...')
import numpy
check_nose(scipy.test('full'))

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

print('Testing iPython...')
import iPython
check_nose(iPython.test())

