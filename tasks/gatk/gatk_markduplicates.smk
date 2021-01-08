rule gatk_markduplicates:
    input:
         in_file = os.path.join(os.path.abspath(output_folder),'GATK_SortSam/{sample}.bam')
    output:
          out_file = os.path.join(os.path.abspath(output_folder),'GATK_MarkDuplicates/{sample}.bam'),
          metrics_file = os.path.join(os.path.abspath(output_folder),'GATK_MarkDuplicates_metrics/{sample}.metrics'),
          out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_MarkDuplicates/tmp/{sample}/')))
    log:
       os.path.join(os.path.abspath(output_folder),'GATK_MarkDuplicates_log/{sample}.log')
    params:
          '--CREATE_INDEX true --MAX_RECORDS_IN_RAM 5000000 --VALIDATION_STRINGENCY LENIENT'
    resources:
             memory = memory
    conda:
         "./../../envs/gatk.yaml"
    shell:
         'mkdir -p {output.out_tmp_dir}; '
         'gatk --java-options "-Xmx{resources.memory}g" MarkDuplicates --TMP_DIR {output.out_tmp_dir} {params} -I {input.in_file} -O {output.out_file} -M {output.metrics_file} 2> {log}'
