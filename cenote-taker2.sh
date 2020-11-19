#cenote-taker2.sh

#1. 使用cenote-taker2 鉴定病毒contigs同时注释
#注意cenote-taker2运行速度很慢建议先用其他病毒鉴定工具，然后用cenote-taker2进行注释
python /path/to/Cenote-Taker2/run_cenote-taker2.0.1.py
usage: run_cenote-taker2.0.1.py [-h] 
                          --contigs ORIGINAL_CONTIGS 
                          --run_title RUN_TITLE 
                          --template_file TEMPLATE_FILE
                          --prune_prophage PROPHAGE 
                          --mem MEM 
                          --cpu CPU
                                [--reads1 F_READS] 
                                [--reads2 R_READS]
                                [--minimum_length_circular CIRC_LENGTH_CUTOFF]
                                [--minimum_length_linear LINEAR_LENGTH_CUTOFF]
                                [--virus_domain_db VIRUS_DOMAIN_DB]
                                [--lin_minimum_hallmark_genes LIN_MINIMUM_DOMAINS]
                                [--circ_minimum_hallmark_genes CIRC_MINIMUM_DOMAINS]
                                [--known_strains HANDLE_KNOWNS]
                                [--blastn_db BLASTN_DB]
                                [--enforce_start_codon ENFORCE_START_CODON]
                                [--handle_contigs_without_hallmark HANDLE_NONVIRAL]
                                [--hhsuite_tool HHSUITE_TOOL]
                                [--isolation_source ISOLATION_SOURCE]
                                [--Environmental_sample ENVIRONMENTAL_SAMPLE]
                                [--collection_date COLLECTION_DATE]
                                [--metagenome_type METAGENOME_TYPE]
                                [--srr_number SRR_NUMBER]
                                [--srx_number SRX_NUMBER]
                                [--biosample BIOSAMPLE]
                                [--bioproject BIOPROJECT]
                                [--assembler ASSEMBLER]
                                [--molecule_type MOLECULE_TYPE]
                                [--data_source DATA_SOURCE]
                                [--filter_out_plasmids FILTER_PLASMIDS]
                                [--scratch_directory SCRATCH_DIR]
                                [--blastp BLASTP]

#得到.tsv 结果，然后进行解析
#2. 从NCBI ftp中
wget nucl_gb.accession2taxid
wget prot.accession2taxid.20201013_0121

#3. 匹配cenote-taker结果中的蛋白accession ID得到taxonmy ID
#注意prot.accession2taxid.20201013_0121文件较大，匹配脚本应该注意
python extract_tax.py

#3.根据tax ID得到物种详细的注释信息
#应用NCBItax2lin得到文件为ncbi_lineages_[date_of_utcnow].csv.gz
#First download taxonomy dump from NCBI:
wget -N ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
mkdir -p taxdump && tar zxf taxdump.tar.gz -C ./taxdump
ncbitax2lin taxdump/nodes.dmp taxdump/names.dmp

#匹配tax ID到ncbi_lineages_[date_of_utcnow].csv.gz
#最后得到病毒详细注释信息
Python extract_tax_family.py

#4. 鉴定宿主---使用CrisprOpenDB
python CL_Interface.py -i Salmonella_161.fasta -m 2

#5. 鉴定噬菌体编码的CRISPR，使用MICD
minced -minNR 2 metagenome.fna metagenome.crisprs

