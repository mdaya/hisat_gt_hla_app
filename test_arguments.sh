#!/bin/bash

nr_threads=$1
let "nr_threads = nr_threads - 1"  
ref_file=$2

out_file=thread_test_log.txt

echo "nr_threads is $nr_threads" > $out_file
echo "ref_file is $ref_file" >> $out_file
