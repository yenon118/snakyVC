import sys
import os
import re

project_name = config['project_name']
workflow_path = config['workflow_path']
input_files_1 = config['input_files_1']
input_files_2 = config['input_files_2']
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
    possible_sample = re.sub('(_..\\.fastq.*)|(_..\\.fq.*)', '', str(os.path.basename(input_files_1[i])))
    if not possible_sample in samples:
        samples.append(possible_sample)
    possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files_1[i])))
    if possible_extension != input_extension_1:
        input_extension_1 = possible_extension

for i in range(len(input_files_2)):
    if os.path.dirname(input_files_2[i]) != input_folder_2:
        input_folder_2 = os.path.dirname(input_files_2[i])
    possible_sample = re.sub('(_..\\.fastq.*)|(_..\\.fq.*)', '', str(os.path.basename(input_files_2[i])))
    if not possible_sample in samples:
        samples.append(possible_sample)
    possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files_2[i])))
    if possible_extension != input_extension_2:
        input_extension_2 = possible_extension


rule all:
    input:
         expand(os.path.abspath(output_folder)+'/BWA_sam/{sample}.sam', sample=samples),
         expand(os.path.abspath(output_folder)+'/BWA_sam_log/{sample}.log', sample=samples),
         expand(os.path.abspath(output_folder)+'/GATK_SortSam/{sample}.bam', sample=samples),
         expand(os.path.abspath(output_folder)+'/GATK_MarkDuplicates/{sample}.bam', sample=samples),
         expand(os.path.abspath(output_folder)+'/GATK_AddOrReplaceReadGroups/{sample}.bam', sample=samples),
         expand(os.path.abspath(output_folder)+'/GATK_HaplotypeCaller_gvcf/{sample}.g.vcf', sample=samples),
         expand(os.path.abspath(output_folder)+'/GATK_HaplotypeCaller_gvcf_gz/{sample}.g.vcf.gz', sample=samples),
         os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs/{project_name}.g.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs/{project_name}.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_SNPs/{project_name}_snp.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels/{project_name}_indel.vcf'.format(project_name=project_name))

include: './tasks/bwa/bwa_mem_pair.smk'

include: './tasks/gatk/gatk_sortsam.smk'
include: './tasks/gatk/gatk_markduplicates.smk'
include: './tasks/gatk/gatk_addorreplacereadgroups.smk'
include: './tasks/gatk/gatk_haplotypecaller.smk'

include: './tasks/bgzip/bgzip_gz_gvcf_file.smk'

include: './tasks/gatk/gatk_combinegvcfs.smk'
include: './tasks/gatk/gatk_genotypegvcfs.smk'
include: './tasks/gatk/gatk_selectvariants_snp.smk'
include: './tasks/gatk/gatk_selectvariants_indel.smk'
