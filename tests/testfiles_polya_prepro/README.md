# Testfiles for the CWL_test_pAp Pipeline
***
> Note:  
 md5sums of gzipped files can only be compared if gzip -n has been used. This option excludes original name and time stamp from the .gz file.

The testfiles have been created on Ubuntu 16.04 as follows:

#### A_seq_test.fq.gz
```
gzip -dc A_seq_raw_file.fq.gz > A_seq_raw_file.fq
head -n 40000 A_seq_raw_file.fq > A_seq_test.fq
gzip -c A_seq_test.fq > A_seq_test.fq.gz
```
*gzip 1.6*

#### ungzip_fastq.fq
`gzip -dc A_seq_test.fq.gz > ungzip_fastq.fq`

*gzip 1.6*

#### fastq2fasta_ungzip.fa
`fastq_to_fasta -r -i ungzip_fastq.fq -o fastq2fasta_ungzip.fa `

*FASTX Toolkit 0.0.14*

#### valid5p_fq2fa_ungzip.fa
`/rs-filter-by-5p-adapter.keep5pAdapter.pl --adapter=....TTT fastq2fasta_ungzip.fa > valid5p_fq2fa_ungzip.fa`

*ralf.schmidt@unibas.ch*

#### cutadapt_valid5p_fq2fa_ungzip.fa
`cutadapt --adapter="TGGAATTCTCGGGTGCCAAGG" --minimum-length=4 -o cutadapt_valid5p_fq2fa_ungzip.fa valid5p_fq2fa_ungzip.fa`

*cutadapt 1.15*

#### revComp_cutadapt_valid5p_fq2fa_ungzip.fa
`fastx_reverse_complement -i cutadapt_valid5p_fq2fa_ungzip.fa > revComp_cutadapt_valid5p_fq2fa_ungzip.fa`

*FASTX Toolkit 0.0.14*

#### revComp_cutadapt_valid5p_fq2fa_ungzip.fa.gz
`gzip -nc revComp_cutadapt_valid5p_fq2fa_ungzip.fa > revComp_cutadapt_valid5p_fq2fa_ungzip.fa.gz`

*gzip 1.6*
