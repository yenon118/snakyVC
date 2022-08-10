rule gatk_sortsam:
	input:
		in_file = os.path.join(os.path.abspath(output_folder),'BWA_sam','{sample}.sam')
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_SortSam','{sample}.bam'),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_SortSam','tmp','{sample}')))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_SortSam_log','{sample}.log')
	params:
		'--SORT_ORDER coordinate --CREATE_INDEX true --MAX_RECORDS_IN_RAM 5000000 --VALIDATION_STRINGENCY LENIENT'
	resources:
		memory = memory
	shell:
		'mkdir -p {output.out_tmp_dir}; '
		'gatk --java-options "-Xmx{resources.memory}g" SortSam --TMP_DIR {output.out_tmp_dir} {params} -I {input.in_file} -O {output.out_file} 2> {log}'
