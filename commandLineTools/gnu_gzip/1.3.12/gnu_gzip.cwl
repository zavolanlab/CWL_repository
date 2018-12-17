cwlVersion: v1.0
class: CommandLineTool
baseCommand: gzip
doc: |
  executes the gzip command implemented for version 1.3.12:
  optional args:
  [decompress, ascii, force, list, name, no-name, quiet, recursive, suffix, test, verbose, (best | fast | speed)]
  fixed args:
  [stdout, zipFile, targetFileName]
  This commandline tool can zip or unzip Files into or from .gz files.

requirements:
#   - $import: runtimeSettingsMedium.yml
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: cjh4zavolab/gzip:1                                                                         #the system temporary directory which
                                                                            #must be located at /tmp.
stdout: $(inputs.targetFileName)
#passing arguments via boolean: allows to specify the possible arguments

arguments: ["--stdout"] # Doesn't work without --stdout, its necessary because off the stdout output in both cases(decompress and compress) is always streamed to a file
inputs:
  ### Optional Inputs ###
  decompress: #tested
    type: boolean?
    inputBinding:
      position: 1
      prefix: --decompress      #if true this will be displayed, if false this woun't appear
    doc: |
      Decompress.

  ascii: #TODO: test
    type: boolean?
    inputBinding:
      position: 3
      prefix: --ascii
    doc: |
      Ascii text mode: convert end-of-lines using local conventions.
      Not supported for all linux Versions

  force: #tested
    type: boolean?
    inputBinding:
      position: 3
      prefix: --force
    doc: |
      Force compression or decompression even if the file has multiple
      links or the corresponding file already exists, or if the compressed
      data is read from or written to a terminal.
      If the input data is not in a format recognized by gzip,
      and if the option --stdout is also given, copy the input data
      without change to the standard output

  list: #tested
    type: boolean?
    inputBinding:
      position: 4
      prefix: --list
    doc: |
      For each compressed file, list the following fields:
      compressed size: size of the compressed file
      uncompressed size: size of the uncompressed file
      ratio: compression ratio (0.0% if unknown)
      uncompressed_name: name of the uncompressed file
      The uncompressed size is given as -1 for files not
      in gzip format, such as compressed .Z files

  name: #TODO: test
    type: boolean?
    inputBinding:
      position: 5
      prefix: --name
    doc: |
      When compressing, always save the original file name and time stamp;
      this is the default. When decompressing, restore the original file name
      and time stamp if present. This option is useful on systems
      which have a limit on file name length or when the time stamp
      has been lost after a file transfer.

  no-name: #TODO: test
    type: boolean?
    inputBinding:
      position: 6
      prefix: --no-name
    doc: |
      When compressing, do not save the original file name and time stamp by default.
      (The original name is always saved if the name had to be truncated.)
      When decompressing, do not restore the original file name if present
      (remove only the gzip suffix from the compressed file name)
      and do not restore the original time stamp if present
      (copy it from the compressed file).

  quiet: #tested
    type: boolean?
    inputBinding:
      position: 7
      prefix: --quiet
    doc: |
      Suppress all warnings.

  recursive: #TODO: test
    type: boolean?
    inputBinding:
      position: 8
      prefix: --recursive
    doc: |
      Travel the directory structure recursively.
      If any of the file names specified on the command line are directories,
      gzip will descend into the directory and compress all the files it finds there
      (or decompress them in the case of gunzip ).

  suffix: #TODO: test
    type: string?
    inputBinding:
      position: 9
      prefix: --suffix
    doc: |
      Use suffix .suf instead of .gz. Any suffix can be given,
      but suffixes other than .z and .gz should be avoided to avoid confusion
      when files are transferred to other systems.

  test: #tested
    type: boolean?
    inputBinding:
      position: 10
      prefix: --test
    doc: |
      Test. Check the compressed file integrity.

  verbose: #tested
    type: boolean?
    inputBinding:
      position: 11
      prefix: --verbose
    doc: |
      Verbose. Display the name and percentage reduction for each file compressed or decompressed.

  excSpeedParameter: #TODO: test           #call exclusive_parameters and add decompress?,  This one has to appear in yml, even if it has no content
    type:
      - type: record
        name: best
        fields:
          best:
            type: boolean
            inputBinding:
              prefix: --best
      - type: record
        name: fast
        fields:
          fast:
            type: boolean
            inputBinding:
              prefix: --fast
      - type: record
        name: speed
        fields:
          fast:
            type: int          #value should be between 1 and 9
            inputBinding:
              prefix: "-"
              separate: false   #don't add a space between prefix and value
      - "null"                  #makes this input optional
    doc: |
      Set the block size to 100 k, 200 k ... 900 k when compressing.
      Has no effect when decompressing. For faster compressing.


  ### Necessary Inputs ###
  zipFile: #tested
    type: File
    inputBinding:
      position: 100     #position is relative, if arguments are added via inputs they should be before this one
    doc: |
      The input zip file which will be unzipped or zipped. If you compress it pay attention to the right file ending.
      Must be gzip compatible.

  targetFileName: #tested      #drawback: outPath must be relative, prefix is location of cwl tool
    type: string?
    doc: |
      Name of the outputfile. Given as String.


outputs:
  zipResult:
    type: stdout


#Usage: gzip [OPTION]... [FILE]...
#Compress or uncompress FILEs (by default, compress FILES in-place).
#
#Mandatory arguments to long options are mandatory for short options too.
#
#  -c, --stdout      write on standard output, keep original files unchanged
#  -d, --decompress  decompress
#  -f, --force       force overwrite of output file and compress links
#  -h, --help        give this help
#  -l, --list        list compressed file contents
#  -L, --license     display software license
#  -n, --no-name     do not save or restore the original name and time stamp
#  -N, --name        save or restore the original name and time stamp
#  -q, --quiet       suppress all warnings
#  -r, --recursive   operate recursively on directories
#  -S, --suffix=SUF  use suffix SUF on compressed files
#  -t, --test        test compressed file integrity
#  -v, --verbose     verbose mode
#  -V, --version     display version number
#  -1, --fast        compress faster
#  -9, --best        compress better
#    --rsyncable   Make rsync-friendly archive
#
#With no FILE, or when FILE is -, read standard input.
