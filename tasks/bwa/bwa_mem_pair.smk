rule bwa_mem:
    input:
         fasta = reference_file,
         fastq_r1 = os.path.join(input_folder_1,'{sample}'+input_extension_1),
         fastq_r2 = os.path.join(input_folder_2,'{sample}'+input_extension_2)
    output:
          out_file = os.path.join(output_folder,'BWA_sam/{sample}.sam'),
          out_log_file = os.path.join(output_folder,'BWA_sam_log/{sample}.log')
    threads: threads
    conda:
         "./../../envs/bwa.yaml"
    shell:
         'bwa mem -t {threads} -M {input.fasta} {input.fastq_r1} {input.fastq_r2} 2> {output.out_log_file} > {output.out_file}'
