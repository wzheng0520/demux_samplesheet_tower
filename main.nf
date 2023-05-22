#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.library = null
params.indexs = null
params.output = null
params.eln = null
params.override = null
params.seqonly = null
params.type = null

process illumina_sample_sheet {
	publishDir "${params.output}", mode: 'copy', pattern: 'samplesheet_demux.csv'
	container "wzheng0520/samplesheet_demux:samplesheet_demux"
	input:
	path library
	path indexs
	path output
	val eln
	val seq

	output:
	path "samplesheet_demux.csv", emit: samplesheet_demux


	script:
	template 'illumina.py'
	
}

process tenx_sample_sheet {
	publishDir "${params.output}", mode: 'copy', pattern: 'samplesheet_demux.csv'
	container "wzheng0520/samplesheet_demux:samplesheet_demux"
	
    cpus 2
    memory '8 GB'

	input:
	path library
	path indexs
	path output
	val eln
	val override

	output:
	path "samplesheet_demux.csv", emit: samplesheet_demux


	script:
	template 'tenx.py'
	
}

process seqonly_sample_sheet {
	publishDir "${params.output}", mode: 'copy', pattern: 'samplesheet_demux.csv'
	container "wzheng0520/samplesheet_demux:samplesheet_demux"

	input:
	path library
	val eln
	val type
	val override

	output:
	path "samplesheet_demux.csv", emit: samplesheet_demux
    
    script:
	template 'seqonly.py'

}

process neb_sample_sheet {
	publishDir "${params.output}", mode: 'copy', pattern: 'samplesheet_demux.csv'
	container "wzheng0520/samplesheet_demux:samplesheet_demux"

	input:
	path library
	path indexs
	path output
	val  eln

	output:
	path "samplesheet_demux.csv", emit: samplesheet_demux
    
    script:
	template 'neb.py'

}



workflow {
	library = Channel.of(params.library)
	indexs = Channel.of(params.indexs)
	output = Channel.of(params.output)
	eln = Channel.of(params.eln)
	type = Channel.of(params.type)
	override = Channel.of(params.override)
	seqonly = Channel.of(params.seqonly)
	seq = Channel.of(params.seq)
	file_path_output = Channel.fromPath(params.output).map{ it+ '/samplesheet_demux.csv' }
	
	if (params.seqonly == 'yes'){
	seqonly_sample_sheet(library, eln, type, override)
	}
	
	else{
	if (params.type == "illumina") {
	illumina_sample_sheet(library, indexs, file_path_output, eln, seq)
	}
	else if (params.type == "10x") {
	tenx_sample_sheet(library, indexs, file_path_output, eln, override)
	}
	else {
	neb_sample_sheet(library, indexs, file_path_output, eln)
	}

	}

	
}
	
	