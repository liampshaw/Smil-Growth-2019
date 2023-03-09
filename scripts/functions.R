theme_basic <- function () { 
  theme_bw(base_size=10) %+replace% 
    theme(
      axis.text=element_text(colour="black")
    ) %+replace% 
    theme(
      panel.grid=element_blank(),
      plot.margin = unit(c(1,1,1,1),units="cm"),
      axis.text=element_text(size=10),
      title=element_text(size=10),
      axis.title=element_text(size=12),
      panel.border = element_blank(),
      axis.line=element_line(colour="black")
    )
}

modelDataset <- function(dataset, 
                         output_prefix="output", 
                         output_dir="output",
                         starting_parameter_estimates=NULL){
  # Function to model a given dataset
  # Read in data
  df = read.csv(paste0('data/', dataset, '.csv'), header=T)
  
  MODEL = DATASETS.DF[DATASETS.DF$Dataset==dataset, "Model"]
  
  # Check the model type required
  if (MODEL=="Logistic"){
    # Fit a four parameter logistic using SSfpl (stats package)
    if (!is.null(starting_parameter_estimates)){
      model = nls(y~SSfpl(x, A, B, xmid, scal),
                  df, 
                  start=starting_parameter_estimates,
                  control = list(warnOnly=T))
    }
    else{
      model = nls(y~SSfpl(x, A, B, xmid, scal),
                  df, 
                  control = list(warnOnly=T))
    }
  }
  if (MODEL=="Linear"){
    # Linear model
    model = lm(y~x,
               df)
  }
  if (MODEL=="Quadratic"){
    # Linear model
    model = lm(y~poly(x, degree=2),
               df)
  }
  if (MODEL=="Quartic"){
    # Linear model
    model = lm(y~poly(x, degree=4),
               df)
  }
  if (MODEL=="Gaussian"){
    # estimate starting values
    x = df$x
    y = df$y
    m.0 <- x[which.max(y)]; s.0 <- (max(x)-min(x))/4; a.0 <- (max(y)-min(y))
    
    model = nls(y ~ k*exp(-1/2*(x-mu)**2/(sigma**2)), 
                df,
                start=list(mu=m.0, sigma=s.0, k=a.0)) # three-parameters
  }
  if (MODEL=="Exponential"){
    # estimate starting values
    x = df$x
    y = df$y
    model = lm(log(y)~x) # fit log(y) to x since easier than y ~ exp(x)
  }
  
  # Predictions
  # Add the fit
  x.limits = c(DATASETS.DF[DATASETS.DF$Dataset==dataset, "xmin"],
               DATASETS.DF[DATASETS.DF$Dataset==dataset, "xmax"])
  y.limits = c(DATASETS.DF[DATASETS.DF$Dataset==dataset, "ymin"],
               DATASETS.DF[DATASETS.DF$Dataset==dataset, "ymax"])
  x.predictions = seq(x.limits[1], x.limits[2], (x.limits[2]-x.limits[1])/100)
  y.predictions = predict(model,newdata = data.frame(x=x.predictions))
  if (MODEL=="Exponential"){ # adjust if exponential fit
    y.predictions = exp(y.predictions)
  }
  
  df.predict = data.frame(x=x.predictions, 
                          y=y.predictions)
  
  # Write the coefficients
  write.csv(summary(model)$coef, file=paste0(output_dir, "/coefs/", output_prefix, "_coefs.csv"))
  
  # Plot the raw data
  pdf(paste0(output_dir, "/figs/", output_prefix, '.pdf'), width=7, height=5)
  plot(df$x, df$y, pch=19, 
       xlab=DATASETS.DF[DATASETS.DF$Dataset==dataset, "x"], 
       ylab=DATASETS.DF[DATASETS.DF$Dataset==dataset, "y"],
       main=paste0(dataset, ": ", DATASETS.DF[DATASETS.DF$Dataset==dataset, "Title"]))
  
  lines(df.predict$x, df.predict$y)
  dev.off()
  
  p = ggplot(df, aes(x, y), pch=19)+
    geom_point()+
    xlab(DATASETS.DF[DATASETS.DF$Dataset==dataset, "x"])+
    ylab(DATASETS.DF[DATASETS.DF$Dataset==dataset, "y"])+
    scale_y_continuous(limits=y.limits, n.breaks=10, breaks=waiver())+
    scale_x_continuous(n.breaks=10, breaks=waiver(), limits=x.limits)
  p = p + geom_line(data=df.predict)+
    theme_basic()
  p.final = p+ggtitle(paste0(dataset, " ", DATASETS.DF[DATASETS.DF$Dataset==dataset, "Title"], 
                             "\nModel: ", MODEL))
  ggsave(file=paste0(output_dir, "/figs-ggplot/", output_prefix, '.pdf'), width=7, height=5,
         p.final)
  return(p.final)
}
