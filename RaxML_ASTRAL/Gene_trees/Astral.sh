#! /bin/bash
#$ -cwd
#$ -V
java -jar ../../../../programari/Astral/astral.5.6.3.jar -i ml_best.trees -o astral_default.tre 2> astral_default.log 1>&2;
