rule gatk_haplotypecaller_chromosomewise:
    input:
        fasta = reference_file,
        in_file = os.path.join(os.path.abspath(output_folder),'GATK_AddOrReplaceReadGroups','{sample}.bam')
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}_{chromosome}.g.vcf.gz'),
        out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','tmp','{sample}_{chromosome}')))
    log:
        os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz_log','{sample}_{chromosome}.log')
    params:
        '-ERC GVCF -L {chromosome}'
    resources:
        memory = memory
    shell:
        """
        mkdir -p {output.out_tmp_dir};
        gatk --java-options "-Xmx{resources.memory}g" HaplotypeCaller --tmp-dir {output.out_tmp_dir} {params} -R {input.fasta} -I {input.in_file} -O {output.out_file} 2> {log}
        """