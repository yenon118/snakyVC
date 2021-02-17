rule gatk_gathervcfs_chromosomewise:
    input:
         fasta = reference_file,
         in_file = expand(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_{chromosome}','{project_name}_{{chromosome}}.vcf'.format(project_name=project_name)), chromosome=chromosomes)
    params:
          ' '.join(['-I '+os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_{chromosome}'.format(chromosome=chromosome),'{project_name}_{chromosome}.vcf'.format(project_name=project_name, chromosome=chromosome)) for chromosome in chromosomes])
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise','{project_name}.vcf'.format(project_name=project_name)),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise','tmp')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_chromosomewise_log','{project_name}.log'.format(project_name=project_name))
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir};
         gatk --java-options "-Xmx{resources.memory}g" GatherVcfs --TMP_DIR {output.out_tmp_dir} -R {input.fasta} {params} -O {output.out_file} 2> {log}
         """
