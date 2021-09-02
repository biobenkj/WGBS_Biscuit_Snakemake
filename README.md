This Snakemake workflow takes paired-end whole-genome bisulfite sequencing (WGBS) data and processes it using BISulfite-seq CUI Toolkit (BISCUIT).

BISCUIT was written to perform alignment, DNA methylation and mutation calling, and allele specific methylation from bisulfite sequencing data (https://huishenlab.github.io/biscuit/).

Download BISCUIT here: https://github.com/huishenlab/biscuit/releases/latest.

# Components of the workflow
	1. Trim adapters
	2. Alignment, duplicate tagging, indexing, flagstat 
	3. Methylation information extraction (BED Format)
	4. Merge C annd G beta values in CpG dinucleotide context
	5. SNP and Epiread extraction
	6. MultiQC with BICUIT QC modules specifically for methyaltion data
	7. [default off] fastq_screen (using Bismark - https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/
	8. [default off] Modify and index reference to include control vectors
	9. [default off] QC methylated and unmethylated controls

Many options can be easily specified in the config.yaml!

# Running the workflow

+ Clone the repo `git clone https://github.com/vari-bbc/WGBS_Biscuit_Snakemake`


+ Place *gzipped* FASTQ files into `raw_data/`


+ Replace the example `bin/samples.tsv` with your own sample sheet containing:
	+ A row for each sample
	+ The following three columns
		A. `sample_1`
		B. `fq1` (name of R1 file for `sample_1` in `raw_data/`)
		C. `fq2` (name of R2 file for `sample_1` in `raw_data/`)
		D. Any other columns included are ignored
		
		
+ Modify the config.yaml to specify the appropriate 
	+ Reference genome
	+ Biscuit index
	+ Biscuit QC assets (https://github.com/huishenlab/biscuit/releases/tag/v0.3.16.20200420)
	+ Environmental modules (If modules are not available, snakemake gives a warning but will run successfully *as long as the required executables are in the path*)
	+ Turn on any optional workflow components


+ Submit the workflow to an HPC using something similar to bin/run_snakemake_workflow.sh (e.g. qsub -q [queue_name] bin/run_snakemake_workflow.sh)

# After the workflow

+ The output files in analysis/pileup/ may be imported into a `BSseq` object using `bicuiteer::readBiscuit()`.
+ analysis/multiqc/multiqc_report.html contains the methylation-specific BISCUIT QC modules (https://huishenlab.github.io/biscuit/docs/alignment/QC.html)

# Test dataset

This workflow comes with a working example dataset. To test the smakemake workflow on your system, place the 10 *_R[12]_fq.gz files in bin/working_example_dataset into raw_data/ and use the default bin/samples.tsv. These example files can be mapped to the human genome.

# Diagrams of possible workflows

## Default workflow - 1 sample
![workflow diagram](bin/DAGs/one_sample_DAG_default_workflow.pdf)

## Full workflow - 5 samples
![workflow diagram](bbin/DAGs/one_sample_DAG_full_workflow.pdf)

## Default workflow - 5 samples
![workflow diagram](bin/DAGs/five_sample_DAG_default_workflow.pdf)

## Full workflow - 1 sample
![workflow diagram](bbin/DAGs/five_sample_DAG_full_workflow.pdf)

# Helpful snakemake commands for debugging a workflow

snakemake -npr # test run

`snakemake --unlock --cores 1` # unlock after a manually aborted run

`snakemake --dag | dot -Tpng > my_dag.png` # create a workflow diagram for your run

`snakemake --use-envmodules --cores 1` # if running on the command line, need use-envmodules option

For more information on Snakemake: https://snakemake.readthedocs.io/en/stable/

