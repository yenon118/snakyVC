rule gatk_selectvariants_gendb_snp:
    input:
         fasta = reference_file,
         in_file = os.path.join(os.path.abspath(output_folder),'GATK_GatherVcfs_gendb','{project_name}.vcf'.format(project_name=project_name))
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gendb_SNPs','{project_name}_snp.vcf'.format(project_name=project_name)),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gendb_SNPs','tmp')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_gendb_SNPs_log','{project_name}_snp.log'.format(project_name=project_name))
    params:
          '--select-type-to-include SNP'
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         """
         mkdir -p {output.out_tmp_dir}; 
         gatk --java-options "-Xmx{resources.memory}g" SelectVariants --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} {params} -O {output.out_file} 2> {log}
         """
