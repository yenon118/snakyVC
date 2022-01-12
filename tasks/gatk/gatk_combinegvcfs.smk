rule gatk_combinegvcfs:
	input:
		fasta = reference_file,
		in_file = expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}.g.vcf.gz'), sample=samples)
	params:
		' '.join(['-V '+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}.g.vcf.gz'.format(sample=sample)) for sample in samples])
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{project_name}.g.vcf.gz'.format(project_name=project_name)),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','tmp')))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_log','{project_name}.log'.format(project_name=project_name))
	resources:
		memory = memory
	conda:
		"./../../envs/gatk.yaml"
	shell:
		"""
		mkdir -p {output.out_tmp_dir}; 
		gatk --java-options "-Xmx{resources.memory}g" CombineGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} {params} -O {output.out_file} 2> {log}
		"""
