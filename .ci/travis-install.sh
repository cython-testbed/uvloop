#!/bin/bash

set -e -x

if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    brew update >/dev/null
    brew upgrade pyenv
    eval "$(pyenv init -)"

    if ! (pyenv versions | grep "${PYTHON_VERSION}$"); then
        pyenv install ${PYTHON_VERSION}
    fi
    pyenv global ${PYTHON_VERSION}
    pyenv rehash

    brew install gnu-sed --with-default-names
    brew outdated libtool || brew upgrade libtool
    brew outdated autoconf || brew upgrade autoconf --with-default-names
    brew outdated automake || brew upgrade automake --with-default-names
fi

pip install --upgrade setuptools pip wheel
pip install -r .ci/requirements.txt
pip install --install-option="--no-cython-compile" https://github.com/cython/cython/archive/98bef7ce50b1883493fc10c2040c83b1ce94ed65.zip
