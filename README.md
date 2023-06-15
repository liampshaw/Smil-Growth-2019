This repository contains data and code for 80 datasets featured in [*Growth: from microorganisms to megacities*](https://mitpress.mit.edu/9780262539685/growth/) (2019) by Vaclav Smil. 

*Growth* contains a wealth of time-series data collected from diverse sources. Smil fits simple models, most notably the [logistic function](https://en.wikipedia.org/wiki/Logistic_function), to demonstrate how widely applicable they are: from the growth of bacteria to the expansion of rail networks.  

This archive intends to make these datasets available for wider use in statistics teaching. Whatever your interest, there is probably a dataset in here for you!  

Thanks to Vaclav Smil for sharing these datasets to make this reanalysis possible. 

## Details

### Datasets

The datasets in `data` are named according to their figure labels in the book itself e.g. `data/1.13.csv` is a csv file corresponding to the raw data points in Figure 1.13. All datasets have named columns `x` and `y`. Metadata about the datasets (i.e. what the numbers actually relate to) are available in `data/datasets.csv`.  

### Output

The raw data points and the fitted models are all included in `fits.pdf` together with the legends as in the original book. This is intended to help with choosing a dataset to reuse.  

### Reproducing the results

The analysis can be run using `scripts/run-fits.R`. Fits are performed with the custom function `modelDataset` in `scripts/functions.R` which applies a fitting approach depending on the model and saves model coefficients to `outputs/coefs` and a plot to `output/figs`.

The models fitted include logistic (n=55), gaussian (n=8), quartic (n=7), exponential (n=5), linear (n=1), and quadratic (n=1).

The reanalysis scripts can be run with

```
Rscript scripts/run-fits.R
```

The pdf output can then be made with:

```
python scripts/makeLatex.py > latex/results.tex
xelatex latex/results.tex
```

The results of the fits are then in 


## Warning 

**Disclaimer**: this reanalysis is my own work. The results will not exactly reproduce the figures or values in Smil (2019). In particular, I  am aware of the following issues with some of the fits:

* 1.17.2 - no fit available. I am not aware of an easy off-the-shelf way to fit an asymmetrical logistic in R (not a model I have ever used    and not aware of an implementation). I attempted to fit my own specification of model but it was very slow and didn't seem to be converging.
* 4.13 - the fit fails completely. I think since here I am fitting a logistic but should probably try exponential.
* 4.19 - Smil fits logistic but I fit an exponential since the process seems in such early stages of growth, but the fit looks bad.
* 4.28 - ditto the above.
* 5.11 - the logistic fit looks very poor.
