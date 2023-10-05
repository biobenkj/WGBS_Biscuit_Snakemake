#!/bin/bash
#SBATCH --export=NONE
#SBATCH -J SNAKEMASTER
#SBATCH -o biscuitBlaster_workflow.o
#SBATCH -e biscuitBlaster_workflow.e
#SBATCH --ntasks 1
#SBATCH --time 240:00:00
#SBATCH --mem=8G
#SBATCH --partition=long

mkdir -p logs/workflows

cd $SLURM_SUBMIT_DIR

snakemake_module="bbc2/snakemake/snakemake-7.25.0"

module load $snakemake_module

# save DAG job file with time stamp
#~ TIME=$(date "+%Y-%m-%d_%H.%M.%S")
#~ snakemake --configfile config/config_UBC_mircordissected_new_hpc.yaml --profile profile/ --dry-run         > logs/workflows/workflow_${TIME}.txt
#~ snakemake --configfile config/config_UBC_mircordissected_new_hpc.yaml --profile profile/ --dag | dot -Tpng > logs/workflows/workflow_${TIME}.png

# make logs dir if it does not exist already. 
logs_dir="logs/"
[[ -d $logs_dir ]] || mkdir -p $logs_dir


echo "Start snakemake workflow." >&1                   
echo "Start snakemake workflow." >&2     

snakemake \
-p \
--latency-wait 20 \
--use-conda \
--jobs 100 \
--cluster "mkdir -p logs/{rule}; sbatch \
-p short,long,laird \
--export=ALL \
--ntasks {threads} \
--mem={resources.mem_gb}G \
-t {resources.time}"

#--slurm \
#--default-resources slurm_account=${SLURM_JOB_USER} slurm_partition=${SLURM_JOB_PARTITION}

echo "snakemake workflow done." >&1                   
echo "snakemake workflow done." >&2                
