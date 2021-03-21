import sys
import os
import re

from snakemake.remote.SFTP import RemoteProvider

input_files = config['input_files']
output_folder = config['output_folder']
host = config['host']
username = config['username']
password = config['password']
local_workflow_path = config['local_workflow_path']
local_reference_file = config['local_reference_file']
local_tmp_folder = config['local_tmp_folder']
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


SFTP = RemoteProvider(username=username, password=password, mkdir_remote=True)


rule all:
    input:
         SFTP.remote(expand(host+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf','{sample}.g.vcf'), sample=samples)),
         SFTP.remote(expand(host+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}.g.vcf.gz'), sample=samples))


rule sftp_gatk_haplotypecaller:
    input:
         fasta = local_reference_file,
         in_file = SFTP.remote(host+os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension))
    output:
          out_file = SFTP.remote(host+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf','{sample}.g.vcf')),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(local_tmp_folder),'GATK_HaplotypeCaller_gvcf','tmp','{sample}')))
    log:
       SFTP.remote(host+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_log','{sample}.log'))
    params:
          '-ERC GVCF'
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        samtools index {input.in_file};
        gatk --java-options "-Xmx{resources.memory}g" HaplotypeCaller --tmp-dir {output.out_tmp_dir} {params} -R {input.fasta} -I {input.in_file} -O {output.out_file} 2> {log}
        """


include: './../tasks/bgzip/sftp_bgzip_gz_gvcf_file.smk'
