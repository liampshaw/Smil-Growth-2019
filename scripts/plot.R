# Model fits for datasets in Growth (2019), Vaclav Smil
# Citations for individual datasets provided in labels.csv
# Author: Liam Shaw (2023)

# TODO:
# Currently we only fit the four-parameter (symmetrical) logistic examples. Add Gaussian/linear/5-parameter logistic
# Create single summary pdf w/ figures, coefficient tables
# Narrative walkthrough for cases where default fitting approach fails


modelDataset <- function(dataset, output_prefix="output", output_dir="output"){
  # Function to model a given dataset
  # Read in data
  df = read.csv(paste0('data/', dataset, '.csv'), header=T)
  
  # Check the model type required
  if (DATASETS.DF[DATASETS.DF$Dataset==dataset, "Model"]=="Logistic"){
    # Fit a four parameter logistic using SSfpl (stats package)
    model = nls(y~SSfpl(x, A, B, xmid, scal),
                                      df, 
                                      control = list(warnOnly=T)) 
  }
  if (DATASETS.DF[DATASETS.DF$Dataset==dataset, "Model"]=="Linear"){
    # Linear model
    model = lm(y~x,
                df)
  }
  if (DATASETS.DF[DATASETS.DF$Dataset==dataset, "Model"]=="Gaussian"){
    # estimate starting values
    m.0 <- x[which.max(y)]; s.0 <- (max(x)-min(x))/4; b.0 <- min(y); a.0 <- (max(y)-min(y))
    
    model = nls(y ~ k*exp(-1/2*(x-mu)**2/(sigma**2)), 
                df,
                start=list(mu=)) # needs fixing
  }
  
  # Write the coefficients
  write.csv(summary(model)$coef, file=paste0(output_dir, "/coefs/", output_prefix, "_coefs.csv"))
  
    # Plot the raw data
  pdf(paste0(output_dir, "/figs/", output_prefix, '.pdf'), width=7, height=5)
    plot(df$x, df$y, pch=19, 
         xlab=DATASETS.DF[DATASETS.DF$Dataset==dataset, "x"], 
         ylab=DATASETS.DF[DATASETS.DF$Dataset==dataset, "y"],
         main=paste0(dataset, ": ", DATASETS.DF[DATASETS.DF$Dataset==dataset, "Title"]))
    # Add the fit
    x.predictions = seq(min(df$x), max(df$x), (max(df$x)-min(df$x))/100)
    lines(x.predictions, predict(model, 
                                 newdata = data.frame(x=x.predictions)))
    dev.off()
}

# Read in parameter names (have a dictionary file of these)
DATASETS.DF = read.csv('data/datasets.csv', header=T, colClasses = rep("character", 7))

# Run models (for now, only logistic)
for (dataset in DATASETS.DF$Dataset[DATASETS.DF$Model=="Logistic"]){
  print(dataset)
   res = try(modelDataset(dataset, output_prefix=dataset))
   if(inherits(res, "try-error")) # if error, then move onto next iteration
   {
     next
   }
}
