# Workflow to do a liftover of ddRAD loci from the *Puffinus mauretanicus* scaffold level genome assembly to the *Calypte anna* chromosome level assembly
## 1) Gather files
### Filter and convert bam file of the Stacks catalog to gff
```
samtools view -b -F 2304 catalog_PMau_minimap2_def_sorted.bam > catalog_PMau_minimap2_def_sorted_filtered.bam
spliced_bam2gff -M catalog_PMau_minimap2_def_sorted_filtered.bam > catalog_PMau_minimap2_def_sorted_filtered.gff
cat catalog_PMau_minimap2_def_sorted.gff | grep -v "^#" | grep "mRNA" | sed 's/pinfish	mRNA/minimap2	match_part/g' > catalog_PMau_minimap2_def_sorted.gffbo #It included all the mapped catalog loci
```
### Add the strand informationwith the custom script get_strand.py
```
python ../Mapping_genome/scripts/get_strand.py catalog_PMau_minimap2_def_sorted_filtered.gffbo catalog_PMau_minimap2_def_sorted_filtered.sam catalog_PMau_minimap2_def_sorted_strand.gff
```
## 2) Run Kraken:
```
RunKraken -c kraken.config -s catalog_PMau_minimap2_def_sorted_filtered_strand.gffbo -S Puf_mau -T Cal_ann
mv mapped.gtf catalog_Cann_kraken_def_sorted_filtered_strand.gff # change the name of the output file
```
This new gff has 128701 records while the one mapped to the PMau genome has 173011. Although there is a lost of loci, there is still much more than trying to map directly the RAdtags to the Calann genome. The mean length of the fragments is actually a little bit longer in the Calann genome probably due to more indels between the catalog loci and Calann

## 3) Convert the gff file to bam to be used as input in Stacks' integrate_alignments
```
gff2bed < catalog_Cann_kraken_def_sorted_filtered_strand.gff > catalog_Cann_kraken_def_sorted_filtered_strand.bed #Convert to bed
samtools faidx ../../Mapping_genome/Reference_genomes/GCA_003957555.1_bCalAnn1_v1.p_genomic.fna #Build the genome file for bedtobam
mv ../../Mapping_genome/Reference_genomes/GCA_003957555.1_bCalAnn1_v1.p_genomic.fna.fai ./
cut -f 1,2 GCA_003957555.1_bCalAnn1_v1.p_genomic.fna.fai > Calann_chrom.sizes
bedtobam -i catalog_Cann_kraken_def_sorted_filtered_strand.bed -g Calann_chrom.sizes > catalog_Cann_kraken_def_sorted_filtered_strand.bam #Convert to bam
```
## 4) Write a python script to generate the bam file in the input required by integrate_alignments (write_liftover_bam.py) and run it
```
python ../Mapping_genome/scripts/write_liftover_bam.py liftover_Calann/catalog_Cann_kraken_def_sorted_filtered_strand.gff catalog_PMau_minimap2_def_sorted_filtered.sam liftover_Calann/catalog_Cann_kraken_def_sorted_filtered_strand.sam catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sam
cat catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sam | grep -v "RRCD010" | sed -E 's/^(\@.*)\.1/\1/g' > catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sambo #To take out the scaffolds were none of the fragments mapped
rm catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sam
mv catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sambo catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sam
cat catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam.sam | samtools view -bS | samtools sort -o catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam_sorted.bam
```
## 5) Run integrate alignments with the liftover bam to integrate alignments to the Cal Ann genome
stacks-integrate-alignments -P $stacks -B catalog_Cann_kraken_def_sorted_filtered_strand_write-liftover-bam_sorted.bam -O ./integrate_alignments_PMau
