readsChannel = Channel.fromFilePairs(params.reads)
	.ifEmpty{ exit 1, 'params.reads was empty - no input files were provided!' }

if (!params.reference) {exit 1, 'params.reference parameter was not specified!'}
referenceChannel = Channel.fromPath(params.reference)
	.ifEmpty{ exit 1, 'params.reference was empty - no reference file was provided!' }

if (!params.adaptersDir) {exit 1, 'params.adaptersDir parameter was not specified'}
adaptersDirChannel = Channel.fromPath(params.adaptersDir)
	.ifEmpty{ exit 1, 'params.adaptersDir was empty!' }

maxLinesChannel = Channel.value(params.maxLines)

if (!params.requiredFlag) { exit 1, 'params.requiredFlag is a... required flag' }

process inputCheckers {

	input:
	set sampleId, file(fastqPair) from readsChannel
	file reference  from referenceChannel
	file adaptersDir from adaptersDirChannel
	val maxNumberOfLines from maxLinesChannel
	
	
	"""
	gunzip -c ${fastqPair[0]} | head -n $maxNumberOfLines >> out.txt
	gunzip -c ${fastqPair[1]} | head -n $maxNumberOfLines >> out.txt

	# Check if provided adapterDir parameter is an actual directory
	if [ ! -d "$adaptersDir" ]; then
		echo 'param.adaptersDir did not provide a directory';
		exit 1;
	fi

	# Checked if the retrieved lines from the FastQ files match the
	# the expected number.
	linesRetrieved=\$(grep -c ^ out.txt)
	expectedLines=\$(($maxNumberOfLines * 2))
	if [ "\$linesRetrieved" -ne "\$expectedLines" ]; then
		echo 'Unexpected number of lines retrieve from input files';
		exit 1;
	fi
	"""

}
