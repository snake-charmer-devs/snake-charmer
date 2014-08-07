pyver: '3.4'

# Deb packages (with optional versions) to install via apt -- order is not important

apt_pkgs:
    - freetds-dev: 0.91-1
    - g++-4.6: 4.6.3-1ubuntu5
    - gfortran: 4:4.6.3-1ubuntu5
    - git: 1:1.7.9.5-1
    - htop: 1.0.1-1
    - libboost-program-options-dev: 1.48.0.2
    - libfreetype6-dev: 2.4.8-1ubuntu2.1
    - libhdf5-serial-dev: 1.8.4-patch1-3ubuntu2
    - libjpeg8-dev: 8c-2ubuntu7
    - liblcms1-dev: 1.19.dfsg-1ubuntu3
    - liblzo2-dev: 2.06-1ubuntu0.1
    - libpng12-dev: 1.2.46-3ubuntu4
    - libpq-dev: 9.1.14-0ubuntu0.12.04
    - libtiff4-dev: 3.9.5-2ubuntu1.6
    - libwebp-dev: 0.1.3-2.1ubuntu1
    - libxml2-dev: 2.7.8.dfsg-5.1ubuntu4.9
    - libxslt1-dev: 1.1.26-8ubuntu1.3
    - libzmq-dev: 2.1.11-1ubuntu1
    - llvm-3.3-dev: 1:3.3-5ubuntu4~precise1
    - octave3.2: 3.2.4-12
    - parallel: 20121122-0ubuntu1~ubuntu12.04.1
    - pandoc: 1.9.1.1-1
    - python-software-properties: 0.82.7.7
    - r-base-dev: 2.14.1-1
    - r-recommended: 2.14.1-1
    - tcl8.5-dev: 8.5.11-1ubuntu1
    - tk8.5-dev: 8.5.11-1
    - zlib1g-dev: 1:1.2.3.4.dfsg-3ubuntu4

# Additional debs for (optional) OpenCV -- work in progress!

opencv_deps:
   - libopencv-dev
   - checkinstall
   - cmake
   - pkg-config
   - yasm
   - libjpeg-dev
   - libjasper-dev
   - libavcodec-dev
   - libavformat-dev
   - libswscale-dev
   - libdc1394-22-dev
   - libxine-dev
   - libgstreamer0.10-dev
   - libgstreamer-plugins-base0.10-dev
   - libv4l-dev
   - python-dev
   - python-numpy
   - libtbb-dev
   - libqt4-dev
   - libgtk2.0-dev
   - libfaac-dev
   - libmp3lame-dev
   - libopencore-amrnb-dev
   - libopencore-amrwb-dev
   - libtheora-dev
   - libvorbis-dev
   - libxvidcore-dev
   - x264
   - v4l-utils
   - ffmpeg

# Python packages to install via pip -- a list of dicts, so order is maintained

pip_pkgs:
    - name:    openpyxl
      ver:     ==1.8.5
    - name:    numpy
      git:     https://github.com/numpy/numpy.git
      rev:     v1.8.1
      setup:   (export BLAS=/usr/local/lib/libopenblas.a ; export LAPACK=/usr/local/lib/libopenblas.a ; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ ; python3.4 setup.py install)
    - name:    scipy
      git:     https://github.com/scipy/scipy.git
      rev:     26ddaf0556266fb28901ddbfc3c817e75d0a9daa
      setup:   (export BLAS=/usr/local/lib/libopenblas.a ; export LAPACK=/usr/local/lib/libopenblas.a ; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ ; python3.4 setup.py install)
    - name:    Theano
      git:     https://github.com/Theano/Theano.git
      rev:     ba81e61d6545d5a82fbf9c85b9e6db2fd3c12ea3
    - name:    numpydoc
      git:     https://github.com/numpy/numpydoc.git
      rev:     56a1b39e8b16f2292f6b2b54ce26d259003fadad
    - name:    Bottleneck
      ver:     ==0.8.0
    - name:    matplotlib
      git:     https://github.com/matplotlib/matplotlib.git
      rev:     4b1bd6301d69f856deca9c614af563f5fb4d1e90
    - name:    patsy
      ver:     ==0.2.1
    - name:    numexpr
      ver:     ==2.4
    - name:    Cython
      git:     https://github.com/cython/cython.git
      rev:     c646da0b6527bf2ad18e706eb4273c712ac356a8
    - name:    tables
      ver:     ==3.1.1
    - name:    beautifulsoup4
      ver:     ==4.2.1
      import:  bs4
    - name:    lxml
      ver:     ==3.3.5
    - name:    deap
      ver:     ==1.0.1
    - name:    fastcluster
      ver:     ==1.1.13
    - name:    sympy
      git:     https://github.com/sympy/sympy.git
      rev:     254d99c1c2bfbd4f634f61cd5a444c8a3e79450b
    - name:    pandas
      ver:     ==0.14
    - name:    lifelines
      ver:     ==0.4.0.0
    - name:    nose
      ver:     ==1.3.3
    - name:    mock
      ver:     ==1.0.1
    - name:    statsmodels
      git:     https://github.com/statsmodels/statsmodels.git
      rev:     74b4dc920456a82e11d4ebd865bb698769b0b767
    - name:    pymc
      git:     https://github.com/andrewclegg/pymc
      rev:     66c3f3743de9c39643ba4fb3ef14f79e4845e8f3
    - name:    psycopg2
      ver:     ==2.5.2
    - name:    pymssql
      ver:     ==2.1.0
    - name:    brewer2mpl
      ver:     ==1.4
    - name:    prettyplotlib
      git:     https://github.com/olgabot/prettyplotlib.git
      rev:     fc04d6e4f5edf1d402f51abeacc0dfd5132f60be
    - name:    seaborn
      ver:     ==0.3.1
    - name:    ipython[all]
      import:  IPython
      ver:     ==2.0.0
    - name:    scikit-learn
      git:     https://github.com/scikit-learn/scikit-learn.git
      rev:     d0f6052a7c0eb8df48b0dd867c2799aa9bd729fa
      import:  sklearn
    - name:    runipy
      ver:     ==0.0.8
    - name:    Pillow
      import:  PIL
      git:     https://github.com/python-imaging/Pillow.git
      rev:     84a701a82b33896a4d6997743c2131ab0a40c588
    - name:    joblib
      git:     https://github.com/joblib/joblib.git
      rev:     f76129c888394a6b32aab8e6436c74c0b2ee842c
    - name:    pexpect
      ver:     ==3.2
    - name:    rpy2
      ver:     ==2.3.10
    - name:    oct2py
      ver:     ==1.3.0
    - name:    pyyaml
      import:  yaml
      ver:     ==3.11
    - name:    nltk
      git:     https://github.com/nltk/nltk.git
      rev:     24e257a6fd29df503e9ffe628f96604012c8a8e1
    - name:    Pyro4
      import:  Pyro4
      ver:     ==4.25
    - name:    gensim
      git:     https://github.com/piskvorky/gensim.git
      rev:     d1c6d58b9acfec97e6c5d677c652293ae2119276
      export:  true
      setup:   python3.4 setup.py develop
    - name:    llvmpy
      git:     https://github.com/llvmpy/llvmpy.git
      rev:     34900d27481bd3457a4fac03569eb152b0fa8678
      setup:   (LLVM_CONFIG_PATH=/usr/bin/llvm-config-3.3 python3.4 setup.py install)
    - name:    numba
      git:     https://github.com/numba/numba.git
      rev:     4b9a36e7b344823fa2d2bb85221a14ff9e0abb03
      export:  true
      setup:   pip3.4 install --install-option=build_ext --install-option="--inplace" -e . 
    - name:    emcee
      ver:     ==2.1.0
    - name:    pystan
      git:     https://github.com/stan-dev/pystan.git
      rev:     15ce22cfc4714ccb0f3b1f256d4704d81ac6ff81
    - name:    mpld3
      ver:     ==0.2
    - name:    wabbit_wappa
      git:     https://github.com/andrewclegg/wabbit_wappa.git
      rev:     a9f7a4d34d44ff6f6000850558d833efe07bbb95
    - name:    requests
      ver:     ==2.3.0

# Misc stuff not installed through usual channels

vw_rev: 0c8da21c979951a36373ca0cb601d4c5bd056038
openblas_rev: v0.2.9

