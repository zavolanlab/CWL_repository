#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "FASTQ to FASTA"

doc: |
  executes the fastq_to_fasta command of FASTX implemented for version 0.0.14:
  optional args:
  [rename, keepUnknown, verbose, compress]
  fixed args:
  [inputFile, targetFileName]


baseCommand: fastq_to_fasta

requirements:
#  - $import: runtimeSettingsMedium.yml
  - class: InlineJavascriptRequirement


hints:
  - class: DockerRequirement
    dockerPull: cjh4zavolab/fastx:0.0.14
  - class: SoftwareRequirement
    packages:
      fastx-toolkit:
        specs: ["http://identifiers.org/RRID:SCR_005534"]
        version: ["0.0.14"]


inputs:
  ### Optional Inputs ###
  rename: #tested
    type: boolean?
    inputBinding:
      position: 1
      prefix: -r
    doc: |
      Rename sequence identifiers to numbers.

  keepUnknown: #tested
    type: boolean?
    inputBinding:
      position: 2
      prefix: -n
    doc: |
      keep sequences with unknown (N) nucleotides.
      Default is to discard such sequences.

  verbose: #tested
    type: boolean?
    inputBinding:
      position: 3
      prefix: -v
    doc: |
      Verbose - report number of sequences.
      If [-o] is specified,  report will be printed to STDOUT.
      If [-o] is not specified (and output goes to STDOUT),
      report will be printed to STDERR.

  compress: # TODO: runs through but cant be decompressed
    type: boolean?
    inputBinding:
      position: 4
      prefix: -z
    doc: |
      Compress output with GZIP. (take care of the targetFileName to have .gz as suffix)

  quality:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -Q33
    doc: |
      Make the most qualities readable

  ### Necessary Inputs ###
  inputFile: #tested
    type: File
    inputBinding:
      position: 5
      prefix: -i
    doc: |
      FASTAQ input file.

  targetFileName: #tested       #drawback: outPath must be relative, prefix is location of cwl tool
    type: string
    doc: |
      Name of the outputfile. Given as String.


outputs:
  q2aResult:
    type: stdout
    format: edam:format_1929

stdout: $(inputs.inputFile.nameroot).fa

doc: |
  usage: fastq_to_fasta [-h] [-r] [-n] [-v] [-z] [-i INFILE] [-o OUTFILE]
  Part of FASTX Toolkit 0.0.14 by A. Gordon (assafgordon@gmail.com)

    [-h]         = This helpful help screen.
    [-r]         = Rename sequence identifiers to numbers.
    [-n]         = keep sequences with unknown (N) nucleotides.
                    Default is to discard such sequences.
    [-v]         = Verbose - report number of sequences.
                    If [-o] is specified,  report will be printed to STDOUT.
                    If [-o] is not specified (and output goes to STDOUT),
                    report will be printed to STDERR.
    [-z]         = Compress output with GZIP.
    [-i INFILE]  = FASTA/Q input file. default is STDIN.
    [-o OUTFILE] = FASTA output file. default is STDOUT.

############################
s:dateModified: "2018-02-28"
s:author:
  - class: s:Person
    s:name: Students
  - class: s:Person
    s:name: Christina J. Herrmann

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
 - https://schema.org/docs/schema_org_rdfa.html
 - http://edamontology.org/EDAM_1.18.owl
