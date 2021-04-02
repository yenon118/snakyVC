import sys
import os
import re

workflow_path = config['workflow_path']
input_files = config['input_files']
chromosomes = config['chromosomes']
alleles_file = config['alleles_file']
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
         expand(os.path.join(os.path.abspath(output_folder), 'GATK_HaplotypeCaller_vcf_{chromosome}', '{sample}_{chromosome}.vcf'), sample=samples, chromosome=chromosomes),
         expand(os.path.join(os.path.abspath(output_folder), 'GATK_GatherVcfs_chromosomewise', '{sample}.vcf'), sample=samples),
         expand(os.path.join(os.path.abspath(output_folder), 'GATK_GatherVcfs_chromosomewise_gz', '{sample}.vcf.gz'), sample=samples)


rule gatk_haplotypecaller:
    input:
        fasta = reference_file,
        alleles = alleles_file,
        in_file = os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension)
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_{chromosome}','{sample}_{chromosome}.vcf'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_{chromosome}','tmp','{sample}_{chromosome}')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_{chromosome}_log','{sample}_{chromosome}.log')
    params:
        selected_chromosome = "{chromosome}"
    resources:
        memory = memory
    conda:
        "./../../envs/gatk.yaml"
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" HaplotypeCaller --tmp-dir {output.out_tmp_dir} -L {params.selected_chromosome} --force-call-filtered-alleles --alleles {input.alleles} -R {input.fasta} -I {input.in_file} -O {output.out_file} 2> {log}
        """


rule gatk_gathervcfs_chromosomewise:
    input:
         fasta = reference_file,
         in_file = expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_{chromosome}','{{sample}}_{chromosome}.vcf'), chromosome=chromosomes)
    params:
          ' '.join(['-I '+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_{chromosome}'.format(chromosome=chromosome),'{{sample}}_{chromosome}.vcf'.format(chromosome=chromosome)) for chromosome in chromosomes])
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise','{sample}.vcf'),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise','tmp', '{sample}')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise_log','{sample}.log')
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir};
         gatk --java-options "-Xmx{resources.memory}g" GatherVcfs --TMP_DIR {output.out_tmp_dir} -R {input.fasta} {params} -O {output.out_file} 2> {log}
         """


rule bgzip_gz_vcf_file:
    input:
         in_file = os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise','{sample}.vcf')
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise_gz','{sample}.vcf.gz')
    conda:
         "./../../envs/htslib.yaml"
    shell:
         'bgzip < {input.in_file} > {output.out_file}'
