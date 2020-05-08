FROM biocontainers/samtools:v1.9-4-deb_cv1

#Install wget
USER root
RUN apt-get clean all && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  \
         wget \
         default-jre \
         git \
         build-essential

#Install picard
USER biodocker
RUN mkdir /home/biodocker/picard && \
    wget https://github.com/broadinstitute/picard/releases/download/2.22.3/picard.jar -O /home/biodocker/picard/picard.jar

#Install HISAT-genotype
RUN git clone https://github.com/DaehwanKimLab/hisat-genotype /home/biodocker/hisat-genotype && \
    cd /home/biodocker/hisat-genotype && \
    git checkout hisatgenotype_v1.1.3 && \
    make hisat2-align-s hisat2-build-s hisat2-inspect-s 

#Install pipeline script
RUN mkdir /home/biodocker/hisat_genotype_run
COPY extract_reads.sh /home/biodocker/hisat_genotype_run
COPY type_hisat_hla.sh /home/biodocker/hisat_genotype_run
COPY test_arguments.sh /home/biodocker/hisat_genotype_run
USER root
RUN chmod a+x /home/biodocker/hisat_genotype_run/type_hisat_hla.sh
RUN chmod a+x /home/biodocker/hisat_genotype_run/extract_reads.sh
USER biodocker

#Set environment variables
RUN echo 'export PATH="/home/biodocker/hisat-genotype:/home/biodocker/hisat-genotype/hisatgenotype_scripts:/home/biodocker/hisat_genotype_run/:$PATH"' >> /home/biodocker/.bashrc && \
    echo 'export PYTHONPATH="${PYTHONPATH}:/home/biodocker/hisat-genotype/hisatgenotype_modules/"' >> /home/biodocker/.bashrc

CMD ["/bin/bash"]
