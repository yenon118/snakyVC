
snakemake -np -j4 --configfile inputs.json --snakefile snakyVC.smk

snakemake -j4 --configfile inputs.json --snakefile snakyVC.smk


snakemake -np -j4 --configfile workflow_inputs/BWA_alignment_to_GATK_HaplotypeCaller_inputs.json \
--snakefile workflows/BWA_alignment_to_GATK_HaplotypeCaller.smk

snakemake -j4 --configfile workflow_inputs/BWA_alignment_to_GATK_HaplotypeCaller_inputs.json \
--snakefile workflows/BWA_alignment_to_GATK_HaplotypeCaller.smk


snakemake -j9 --configfile lewis_slurm_inputs.json --snakefile snakyVC.smk

snakemake --cluster "sbatch --account=xulab \
--partition=Lewis,BioCompute,hpc5,General --mem=16G" \
--jobs 30 --latency-wait 180 --configfile lewis_slurm_inputs.json --snakefile snakyVC.smk

snakemake --cluster "sbatch --account=xulab \
--partition=Lewis,BioCompute,hpc5,General --mem=16G" \
--jobs 30 --latency-wait 3600 --immediate-submit --notemp \
--configfile lewis_slurm_inputs.json --snakefile snakyVC.smk

nohup snakemake --cluster "sbatch --account=xulab \
--partition=Lewis,BioCompute,hpc5,General --mem=16G" \
--jobs 30 --latency-wait 3600 \
--configfile lewis_slurm_inputs.json --snakefile snakyVC.smk &
