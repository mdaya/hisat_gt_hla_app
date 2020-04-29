#!/usr/bin/env cwl-runner
  
class: CommandLineTool
id: "HISAT-genotype"
label: "HISAT-genotype HLA tool"
cwlVersion: v1.0
doc: |
    ![build_status](https://quay.io/repository/hisat_gt_hla_app/status)
    A tool for calling HLA alleles from whole genome sequence CRAM files. 

dct:creator:
  "@id": "http://orcid.org/0000-0002-9057-6593"
  foaf:name: Michelle Daya
  foaf:mbox: "mailto:michelle.daya@gmail.com"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/mdaya/hisat_gt_hla_app:1.0"

hints:
  - class: ResourceRequirement 
    coresMin: 1
    ramMin: 8184  # "the process requires at least 8GB of RAM"

inputs:
  ref_file_input:
    type: File
    doc: "tar.gz file containing reference files required by HISAT-genotype"
    inputBinding:
      position: 1

  cram_input:
    type: File
    doc: "The CRAM file to use as input"
    format: "http://edamontology.org/format_3462" 
    inputBinding:
      position: 2
    secondaryFiles: .crai
  
outputs:
  hla_type_report:
    type: File
    outputBinding:
      glob: assembly_graph-hla*.report
    doc: "A text file that contains the HLA typing output"

baseCommand: ["bash", "/home/biodocker/hisat_genotype_run/type_hla.sh"]

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
