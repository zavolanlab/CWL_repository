#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: cutadapt
doc: |
  executes the cutadapt command, implemented for version 1.8.3:
  optional args:
  [adapter, front, anywhere, errorRate, noIndels, times, overlap, matchReadWildcards,
  discardUntrimmed, discardTrimmed, noTrim, minimumLength, maximumLength, maxN,
  quiet, infoFile, restFile, wildcardFile, tooShortOutput, tooLongOutput, untrimmedOutput,
  bwa, maq, stripF3, trimN, noZeroCap, doubleEncode, colorspace, cut, qualityCutoff, qualityBase, prefix, suffix,
  stripSuffix, lengthTag,
  adapterPaired, frontPaired, anywherePaired, cutPaired, pairedOutput, untrimmedPairedOutput,
  format]

  fixed args:
  [inputFile, targetFileName]
  introduction for cutadapt you can find here: http://cutadapt.readthedocs.io/en/stable/guide.html
  Cutadapt is a Tool for finding and removing adapter sequences, primer or PolyA Tails.
  So it can find any sort of unwanted or unnatural Sequence.

  allowed input file formats:  [fastq, fasta, .gz, .xz, .bz2]

hints:
  - class: DockerRequirement
    dockerPull: cjh4zavolab/cutadapt:1.16

requirements:
#  - $import: runtimeSettingsMedium.yml
  - class: InlineJavascriptRequirement

stdout: $(inputs.targetFileName)

inputs:
  ### Optional Inputs ###
  # Options that influence how the adapters are found:
  adapter: # tested
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
      Sequence of an adapter that was ligated to the 3` end.
      The adapter itself and anything that follows is
      trimmed. If the adapter sequence ends with the '$'
      character, the adapter is anchored to the end of the
      read and only found if it is a suffix of the read.

  front: # tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: --front==
          separate: false
    inputBinding:
      position: 10
    doc: |
      Sequence of an adapter that was ligated to the 5` end.
      If the adapter sequence starts with the character '^',
      the adapter is 'anchored'. An anchored adapter must
      appear in its entirety at the 5` end of the read (it
      is a prefix of the read). A non-anchored adapter may
      appear partially at the 5` end, or it may occur within
      the read. If it is found within a read, the sequence
      preceding the adapter is also trimmed. In all cases,
      the adapter itself is trimmed.

  anywhere: # tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: --anywhere==
          separate: false
    inputBinding:
      position: 10
    doc: |
      Sequence of an adapter that was ligated to the 5` or
      3` end. If the adapter is found within the read or
      overlapping the 3` end of the read, the behavior is
      the same as for the -a option. If the adapter overlaps
      the 5`` end (beginning of the read), the initial
      portion of the read matching the adapter is trimmed,
      but anything that follows is kept.

  errorRate: #tested
    type: float?
    inputBinding:
      position: 10
      prefix: --error-rate=
      separate: false
    doc: |
      Maximum allowed error rate (no. of errors divided by
      the length of the matching region) (default: 0.1)

  noIndels: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-indels
    doc: |
      Do not allow indels in the alignments (allow only
      mismatches). Currently only supported for anchored
      adapters. (default: allow both mismatches and indels)

  times: #tested
    type: int?
    inputBinding:
      position: 10
      prefix: --times=
      separate: false
    doc: |
      Try to remove adapters at most COUNT times. Useful
      when an adapter gets appended multiple times (default:1).

  overlap: #tested
    type: int?
    inputBinding:
      position: 10
      prefix: --overlap=
      separate: false
    doc: |
      Minimum overlap length. If the overlap between the
      read and the adapter is shorter than LENGTH, the read
      is not modified. This reduces the no. of bases trimmed
      purely due to short random adapter matches (default:3).

  matchReadWildcards: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --match-read-wildcards
    doc: |
      Allow IUPAC wildcards in reads (default: False).


  # Options for filtering of processed reads:
  # Maybe some of them are exclusive
  discardUntrimmed: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --discard-untrimmed
    doc: |
      Discard reads that do not contain the adapter.

  discardTrimmed: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --discard-trimmed
    doc: |
      Discard reads that contain the adapter instead of
      trimming them. Also use -O in order to avoid throwing
      away too many randomly matching reads!

  noTrim: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-trim
    doc: |
      Match and redirect reads to output/untrimmed-output as
      usual, but do not remove adapters.

  maskAdapter: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --mask-adapter
    doc: |
      Mask adapters with 'N' characters instead of trimming them.

  minimumLength: #tested
    type: int?
    inputBinding:
      position: 10
      prefix: --minimum-length=
      separate: false
    doc: |
      Discard trimmed reads that are shorter than LENGTH.
      Reads that are too short even before adapter removal
      are also discarded. In color space, an initial primer
      is not counted (default: 0).

  maximumLength: #tested
    type: int?
    inputBinding:
      position: 10
      prefix: --maximum-length=
      separate: false
    doc: |
      Discard trimmed reads that are longer than LENGTH.
      Reads that are too long even before adapter removal
      are also discarded. In color space, an initial primer
      is not counted (default: no limit).

  maxN: #tested
    type: double?
    inputBinding:
      position: 10
      prefix: --max-n=
      separate: false
    doc: |
      The max proportion of N`s allowed in a read. A number
      < 1 will be treated as a proportion while a number > 1
      will be treated as the maximum number of N`s contained.


  # Options that influence what gets output to where:
  quiet: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --quiet
    doc: |
      Do not print a report at the end.

  infoFile: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --info-file=
      separate: false
    doc: |
      Write information about each read and its adapter
      matches into FILE. See the documentation for the file
      format.

  restFile: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --rest-file=
      separate: false
    doc: |
      When the adapter matches in the middle of a read,
      write the rest (after the adapter) into FILE.

  wildcardFile: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --wildcard-file=
      separate: false
    doc: |
      When the adapter has wildcard bases ('N's), write
      adapter bases matching wildcard positions to FILE.
      When there are indels in the alignment, this will
      often not be accurate.

  tooShortOutput: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --too-short-output=
      separate: false
    doc: |
      Write reads that are too short (according to length
      specified by -m) to FILE. (default: discard reads)

  tooLongOutput: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --too-long-output=
      separate: false
    doc: |
      Write reads that are too long (according to length
      specified by -M) to FILE. (default: discard reads)

  untrimmedOutput: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --untrimmed-output=
      separate: false
    doc: |
      Write reads that do not contain the adapter to FILE.
      (default: output to same file as trimmed reads)


  # Additional modifications to the reads:
  bwa: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --bwa
    doc: |
      MAQ- and BWA-compatible colorspace output. This
      enables --colorspace, --double-encode, --trim-primer, --strip-f3 and --suffix '/1'.
      # make it possible to enable args above only when this (bwa is used) ???

  maq: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --maq
    doc: |
      MAQ- and BWA-compatible colorspace output. This
      enables --colorspace, --double-encode, --trim-primer, --strip-f3 and --suffix '/1'.
      #  make it possible to enable args above only when this (maq is used) ???

  stripF3: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --strip-f3
    doc: |
      For colorspace: Strip the _F3 suffix of read names

  trimN: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --trim-n
    doc: |
      Trim N`s on ends of reads.

  noZeroCap: #checked
    type: boolean?
    inputBinding:
      position: 10
      prefix: --no-zero-cap
    doc: |
      Do not change negative quality values to zero.
      Colorspace quality values of -1 would appear as spaces
      in the output FASTQ file. Since many tools have
      problems with that, negative qualities are converted
      to zero when trimming colorspace data. Use this option
      to keep negative qualities.

  doubleEncode: #checked
    type: boolean?
    inputBinding:
      position: 10
      prefix: --double-encode
    doc: |
      When in colorspace, double-encode colors (map
      0,1,2,3,4 to A,C,G,T,N).

  colorspace: #checked
    type: boolean?
    inputBinding:
      position: 10
      prefix: --colorspace
    doc: |
      Colorspace mode: Also trim the color that is adjacent
      to the found adapter.

  cut: #tested
    type: int?
    inputBinding:
      position: 10
      prefix: --cut=
      separate: false
    doc: |
      Remove LENGTH bases from the beginning or end of each
      read. If LENGTH is positive, the bases are removed
      from the beginning of each read. If LENGTH is
      negative, the bases are removed from the end of each
      read. This option can be specified twice if the
      LENGTHs have different signs.

  qualityCutoff: #tested
    type: int[]? # TODO: max 2 inputs
    inputBinding:
      prefix: --quality-cutoff=
      itemSeparator: ","
      separate: false
      position: 10
    doc: |
      Trim low-quality bases from 5'' and/or 3'' ends of reads
      before adapter removal. If one value is given, only
      the 3'' end is trimmed. If two comma-separated cutoffs
      are given, the 5'' end is trimmed with the first
      cutoff, the 3'' end with the second. The algorithm is
      the same as the one used by BWA (see documentation).
      (default: no trimming). Only works with fastq.

  qualityBase: #tested
    type: int? # TODO: specific range
    inputBinding:
      position: 10
      prefix: --quality-base=
      separate: false
    doc: |
      Assume that quality values are encoded as
      ascii(quality + QUALITY_BASE). The default (33) is
      usually correct, except for reads produced by some
      versions of the Illumina pipeline, where this should
      be set to 64. (Default: 33) Only works with fastq.

  prefix: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --prefix=
      separate: false
    doc: |
      Only works with fastq.

  suffix: #tested
    type: string?
    inputBinding:
      position: 10
      prefix: --suffix=
      separate: false
    doc: |
      Only works with fastq.

  stripSuffix: #checked
    type: string?
    inputBinding:
      position: 10
      prefix: --strip-suffix=
      separate: false
    doc: |
      Remove this suffix from read names if present. Can be
      given multiple times.

  lengthTag: #checked
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


  # PairedEnd options:
  adapterPaired: #tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -A
    inputBinding:
      position: 10
    doc: |
      Paired
      Sequence of an adapter that was ligated to the 3` end.
      The adapter itself and anything that follows is
      trimmed. If the adapter sequence ends with the '$'
      character, the adapter is anchored to the end of the
      read and only found if it is a suffix of the read.

  frontPaired: #tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -G
    inputBinding:
      position: 10
    doc: |
      Paired
      Sequence of an adapter that was ligated to the 5` end.
      If the adapter sequence starts with the character '^',
      the adapter is 'anchored'. An anchored adapter must
      appear in its entirety at the 5` end of the read (it
      is a prefix of the read). A non-anchored adapter may
      appear partially at the 5` end, or it may occur within
      the read. If it is found within a read, the sequence
      preceding the adapter is also trimmed. In all cases,
      the adapter itself is trimmed.

  anywherePaired: #tested
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -B
    inputBinding:
      position: 10
    doc: |
      Paired
      Sequence of an adapter that was ligated to the 5` or
      3` end. If the adapter is found within the read or
      overlapping the 3` end of the read, the behavior is
      the same as for the -a option. If the adapter overlaps
      the 5`` end (beginning of the read), the initial
      portion of the read matching the adapter is trimmed,
      but anything that follows is kept.

  cutPaired: #checked
    type: int?
    inputBinding:
      position: 10
      prefix: -U
    doc: |
      Remove LENGTH bases from the beginning or end of each
      read. If LENGTH is positive, the bases are removed
      from the beginning of each read. If LENGTH is
      negative, the bases are removed from the end of each
      read. This option can be specified twice if the
      LENGTHs have different signs.

  pairedOutput: #tested    type: stderr
    type: string? # TODO: Is needed for paired output (maybe dependend parameter)
    inputBinding:
      position: 10
      prefix: --paired-output=
      separate: false
    doc: |
      Write second read in a pair to FILE.

  untrimmedPairedOutput: #checked
    type: string? # TODO: is dependent with untrimmetOutput !!!
    inputBinding:
      position: 10
      prefix: --untrimmed-paired-output=
      separate: false
    doc: |
      Write the second read in a pair to this FILE when no
      adapter was found in the first read. Use this option
      together with --untrimmed-output when trimming paired-
      end reads. (Default: output to same file as trimmed reads.)

  # Misc
  format: # TODO: does not work ???
    type: string? # TODO: Its a String-set [fasta, fastq, sra-fastq]
    inputBinding:
      position: 10
      prefix: --format=
      separate: false
    doc: |
      Input file format; can be either 'fasta', 'fastq' or
      'sra-fastq'. Ignored when reading csfasta/qual files
      (default: auto-detect from file name extension).


  ### Necessary Inputs ###
  inputFile: #tested
    type: File
    #format: [edam:format_2545 , edam:format_2546]      #FASTQ-like format, FASTA-like
    inputBinding:
      position: 100
    doc: |
      FASTA/Q input file. Also .gz, .xz, .bz2 is accepted.      #TODO compressed data is not defined at edam?????

  targetFileName: #tested
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


# TODO: one of 5 Inputs have to appear, but they can be mixed and appear more than one time (how to do, is it possible)

#cutadapt removes adapter sequences from high-throughput sequencing reads.
#
#Usage:
#    cutadapt -a ADAPTER [options] [-o output.fastq] input.fastq
#
#For paired-end reads:
#    cutadapt -a ADAPT1 -A ADAPT2 [options] -o out1.fastq -p out2.fastq in1.fastq in2.fastq
#
#Replace "ADAPTER" with the actual sequence of your 3' adapter. IUPAC wildcard
#characters are supported. The reverse complement is *not* automatically
#searched. All reads from input.fastq will be written to output.fastq with the
#adapter sequence removed. Adapter matching is error-tolerant. Multiple adapter
#sequences can be given (use further -a options), but only the best-matching
#adapter will be removed.
#
#Input may also be in FASTA format. Compressed input and output is supported and
#auto-detected from the file name (.gz, .xz, .bz2). Use the file name '-' for
#standard input/output. Without the -o option, output is sent to standard output.
#
#Some other available features are:
#  * Various other adapter types (5' adapters, "mixed" 5'/3' adapters etc.)
#  * Trimming a fixed number of bases
#  * Quality trimming
#  * Trimming colorspace reads
#  * Filtering reads by various criteria
#
#Use "cutadapt --help" to see all command-line options.
#See http://cutadapt.readthedocs.org/ for full documentation.
#
#Options:
#  --version             show program's version number and exit
#  -h, --help            show this help message and exit
#  -f FORMAT, --format=FORMAT
#                        Input file format; can be either 'fasta', 'fastq' or
#                        'sra-fastq'. Ignored when reading csfasta/qual files
#                        (default: auto-detect from file name extension).
#
#  Options that influence how the adapters are found:
#    Each of the following three parameters (-a, -b, -g) can be used
#    multiple times and in any combination to search for an entire set of
#    adapters of possibly different types. Only the best matching adapter
#    is trimmed from each read (but see the --times option). Instead of
#    giving an adapter directly, you can also write file:FILE and the
#    adapter sequences will be read from the given FILE (which must be in
#    FASTA format).
#
#    -a ADAPTER, --adapter=ADAPTER
#                        Sequence of an adapter that was ligated to the 3' end.
#                        The adapter itself and anything that follows is
#                        trimmed. If the adapter sequence ends with the '$'
#                        character, the adapter is anchored to the end of the
#                        read and only found if it is a suffix of the read.
#    -g ADAPTER, --front=ADAPTER
#                        Sequence of an adapter that was ligated to the 5' end.
#                        If the adapter sequence starts with the character '^',
#                        the adapter is 'anchored'. An anchored adapter must
#                        appear in its entirety at the 5' end of the read (it
#                        is a prefix of the read). A non-anchored adapter may
#                        appear partially at the 5' end, or it may occur within
#                        the read. If it is found within a read, the sequence
#                        preceding the adapter is also trimmed. In all cases,
#                        the adapter itself is trimmed.
#    -b ADAPTER, --anywhere=ADAPTER
#                        Sequence of an adapter that was ligated to the 5' or
#                        3' end. If the adapter is found within the read or
#                        overlapping the 3' end of the read, the behavior is
#                        the same as for the -a option. If the adapter overlaps
#                        the 5' end (beginning of the read), the initial
#                        portion of the read matching the adapter is trimmed,
#                        but anything that follows is kept.
#    -e ERROR_RATE, --error-rate=ERROR_RATE
#                        Maximum allowed error rate (no. of errors divided by
#                        the length of the matching region) (default: 0.1)
#    --no-indels         Do not allow indels in the alignments (allow only
#                        mismatches). Currently only supported for anchored
#                        adapters. (default: allow both mismatches and indels)
#    -n COUNT, --times=COUNT
#                        Try to remove adapters at most COUNT times. Useful
#                        when an adapter gets appended multiple times (default:
#                        1).
#    -O LENGTH, --overlap=LENGTH
#                        Minimum overlap length. If the overlap between the
#                        read and the adapter is shorter than LENGTH, the read
#                        is not modified. This reduces the no. of bases trimmed
#                        purely due to short random adapter matches (default:
#                        3).
#    --match-read-wildcards
#                        Allow IUPAC wildcards in reads (default: False).
#    -N, --no-match-adapter-wildcards
#                        Do not interpret IUPAC wildcards in adapters.
#
#  Options for filtering of processed reads:
#    --discard-trimmed, --discard
#                        Discard reads that contain the adapter instead of
#                        trimming them. Also use -O in order to avoid throwing
#                        away too many randomly matching reads!
#    --discard-untrimmed, --trimmed-only
#                        Discard reads that do not contain the adapter.
#    -m LENGTH, --minimum-length=LENGTH
#                        Discard trimmed reads that are shorter than LENGTH.
#                        Reads that are too short even before adapter removal
#                        are also discarded. In colorspace, an initial primer
#                        is not counted (default: 0).
#    -M LENGTH, --maximum-length=LENGTH
#                        Discard trimmed reads that are longer than LENGTH.
#                        Reads that are too long even before adapter removal
#                        are also discarded. In colorspace, an initial primer
#                        is not counted (default: no limit).
#    --no-trim           Match and redirect reads to output/untrimmed-output as
#                        usual, but do not remove adapters.
#    --max-n=LENGTH      The max proportion of N's allowed in a read. A number
#                        < 1 will be treated as a proportion while a number > 1
#                        will be treated as the maximum number of N's
#                        contained.
#    --mask-adapter      Mask adapters with 'N' characters instead of trimming
#                        them.
#
#  Options that influence what gets output to where:
#    --quiet             Do not print a report at the end.
#    -o FILE, --output=FILE
#                        Write modified reads to FILE. FASTQ or FASTA format is
#                        chosen depending on input. The summary report is sent
#                        to standard output. Use '{name}' in FILE to
#                        demultiplex reads into multiple files. (default:
#                        trimmed reads are written to standard output)
#    --info-file=FILE    Write information about each read and its adapter
#                        matches into FILE. See the documentation for the file
#                        format.
#    -r FILE, --rest-file=FILE
#                        When the adapter matches in the middle of a read,
#                        write the rest (after the adapter) into FILE.
#    --wildcard-file=FILE
#                        When the adapter has wildcard bases ('N's), write
#                        adapter bases matching wildcard positions to FILE.
#                        When there are indels in the alignment, this will
#                        often not be accurate.
#    --too-short-output=FILE
#                        Write reads that are too short (according to length
#                        specified by -m) to FILE. (default: discard reads)
#    --too-long-output=FILE
#                        Write reads that are too long (according to length
#                        specified by -M) to FILE. (default: discard reads)
#    --untrimmed-output=FILE
#                        Write reads that do not contain the adapter to FILE.
#                        (default: output to same file as trimmed reads)
#
#  Additional modifications to the reads:
#    -u LENGTH, --cut=LENGTH
#                        Remove LENGTH bases from the beginning or end of each
#                        read. If LENGTH is positive, the bases are removed
#                        from the beginning of each read. If LENGTH is
#                        negative, the bases are removed from the end of each
#                        read. This option can be specified twice if the
#                        LENGTHs have different signs.
#    -q [5'CUTOFF,]3'CUTOFF, --quality-cutoff=[5'CUTOFF,]3'CUTOFF
#                        Trim low-quality bases from 5' and/or 3' ends of reads
#                        before adapter removal. If one value is given, only
#                        the 3' end is trimmed. If two comma-separated cutoffs
#                        are given, the 5' end is trimmed with the first
#                        cutoff, the 3' end with the second. The algorithm is
#                        the same as the one used by BWA (see documentation).
#                        (default: no trimming)
#    --quality-base=QUALITY_BASE
#                        Assume that quality values are encoded as
#                        ascii(quality + QUALITY_BASE). The default (33) is
#                        usually correct, except for reads produced by some
#                        versions of the Illumina pipeline, where this should
#                        be set to 64. (Default: 33)
#    --trim-n            Trim N's on ends of reads.
#    -x PREFIX, --prefix=PREFIX
#                        Add this prefix to read names
#    -y SUFFIX, --suffix=SUFFIX
#                        Add this suffix to read names
#    --strip-suffix=STRIP_SUFFIX
#                        Remove this suffix from read names if present. Can be
#                        given multiple times.
#    -c, --colorspace    Colorspace mode: Also trim the color that is adjacent
#                        to the found adapter.
#    -d, --double-encode
#                        When in colorspace, double-encode colors (map
#                        0,1,2,3,4 to A,C,G,T,N).
#    -t, --trim-primer   When in colorspace, trim primer base and the first
#                        color (which is the transition to the first
#                        nucleotide)
#    --strip-f3          For colorspace: Strip the _F3 suffix of read names
#    --maq, --bwa        MAQ- and BWA-compatible colorspace output. This
#                        enables -c, -d, -t, --strip-f3 and -y '/1'.
#    --length-tag=TAG    Search for TAG followed by a decimal number in the
#                        description field of the read. Replace the decimal
#                        number with the correct length of the trimmed read.
#                        For example, use --length-tag 'length=' to correct
#                        fields like 'length=123'.
#    --no-zero-cap       Do not change negative quality values to zero.
#                        Colorspace quality values of -1 would appear as spaces
#                        in the output FASTQ file. Since many tools have
#                        problems with that, negative qualities are converted
#                        to zero when trimming colorspace data. Use this option
#                        to keep negative qualities.
#    -z, --zero-cap      Change negative quality values to zero. This is
#                        enabled by default when -c/--colorspace is also
#                        enabled. Use the above option to disable it.
#
#  Paired-end options.:
#    The -A/-G/-B/-U options work like their -a/-b/-g/-u counterparts.
#
#    -A ADAPTER          3' adapter to be removed from the second read in a
#                        pair.
#    -G ADAPTER          5' adapter to be removed from the second read in a
#                        pair.
#    -B ADAPTER          5'/3 adapter to be removed from the second read in a
#                        pair.
#    -U LENGTH           Remove LENGTH bases from the beginning or end of each
#                        read (see --cut).
#    -p FILE, --paired-output=FILE
#                        Write second read in a pair to FILE.
#    --untrimmed-paired-output=FILE
#                        Write the second read in a pair to this FILE when no
#                        adapter was found in the first read. Use this option
#                        together with --untrimmed-output when trimming paired-
#                        end reads. (Default: output to same file as trimmed
#                        reads.)

###########################
#s:author:
#  - class: s:Person
#    s:name: Students

$namespaces:
  edam: http://edamontology.org/
#  s: https://schema.org/

$schemas:
  - http://edamontology.org/EDAM.owl
#  - https://schema.org/docs/schema_org_rdfa.html
