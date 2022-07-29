import sys, os, re, argparse, string

parser = argparse.ArgumentParser()
parser.add_argument('Fastq1_file', help='1 name of the sequencing file file fastq format') 
parser.add_argument('Fastq2_file', help='name of the sequencing file file fastq format')
args = parser.parse_args()
Reads_file = args.Fastq1_file
Reads2_file = args.Fastq2_file
aa=[]
aa=Reads_file.split(".unassembled.")
g=''
a=''
a=str(aa[0])
for i in a:
	if i!="'" and i!="[" and i!="]":
		g+=i
Read_Unit=g+".assembled.concatenated.fastq"
count=0
#This is a loop to store the IDs
with open(Reads_file, 'r') as f:
	ID=[]
	count=0
	asd=''
	for se in f:
		if count%4==0 and se!='\n':
			asd+=se+'\n'
		count+=1
ID=asd.split()
#This is a loop to store reads			
with open(Reads_file, 'r') as f:
	output=''
	asd=''
	line_length=''
	Read=[]
	count=0
	Header=f.readline()
	for se in f:
		if count%4==0:
			asd+=se+'\n'
		count+=1
Read=asd.split()
#This is a loop to store reads2		
with open(Reads2_file, 'r') as f:
	output=''
	asd=''
	line_length=''
	Read2=[]
	count=0
	Header=f.readline()
	for se in f:
		if count%4==0:
			asd+=se+'\n'
		count+=1
Read2=asd.split()
#Quality markers 1 trimming
with open(Reads_file, 'r') as f:
	asd=''
	Quality_Marker=[]
	J=0
	count=0
	Header2=f.readline()
	Header2=f.readline()
	Header3=f.readline()
	for se in f:
		if count%4==0:
			asd+=se+'\n'
		count+=1
Quality_Marker=asd.split()
#Quality markers 2 trimming
asd=''
with open(Reads2_file, 'r') as f:
	x=''
	Quality_Marker2=[]
	J=0
	count=0
	Header2=f.readline()
	Header2=f.readline()
	Header3=f.readline()
	for se in f:
		J+=1
		if count%4==0:
			asd+=se+'\n'
		count+=1
Quality_Marker2=asd.split()
Unit_file=open(Read_Unit,'w')
output2=''
for i in range(0,len(ID)-1):
	count+=1
	output2+=ID[i]+'\n'+Read[i]+Read2[i]+'\n'+'+'+'\n'+Quality_Marker[i]+Quality_Marker2[i]+'\n'
Unit_file.write(output2)

