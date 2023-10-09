###-----------------------------------------------------------------------------------------------------------------###
# Notes on where variables are defined, if not defined in binned_averages.smk
#
# output_directory - workflow/Snakefile
# config           - workflow/Snakefile
# create_tag       - workflow/Snakefile
# bin_tags         - workflow/Snakefile
#
###-----------------------------------------------------------------------------------------------------------------###

def get_biscuit_reference(wildcards):
    if config['build_ref_with_methylation_controls']: # Currently not set up to be generated
        return 'merged_reference/merged.fa.gz'
    else:
        return config['ref']['fasta']

rule binned_averages:
    input:
        reference = get_biscuit_reference,
        bed = f'{output_directory}/analysis/pileup/{{sample}}_mergecg.bed.gz',
    params:
        outfile_no_gz = expand("{{output_directory}}/analysis/binned_averages/{{sample}}_{BIN_TAGS}.bed", BIN_TAGS = bin_tags), # arg to find_binned_average.sh not initially gz
        bins = config["binned_averages"]["bin_sizes"], # bins and bin_tags correspond
        tags = bin_tags,
        cov_filter = config["binned_averages"]["cov_filter"]
    output:
        outfile = expand("{{output_directory}}/analysis/binned_averages/{{sample}}_{BIN_TAGS}.bed.gz", BIN_TAGS = bin_tags)
    log:
        f'{{output_directory}}/logs/binned_averages/{{sample}}.log',
    threads: 1
    resources:
        mem_gb = config["hpc_parameters"]["small_memory_gb"],
        time = config["runtime"]["medium"]
    benchmark:
        f'{{output_directory}}/benchmarks/binned_averages/{{sample}}.log',
    conda:
        '../envs/biscuit.yaml'
    envmodules:
        config["envmodules"]["bedtools"],
    shell:
        """
        set -euo pipefail
        
        bins=({params.bins})
        outfiles=({params.outfile_no_gz})
        
        for i in "${{!bins[@]}}"; do 
            bash workflow/scripts/find_binned_average.sh \
                 {input.reference}.fai \
                 ${{bins[$i]}} \
                 {params.cov_filter} \
                 {input.bed} \
                 ${{outfiles[$i]}} # find_binned_average gzips the file, so different than {{output.outfile}}
        done
        
        """   
