#!/bin/bash
#SBATCH -t 4-00:00:00
#SBATCH --mem=8G
#SBATCH --job-name=SNAKEMASTER
#SBATCH -o logs/workflows/workflow_output-%j.log

cd ${SLURM_SUBMIT_DIR}

mkdir -p logs/workflows

# save DAG job file with time stamp
TIME=$(date "+%Y-%m-%d_%H.%M.%S")
snakemake --configfile config/config.yaml --profile profile/ --dry-run         > logs/workflows/workflow_${TIME}.txt
snakemake --configfile config/config.yaml --profile profile/ --dag | dot -Tpng > logs/workflows/workflow_${TIME}.png

# Default to using conda, if using environment modules, then replace --use-conda with --use-envmodules
# Note, this requires downloading mamba (conda install -n base -c conda-forge mamba)
snakemake \
    --configfile config/config.yaml \
    --profile profile/ \
    --slurm \
    --default-resources slurm_account=[ENTER YOUR SLURM ACCOUNT] slurm_partition=[ENTER SLURM PARTITION TO USE]
