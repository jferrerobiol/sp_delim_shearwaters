#!/Users/apple/anaconda3/bin/python

### Usage python write_liftover_bam.py <gff_file> <sam_file_original_genome> <sam_file_bedtobam> <output_sam>

import sys
from Bio.Seq import Seq

#Filling the dictionary based on the values on the sam_ori_genome
d = {}
with open(sys.argv[2], 'r') as sam_ori_genome:
    for l in sam_ori_genome:
        if l[0] != '@':
            l = l.split("\t")
            qname = int(l[0])
            flag = l[1]
            mapq = l[4]
            cigar = l[5]
            rnext = '*'
            pnext = '0'
            tlen = '0'
            seq = l[9]
            qual = '*'
            d[qname] = {"flag" : flag, "mapq" : mapq, "cigar" : cigar, "rnext" : rnext, "pnext" : pnext, "tlen" : tlen, "seq" : seq, "qual" : qual}

#Open and write the headers of the sam_bedtobam to the sam_output
sam_output = open(sys.argv[4], 'w')

with open(sys.argv[3], 'r') as sam_bedtobam:
    for l in sam_bedtobam:
        if l[0] == '@':
            sam_output.write(l)

#Open the gff file and write the output to the sam_output file
with open(sys.argv[1], 'r') as gff:
    for l in gff:
        l = l.split("\t")
        chr_int = l[0]
        chr_int_parse = chr_int.split(".")
        rname = chr_int_parse[0]
        pos = l[3]
        id_info = l[8]
        id_info_parsed = id_info.split("\"")
        id = int(id_info_parsed[1])
        strand = l[6]
        seq = Seq(d[id]['seq'])
        if strand == '+': #Change the orientation of the sequence if they mapped in opposite strands in the 2 genomes
            flag = '0'
            if int(d[id]['flag']) == 16:
                seq = seq.reverse_complement()
        if strand == '-': #Change the orientation of the sequence if they mapped in opposite strands in the 2 genomes
            flag = '16'
            if int(d[id]['flag']) == 0:
                seq = seq.reverse_complement()
        sam_output.write(str(id) + '\t' +  flag + '\t' + rname + '\t' + pos + '\t' + d[id]['mapq'] + '\t' + d[id]['cigar'] + '\t' + d[id]['rnext'] + '\t' + d[id]['pnext'] + '\t' + d[id]['tlen'] + '\t' + str(seq) + '\t' + d[id]['qual'] + '\n')

sam_output.close()
