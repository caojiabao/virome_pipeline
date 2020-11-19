##Pathseq pipline (gatk 4)

#covert fastq to bam file 
java -jar picard.jar FastqToSam \
   F1=forward_reads.fastq \
   F2=reverse_reads.fastq \
   O=unaligned_read_pairs.bam \
   SM=sample001

#构建custom database
#build the host and microbe BWA index imgages
#generate the host k-mer library file
#!/bin/bash
set -eu
GATK_HOME=/path/to/gatk
REFSEQ_CATALOG=/path/to/RefSeq-releaseXX.catalog.gz
TAXDUMP=/path/to/taxdump.tar.gz

echo "Building pathogen reference..."
$GATK_HOME/gatk BwaMemIndexImageCreator -I microbe.fasta
samtools fadix microbe.fasta
java -jar /software_users/caojiabao/picard.jar CreateSequenceDictionary R=microbe.fasta O=microbe.dict
$GATK_HOME/gatk PathSeqBuildReferenceTaxonomy -R microbe.fasta --refseq-catalog $REFSEQ_CATALOG --tax-dump $TAXDUMP -O microbe.db

echo "Building host reference..."
$GATK_HOME/gatk BwaMemIndexImageCreator -I host.fasta
samtools faidx host.fasta
java -jar /software_users/caojiabao/picard.jar CreateSequenceDictionary R=host.fasta O=host.dict
$GATK_HOME/gatk PathSeqBuildKmers --reference host.fasta -O host.hss

#run the pathseq pipeline 
gatk PathSeqPipelineSpark \
    --input test_sample.bam \
    --filter-bwa-image hg19mini.fasta.img \
    --kmer-file hg19mini.hss \
    --min-clipped-read-length 70 \
    --microbe-fasta e_coli_k12.fasta \
    --microbe-bwa-image e_coli_k12.fasta.img \
    --taxonomy-file e_coli_k12.db \
    --output output.pathseq.bam \
    --scores-output output.pathseq.txt

#output有两个
#output.pathseq.bam : contains all high-quality non-host reads aligned to the microbe reference.
#output.pathseq.txt : a tab-delimited table of the input sample’s microbial composition.

