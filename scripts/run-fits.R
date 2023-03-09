# Model fits for datasets in Growth (2019), Vaclav Smil
# Citations for individual datasets provided in labels.csv
# Author: Liam Shaw (2023)
library(ggplot2)

set.seed(20230309)
source('scripts/functions.R')

# Read in parameter names (effectively a dictionary file with info on each figure/dataset)
DATASETS.DF = read.csv('data/datasets.csv', header=T, colClasses = c(rep("character", 6),
                                                                     rep("numeric", 4),
                                                                     rep("character", 4)))

# Run models 
for (dataset in DATASETS.DF$Dataset[DATASETS.DF$Parent.figure!="yes"]){
  if (dataset %in% DATASETS.DF$Dataset[(DATASETS.DF$Model=="Logistic" | DATASETS.DF$Model=="Linear" | DATASETS.DF$Model=="Quadratic" | DATASETS.DF$Model=="Gaussian" | DATASETS.DF$Model=="Quartic" | DATASETS.DF$Model=="Exponential") & DATASETS.DF$Parent.figure!="yes"]){
    print(dataset)
    res = try(modelDataset(dataset, output_prefix=dataset))
    if(inherits(res, "try-error")) # if error, then move onto next iteration
    {
      next
    }
    assign(paste0("p.", dataset), res)
  }
  else{
    print(paste0("Not run: ", dataset))
  }
}

# SPECIAL CASES
# Rerun three problematic cases with starting estimates
# Here I have messed around with starting parameters
# by plotting the data and using knowledge of logistic function:
# see scripts/special-cases.R

# 5.5
p.5.5 = modelDataset("5.5",
             output_prefix="5.5", 
             starting_parameter_estimates = list(A=0, 
                                                 B=40, 
                                                 xmid=2100, 
                                                 scal=50))
# 5.29.4
p.5.29.4 = modelDataset("5.29.4",
             output_prefix="5.29.4", 
             starting_parameter_estimates = list(A=0,
                                                 B=100000,
                                                 xmid=2010,
                                                 scal=10))

# 5.30.3
p.5.30.3 = modelDataset("5.30.3",
             output_prefix="5.30.3", 
             starting_parameter_estimates =list(A=0,
                                                B=20,
                                                xmid=2000,
                                                scal=5))