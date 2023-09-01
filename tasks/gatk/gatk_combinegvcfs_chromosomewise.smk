rule gatk_combinegvcfs_chromosomewise:
	input:
		fasta = reference_file,
		in_file = expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}.g.vcf.gz'), sample=samples)
	params:
		all_gvcf_in_files = ' '.join(['-V '+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz','{sample}.g.vcf.gz'.format(sample=sample)) for sample in samples]),
		selected_chromosome = '{chromosome}'
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{project_name}_{{chromosome}}.g.vcf.gz'.format(project_name=project_name)),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','tmp','{project_name}_{{chromosome}}'.format(project_name=project_name))))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_log','{project_name}_{{chromosome}}.log'.format(project_name=project_name))
	resources:
		memory = memory
	shell:
		"""
		mkdir -p {output.out_tmp_dir};
		gatk --java-options "-Xmx{resources.memory}g" CombineGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} {params.all_gvcf_in_files} -L {params.selected_chromosome} -O {output.out_file} 2> {log}
		"""
