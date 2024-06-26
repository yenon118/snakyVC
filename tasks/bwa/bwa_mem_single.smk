rule bwa_mem:
    input:
        fasta = reference_file,
        fastq = os.path.join(os.path.abspath(input_folder),'{sample}'+input_extension)
    output:
        out_file = os.path.join(os.path.abspath(output_folder),'BWA_sam','{sample}.sam')
    log:
        os.path.join(os.path.abspath(output_folder),'BWA_sam_log','{sample}.log')
    threads: threads
    shell:
        """
        bwa mem -t {threads} -M {input.fasta} {input.fastq} 2> {log} > {output.out_file}
        """