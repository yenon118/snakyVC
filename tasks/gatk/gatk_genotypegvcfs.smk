rule gatk_genotypegvcfs:
    input:
         fasta = reference_file,
         in_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs/{project_name}.g.vcf'.format(project_name=project_name))
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs/{project_name}.vcf'.format(project_name=project_name)),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs/tmp/')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_log/{project_name}.log'.format(project_name=project_name))
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir}; 
         gatk --java-options "-Xmx{resources.memory}g" GenotypeGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} -O {output.out_file} 2> {log}
         """
