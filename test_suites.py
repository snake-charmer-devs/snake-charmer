# Run this with the appropriate version of Python that's just been installed

import sys
import subprocess

def check_nose(result):
    if not result.wasSuccessful():
        sys.exit(1)

def check_bool(result):
    if not result:
        sys.exit(1)

print('Testing scikit-learn...')
retcode = subprocess.call(['nosetests', '--exe', 'sklearn', '--processes=-1'])
check_bool(retcode == 0)

print('Testing IPython...')
# -j means run in parallel, all cores
retcode = subprocess.call(['iptests', '-j'])
check_bool(retcode == 0)

print('Testing Pandas...')
retcode = subprocess.call(['nosetests', 'pandas', '--processes=-1'])
check_bool(retcode == 0)

print('Testing NumPy...')
import numpy
check_nose(numpy.test('full'))

print('Testing PyMC...')
import pymc
check_nose(pymc.test())

# These have known (reported) issues in 3.4 at the moment

print('Testing SciPy...')
import scipy
check_nose(scipy.test('full'))

print('Testing Matplotlib...')
import matplotlib
check_bool(matplotlib.test())

print('Testing Theano...')
import theano
theano.config.compute_test_value = 'ignore'
theano.config.compute_test_value_opt = 'ignore'
check_nose(theano.test())

# TODO for those packages without easy post-install testing, we should at least make sure they import

