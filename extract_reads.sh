#!/bin/bash

#TODO: Uncomment the below command and remove the redundant echo statements of tool commands
#set -x

#TODO later: 
#Perhaps sample_id can come from file metadata
#Figure out how to best parameterize memory usage (currently assuming 8GB is available and 7G is hardcoded for SamToFastq

#Input parameters
cram_file_name=$1
ref_fasta_file_name=$2
sample_id=`basename $cram_file_name | cut -f1 -d"."` 
nr_cores=`lscpu | grep CPU\(s\): | awk '{print $2}'`   #Number of logical cores
let "nr_threads = nr_cores - 1"   #Minus the main thread as required by samtools

#Output parameters
fq_1=${sample_id}_extract.bam.1.fq.gz 
fq_2=${sample_id}_extract.bam.2.fq.gz 
log_file_name=${sample_id}_extract_reads_log.txt

#Start timer 
SECONDS=0

#Extract MHC region to a temporary bam file
echo "Executing command to extract MHC region..." > $log_file_name
echo "samtools view -F 4 -@ $nr_threads -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai --bo ${sample_id}_MHC.bam $cram_file_name chr6:2700000-35000000" >> $log_file_name
#samtools view -F 4 
#   -@ $nr_threads \
#   -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai \
#   --bo ${sample_id}_MHC.bam $cram_file_name chr6:2700000-35000000 &>> $log_file_name

#Extract unmapped reads to a temporary bam file
echo "Executing command to extract unmapped reads..." >> $log_file_name
echo "samtools view -f 4 -@ $nr_threads -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai -bo ${sample_id}_unmapped.bam $cram_file_name" >> $log_file_name
#samtools view -f 4 \
#   -@ $nr_threads \
#   -T $ref_fasta_file_name -t ${ref_fasta_file_name}.fai \
#   -bo ${sample_id}_unmapped.bam $cram_file_name &>> $log_file_name

#Merge the 2 temporary bam files
echo "Executing command to merge reads..." >> $log_file_name
echo "samtools merge ${sample_id}_extract.bam ${sample_id}_MHC.bam ${sample_id}_unmapped.bam" >> $log_file_name
#samtools merge ${sample_id}_extract.bam ${sample_id}_MHC.bam ${sample_id}_unmapped.bam &>> $log_file_name

#Extract reads from the merged bam file to fastq zipped files
echo "Extracting merged reads to paired end fastq files..." >> $log_file_name
echo "java -Xmx7G -jar /home/biodocker/picard/picard.jar SamToFastq I=${sample_id}_extract.bam FASTQ=$fq_1 SECOND_END_FASTQ=$fq_2 NON_PF=true RE_REVERSE=true VALIDATION_STRINGENCY=LENIENT" >> $log_file_name
touch $fq_1  #TODO: remove after test
touch $fq_2  #TODO: remove after test
#java -Xmx7G -jar /home/biodocker/picard/picard.jar SamToFastq \
#   I=${sample_id}_extract.bam \
#   FASTQ=$fq_1 SECOND_END_FASTQ=$fq_2 \
#   NON_PF=true RE_REVERSE=true VALIDATION_STRINGENCY=LENIENT &>> $log_file_name

#Log processing time
echo "Total processing time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec" >> $log_file_name
