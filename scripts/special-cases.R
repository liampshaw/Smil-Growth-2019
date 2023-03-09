# Read in parameter names (have a dictionary file of these)
DATASETS.DF = read.csv('data/datasets.csv', header=T, colClasses = c(rep("character", 6),
                                                                     rep("numeric", 4),
                                                                     rep("character", 4)))

# Investigate special cases one-by-one
dataset = "4.28"
output_prefix = "4.28"
df = read.csv(paste0('data/', dataset, '.csv'), header=T)
MODEL = DATASETS.DF[DATASETS.DF$Dataset==dataset, "Model"]

# Model is logistic
model = nls(y~SSfpl(x, A, B, xmid, scal),
            df,
            control=list(maxiter=100),
            start=list(A=0, B=900,xmid=2020, scal=1.5))
x.limits = c(DATASETS.DF[DATASETS.DF$Dataset==dataset, "xmin"],
             DATASETS.DF[DATASETS.DF$Dataset==dataset, "xmax"])
y.limits = c(DATASETS.DF[DATASETS.DF$Dataset==dataset, "ymin"],
             DATASETS.DF[DATASETS.DF$Dataset==dataset, "ymax"])
x.predictions = seq(x.limits[1], x.limits[2], (x.limits[2]-x.limits[1])/100)
y.predictions = predict(model,newdata = data.frame(x=x.predictions))

df.predict = data.frame(x=x.predictions, 
                        y=y.predictions)
# 5.5
dataset = "5.5"
output_prefix = "5.5"
df = read.csv(paste0('data/', dataset, '.csv'), header=T)

df$x = as.numeric(df$x)
df$x.small = df$x/1000

MODEL = DATASETS.DF[DATASETS.DF$Dataset==dataset, "Model"]

# Model is logistic
model = nls(y~SSfpl(x, A, B, xmid, scal),
            df,
            control=list(minFactor=1e-10))
# Doesn't work
# So we need to try a different form
# We can fit exponential model as linear
exp.model = lm(log(y)~x, df)
# Works fine

# SSfpl formula is
# A+(B-A)/(1+exp((xmid-input)/scal))
# y = L/(1+exp(-k[x-x0]))
# log(y) = log(L) - log(1+exp())
# Maybe we can scale so y is between 0 and 1?
df$y.scal = 0.5*df$y/max(df$y)
# And so x is centred around zero
df$x.scal = df$x -2015
model = nls(y ~ SSfpl(x, A, B, xmid, scal),
    df, start=list(A=0,
                   B=10,
                  xmid=2015,
                   scal=50))
# The choice of scal really matters
# scal=1 fails as starting estimate due to singular gradient
# scal=100 fails because of step factor reduced below minFactor

x.limits = c(DATASETS.DF[DATASETS.DF$Dataset==dataset, "xmin"],
             DATASETS.DF[DATASETS.DF$Dataset==dataset, "xmax"])
y.limits = c(DATASETS.DF[DATASETS.DF$Dataset==dataset, "ymin"],
             DATASETS.DF[DATASETS.DF$Dataset==dataset, "ymax"])
x.predictions = seq(x.limits[1], x.limits[2], (x.limits[2]-x.limits[1])/100)
y.predictions = predict(model,newdata = data.frame(x=x.predictions))

df.predict = data.frame(x=x.predictions, 
                        y=y.predictions)
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


# 5.29.4
# Investigate special cases one-by-one
dataset = "5.29.4"
output_prefix = "5.29.4"
df = read.csv(paste0('data/', dataset, '.csv'), header=T)
nls(y ~ SSfpl(x, A, B, xmid, scal),
    df, start=list(A=0,
                   B=100000,
                   xmid=2010,
                   scal=10))

# 5.30.3
dataset = "5.30.3"
output_prefix = "5.30.3"
df = read.csv(paste0('data/', dataset, '.csv'), header=T)
plot(df$x, df$y)
nls(y ~ SSfpl(x, A, B, xmid, scal),
    df, start=list(A=0,
                   B=20,
                   xmid=2000,
                   scal=5))
plot(seq(1950, 2100), f(seq(1950, 2100), 0, 20, 2000, 5))

# 1.17.2
# asymmetrical logistic]
# mycurvefit formula:
# y = 403.7003 + (-0.7670739 - 403.7003)/(1 + (x/1774.296)^560.36)^1.049668
# y = d + (a-d)/(1+(x/c)**b)**m
#

# mycurvefit for symmetrical logistic has
# y = d + (a-d)/(1+(x/c)**b)
# compare to
# y = A+(B-A)/(1+exp((xmid-x)/scal)
# so:
# d -> A
# a -> B
# (x/c)**b -> exp(xmid-x)/scal
# i.e. we just add an extra exponent for the denominator
asymmetricalLogistic <- function(x,A, B, xmid, scal, m) {A+(B-A)/(1+exp((xmid-x)/scal))**m}
dataset = "1.17.2"
output_prefix = "1.17.2"
df = read.csv(paste0('data/', dataset, '.csv'), header=T)

plot(df$x, df$y)
lines(seq(1760, 1850), asymmetricalLogistic(seq(1760, 1850),
                                           0, 650, 1780, 6, 0.95))


# first: fit symmetrical logistic
model.symm = nls(y ~ SSfpl(x, A, B, xmid, scal), df)
coef(model.symm)
# use these as starting params
plot(df$x, df$y, xlim=c(1760, 1850), ylim=c(0,1000))
lines(seq(1760, 1850), asymmetricalLogistic(seq(1760, 1850),
                                            -73, 763,1779, 7, 1))

nls(y ~ asymmetricalLogistic(x, A, B, xmid, scal, m),
    df, start=list(A=-73,
                   B=763,
                   xmid=1779,
                   scal=7,
                   m=1),
    control=list(tol=3))
# After looking at the values it ends up with...
plot(df$x, df$y, xlim=c(1760, 1850), ylim=c(0,1000))
lines(seq(1760, 1850), asymmetricalLogistic(seq(1760, 1850),
                                            -16, 891, 1685, 11.7, 2720.8))
