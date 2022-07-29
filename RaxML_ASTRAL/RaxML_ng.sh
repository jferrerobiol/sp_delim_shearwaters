#!/bin/bash
#$ -V
#$ -cwd

#Directory for the RaxML-ng output files
cd $HOME/JoseMari/phylo_analyses/raxml-ng/PMY_Only/
#Location of the phylip file
phylip=$HOME/JoseMari/phylo_analyses/raxml-ng/PMY_Only/PPuf_clust89_percent65_min5PMY.phy
#name of the outfiles
name=PMY_nopart_raxml_ng
#RaxML commands
raxml-ng --msa $phylip --model GTR+G --prefix $name --seed 2 --threads 20 --brlen scaled --tree pars{10},rand{10}
raxml-ng --bootstrap --msa $phylip --model GTR+G  --prefix $name --seed 333 --threads 20 --bs-trees 300
raxml-ng --bsconverge --bs-trees ${name}.raxml.bootstraps --prefix $name --seed 2 --threads 20 --bs-cutoff 0.03
raxml-ng --support --tree ${name}.raxml.bestTree --bs-trees ${name}.raxml.bootstraps --prefix $name --threads 20

