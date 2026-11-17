#!/bin/bash
#SBATCH --export=ALL # export all environment variables to the batch job
#SBATCH -D .
#SBATCH -p mrcq # submit to the parallel queue
#SBATCH --time=120:00:00 # maximum walltime for the job e.g. 01:00:00
#SBATCH -A Research_Project-MRC190311 # research project to submit under
#SBATCH --nodes=1 # specify number of nodes
#SBATCH --ntasks-per-node=16 # specify number of processors per node
# #SBATCH --mem=60G # specify bytes of memory to reserve
#SBATCH --mail-type=END # send email at job completion
#SBATCH --mail-user=s.k.leung@exeter.ac.uk # email address

module load CUDA/11.7
#https://github.com/STOmics/SAW/issues/179

export OMP_NUM_THREADS=4
export NUMBA_NUM_THREADS=32
export MKL_NUM_THREADS=4
export OPENBLAS_NUM_THREADS=4
export VECLIB_MAXIMUM_THREADS=4
export NUMEXPR_NUM_THREADS=4

echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo "NUMBA_NUM_THREADS=$NUMBA_NUM_THREADS"

#"/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/saw/package/saw-8.1.3/bin/saw" -h

#set output directory
#cd "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/output/"
#"/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/saw/package/saw-8.1.3/bin/saw" count --id EX039 --sn Y01138N6 --omics=transcriptomics --kit-version="Stereo-seq T FF V1.3" --sequencing-type="PE75_50+100" --chip-mask "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/chip_mask/Y01138N6.barcodeToPos.h5" --organism=human --tissue=brain --reference "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/reference/transcriptome/" --fastqs "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/alacris/EX039/" --image "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/microscope_image/Y01138N6_ssDNA.tif" 

# EX091
#cd "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/EX091_output/"
#"/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/saw/package/saw-8.1.3/bin/saw" count --sn Y01109M1 --omics=transcriptomics --kit-version="Stereo-seq T FF V1.3" --sequencing-type=#"PE75_50+100" --chip-mask "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/chip_mask/Y01109M1.barcodeToPos.h5" --organism=human --tissue=brain --reference "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/reference/transcriptome/" --fastqs "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/alacris/EX091/" --image "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/microscope_image/Y01109M1_ssDNA.tif" 

# EX0111
#cd "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/EX111_output/"
#"/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/saw/package/saw-8.1.3/bin/saw" count --sn Y01100M8 --omics=transcriptomics --kit-version="Stereo-seq T FF V1.3" --sequencing-type="PE75_50+100" --chip-mask "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/chip_mask_skl/Y01100M8.barcodeToPos.h5" --organism=human --tissue=brain --reference "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/reference/transcriptome/" --fastqs "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/alacris/EX111/" --image "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/microscope_image/Y01100M8_ssDNA.tif" 

# EX031
cd "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/EX031_output/"
"/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/saw/package/saw-8.1.3/bin/saw" count --sn Y01138JE --omics=transcriptomics --kit-version="Stereo-seq T FF V1.3" --sequencing-type="PE75_50+100" --chip-mask "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/chip_mask/Y01138JE.barcodeToPos.h5" --organism=human --tissue=brain --reference "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/reference/transcriptome/" --fastqs "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/Stereo_seq_human_AD/alacris/EX031/" --image "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/microscope_image/Y01138JE_ssDNA.tif" 

echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo "NUMBA_NUM_THREADS=$NUMBA_NUM_THREADS"


#--image-tar "/lustre/projects/Research_Project-MRC190311/longReadSeq/ONTRNA/spatial/microscope_image/Y01138N6_SC_20251128_120725_4.1.2.tar.gz" 

echo "All done"
