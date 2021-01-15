#!/bin/bash
#SBATCH -c1 --mem-per-cpu=4000 --gres=gpu:1 --time=1:0:0

module load StdEnv/2020 python cudacore/.11.0.2 cudnn
source ~/env-382-jn/bin/activate
SECONDS=0
python mnist.py
echo Elapsed $SECONDS seconds

