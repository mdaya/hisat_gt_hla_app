#!/bin/bash

#Set the input file names
ref_file_tar_name=$1
cram_file_name=$2

#Extract sample ID from input CRAM
sample_id=`basename $cram_file_name | cut -f1 -d"."`

#Copy ref files to current directory - this is required by HISAT-genotype
tar -xvzf $ref_file_tar_name -C .
base_name=`basename $ref_file_tar_name | cut -f1 -d"."`
mv ${base_name}/* .
rm -r ${base_name}

#Extract reads from chr6 MHC region and all unmapped reads to fastq
samtools view -F 4 -bo ${sample_id}_MHC.bam $cram_file_name chr6:2700000-35000000
samtools view -f 4 -bo ${sample_id}_unmapped.bam $cram_file_name
samtools merge ${sample_id}_extract.bam ${sample_id}_MHC.bam ${sample_id}_unmapped.bam
java -Xmx4G -jar /home/biodocker/picard/picard.jar SamToFastq \
   I=${sample_id}_extract.bam \
   FASTQ=${sample_id}_extract.bam.1.fq.gz SECOND_END_FASTQ=${sample_id}_extract.bam.2.fq.gz \
   NON_PF=true RE_REVERSE=true VALIDATION_STRINGENCY=LENIENT

#Extract reads that map to HLA
hisatgenotype_toolkit extract-reads --base hla \
   -1 ${sample_id}_extract.bam.1.fq.gz -2 ${sample_id}_extract.bam.2.fq.gz

#Type HLA
hisatgenotype_toolkit locus -x genotype_genome \
   --base hla \
   --locus-list A,B,C,DRB1,DQA1,DQB1 \
   -1 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-1.fq.gz -2 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-2.fq.gz
