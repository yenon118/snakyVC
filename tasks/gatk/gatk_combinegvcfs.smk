rule gatk_combinegvcfs:
    input:
         fasta = reference_file,
         in_file = expand(os.path.abspath(output_folder)+'/GATK_HaplotypeCaller_gvcf/{sample}.g.vcf', sample=samples)
    params:
          ' '.join(['-V '+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf/{sample}.g.vcf'.format(sample=sample)) for sample in samples])
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs/{project_name}.g.vcf'.format(project_name=project_name)),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs/tmp/')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_log/{project_name}.log'.format(project_name=project_name))
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir}; 
         gatk --java-options "-Xmx{resources.memory}g" CombineGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} {params} -O {output.out_file} 2> {log}
         """
