#!/bin/bash

set -e -x

if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
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
pip install --install-option="--no-cython-compile" https://github.com/cython/cython/archive/d902b7cf24eba5bc5be9e8001d639abd912adf6d.zip
