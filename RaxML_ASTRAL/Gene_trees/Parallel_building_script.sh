#!/bin/bash
#-V
#-cwd
#Build a RAXML for each locus
 for i in *phy; do gene_id=$(echo $i | sed 's/.phy/_output/'); printf raxmlHPC\-PTHREADS\-SSE3\ \-s\ $i\ \-T\ 5\ \-n\ $gene_id\ \-m\ GTRGAMMA\ \-p\ $RANDOM\ \-f\ a\ \-x\ $RANDOM\ \-N\ 100\ \-w\ \$HOME\/JoseMari\/phylo\_analyses\/RAxML\/gene\_trees/'\n' >> raxml_gene_trees_parallel; done

