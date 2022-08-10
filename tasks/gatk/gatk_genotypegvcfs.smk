rule gatk_genotypegvcfs:
	input:
		fasta = reference_file,
		in_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{project_name}.g.vcf.gz'.format(project_name=project_name))
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{project_name}.vcf.gz'.format(project_name=project_name)),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','tmp')))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_log','{project_name}.log'.format(project_name=project_name))
	resources:
		memory = memory
	shell:
		"""
		mkdir -p {output.out_tmp_dir}; 
		gatk --java-options "-Xmx{resources.memory}g" GenotypeGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} -O {output.out_file} 2> {log}
		"""
