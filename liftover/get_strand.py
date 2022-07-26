#!/Users/apple/anaconda3/bin/python

### Usage python get_strand.py <gff_file> <sam_file> <gff_with_strand>

import sys

#Opening input and output files
gff = open(sys.argv[1])
gff_out = open(sys.argv[3], 'w')

d = {}

# Filling the dictionary
with open(sys.argv[2], 'r') as sam:
    for l in sam:
        if l[0] != '@':
            l = l.split("\t")
            id_sam = int(l[0])
            flag = int(l[1])
            if flag == 0 or flag == 256 or flag == 2048:
                strand = '+'
            if flag == 16 or flag == 272 or flag == 2064:
                strand = '-'
            d[id_sam] = strand

#Read the first line
line = gff.readline()

while line:
    line_parsed = line.split("\t")
    id_info = line_parsed[8]
    id_info_parsed =line.split("\"")
    id = int(id_info_parsed[1])
    strand_out = d[id]
    gff_out.write(line_parsed[0] + '\t' + line_parsed[1] + '\t' + line_parsed[2] + '\t' + line_parsed[3] + '\t' + line_parsed[4] + '\t' + line_parsed[5] + '\t' + line_parsed[6] + '\t' + strand_out + '\t' + line_parsed[8])
    line = gff.readline()

gff.close()
gff_out.close()
