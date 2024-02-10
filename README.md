# snakyVC

<!-- badges: start -->
<!-- badges: end -->

The snakyVC pipeline is designed for efficiently and parallelly executing variant calling on next-generation sequencing (NGS) whole-genome datasets.

## Requirements

In order to run the snakyVC pipeline, users need to install Miniconda and prepare the Miniconda environment in their computing systems.

The required software, programming languages, and packages include:

```
bwa>=0.7.17
gatk4>=4.4.0.0
samtools>=1.6
htslib>=1.3
python>=3.12
snakemake>=8.4
numpy>=1.26
pandas>=2.2
```

Miniconda can be downloaded from [https://docs.anaconda.com/free/miniconda/](https://docs.anaconda.com/free/miniconda/).

For example, if users plan to install Miniconda3 Linux 64-bit, the wget tool can be used to download the Miniconda.

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

To install Miniconda in a server or cluster, users can use the command below.

Please remember to replace the _<installation_shell_script>_ to the actual Miniconda installation shell script. In our case, it is **Miniconda3-latest-Linux-x86_64.sh**.

Please also remember to replace the _<desired_new_directory>_ to an actual directory absolute path. 

```
chmod 777 -R <installation_shell_script>
./Miniconda3-latest-Linux-x86_64.sh -b -u -p <desired_new_directory>
rm -rf <installation_shell_script>
```

Installation of the Miniconda is required, and Miniconda environment needs to be activated every time before running the snakyVC pipeline.

Write a Conda configuration file (.condarc) before creating a Conda environment:

```
nano ~/.condarc
```

Put the following text into the Conda configuration file (make sure you change *envs_dirs* and *pkgs_dirs*) then save the file:

Please make sure to replace _/new/path/to/_ to an actual directory absolute path.

```
envs_dirs:
	- /new/path/to/miniconda/envs
pkgs_dirs:
	- /new/path/to/miniconda/pkgs
channels:
	- conda-forge
	- bioconda
	- defaults
```

Create a Conda environment by specifying all required packages (option 1).

Please make sure to replace the _<conda_environment_name>_ to an environment name of your choice.

```
conda create -n <conda_environment_name> bioconda::gatk4 bioconda::samtools bioconda::bcftools bioconda::htslib \
bioconda::bedtools bioconda::bwa bioconda::snakemake bioconda::snakemake-executor-plugin-cluster-generic \
conda-forge::numpy conda-forge::pandas
```

Create a Conda environment by using a yaml environment file (option 2).

Please make sure to replace the _<conda_environment_name>_ to an environment name of your choice.

```
conda create --name <conda_environment_name> --file snakyVC-environment.yml
```

Create a Conda environment named *happigwas* by using a explicit specification file (option 3).

Please make sure to replace the _<conda_environment_name>_ to an environment name of your choice.

```
conda create --name <conda_environment_name> --file snakyVC-spec-file.txt
```

Activate Conda environment using conda activate command. 

This step is required every time before running snakyVC pipeline.

Please make sure to replace the _<conda_environment_name>_ to an environment name of your choice.

```
conda activate <conda_environment_name>
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
		"/scratch/yenc/projects/snakyVC/data/CCCRR108616_1.fastq",
		"/scratch/yenc/projects/snakyVC/data/CCCRR108617_1.fastq",
		"/scratch/yenc/projects/snakyVC/data/CCCRR108618_1.fastq",
		"/scratch/yenc/projects/snakyVC/data/CCCRR108619_1.fastq"
	],
	"input_files_2": [
		"/scratch/yenc/projects/snakyVC/data/CCCRR108616_2.fastq",
		"/scratch/yenc/projects/snakyVC/data/CCCRR108617_2.fastq",
		"/scratch/yenc/projects/snakyVC/data/CCCRR108618_2.fastq",
		"/scratch/yenc/projects/snakyVC/data/CCCRR108619_2.fastq"
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

Below are some fundamental examples illustrating the usage of the snakyVC pipeline.

Please adjust _/path/to/_ to an actual directory absolute path.

**Examples of running without an executor.**

```
cd /path/to/snakyVC

snakemake -j 4 --configfile inputs.json --snakefile snakyVC.smk
```

```
cd /path/to/snakyVC

snakemake -j 4 --configfile workflow_inputs/BWA_alignment_to_GATK_HaplotypeCaller_inputs.json \
--snakefile workflows/BWA_alignment_to_GATK_HaplotypeCaller.smk
```

```
cd /path/to/snakyVC

snakemake -j 9 --configfile lewis_slurm_inputs.json --snakefile snakyVC.smk
```

**Examples of running with an executor.**

Snakemake version >= 8.0.0.

```
cd /path/to/snakyVC

snakemake --executor cluster-generic \
--cluster-generic-submit-cmd "sbatch --account=xulab \
--partition=Lewis,BioCompute,hpc5,General --mem=16G" \
--jobs 30 --latency-wait 180 --configfile lewis_slurm_inputs.json \
--snakefile snakyVC.smk
```

Snakemake version < 8.0.0.

```
cd /path/to/snakyVC

snakemake --cluster "sbatch --account=xulab \
--partition=Lewis,BioCompute,hpc5,General --mem=16G" \
--jobs 30 --latency-wait 180 --configfile lewis_slurm_inputs.json \
--snakefile snakyVC.smk
```

## Flowchart

![SnakyVC_pipeline_flowchart](https://user-images.githubusercontent.com/22091525/210927434-b8a63da6-d635-4c25-9fca-155513ac1aab.png)

## Citation

Chan YO, Dietz N, Zeng S, Wang J, Flint-Garcia S, Salazar-Vidal MN, Škrabišová M, Bilyeu K, Joshi T: **The Allele Catalog Tool: a web-based interactive tool for allele discovery and analysis.** BMC Genomics 2023, 24(1):107.

## Remarks

1. The GATK:CombineGVCFs and GATK:GenotypeGVCFs can be either parallelly executed based on number of chromosomes or not parallelly executed at all. If users are combining a large number of accessions into one to perform calling, these two processes will take a lot of time.
2. The execution time of the SnakyVC pipeline mainly depends on the size of the data and the available computing resources on the machine.
