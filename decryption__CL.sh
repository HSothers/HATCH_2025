
#!/bin/bash

# Run this if the conda enviroment hasn't been created yet
#module load Anaconda3/5.3.0
#conda create -n hatch
#y

#source activate hatch
#conda install -c bioconda -y cryfa


module load Anaconda3/5.3.0
source activate hatch

file = $1

conda create –n hatch

conda activate hatch

conda install -c bioconda -y cryfa

cryfa


cryfa -k key.txt -d $1 > $2
#this decrypts the file
