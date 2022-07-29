#!/bin/bash
#$ -cwd

cd $HOME/JoseMari/Individual_FineRADstructure/PPuf/
#File conversion from pyRAD .alleles to fineRADStructure .finerad
for file in *.alleles;do
        python $HOME/JoseMari/scripts/fineradinput.py -i $file
done
#With no genome is necessary to perform LD analysis.
for file in *.finerad; do 
      $HOME/JoseMari/fineRADstructure-master/sampleLD.R $file ${file/.finerad/_LD.finerad}
done
#FineRADStructure analysis:
#Compute Coancestry matrix
for file in *_LD.finerad; do
        $HOME/JoseMari/fineRADstructure-master/RADpainter paint $file  
done 
#Infer clustering using MCMC
for file in *chunks.out; do
         $HOME/JoseMari/fineRADstructure-master/finestructure -x 100000 -y 100000 -z 1000 $file ${file/.out/.mcmc.xml}
done
#Construct phylogenetic tree
for file in *_chunks.out;do
        $HOME/JoseMari/fineRADstructure-master/finestructure -m T -x 10000 $file ${file/.out/.mcmc.xml} ${file/.out/.mcmcTree.xml}
done

