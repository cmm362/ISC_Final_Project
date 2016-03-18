ISC_Final_Project

My research involves comparing the composition of the gut microbiota between mice and looking for relationships between the composition of the gut microbiota and systemic immune responses. This involves sending DNA isolates from mouse feces to Argonne National Lab, where 16S Ribosomal Sequencing is performed, resulting in a measure of the abundance of each species as a percentage of all bacteria in the fecal sample. Typically, I give my labmate a plate filled  with DNA isolates from many different mice, with each sample labeled with a simple ID number that I come up with.  He then compiles my samples with those of multiple other people in our lab to send to Argonne. He gives each sample his own ID number and when I receive a csv file with the sequencing data, I go back through all of his data labels and try to match them with the experiment number, treatment, mouse and time points corresponding with each sample. I then compare the abundance of each species between two time points for the treatment group of interest and compare the changes I see over time between different treatment groups. I run a paired T test to determine the significance of each change and then plot the percent different in abundance over time in each group I am comparing. Before, it took me hours to find and arrange my data and analyze it in Excel. Using my final project, I can re-label all of my samples in a convenient way, filter out other peoples' samples, extract a csv with the % differences for each group I am interested in, and then make a  plot showing the percent difference for all statistically significant changes with each treatment group, and I can do all of that in less than a minute by typing in some simple input about the specific experiment, treatment groups, taxonomic level, and timepoints that I want to compare.

The packages that need to be installed are: ggplot2, dplyr and reshape
I chose not to include the installation in the code because it only needs to happen once per session and I tend to run the code multiple times in a row

Before running the code, please download the folder containing data files for taxonomic levels 2-6 under your "Documents" folder. The folders will allow the correct path so that all of the code will work on your computer.

Then run the code in R.

The code asks for user input. One sample set of parameters that should work are:
Folder containing sequencing submission: 09012015 Submission
Taxon Level (L2-L6): L6
Experiment (CM___): CM002.2
Group 1 (control): Control
Group 2 (control): Treatment
Baseline timepoint (numerical) for Group 1: 0
Baseline timepoint (numerical) for Group 2: 0
End timepoint (numerical) for Group 1: 7
End timepoint (numerical) for Group 2: 7
#The plot and csv generated will be put in the "ROutput" Folder"

