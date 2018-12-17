#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "Cutadapt - find and remove adapter (or other unwanted) sequences
        from high-throughput sequencing reads"

doc: |
  Cutadapt (version 1.16)

  Usage:
      cutadapt -a ADAPTER [options] [-o output.fastq] input.fastq
  For paired-end reads:
      cutadapt -a ADAPT1 -A ADAPT2 [options] -o out1.fastq -p out2.fastq in1.fastq in2.fastq

  Replace "ADAPTER" with the actual sequence of your 3'' adapter. IUPAC wildcard
  characters are supported. The reverse complement is *not* automatically
  searched. All reads from input.fastq will be written to output.fastq with the
  adapter sequence removed. Adapter matching is error-tolerant. Multiple adapter
  sequences can be given (use further -a options), but only the best-matching
  adapter will be removed.

  Input may also be in FASTA format. Compressed input and output is supported and
  auto-detected from the file name (.gz, .xz, .bz2). Use the file name '-' for
  standard input/output. Without the -o option, output is sent to standard output.

  Citation:

  Marcel Martin. Cutadapt removes adapter sequences from high-throughput
  sequencing reads. EMBnet.Journal, 17(1):10-12, May 2011.
  http://dx.doi.org/10.14806/ej.17.1.200

  Use "cutadapt --help" to see all command-line options.
  See http://cutadapt.readthedocs.io/ for full documentation.

hints:
  - class: DockerRequirement
    dockerPull: cjh4zavolab/cutadapt:1.16

requirements:
#  - $import: runtimeSettingsMedium.yml
  - class: InlineJavascriptRequirement

stdout: $(inputs.targetFileName)

inputs:
  ### Optional Inputs ###
  # Finding adapters:
  adapter: # not tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: --adapter=
          separate: false
    inputBinding:
      position: 10
    doc: |
      Sequence of an adapter ligated to the 3` end (paired
      data: of the first read). The adapter and subsequent
      bases are trimmed. If a '$' character is appended
      ('anchoring'), the adapter is only found if it is a
      suffix of the read.

  front: # not tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: --front=
          separate: false
    inputBinding:
      position: 10
    doc: |
      Sequence of an adapter ligated to the 5` end (paired
      data: of the first read). The adapter and any
      preceding bases are trimmed. Partial matches at the 5`
      end are allowed. If a '^' character is prepended
      ('anchoring'), the adapter is only found if it is a
      prefix of the read.

  anywhere: # not tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: --anywhere=
          separate: false
    inputBinding:
      position: 10
    doc: |
      Sequence of an adapter that may be ligated to the 5`
      or 3` end (paired data: of the first read). Both types
      of matches as described under -a und -g are allowed.
      If the first base of the read is part of the match,
      the behavior is as with -g, otherwise as with -a. This
      option is mostly for rescuing failed library
      preparations - do not use if you know which end your
      adapter was ligated to!

  errorRate: # not tested
    type: float?
    inputBinding:
      position: 10
      prefix: --error-rate=
      separate: false
    doc: |
      Maximum allowed error rate (no. of errors divided by
      the length of the matching region) (default: 0.1)

  noIndels: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-indels
    doc: |
      Allow only mismatches in alignments.
      Default: allow both mismatches and indels

  times: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --times=
      separate: false
    doc: |
      Remove up to COUNT adapters from each read. Default: 1

  overlap: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --overlap=
      separate: false
    doc: |
      Require MINLENGTH overlap between read and adapter for
      an adapter to be found. Default: 3

  matchReadWildcards: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --match-read-wildcards
    doc: |
      Interpret IUPAC wildcards in reads. Default: False

  noMatchAdapterWildcards: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-match-adapter-wildcards
    doc: |
      Do not interpret IUPAC wildcards in adapters.

  noTrim: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-trim
    doc: |
      Match and redirect reads to output/untrimmed-output as usual,
      but do not remove adapters.

  maskAdapter:  # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --mask-adapter
    doc: |
      Mask adapters with 'N' characters instead of trimming them.

  # Additional read modifications:
  cut: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --cut=
      separate: false
    doc: |
      Remove bases from each read (first read only if
      paired). If LENGTH is positive, remove bases from the
      beginning. If LENGTH is negative, remove bases from
      the end. Can be used twice if LENGTHs have different
      signs. This is applied *before* adapter trimming.

  nextseqTrim: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --nextseq-trim=
      separate: false
    doc: |
      (3` CUTOFF) NextSeq-specific quality trimming (each read). Trims
      also dark cycles appearing as high-quality G bases.

  qualityCutoff: # not tested
    type: int[]? # TODO: max 2 inputs
    inputBinding:
      prefix: --quality-cutoff=
      itemSeparator: ","
      separate: false
      position: 10
    doc: |
      Trim low-quality bases from 5` and/or 3` ends of each
      read before adapter removal. Applied to both reads if
      data is paired. If one value is given, only the 3` end
      is trimmed. If two comma-separated cutoffs are given,
      the 5` end is trimmed with the first cutoff, the 3`
      end with the second.

  qualityBase: # not tested
    type: int? # TODO: allowed values
    inputBinding:
      position: 10
      prefix: --quality-base=
      separate: false
    doc: |
      Assume that quality values in FASTQ are encoded as
      ascii(quality + QUALITY_BASE). This needs to be set to
      64 for some old Illumina FASTQ files. Default: 33

  length: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --length=
      separate: false
    doc: |
      Shorten reads to LENGTH. This and the following
      modifications are applied after adapter trimming.

  trimN: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --trim-n
    doc: |
      Trim N`s on ends of reads.

  lengthTag: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --length-tag=
      separate: false
    doc: |
      Search for TAG followed by a decimal number in the
      description field of the read. Replace the decimal
      number with the correct length of the trimmed read.
      For example, use --length-tag 'length=' to correct
      fields like 'length=123'.

  stripSuffix: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --strip-suffix=
      separate: false
    doc: |
      Remove this suffix from read names if present. Can be
      given multiple times.

  prefix: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --prefix=
      separate: false
    doc: |
      Add this prefix to read names. Use {name} to insert
      the name of the matching adapter.

  suffix: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --suffix=
      separate: false
    doc: |
      Add this suffix to read names; can also include {name}

  # Filtering of processed reads:
  # Filters are applied after above read modifications. Paired-end reads
  # are always discarded pairwise (see also --pair-filter).
  minimumLength: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --minimum-length=
      separate: false
    doc: |
      Discard reads shorter than LENGTH. Default: 0

  maximumLength: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --maximum-length=
      separate: false
    doc: |
      Discard reads longer than LENGTH. Default: no limit

  maxN: # not tested
    type: float?
    inputBinding:
      position: 10
      prefix: --max-n=
      separate: false
    doc: |
       Discard reads with more than COUNT 'N' bases. If COUNT
       is a number between 0 and 1, it is interpreted as a
       fraction of the read length.

  discardTrimmed: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --discard-trimmed
    doc: |
      Discard reads that contain an adapter. Also use -O to
      avoid discarding too many randomly matching reads!

  discardUntrimmed: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --discard-untrimmed
    doc: |
      Discard reads that do not contain the adapter.

  # Output options:
  quiet: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --quiet
    doc: |
      Print only error messages.

  infoFile: #not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --info-file=
      separate: false
    doc: |
      Write information about each read and its adapter
      matches into FILE. See the documentation for the file
      format.

  restFile: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --rest-file=
      separate: false
    doc: |
      When the adapter matches in the middle of a read,
      write the rest (after the adapter) into FILE.

  wildcardFile: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --wildcard-file=
      separate: false
    doc: |
      When the adapter has N wildcard bases, write adapter
      bases matching wildcard positions to FILE. (Inaccurate
      with indels.)

  tooShortOutput: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --too-short-output=
      separate: false
    doc: |
      Write reads that are too short (according to length
      specified by -m) to FILE. (default: discard reads)

  tooLongOutput: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --too-long-output=
      separate: false
    doc: |
      Write reads that are too long (according to length
      specified by -M) to FILE. (default: discard reads)

  untrimmedOutput: # not tested
    type: string?
    inputBinding:
      position: 10
      prefix: --untrimmed-output=
      separate: false
    doc: |
      Write reads that do not contain the adapter to FILE.
      (default: output to same file as trimmed reads)

  # Colorspace options:
  colorspace: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --colorspace
    doc: |
      Enable colorspace mode

  doubleEncode: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --double-encode
    doc: |
      Double-encode colors (map 0,1,2,3,4 to A,C,G,T,N).

  trimPrimer: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --trim-primer
    doc: |
      Trim primer base and the first color

  stripF3: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --strip-f3
    doc: |
      Strip the _F3 suffix of read names

  bwa: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --bwa
    doc: |
      MAQ- and BWA-compatible colorspace output. This
      enables --colorspace, --double-encode, --trim-primer, --strip-f3 and --suffix '/1'.
      # enable args above only when this is used ???

  maq: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --maq
    doc: |
      MAQ- and BWA-compatible colorspace output. This
      enables --colorspace, --double-encode, --trim-primer, --strip-f3 and --suffix '/1'.
      # enable args above only when this is used ???

  zeroCap: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --zero-cap
    doc: |
      Change negative quality values to zero.
      Enabled by default in colorspace mode since many tools have
      problems with negative qualities

  noZeroCap: # not tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-zero-cap
    doc: |
      Disable zero capping

  # PairedEnd options:
  # The -A/-G/-B/-U options work like their -a/-b/-g/-u counterparts, but
  # are applied to the second read in each pair.
  adapterPaired: # not tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -A
    inputBinding:
      position: 10
    doc: |
      3` adapter to be removed from second read in a pair.

  frontPaired: # not tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -G
    inputBinding:
      position: 10
    doc: |
      5` adapter to be removed from second read in a pair.

  anywherePaired: # not tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -B
    inputBinding:
      position: 10
    doc: |
      5`/3 adapter to be removed from second read in a pair.

  cutPaired: # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: -U
    doc: |
    Remove LENGTH bases from second read in a pair (see --cut).

  pairedOutput: # not tested   type: stderr
    type: string? # TODO: Is needed for paired output (maybe dependend parameter)
    inputBinding:
      position: 10
      prefix: --paired-output=
      separate: false
    doc: |
      Write second read in a pair to FILE.

  pairFilter: # not tested
    type:
      - "null"
      - type: enum
        symbols: [any, both]
    inputBinding:
      prefix: --pair-filter
      separate: false
      position: 10
    doc: |
      Which of the reads in a paired-end read have to match
      the filtering criterion in order for the pair to be
      filtered. Default: any

  interleaved: # not tested
    type: boolean?
    inputBinding:
      prefix: --interleaved
      position: 10
    doc: |
      Read and write interleaved paired-end reads.

  untrimmedPairedOutput: # not tested
    type: string? # TODO: force untrimmedOutput !!!
    inputBinding:
      position: 10
      prefix: --untrimmed-paired-output=
      separate: false
    doc: |
      Write the second read in a pair to this FILE when no
      adapter was found in the first read. Use this option
      together with --untrimmed-output when trimming paired-
      end reads. (Default: output to same file as trimmed reads.)

  tooShortPairedOutput: # not tested
    type: string? # TODO: force --too-short-output
    inputBinding:
      position: 10
      prefix: --too-short-paired-output=
      separate: false
    doc: |
      Write second read in a pair to this file if pair is
      too short. Use together with --too-short-output.

  tooLongPairedOutput: # not tested
    type: string? # TODO: force --too-long-output
    inputBinding:
      position: 10
      prefix: --too-long-paired-output=
      separate: false
    doc: |
      Write second read in a pair to this file if pair is
      too long. Use together with --too-long-output.

  # Misc
  format: # not tested
    type:
      - "null"
      - type: enum
        symbols: [fasta, fastq, sra-fastq]
    inputBinding:
      position: 10
      prefix: --format=
      separate: false
    doc: |
      Input file format; can be either 'fasta', 'fastq' or
      'sra-fastq'. Ignored when reading csfasta/qual files
      (default: auto-detect from file name extension).

  cores:  # not tested
    type: int?
    inputBinding:
      position: 10
      prefix: --cores=
      separate: false
    doc: |
      Number of CPU cores to use. Default: 1

  ### Necessary Inputs ###
  inputFile:  # not tested
    type: File
    format: [edam:format_2545 , edam:format_2546]  #FASTQ-like format, FASTA-like
    inputBinding:
      position: 100
    doc: |
      FASTA/Q input file. Also .gz, .xz, .bz2 is accepted. #TODO compressed data is not defined at edam?????

  targetFileName:  # not tested
    type: string
    doc: |
      Name of the outputfile. Given as String.

outputs:
  cutadapt_fasta_out:
    type: stdout

  infoFileOutput:
    type: File?
    outputBinding:
      glob: $(inputs.infoFile)

  restFileOutput:
    type: File?
    outputBinding:
      glob: $(inputs.restFile)

  wildcardFileOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.wildcardFile)

  tooShortOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.tooShortOutput)

  tooLongOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.tooLongOutput)

  untrimmedOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.untrimmedOutput)

  pairedOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.pairedOutput)

  untrimmedPairedOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.untrimmedPairedOutput)

  tooShortPairedOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.tooShortPairedOutput)

  tooLongPairedOutputOutput:
    type: File?
    outputBinding:
      glob: $(inputs.tooLongPairedOutput)

###########################
baseCommand: cutadapt


###########################
$namespaces:
  edam: http://edamontology.org/
  s: https://schema.org/

$schemas:
  - http://edamontology.org/EDAM.owl
  - https://schema.org/docs/schema_org_rdfa.html

###########################
s:mainEntity:
  class: s:SoftwareSourceCode
  s:name: "cutadapt"
  s:about: >
    cutadapt removes adapter sequences from high-throughput sequencing reads.

  s:url: http://cutadapt.readthedocs.io/en/stable/index.html#
  s:license: https://spdx.org/licenses/MIT

  s:creator:
  - class: s:Person
    s:name: "Marcel Martin"

  s:publication:
  - class: s:ScholarlyArticle
    id: http://dx.doi.org/10.14806/ej.17.1.200
    s:name: "Marcel Martin. Cutadapt removes adapter sequences from high-throughput sequencing reads."
    s:url: http://journal.embnet.org/index.php/embnetjournal/article/view/200


s:license: https://spdx.org/licenses/Apache-2.0
s:copyrightHolder: Biozentrum, University of Basel

s:isPartOf:
  class: s:CreativeWork
  s:name: Common Workflow Language
  s:url: http://commonwl.org/

s:author:
  class: s:Person
  s:name: Christina J. Herrmann
  s:email: christina.herrmann@unibas.ch
  s:worksFor:
  - class: s:Organization
    s:name: Biozentrum, University of Basel
    s:location: Klingelbergstrasse 50/70, CH-4056 Basel, Switzerland
    s:department:
    - class: s:Organization
      s:name: Zavolan Lab
