rule gatk_selectvariants_indel:
    input:
        fasta = reference_file,
        in_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{project_name}.vcf.gz'.format(project_name=project_name))
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz','{project_name}_indel.vcf.gz'.format(project_name=project_name)),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz','tmp')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_SelectVariants_Indels_gz_log','{project_name}_indel.log'.format(project_name=project_name))
    params:
        '--select-type-to-include INDEL'
    resources:
        memory = memory
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" SelectVariants --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} {params} -O {output.out_file} 2> {log}
        """