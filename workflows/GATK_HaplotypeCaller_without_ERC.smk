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
         expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf','{sample}.vcf'), sample=samples),
         expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_gz','{sample}.vcf.gz'), sample=samples)


rule gatk_haplotypecaller:
    input:
        fasta = reference_file,
        in_file = os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension)
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf','{sample}.vcf'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf','tmp','{sample}')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_log','{sample}.log')
    resources:
        memory = memory
    conda:
        "./../../envs/gatk.yaml"
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" HaplotypeCaller --tmp-dir {output.out_tmp_dir} --output-mode EMIT_ALL_CONFIDENT_SITES -R {input.fasta} -I {input.in_file} -O {output.out_file} 2> {log}
        """


include: './../tasks/bgzip/bgzip_gz_vcf_file.smk'
