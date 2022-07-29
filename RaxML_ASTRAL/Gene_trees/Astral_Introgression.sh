#! /bin/bash
#$ -cwd
#$ -V
java -jar ../../../../programari/Astral/astral.5.6.3.jar -q astral_default.tre -i ml_best.trees -t 2 -o astral_scored_t2.tre 2> astral_scored_t2.log 1>&2;
java -jar ../../../../programari/Astral/astral.5.6.3.jar -q astral_default.tre -i ml_best.trees -t 10 -o astral_scored_t10.tre 2> astral_scored_t10.log 1>&2;

