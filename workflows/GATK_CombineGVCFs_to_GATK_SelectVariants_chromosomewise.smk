import sys
import os
import re

project_name = config['project_name']
workflow_path = config['workflow_path']
input_files = config['input_files']
chromosomes = config['chromosomes']
reference_file = config['reference_file']
output_folder = config['output_folder']
memory = config['memory']
threads = config['threads']

samples = []
input_folder = ''
input_extension = ''

for i in range(len(input_files)):
    if os.path.dirname(input_files[i]) != input_folder:
        input_folder = os.path.dirname(input_files[i])
    possible_sample = re.sub('(\\.g\\.vcf.*)', '', str(os.path.basename(input_files[i])))
    if not possible_sample in samples:
        samples.append(possible_sample)
    possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files[i])))
    if possible_extension != input_extension:
        input_extension = possible_extension


rule all:
    input:
         expand(os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_gvcf_{chromosome}', '{sample}_{chromosome}.g.vcf'), sample=samples, chromosome=chromosomes),
         expand(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_{chromosome}','{project_name}_{{chromosome}}.g.vcf'.format(project_name=project_name)), chromosome=chromosomes),
         expand(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_{chromosome}','{project_name}_{{chromosome}}.vcf'.format(project_name=project_name)), chromosome=chromosomes),
         os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise','{project_name}.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_chromosomewise_SNPs','{project_name}_snp.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_chromosomewise_Indels','{project_name}_indel.vcf'.format(project_name=project_name))


rule grep_gatk_haplotypecaller:
    input:
         in_file = os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension)
    params:
          selected_chromosome = "{chromosome}"
    output:
          out_file = os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_gvcf_{chromosome}', '{sample}_{chromosome}.g.vcf')
    log:
       os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_gvcf_{chromosome}_log', '{sample}_{chromosome}.log')
    resources:
             memory = memory
    shell:
         """
         grep -e "^#" -e "{params.selected_chromosome}" {input.in_file} > {output.out_file}
         """


include: './../tasks/gatk/gatk_combinegvcfs_chromosomewise.smk'
include: './../tasks/gatk/gatk_genotypegvcfs_chromosomewise.smk'
include: './../tasks/gatk/gatk_gathervcfs_chromosomewise.smk'
include: './../tasks/gatk/gatk_selectvariants_chromosomewise_snp.smk'
include: './../tasks/gatk/gatk_selectvariants_chromosomewise_indel.smk'
