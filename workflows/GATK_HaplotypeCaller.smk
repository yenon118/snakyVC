import sys
import os
import re

workflow_path = config['workflow_path']
input_files = config['input_files']
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
    possible_sample = re.sub('(\\.bam)', '', str(os.path.basename(input_files[i])))
    if not possible_sample in samples:
        samples.append(possible_sample)
    possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files[i])))
    if possible_extension != input_extension:
        input_extension = possible_extension


rule all:
    input:
         expand(os.path.abspath(output_folder)+'/GATK_HaplotypeCaller_gvcf/{sample}.g.vcf', sample=samples),
         expand(os.path.abspath(output_folder)+'/GATK_HaplotypeCaller_gvcf_gz/{sample}.g.vcf.gz', sample=samples)

include: './../tasks/gatk/gatk_haplotypecaller.smk'

include: './../tasks/bgzip/bgzip_gz_gvcf_file.smk'
