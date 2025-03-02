#!/bin/bash


module load Anaconda3/5.3.0
source activate hatch

file = $1

conda create –n hatch

conda activate hatch

conda install -c bioconda -y cryfa

cryfa


cryfa -k key.txt file > encrypt 
#this creates the encrypted file, opening the file causing everything to immediately crash
