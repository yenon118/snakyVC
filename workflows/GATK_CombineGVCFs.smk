import sys
import os
import re

project_name = config['project_name']
workflow_path = config['workflow_path']
input_files = config['input_files']
reference_file = config['reference_file']
output_folder = config['output_folder']
output_prefix = config['output_prefix']
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
        os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{output_prefix}.g.vcf.gz'.format(output_prefix=output_prefix)),


rule gatk_combinegvcfs:
    input:
        fasta = reference_file,
        in_file = expand(os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension), sample=samples)
    params:
        ' '.join(['-V '+os.path.join(os.path.abspath(input_folder),str('{sample}'+input_extension).format(sample=sample)) for sample in samples])
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{output_prefix}.g.vcf.gz'.format(output_prefix=output_prefix)),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','tmp')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_log','{output_prefix}.log'.format(output_prefix=output_prefix))
    resources:
        memory = memory
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" CombineGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} {params} -O {output.out_file} 2> {log}
        """