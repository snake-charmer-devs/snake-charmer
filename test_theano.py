# Theano has a weird test bug where it sets theano.config.compute_test_value
# to 'raise', then fails to set it back, causing lots of other tests to fail.
# But this only happens the first time... So you can catch it and retry.

import theano
theano.config.compute_test_value = 'off'
result = theano.test(extra_argv=['-x'])
if not result.wasSuccessful():
    print()
    print('RETRYING WITH TEST VALUES DISABLED')
    print('**********************************')
    print()
    print('Please ignore any error messages above here. Any below here *do* apply, however.')
    print()
    theano.config.compute_test_value = 'off'
    theano.test()

