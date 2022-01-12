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
		expand(os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_gvcf_gz_{chromosome}', '{sample}_{chromosome}.g.vcf.gz'), sample=samples, chromosome=chromosomes),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_{chromosome}','{project_name}_{{chromosome}}.g.vcf.gz'.format(project_name=project_name)), chromosome=chromosomes),
		expand(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_{chromosome}','{project_name}_{{chromosome}}.vcf.gz'.format(project_name=project_name)), chromosome=chromosomes),
		os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_gz_chromosomewise','{project_name}.vcf.gz'.format(project_name=project_name)),
		os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gz_chromosomewise_SNPs','{project_name}_snp.vcf.gz'.format(project_name=project_name)),
		os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gz_chromosomewise_Indels','{project_name}_indel.vcf.gz'.format(project_name=project_name))


rule gatk_selectvariants_chromosomewise:
	input:
		fasta = reference_file,
		in_file = os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension)
	params:
		selected_chromosome = "{chromosome}"
	output:
		out_file = os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_gvcf_gz_{chromosome}', '{sample}_{chromosome}.g.vcf.gz'),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz_{chromosome}','tmp', '{sample}')))
	log:
		os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_gvcf_gz_{chromosome}_log', '{sample}_{chromosome}.log')
	resources:
		memory = memory
	shell:
		"""
		mkdir -p {output.out_tmp_dir}; 
		gatk --java-options "-Xmx{resources.memory}g" SelectVariants --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} -L {params.selected_chromosome} -O {output.out_file} 2> {log}
		"""


include: './../tasks/gatk/gatk_combinegvcfs_chromosomewise.smk'
include: './../tasks/gatk/gatk_genotypegvcfs_chromosomewise.smk'
include: './../tasks/gatk/gatk_gathervcfs_chromosomewise.smk'
include: './../tasks/gatk/gatk_selectvariants_chromosomewise_snp.smk'
include: './../tasks/gatk/gatk_selectvariants_chromosomewise_indel.smk'
