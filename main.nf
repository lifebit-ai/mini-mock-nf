readsChannel = Channel.fromFilePairs(params.reads)
	.ifEmpty{ exit 1, 'params.reads was empty - no input files were provided!' }

referenceChannel = Channel.fromPath(params.reference)
	.ifEmpty{ exit 1, 'params.reference was empty - no reference file was provided!' }

maxLinesChannel = Channel.value(params.maxLines)

if (!params.requiredFlag) { exit 1, 'params.requiredFlag is a... required flag' }

process inputCheckers {

	echo true

	input:
	set sampleId, file(fastqPair) from readsChannel
	file reference  from referenceChannel
	val maxNumberOfLines from maxLinesChannel
	
	
	"""
	gunzip -c $fastqPair[0] | head -n $maxNumberOfLines >> out.txt
	gunzip -c $fastqPair[1] | head -n $maxNumberOfLines >> out.txt

	linesRetrieved=\$(grep -c ^ out.txt)
	expectedLines=\$(($maxNumberOfLines * 2))
	if [ "\$linesRetrieved" -ne "\$expectedLines" ]; then
		echo 'Unexpected number of lines retrieve from input files';
		exit 1;
	fi
	"""

}
