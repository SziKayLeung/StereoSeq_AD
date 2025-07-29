#!/usr/bin/env Rscript
## ----------Script-----------------
##
## Author: Szi Kay Leung (S.K.Leung@exeter.ac.uk)
## output a list of transcripts that are documented in the TALON gtf but not in the abundance file
## sanity check for TALON pipeline
## Input:
##  --gtf = TALON gtf generated from talon_create_GTF
##  --counts = TALON abundance file
##  --output = output path and name of file
## --------------------------------

## ---------- packages -----------------

suppressMessages(library("dplyr"))
suppressMessages(library("stringr"))
suppressMessages(library("data.table"))


## ---------- input files -----------------

dir <- c("C:/Users/sl693/OneDrive - University of Exeter/ExeterPostDoc/1_Projects/BRC/3_Samples/")
weight_samples <- read.csv(paste0(dir, "BDR_Phenotype/MRC BDR Individual Library_GENDER_AGE_BRAAK_WEIGHT.csv"))
mrc_BDR <- fread(paste0(dir, "BDR_Phenotype/MRC_BDR_Individual_Library.csv"), data.table = F)


## ---------- selecting list of samples from Oxford and Newcastle cohort -----------------

# filtering for samples in Oxford and Newcastle cohort 
mrc_BDR_criteria <- mrc_BDR %>% filter(Institute %in% c("Oxford","Newcastle"), BraakStage %in% c(0,1,6))
colnames(mrc_BDR_criteria)[14] <- "PMI_hours"

# samples that passed ATAC QC and DNAm QC
passATAC <- read.csv(paste0(dir,"BDR_Phenotype/passAllStatus.csv")) %>% mutate(Individual_ID = stringr::word(sampleCode,c(1),sep = ("_")))
passDNAm <- read.csv(paste0(dir,"BDR_Phenotype/passQCStatusStage3AllSamples_DNAm.csv"))
samplesPassedATACQC <- unique(passATAC[passATAC$PASSALL == TRUE, "Individual_ID"])
samplesPassedDNAm <- unique(passDNAm[passDNAm$passQCS3 == TRUE, "Individual_ID"])

# select samples for stereo-seq
samplesForSpatial <- weight_samples %>% filter(Institute %in% c("Oxford","Newcastle"), BraakStage %in% c(0,1,6)) %>% 
  mutate(passedATAC = ifelse(ExeterID %in% samplesPassedATACQC, TRUE, FALSE),
                             passedDNAm = ifelse(ExeterID %in% samplesPassedDNAm, TRUE, FALSE)) %>% 
  mutate(passedATAC = ifelse(ExeterID %in% passATAC$Individual_ID, passedATAC, NA),
         passedDNAm = ifelse(ExeterID %in% passDNAm$Individual_ID, passedDNAm, NA)) %>% 
  mutate(matchingDemo = ifelse(ExeterID %in% mrc_BDR_criteria$ExeterID, TRUE, FALSE)) %>% 
  merge(.,mrc_BDR_criteria[,c("ExeterID","PMI_hours","PATHDIAG")], by = "ExeterID") %>% 
  arrange(PMI_hours)

message("All samples, Braak stage 0,1,6:", nrow(samplesForSpatial))
message("All samples, Braak stage 0,1,6 passed QC:", nrow(samplesForSpatial %>% filter(passedDNAm == TRUE, passedATAC == TRUE)))

# output
write.csv(samplesForSpatial, paste0(dir, "Samples_Selected_RIN/samplesForSpatial.csv"), quote = F, row.names = F)


## ---------- selecting for additional samples from Oxford and Newcastle cohort after 1st round of tapestation -----------------

samplesforSpatial <- read.csv(paste0(dir, "Samples_Selected_RIN/samplesForSpatial.csv"))

## include PMI delay information (maybe more informative of which samples to select to test RIN)
# file from Rhiannon
BDR_demo <- fread(paste0(dir, "BDR_Phenotype/FinalSelectionPheno.txt"), data.table = F)
# file from Emma D
BDR_demo2 <- fread(paste0(dir, "BDR_Phenotype/sampleSheet_BDR_QC_array_feb2025.csv"), data.table = F)
# merge phenotype files
BDR_demo <- merge(BDR_demo, BDR_demo2[,c("Individual_ID","BBNID","BraakStage","Institute")], by.x = "BBNId", by.y = "BBNID")

# exclude samples already selected for tapstation
samplesSelectedForRin <- c("EX033","EX059","EX030","EX058","EX038","EX043","EX067","EX076")

# list of additional samples
SecondRoundRIN <- BDR_demo[BDR_demo$Individual_ID %in% 
           samplesforSpatial$ExeterID,c("Individual_ID","Institute","BraakStage","Gender","PMD","APOE")] %>% distinct(.) %>% 
  arrange(PMD) %>% filter(!Individual_ID %in% samplesSelectedForRin) %>% 
  merge(., weight_samples[,c("ExeterID","Mass..mg.")], by.x = "Individual_ID", by.y = "ExeterID")

# output
write.csv(SecondRoundRIN, paste0(dir, "Samples_Selected_RIN/samplesForSpatial_2ndRoundRIN.csv"),quote = F, row.names = F)


## ---------- selecting for additional samples for new chips -----------------
samplesSelectedForRin <- c(samplesSelectedForRin, c("EX087","EX060","EX088","EX035","EX047","EX102","EX058","EX047",
                                                    "EX102","EX087","EX039","EX090"))

# list of additional samples
ThirdRoundRIN <- BDR_demo[BDR_demo$Individual_ID %in% 
                             samplesforSpatial$ExeterID,c("Individual_ID","Institute","BraakStage","Gender","PMD","APOE")] %>% distinct(.) %>% 
  arrange(PMD) %>% filter(!Individual_ID %in% samplesSelectedForRin) %>% 
  filter(BraakStage %in% c(0,1,6)) %>% 
  merge(., weight_samples[,c("ExeterID","Mass..mg.")], by.x = "Individual_ID", by.y = "ExeterID", all.x = T)

write.csv(ThirdRoundRIN, paste0(dir, "Samples_Selected_RIN/samplesForSpatial_3rdRoundRIN.csv"),quote = F, row.names = F)
