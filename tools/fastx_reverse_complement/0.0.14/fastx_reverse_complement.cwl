#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "FASTQ/A Reverse Complement"

doc: |
  executes the fastx_reverse_complement command of FASTX implemented for version 0.0.13:
  optional args:
  [compress]
  fixed args:
  [inputFile, targetFileName]
  Producing the Reverse-complement of each sequence in a FASTQ/FASTA file.

  usage: fastx_reverse_complement [-h] [-r] [-z] [-v] [-i INFILE] [-o OUTFILE]
  Part of FASTX Toolkit 0.0.13 by A. Gordon (assafgordon@gmail.com)

  	   [-h]         = This helpful help screen.
  	   [-z]         = Compress output with GZIP.
  	   [-i INFILE]  = FASTA/Q input file. default is STDIN.
  	   [-o OUTFILE] = FASTA/Q output file. default is STDOUT.

baseCommand: fastx_reverse_complement

stdout: $(inputs.targetFileName)

requirements:
#  - $import: runtimeSettingsMedium.yml
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: cjh4zavolab/fastx:0.0.14
    #dockerFile: >
    #  $import: fastx-Dockerfile
  - class: SoftwareRequirement
    packages:
      fastx-toolkit:
        specs: ["http://identifiers.org/RRID:SCR_005534"]
        version: ["0.0.13"]

inputs:
  ### Optional Inputs ###
  compress: # TODO: runs through but cant be decompressed ???
    type: boolean?
    inputBinding:
      position: 1
      prefix: -z
    doc: |
      Compress output with GZIP. (take care of the targetFileName to have .gz as suffix)


  ### Necessary Inputs ###
  inputFile:
    type: File
    #format: [edam:format_1929, edam:format_1930]
    inputBinding:
      position: 5
      prefix: -i
    doc: |
      FASTAQ input file.

  targetFileName:
    type: string
    doc: |
      Name of the outputfile. Given as String.

outputs:
  reverse_complement_out:
    type: stdout
    #format: edam:format_1929


############################
s:dateCreated: "2017-11-30"
s:author:
  - class: s:Person
    s:name: Christina J. Herrmann
    s:email: mailto:christina.herrmann@unibas.ch

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
 - https://schema.org/docs/schema_org_rdfa.html # Might need to pip install html5lib
 - http://edamontology.org/EDAM_1.18.owl
