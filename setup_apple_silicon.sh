#!/bin/bash
trap 'exit' SIGINT

if [ ! -d "./micromamba" ]; then
    mkdir -p ./micromamba
    wget -qO- https://micro.mamba.pm/api/micromamba/osx-arm64/latest | tar -xvj bin/micromamba
    mv bin micromamba
fi

source activate.sh

if [ ! -f "activate.fish" ]; then
    echo "set -gx MAMBA_ROOT_PREFIX ./micromamba/" > activate.fish
    ./micromamba/bin/micromamba shell hook -s fish >> activate.fish
    echo "micromamba activate" >> activate.fish
fi

micromamba install -y python=3.11
pip install pandas matplotlib xgboost scikit-learn
pip install torch torchvision torchaudio
pip install clemont

pushd lib/
###################################################
# From tulip-control/dd script install_dd_cudd.sh #
###################################################
#
# Install `dd`, including the modules
# `dd.cudd` and `dd.cudd_zdd`

set -v
set -e
pip install dd
    # to first install
    # dependencies of `dd`
pip uninstall -y dd
pip download \
    --no-deps dd \
    --no-binary dd
tar -xzf dd-*.tar.gz
pushd dd-*/
export DD_FETCH=1 DD_CUDD=1 DD_CUDD_ZDD=1
pip install . \
    -vvv \
    --use-pep517 \
    --no-build-isolation
# confirm that `dd.cudd` did get installed
pushd tests/
python -c 'import dd.cudd'
popd
popd
##################################################
# End tulip-control/dd script install_dd_cudd.sh #
##################################################
popd

