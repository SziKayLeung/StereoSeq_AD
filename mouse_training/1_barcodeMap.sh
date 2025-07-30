#!/bin/bash
#SBATCH --export=ALL # export all environment variables to the batch job
#SBATCH -D . # set working directory to .
#SBATCH -p mrcq # submit to the parallel queue
#SBATCH --time=20:00:00 # maximum walltime for the job
#SBATCH -A Research_Project-MRC148213 # research project to submit under
#SBATCH --nodes=1 # specify number of nodes
#SBATCH --ntasks-per-node=16 # specify number of processors per node
#SBATCH --mail-type=END # send email at job completion
#SBATCH --mail-user=sl693@exeter.ac.uk # email address

# 15/07/2025: run ST_BarcodeMap on mouse training data
# 16/07/2025: extract mouse ONT reads that have the CID sequence (1-25bp)

##-------------------------------------------------------------------------

module load Miniconda2
source activate spatial

export PATH=/lustre/projects/Research_Project-MRC148213/lsl693/software/ST_BarcodeMap:$PATH
metadir=/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/mouse_analysis/0_metadata
#ST_BarcodeMap-0.0.1 --in ${metadir}/Y01037C4.barcodeToPos.h5 --out ${metadir}/Y01037C4.barcodeToPos.txt --action 3

# subset reads that have barcoded data
basecalledDir=/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/mouse_analysis/1_basecalled
barcode=/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/mouse_analysis/0_metadata/Y01037C4.barcodeToPos.txt
outputdir=/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/mouse_analysis/6_combined_spatial

#cut -f1 ${barcode} > ${metadir}/Y01037C4.barcode.txt
for i in ${basecalledDir}/mouse_[0-9][0-9]_merged.fastq; do 
  echo $i
  sample=$(basename $i _merged.fastq)
  seqkit grep -s -f ${metadir}/Y01037C4.barcode.txt $i > ${outputdir}/${sample}_merged_barcoded.fastq   
done