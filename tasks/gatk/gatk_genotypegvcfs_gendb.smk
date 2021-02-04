rule gatk_genotypegvcfs_gendb:
    input:
         fasta = reference_file,
         in_gendb = os.path.join(os.path.abspath(output_folder),'GATK_GenomicsDBImport/{project_name}_{{chromosome}}'.format(project_name=project_name))
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gendb/{project_name}_{{chromosome}}.vcf'.format(project_name=project_name)),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gendb/tmp_{chromosome}/')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gendb_log/{project_name}_{{chromosome}}.log'.format(project_name=project_name))
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir};
         gatk --java-options "-Xmx{resources.memory}g" GenotypeGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V gendb://{input.in_gendb} -O {output.out_file} 2> {log}
         """
