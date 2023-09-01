rule gatk_genotypegvcfs_chromosomewise:
	input:
		fasta = reference_file,
		in_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz','{project_name}_{{chromosome}}.g.vcf.gz'.format(project_name=project_name))
	params:
		selected_chromosome = '{chromosome}'
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','{project_name}_{{chromosome}}.vcf.gz'.format(project_name=project_name)),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz','tmp', '{project_name}_{{chromosome}}'.format(project_name=project_name))))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_log','{project_name}_{{chromosome}}.log'.format(project_name=project_name))
	resources:
		memory = memory
	shell:
		"""
		mkdir -p {output.out_tmp_dir};
		gatk --java-options "-Xmx{resources.memory}g" GenotypeGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} -L {params.selected_chromosome} -V {input.in_file} -O {output.out_file} 2> {log}
		"""
