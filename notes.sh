
snakemake -pj 10 --configfile inputs.json --snakefile snakyVC.smk


snakemake -pj 10 --configfile workflow_inputs/BWA_alignment_to_GATK_HaplotypeCaller_inputs.json \
--snakefile workflows/BWA_alignment_to_GATK_HaplotypeCaller.smk

snakemake -pj 10 --configfile workflow_inputs/GATK_CombineGVCFs_to_GATK_SelectVariants_inputs.json \
--snakefile workflows/GATK_CombineGVCFs_to_GATK_SelectVariants.smk


snakemake -pj 10 --configfile workflow_inputs/BWA_alignment_to_GATK_AddOrReplaceReadGroups_inputs.json \
--snakefile workflows/BWA_alignment_to_GATK_AddOrReplaceReadGroups.smk

snakemake -pj 10 --configfile workflow_inputs/GATK_HaplotypeCaller_inputs.json \
--snakefile workflows/GATK_HaplotypeCaller.smk

snakemake -pj 10 --configfile workflow_inputs/GATK_CombineGVCFs_to_GATK_SelectVariants_chromosomewise_inputs.json \
--snakefile workflows/GATK_CombineGVCFs_to_GATK_SelectVariants_chromosomewise.smk


snakemake -pj 10 --configfile workflow_inputs/BWA_alignment_single_inputs.json \
--snakefile workflows/BWA_alignment_single.smk

snakemake -pj 10 --configfile workflow_inputs/GATK_SortSam_to_GATK_SelectVariants_inputs.json \
--snakefile workflows/GATK_SortSam_to_GATK_SelectVariants.smk


snakemake -pj 10 --configfile workflow_inputs/BWA_alignment_single_inputs.json \
--snakefile workflows/BWA_alignment_single.smk

snakemake -pj 10 --configfile workflow_inputs/GATK_SortSam_to_GATK_AddOrReplaceReadGroups_inputs.json \
--snakefile workflows/GATK_SortSam_to_GATK_AddOrReplaceReadGroups.smk

snakemake -pj 10 --configfile workflow_inputs/GATK_MarkDuplicates_to_GATK_SelectVariants_inputs.json \
--snakefile workflows/GATK_MarkDuplicates_to_GATK_SelectVariants.smk




snakemake -pj 10 --configfile lewis_slurm_inputs.json --snakefile snakyVC.smk


snakemake -pj 10 --configfile lewis_slurm_chromosomewise_inputs.json --snakefile snakyVC_chromosomewise.smk


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
