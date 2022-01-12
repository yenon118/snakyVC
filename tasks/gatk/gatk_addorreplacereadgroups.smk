rule gatk_addorreplacereadgroups:
	input:
		in_file = os.path.join(os.path.abspath(output_folder),'GATK_MarkDuplicates','{sample}.bam')
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_AddOrReplaceReadGroups','{sample}.bam'),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_AddOrReplaceReadGroups','tmp','{sample}')))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_AddOrReplaceReadGroups_log','{sample}.log')
	params:
		p1 = '--SORT_ORDER coordinate --CREATE_INDEX true --MAX_RECORDS_IN_RAM 5000000 --VALIDATION_STRINGENCY LENIENT',
		p2 = '--RGID {sample} --RGLB {sample} --RGPL Illumina --RGPU {sample} --RGSM {sample} --RGCN BGI'
	resources:
		memory = memory
	conda:
		"./../../envs/gatk.yaml"
	shell:
		'mkdir -p {output.out_tmp_dir}; '
		'gatk --java-options "-Xmx{resources.memory}g" AddOrReplaceReadGroups --TMP_DIR {output.out_tmp_dir} {params.p1} {params.p2} -I {input.in_file} -O {output.out_file} 2> {log}'
