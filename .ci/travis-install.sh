#!/bin/bash

set -e -x

if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    # https://github.com/travis-ci/travis-ci/issues/6307#issuecomment-233315824
    rvm get head

    git clone --depth 1 https://github.com/yyuu/pyenv.git ~/.pyenv
    PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    if ! (pyenv versions | grep "${PYTHON_VERSION}$"); then
        pyenv install ${PYTHON_VERSION}
    fi
    pyenv global ${PYTHON_VERSION}
    pyenv rehash

    brew update

    brew install gnu-sed --with-default-names
    brew outdated libtool || brew upgrade libtool
    brew outdated autoconf || brew upgrade autoconf --with-default-names
    brew outdated automake || brew upgrade automake --with-default-names
fi

pip install --upgrade pip wheel
pip install --upgrade setuptools
pip install -r .ci/requirements.txt
pip install --install-option="--no-cython-compile" https://github.com/cython/cython/archive/9b3dd8ec9d0b699438bb5f179d4812fbbbae73ed.zip
