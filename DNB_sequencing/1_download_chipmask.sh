#!/bin/bash
#SBATCH --export=ALL # export all environment variables to the batch job
#SBATCH -D . # set working directory to .
#SBATCH -p mrcq # submit to the parallel queue
#SBATCH --time=2:00:00 # maximum walltime for the job
#SBATCH -A Research_Project-MRC148213 # research project to submit under
#SBATCH --nodes=1 # specify number of nodes
#SBATCH --ntasks-per-node=16 # specify number of processors per node
#SBATCH --mail-type=END # send email at job completion
#SBATCH --mail-user=s.k.leung@exeter.ac.uk # email address
#SBATCH --output=1_download_chipmask-%A_%a.o
#SBATCH --error=1_download_chipmask-%A_%a.e

# 15/06/2026: download chipmask to analyse DNB-Seq for first 4 samples 
# EX039 (Y01138N6) already downloaded and analysed by R.Bamford in Jan 2026

samples=(EX031 EX091 EX111)
chipMask=(Y01138JE Y011090M1 Y01100M8)

chipMaskDownload=/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/download_mask 
outputChipMaskDir=/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/chip_mask_skl/

for i in {0..2}; do
  if [ ! -f ${outputChipMaskDir}/${chipMask[$i]}.barcodeToPos.h5 ]; then
  	echo "Processing ${samples[$i]} with chipmask ${chipMask[$i]}" 
  	${chipMaskDownload} download --chipSN ${chipMask[$i]} --outputPath ${outputChipMaskDir} --logFile download_log_${samples[$i]}_${chipMask[$i]}.txt
  fi
done