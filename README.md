# snakyVC

<!-- badges: start -->
<!-- badges: end -->

The snakyVC is a pipeline built for variant calling using next-generation sequencing (NGS) whole-genome sequencing datasets.

## Requirements

In order to run the snakyVC, users need to install software, programming languages, and packages in their computing systems.
The software, programming languages, and packages include: 

```
BWA
GATK
HTSlib
Python3
Snakemake
``` 

## Installation

You can install the snakyVC from [Github](https://github.com/yenon118/snakyVC.git) with:

```
git clone https://github.com/yenon118/snakyVC.git
```

## Usage

#### Write a configuration file in json format

Please save the file with .json extension.

```
{
  "project_name": "Test",
  "workflow_path": "/scratch/yenc/projects/snakyVC",
  "input_files_1": [
    "/scratch/yenc/projects/snakyVC/data/CCCRR108616_r1.fastq",
    "/scratch/yenc/projects/snakyVC/data/CCCRR108617_r1.fastq",
    "/scratch/yenc/projects/snakyVC/data/CCCRR108618_r1.fastq",
    "/scratch/yenc/projects/snakyVC/data/CCCRR108619_r1.fastq"
  ],
  "input_files_2": [
    "/scratch/yenc/projects/snakyVC/data/CCCRR108616_r2.fastq",
    "/scratch/yenc/projects/snakyVC/data/CCCRR108617_r2.fastq",
    "/scratch/yenc/projects/snakyVC/data/CCCRR108618_r2.fastq",
    "/scratch/yenc/projects/snakyVC/data/CCCRR108619_r2.fastq"
  ],
  "reference_file": "/scratch/yenc/projects/snakyVC/data/Wm82.a2.v1.subset.fa",
  "output_folder": "/scratch/yenc/projects/snakyVC/output/",
  "memory": 100,
  "threads": 10
}
```

#### Run workflow with the Snakemake workflow management system

```
snakemake -j NUMBER_OF_JOBS --configfile CONFIGURATION_FILE --snakefile SNAKEMAKE_FILE

Mandatory Positional Argumants:
    NUMBER_OF_JOBS                          - the number of jobs
    CONFIGURATION_FILE                      - a configuration file
    SNAKEMAKE_FILE                          - the snakyVC.smk file that sit inside this repository 
```

## Examples

These are a few basic examples which show you how to use the snakyVC:

```
cd /path/to/snakyVC

snakemake -j4 --configfile inputs.json --snakefile snakyVC.smk
```

```
cd /path/to/snakyVC

snakemake -j4 --configfile workflow_inputs/BWA_alignment_to_GATK_HaplotypeCaller_inputs.json \
--snakefile workflows/BWA_alignment_to_GATK_HaplotypeCaller.smk
```

```
cd /path/to/snakyVC

snakemake -j9 --configfile lewis_slurm_inputs.json --snakefile snakyVC.smk
```

```
cd /path/to/snakyVC

snakemake --cluster "sbatch --account=xulab \
--partition=Lewis,BioCompute,hpc5,General --mem=16G" \
--jobs 30 --latency-wait 180 --configfile lewis_slurm_inputs.json --snakefile snakyVC.smk
```

