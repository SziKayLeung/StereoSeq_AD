#!/bin/bash
#SBATCH --export=ALL # export all environment variables to the batch job
#SBATCH -D . # set working directory to .
#SBATCH -p mrcq # submit to the parallel queue
#SBATCH --time=144:00:00 # maximum walltime for the job
#SBATCH -A Research_Project-MRC148213 # research project to submit under
#SBATCH --nodes=1 # specify number of nodes
#SBATCH --ntasks-per-node=16 # specify number of processors per node
#SBATCH --mail-type=END # send email at job completion
#SBATCH --mail-user=sl693@exeter.ac.uk # email address
#SBATCH --array=0-19%5 # 20 samples
#SBATCH --output=1_barcodeMap-%A_%a.o
#SBATCH --error=1_barcodeMap-%A_%a.e

# 15/07/2025: run ST_BarcodeMap on mouse training data
# 16/07/2025: extract mouse ONT reads that have the CID sequence (1-25bp) -> timed out using grep
# 30/07/2025: use split_on_primer.py to extract primer sequence (script is poorly written)
# 30/07/2025: use cutadapt


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

cd $outputdir
#awk '{print ">"$2"_"$3"\n"$1}' ${metadir}/Y01037C4.barcodeToPos.txt > $outputdir/Y01037C4.barcodeToPos.primer.fasta

#cutadapt -g myadapter=GTTTTCGTGTTCCTTCGTTCAGTTA ${basecalledDir}/mouse_00_merged.fastq \
#-o output.fq --minimum-length 150 --too-short-output short_length.fastq --discard-untrimmed --error-rate 0  --overlap 25 --info-file trimmed_info.txt 
#cutadapt -u 10 -o output2.fq output.fq

FastqFiles=(${basecalledDir}/mouse_[0-9][0-9]_merged.fastq)
FastqFile=${FastqFiles[${SLURM_ARRAY_TASK_ID}]}  

echo $FastqFile
sample=$(basename $FastqFile _merged.fastq)
cutadapt -g ^file:$outputdir/Y01037C4.barcodeToPos.primer.fasta $FastqFile \
  -o ${sample}-{name}.fq \
  --minimum-length 150 \
  --too-short-output short_length.fastq \
  --discard-untrimmed \
  --error-rate 0  \
  --overlap 25 \
  --info-file trimmed_info.txt 2> ${sample}_cutadapt.log
     

#grep myadapter trimmed_info.txt