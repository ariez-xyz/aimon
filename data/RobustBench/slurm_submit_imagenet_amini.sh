#!/bin/bash
#
# To submit: sbatch script.sh
#
# IMPORTANT: This section breaks when placed towards the end of the config options
# -------------------------------------------------------
# Use GPU partition, use one GPU, specify GPU type
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --constraint=L40S
# -------------------------------------------------------
#
#SBATCH --job-name=amini-imagenet
#SBATCH --output=amini-imagenet-%j.log
#
# 8 cores
#SBATCH -c 8
#SBATCH --time=05:00:00
#SBATCH --mem=64GB
#
# Do not requeue the job in the case it fails.
#SBATCH --no-requeue
# Export the local environment to the compute nodes
#SBATCH --export=ALL
#

MODEL=Amini2024MeanSparse
DATASET=imagenet
N=5000
THREATMODEL=Linf

pushd ../..
source activate.sh
popd

srun /usr/bin/nvidia-smi

mkdir -p predictions

python predict.py --model "$MODEL" --dataset "$DATASET" --output "predictions/$DATASET-$MODEL.csv" --n-examples "$N" --threat-model "$THREATMODEL" 

python predict.py --model "$MODEL" --dataset "$DATASET" --output "predictions/$DATASET-$MODEL-adv.csv" --n-examples "$N" --threat-model "$THREATMODEL" --adversarials --adversarial-batchsize 100
