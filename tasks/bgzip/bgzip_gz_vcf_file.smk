rule bgzip_gz_gvcf_file:
    input:
         in_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf','{sample}.vcf')
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_vcf_gz','{sample}.vcf.gz')
    conda:
         "./../../envs/htslib.yaml"
    shell:
         'bgzip < {input.in_file} > {output.out_file}'
