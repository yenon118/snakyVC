import sys
import os
import re

project_name = config['project_name']
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
    possible_sample = re.sub('(\\.g\\.vcf.*)', '', str(os.path.basename(input_files[i])))
    if not possible_sample in samples:
        samples.append(possible_sample)
    possible_extension = re.sub(possible_sample,'',str(os.path.basename(input_files[i])))
    if possible_extension != input_extension:
        input_extension = possible_extension


rule all:
    input:
        expand(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{sample}.vcf.gz'), sample=samples),
        expand(os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_SNPs_gz','{sample}_snp.vcf.gz'), sample=samples),
        expand(os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz','{sample}_indel.vcf.gz'), sample=samples)


rule gatk_genotypegvcfs:
    input:
        fasta = reference_file,
        in_file = os.path.join(os.path.abspath(input_folder),'{sample}.g.vcf.gz')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{sample}.vcf.gz'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','tmp','{sample}')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_log','{sample}.log')
    resources:
        memory = memory
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" GenotypeGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} -O {output.out_file} 2> {log}
        """


rule gatk_selectvariants_snp:
    input:
        fasta = reference_file,
        in_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{sample}.vcf.gz')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_SNPs_gz','{sample}_snp.vcf.gz'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_SNPs_gz','tmp','{sample}')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_SNPs_gz_log','{sample}_snp.log')
    params:
        '--select-type-to-include SNP'
    resources:
        memory = memory
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" SelectVariants --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} {params} -O {output.out_file} 2> {log}
        """


rule gatk_selectvariants_indel:
    input:
        fasta = reference_file,
        in_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{sample}.vcf.gz')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz','{sample}_indel.vcf.gz'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz','tmp','{sample}')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz_log','{sample}_indel.log')
    params:
        '--select-type-to-include INDEL'
    resources:
        memory = memory
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" SelectVariants --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} {params} -O {output.out_file} 2> {log}
        """