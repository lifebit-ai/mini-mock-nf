# mini-mock-nf

Minimal nextflow pipeline for testing purposes. It does not do anything
meaningfull other than just checking input parameters. 

## How to run it

This pipeline has three mandatory parameters and one options:

- [optional] `reads`: Path to paired-end FastQ files that must be specified with
  a glob pattern. By default it is set to `"${baseDir}/reads/*_{1,2}*"`
- `reference`: Path to a single text file. An example reference file is provided in 
  `reads/reference.txt`
- `maxLines`: Text value parameter that should be an integer. It fetches the first N
  lines from the FastQ files. It can be used to force the pipeline to fail by providing
  a higher number than the number of lines in the FastQ files (the example ones contain
  20 lines, so setting 21 will make the pipeline fail).
- `requiredFlag`: Flag parameter that needs to be provided for the pipeline to pass.

