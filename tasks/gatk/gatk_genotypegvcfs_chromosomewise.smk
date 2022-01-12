rule gatk_genotypegvcfs_chromosomewise:
	input:
		fasta = reference_file,
		in_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_{chromosome}','{project_name}_{{chromosome}}.g.vcf.gz'.format(project_name=project_name))
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_{chromosome}','{project_name}_{{chromosome}}.vcf.gz'.format(project_name=project_name)),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_{chromosome}','tmp_{chromosome}')))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_GenotypeGVCFs_gz_{chromosome}_log','{project_name}_{{chromosome}}.log'.format(project_name=project_name))
	resources:
		memory = memory
	conda:
		"./../../envs/gatk.yaml"
	shell:
		"""
		mkdir -p {output.out_tmp_dir};
		gatk --java-options "-Xmx{resources.memory}g" GenotypeGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} -V {input.in_file} -O {output.out_file} 2> {log}
		"""
