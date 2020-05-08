#!/bin/bash

#TODO: Uncomment the below command and remove the redundant echo statements of tool commands
#set -x

#TODO later: 
#Perhaps sample_id can come from file metadata

#Input parameters
fq_1=$1
fq_2=$2
sample_id=`basename $fq_1 | cut -f1 -d"_"` 

#Output parameters
out_file_name=${sample_id}_hla_report.txt
log_file_name=${sample_id}_type_hisat_hla_log.txt

#Start timer 
SECONDS=0

shift
shift
for file in "$@"
do
  echo "Moving $file to current directory ..." >> $log_file_name
  mv $file .
done
#TODO: remove the below - check if reference files have been copied
ls hla*  &>> $log_file_name
ls *genome*  &>> $log_file_name

#Extract reads that map to HLA
echo "Extracting reads that map to HLA..." >> $log_file_name
echo "hisatgenotype_toolkit extract-reads --base hla -1 $fq_1 -2 $fq_2" >> $log_file_name
#hisatgenotype_toolkit extract-reads --base hla -1 $fq_1 -2 $fq_2 &>> $log_file_name

#Type HLA
echo "Type HLA..." >> $log_file_name
echo "hisatgenotype_toolkit locus -x genotype_genome --base hla --locus-list A,B,C,DRB1,DQA1,DQB1 -1 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-1.fq.gz -2 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-2.fq.gz" >> $log_file_name
touch  assembly_graph-hla-${sample_id}_extract.report  #TODO: remove after test
#hisatgenotype_toolkit locus -x genotype_genome \
#   --base hla \
#   --locus-list A,B,C,DRB1,DQA1,DQB1 \
#   -1 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-1.fq.gz -2 ${sample_id}_extract.bam.1.fq.gz-hla-extracted-2.fq.gz &>> $log_file_name

#Copy output
mv assembly_graph-hla-${sample_id}_extract.report $out_file_name &>> $log_file_name

#Log processing time
echo "Total processing time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec" >> $log_file_name
