import sys
import os
import re

project_name = config['project_name']
workflow_path = config['workflow_path']
input_files_1 = config['input_files_1']
input_files_2 = config['input_files_2']
chromosomes = config['chromosomes']
reference_file = config['reference_file']
output_folder = config['output_folder']
memory = config['memory']
threads = config['threads']

samples = []
input_folder_1 = ''
input_folder_2 = ''
input_extension_1 = ''
input_extension_2 = ''

for i in range(len(input_files_1)):
	if os.path.dirname(input_files_1[i]) != input_folder_1:
		input_folder_1 = os.path.dirname(input_files_1[i])
	possible_sample = re.sub('_[^_]*$', '', str(os.path.basename(input_files_1[i])))
	if not possible_sample in samples:
		samples.append(possible_sample)
	possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files_1[i])))
	if possible_extension != input_extension_1:
		input_extension_1 = possible_extension

for i in range(len(input_files_2)):
	if os.path.dirname(input_files_2[i]) != input_folder_2:
		input_folder_2 = os.path.dirname(input_files_2[i])
	possible_sample = re.sub('_[^_]*$', '', str(os.path.basename(input_files_2[i])))
	if not possible_sample in samples:
		samples.append(possible_sample)
	possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files_2[i])))
	if possible_extension != input_extension_2:
		input_extension_2 = possible_extension


rule all:
	input:
		expand(os.path.join(os.path.abspath(output_folder),'BWA_sam','{sample}.sam'), sample=samples),
		expand(os.path.join(os.path.abspath(output_folder),'BWA_sam_log','{sample}.log'), sample=samples),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_SortSam','{sample}.bam'), sample=samples),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_MarkDuplicates','{sample}.bam'), sample=samples),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_AddOrReplaceReadGroups','{sample}.bam'), sample=samples),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}_{chromosome}.g.vcf.gz'), sample=samples, chromosome=chromosomes),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{project_name}_{{chromosome}}.g.vcf.gz'.format(project_name=project_name)), chromosome=chromosomes),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{project_name}_{{chromosome}}.vcf.gz'.format(project_name=project_name)), chromosome=chromosomes),
		os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_gz_chromosomewise','{project_name}.vcf.gz'.format(project_name=project_name)),
		os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gz_chromosomewise_SNPs','{project_name}_snp.vcf.gz'.format(project_name=project_name)),
		os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gz_chromosomewise_Indels','{project_name}_indel.vcf.gz'.format(project_name=project_name))

include: './tasks/bwa/bwa_mem_pair.smk'

include: './tasks/gatk/gatk_sortsam.smk'
include: './tasks/gatk/gatk_markduplicates.smk'
include: './tasks/gatk/gatk_addorreplacereadgroups.smk'
include: './tasks/gatk/gatk_haplotypecaller_chromosomewise.smk'
include: './tasks/gatk/gatk_combinegvcfs_chromosomewise.smk'
include: './tasks/gatk/gatk_genotypegvcfs_chromosomewise.smk'
include: './tasks/gatk/gatk_gathervcfs_chromosomewise.smk'
include: './tasks/gatk/gatk_selectvariants_chromosomewise_snp.smk'
include: './tasks/gatk/gatk_selectvariants_chromosomewise_indel.smk'
