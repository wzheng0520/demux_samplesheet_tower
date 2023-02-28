nextflow.enable.dsl=2

params.library = null
params.indexs = null
params.output = null
params.eln = null
params.override = null
params.seqonly = null
params.type = null

process illumina_sample_sheet {
	container = "quay.io/biocontainers/pandas:1.4.3" + ":quay.io/biocontainers/openpyxl:1.8.6--py36_0"
	input:
	path library
	path indexs
	path output
	val eln

	output:
	path("*.csv"), emit: samplesheet_demux


	script:
	template 'illumina.py'
	
}

process tenx_sample_sheet {
	container = "quay.io/biocontainers/pandas:1.4.3" + ":quay.io/biocontainers/openpyxl:1.8.6--py36_0"
	
    cpus 2
    memory '8 GB'

	input:
	path library
	path indexs
	path output
	val eln
	val override

	output:
	path("*.csv"), emit: samplesheet_demux


	script:
	template 'tenx.py'
	
}

process seqonly_sample_sheet {
	container = "quay.io/biocontainers/pandas:1.4.3" + ":quay.io/biocontainers/openpyxl:1.8.6--py36_0"
    cpus 2
    memory '8 GB'

	input:
	path library
	path output
	val type
	val eln
	val override

	output:
	path("*.csv"), emit: samplesheet_demux


	script:
	template 'seqonly.py'
	
}



workflow {
	library = Channel.of(params.library)
	indexs = Channel.of(params.indexs)
	output = Channel.of(params.output)
	eln = Channel.of(params.eln)
	type = Channel.of(params.type)
	override = Channel.of(params.override)
	seqonly = Channel.of(params.seqonly)
	
	if (params.seqonly == 'yes'){
	seqonly_sample_sheet(library, output, type, eln, override)
	}
	
	else{
	if (params.type == "illumina") {
	illumina_sample_sheet(library, indexs, output, eln)
	}
	else{
	tenx_sample_sheet(library, indexs, output, eln, override)
	}

	}

	
}
	
	