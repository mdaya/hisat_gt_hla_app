#!/bin/bash

ref_file=$1
nr_threads=$2
let "nr_threads = nr_threads - 1"  

out_file=thread_test_log.txt

echo "ref_file is $ref_file" > $out_file
echo "nr_threads is $nr_threads" >> $out_file
