#!/bin/bash

#Set the input file names
ref_file_tar_name=$1
cram_file_name=$2
crai_file_name=$3

#Extract sample ID from input CRAM
sample_id=`basename $cram_file_name | cut -f1 -d"."`

#Copy ref files to current directory - this is required by HISAT-genotype
tar -xvzf $ref_file_tar_name -C .
base_name=`basename $ref_file_tar_name | cut -f1 -d"."`
mv ${base_name}/* .
rm -r ${base_name}

#Extract reads from chr6 MHC region and all unmapped reads to fastq
ls -alh $cram_file_name
ls -alh $crai_file_name
touch ${sample_id}_MHC.bam 
touch ${sample_id}_unmapped.bam 
touch ${sample_id}_extract.bam 
touch ${sample_id}_extract.bam.1.fq.gz 
touch ${sample_id}_extract.bam.2.fq.gz 

#Extract reads that map to HLA
touch ${sample_id}_extract.bam.1.fq.gz-hla-extracted-1.fq.gz
touch ${sample_id}_extract.bam.1.fq.gz-hla-extracted-2.fq.gz

#Type HLA
touch assembly_graph-hla-${sample_id}_extract.report
