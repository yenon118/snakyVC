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
         expand(os.path.join(os.path.abspath(output_folder),'GATK_GenomicsDBImport','{project_name}_{{chromosome}}'.format(project_name=project_name)), chromosome=chromosomes),
         expand(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gendb','{project_name}_{{chromosome}}.vcf'.format(project_name=project_name)), chromosome=chromosomes),
         os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_gendb','{project_name}.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gendb_SNPs','{project_name}_snp.vcf'.format(project_name=project_name)),
         os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gendb_Indels','{project_name}_indel.vcf'.format(project_name=project_name))


rule gatk_genomicsdbimport:
    input:
         in_file = expand(os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension), sample=samples)
    params:
          joined_in_files = ' '.join(['-V '+os.path.join(os.path.abspath(input_folder),str('{sample}'+input_extension).format(sample=sample)) for sample in samples]),
          selected_chromosome = "{chromosome}"
    output:
          out_dir = directory(os.path.join(os.path.abspath(output_folder),'GATK_GenomicsDBImport','{project_name}_{{chromosome}}'.format(project_name=project_name))),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenomicsDBImport','tmp_{chromosome}')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_GenomicsDBImport_log','{project_name}_{{chromosome}}.log'.format(project_name=project_name))
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir};
         gatk --java-options "-Xmx{resources.memory}g" GenomicsDBImport --tmp-dir {output.out_tmp_dir} {params.joined_in_files} --genomicsdb-workspace-path {output.out_dir} -L {params.selected_chromosome} 2> {log}
         """

include: './../tasks/gatk/gatk_genotypegvcfs_gendb.smk'
include: './../tasks/gatk/gatk_gathervcfs_gendb.smk'
include: './../tasks/gatk/gatk_selectvariants_gendb_snp.smk'
include: './../tasks/gatk/gatk_selectvariants_gendb_indel.smk'
