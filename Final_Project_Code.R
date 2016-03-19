##Christine notes:
##The only thing I changed to get it up and running was adding library(dplyr).

## Liz Notes:
## You should load any packages you need to run this code
## at the top of the script. It won't cause any problems
## if the packages are already loaded and it saves you having to
## remember to do it.
library(ggplot2)
library(reshape)
library(dplyr)

##Take simple user input to find the correct files
TaxonLevel <- readline(prompt="Taxon Level (L2-L6): ")
## SeqDataFileName <- paste("~/Documents/Alegre Lab/Sequencing/", SequencingFolder, "/otu_table_filtered_", TaxonLevel, ".csv", sep = "", collapse = "")
###############################
## Liz's recommendation
## I removed the absolute file path, so that the user can input the
## relative path to the file on their own computer.
## Also, 'collapse = ""' shouldn't be necessary unless paste is taking in
## a vector.
###############################
SeqDataFileName <- paste("Data/otu_table_filtered_", TaxonLevel, ".csv", sep = "", collapse = "")

#Rename columns in data file as CM Experiment numbers
seqdata <- read.csv(SeqDataFileName, header = TRUE)
TaxonCount <- nrow(seqdata)
ColumnCount <- ncol(seqdata)
###############################
## Liz's recommendation
## I removed the absolute file path as above
###############################
KLnames <- read.csv("Data/KL_Map.csv", header = TRUE)
KLnamesfrom <- as.vector(KLnames$Sequencing_Tag)
KLnamesto <- as.vector(KLnames$Sequencing_ID)
for (n in 1:500) {
  colnames(seqdata)[colnames(seqdata) == KLnamesfrom[n]] <- KLnamesto[n]
  n <- n + 1
}

# Rename columns in data file as Experiment_Treatment_Sample_Day
CMnames <- read.csv("Data/CM_Map.csv", header = TRUE)
CMnamesfrom <- as.vector(CMnames$Sequencing_ID)
CMnamesexp <- as.vector(CMnames$Experiment)
CMnamestreatment <- as.vector(CMnames$Treatment)
CMnamessample <- as.vector(CMnames$Sample)
CMnamesday <- as.vector(CMnames$Day)
for (a in 1:500) {
  colnames(seqdata)[colnames(seqdata) == CMnamesfrom[a]] <- paste(CMnamesexp[a], CMnamestreatment[a], CMnamesday[a], CMnamessample[a], sep = "_")
  a = a + 1
}

#Take user input variables in order to find the correct subsets of data to compare
#Find Experiment
ExperimentID <- readline(prompt="Experiment (CM___): ")
TargetExperiment <- grep(paste(ExperimentID, "_", sep = "", collapse = ""), colnames(seqdata), value = TRUE)

#Find two timepoints from group 1
Group1 <- readline(prompt="Group 1 (control): ")
Group2 <- readline(prompt="Group 2 (treatment): ")
Group1Base = readline(prompt="Baseline timepoint (numerical) for Group 1: ") #Set baseline timepoint for group 1
Group2Base = readline(prompt="Baseline timepoint (numerical) for Group 2: ") #Set baseline timepoint for group 2
Group1End = readline(prompt="End timepoint (numerical) for Group 1: ") #Set experimental timepoint for group 1
Group2End = readline(prompt="End timepoint (numerical) for Group 2: ") #Set experimental timepoint for group 2

#Define vectors containing the column names for each experimental group
TargetGroup1 <- grep(paste("_", Group1, "_", sep = "", collapse = ""), TargetExperiment, value = TRUE)
TargetGroup2 <- grep(paste("_", Group2, "_", sep = "", collapse = ""), TargetExperiment, value = TRUE)

#Make vectors for each Experimental group for given time points in a consistent sample order
TargetGroup1Base <- sort(grep(paste("_", Group1Base, "_", sep = "", collapse = ""), TargetGroup1, value = TRUE))
TargetGroup2Base <- sort(grep(paste("_", Group2Base, "_", sep = "", collapse = ""), TargetGroup2, value = TRUE))
TargetGroup1End <- sort(grep(paste("_", Group1End, "_", sep = "", collapse = ""), TargetGroup1, value = TRUE))
TargetGroup2End <- sort(grep(paste("_", Group2End, "_", sep = "", collapse = ""), TargetGroup2, value = TRUE))


#Find average difference between time points for group 1
DifferenceGroup1Results <- 1:TaxonCount
for (Taxon in 1:TaxonCount) {
  DifferenceGroup1Results[Taxon] <- 100 * mean(((as.numeric(seqdata[Taxon, TargetGroup1End])) - mean(as.numeric(seqdata[Taxon, TargetGroup1Base])))/mean(as.numeric(seqdata[Taxon, TargetGroup1Base])))
  Taxon <- Taxon + 1
}

#Find average difference between time points for group 1
DifferenceGroup2Results <- 1:TaxonCount
for (Taxon in 1:TaxonCount) {
  DifferenceGroup2Results[Taxon] <- 100 * ((mean(as.numeric(seqdata[Taxon, TargetGroup2End])) - mean(as.numeric(seqdata[Taxon, TargetGroup2Base])))/mean(as.numeric(seqdata[Taxon, TargetGroup2Base])))
  Taxon <- Taxon + 1
}


#Perform Paired T tests for each taxon (need to loop by row) in Group 1
TTestGroup1Results <- 1:TaxonCount
for (Taxon in 1:TaxonCount) {
  TTestGroup1Results[Taxon] <- t.test(as.numeric(seqdata[Taxon, TargetGroup1Base]), 
                                      as.numeric(seqdata[Taxon, TargetGroup1End]), 
                                      paired = TRUE)$p.value
  Taxon <- Taxon + 1
}

#Perform Paired T tests for each taxon (need to loop by row) in Group 2
TTestGroup2Results <- 1:TaxonCount
for (Taxon in 1:TaxonCount) {
  TTestGroup2Results[Taxon] <- t.test(as.numeric(seqdata[Taxon, TargetGroup2Base]), 
                                      as.numeric(seqdata[Taxon, TargetGroup2End]), 
                                      paired = TRUE)$p.value
  Taxon <- Taxon + 1
}

#Convert p values from T test into matrix
DifferenceOutput <- matrix(c(as.numeric(DifferenceGroup1Results), as.numeric(DifferenceGroup2Results)), nrow = TaxonCount)
rownames(DifferenceOutput) <- as.character(seqdata[1:TaxonCount, 1])
colnames(DifferenceOutput) <- c(paste(Group1, "_days_", Group1Base, "_to_", Group1End, sep = "", collapse = ""),
                                 paste(Group2, "_days_", Group2Base, "_to_", Group2End, sep = "", collapse = ""))

PValueOutput <- matrix(c(as.numeric(TTestGroup1Results), as.numeric(TTestGroup2Results)), nrow = TaxonCount)
rownames(PValueOutput) <- as.character(seqdata[1:TaxonCount, 1])
colnames(PValueOutput) <- c(paste(Group1, "_days_", Group1Base, "_to_", Group1End, sep = "", collapse = ""),
                                paste(Group2, "_days_", Group2Base, "_to_", Group2End, sep = "", collapse = ""))
MeltedMatrixDifferences <- melt(DifferenceOutput)
MeltedMatrixPValues <- melt(PValueOutput)

FinishedMatrix <- matrix(nrow = TaxonCount * 2, ncol = 4)
FinishedMatrix[,1] <- as.character(MeltedMatrixDifferences[,1])
FinishedMatrix[,2] <- as.character(MeltedMatrixDifferences[,2])
FinishedMatrix[,3] <- MeltedMatrixDifferences[,3]
FinishedMatrix[,4] <- MeltedMatrixPValues[,3]
colnames(FinishedMatrix) <- c("Taxon", "Group", "Difference", "P_value")

##Convert results matrix into CSV and save with title reflecting the comparison that was done
#########################
## Liz Notes:
## I removed the absolute file path. Instead I had the results automatically go
## to how a Results folder, which is the standard approach in our lab.
## I also create a Results folder if it doesn't already exist.
## Great work putting together an informative file name here!
#########################
system("mkdir Results") ## will print a warning if folder exists, but won't stop code
CSVOutputFileName <- paste("Results/", TaxonLevel, "_", ExperimentID, "_", Group1, "_Days_", Group1Base, "_to_", Group1End, "_vs_", Group2, "_Days_", Group1Base, "_to_", Group1End, ".csv", sep = "", collapse = "")
write.csv(FinishedMatrix, file = CSVOutputFileName)

#Bar plot of p values for each taxon, omitting all taxa that had NaN as the result (because the taxon was not detected in any of the samples for the comparison)
#Since I am only interested in p values < 0.05, I am only including data with p value < 0.1
#First, melt the df to a format that can be interpreted by ggplot with three columns: the taxon, the group it belongs to, and the p value from the paired t test
DF <- na.omit(read.csv(file = CSVOutputFileName, header = TRUE))
NewTitles <- sub(';c__', paste(';', '
      ', 'c__'), DF[,2])
NewTitles <- sub(';f__', paste(';', '
      ', 'f__'), NewTitles)
DF[,2] <- NewTitles
DF <- filter(DF, DF[,5] < 0.05)
DF[,5]

#Then make the bar plot, with the x axis as taxon, the y axis as p value, and the color as group
#It looks a little weird to have super wide bars wherever only one group had an omitted data point, but I actually like it better that way because it differentiates between NA and a very low p value, which would have extremely different consequences
PlotTitle <- paste(ExperimentID, " ", TaxonLevel, sep = "", collapse = "")
DifferencesPlot <- ggplot(data = DF, aes(x = Taxon, y = Difference, fill = Group)) + 
  geom_bar(position = "dodge", stat = "identity") + 
  theme(axis.text.x = element_text(size = 6, angle = 90, hjust = 1, vjust = 0.5),
        legend.key.size = unit(0.5, "cm"),
        legend.title=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.line.x = element_line(colour = "gray"),
        axis.line.y = element_line(colour = "gray")) + 
  xlab("Taxon") + 
  ylab("% Difference over Time") + 
  ggtitle(PlotTitle)

##Export this plot as jpeg
################################
## Liz Notes:
## Same idea here. I put the figure in a Figures folder.
################################
system("mkdir Figures") ## will print a warning if folder exists, but won't stop code
GGPlotOutputFileName <- paste("Figures/", TaxonLevel, "_", ExperimentID, "_", Group1, "_Days_", Group1Base, "_to_", Group1End, "_vs_", Group2, "_Days_", Group1Base, "_to_", Group1End, ".jpg", sep = "", collapse = "")
ggsave(GGPlotOutputFileName, DifferencesPlot)
