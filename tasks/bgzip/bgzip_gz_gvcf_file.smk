rule bgzip_gz_gvcf_file:
    input:
         in_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf/{sample}.g.vcf')
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz/{sample}.g.vcf.gz')
    conda:
         "./../../envs/htslib.yaml"
    shell:
         'bgzip < {input.in_file} > {output.out_file}'
