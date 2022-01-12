rule gatk_combinegvcfs_chromosomewise:
	input:
		fasta = reference_file,
		in_file = expand(os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz_{{chromosome}}','{sample}_{{chromosome}}.g.vcf.gz'), sample=samples)
	params:
		' '.join(['-V '+os.path.join(os.path.abspath(output_folder),'GATK_HaplotypeCaller_gvcf_gz_{chromosome}','{sample}_{{chromosome}}.g.vcf.gz'.format(sample=sample)) for sample in samples])
	output:
		out_file = os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_{chromosome}','{project_name}_{{chromosome}}.g.vcf.gz'.format(project_name=project_name)),
		out_tmp_dir = temp(directory(os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_{chromosome}','tmp_{chromosome}')))
	log:
		os.path.join(os.path.abspath(output_folder),'GATK_CombineGVCFs_gz_{chromosome}_log','{project_name}_{{chromosome}}.log'.format(project_name=project_name))
	resources:
		memory = memory
	conda:
	   "./../../envs/gatk.yaml"
	shell:
	   """
	   mkdir -p {output.out_tmp_dir};
	   gatk --java-options "-Xmx{resources.memory}g" CombineGVCFs --tmp-dir {output.out_tmp_dir} -R {input.fasta} {params} -O {output.out_file} 2> {log}
	   """
