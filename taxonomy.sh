#viral contig taxonomy annotation
#利用kaiju方法

#自己构建病毒蛋白数据库，这里我利用uniprot中的所有病毒蛋白数据库
#下载所有uniprot蛋白
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_trembl.fasta.gz
#下载病毒注释
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_trembl_viruses.dat.gz
#提取病毒蛋白
seqkit grep 方法

#利用kaiju构建数据库
kaiju-mkbwt -n 5 -a ACDEFGHIKLMNPQRSTVWY -o proteins uniprot_trembl_virus_phage.fa
kaiju-mkfmi proteins

#Running Kaiju
kaiju -t nodes.dmp -f kaiju_db.fmi -i inputfile.fastq -o kaiju.out -z 40


#Adding taxa names to output file
kaiju-addTaxonNames -t nodes.dmp -n names.dmp -i kaiju.out -o kaiju.names.out