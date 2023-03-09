This repository contains data and code for 80 datasets featured in *Growth: from microorganisms to megacities* (2009) by Vaclav Smil. 

The analysis can be run using `scripts/run-fits.R`. Fits are performed with the custom function `modelDataset` in `scripts/functions.R` which applies a fitting approach depending on the model and saves model coefficients to `outputs/coefs` and a plot to `output/figs`.

| Model 		| No. of datasets| 
| ---			| ---|
| Logistic 		| 55|
| Gaussian 		| 8 |
| Quartic 		| 7 |
| Exponential		| 5 |
| Linear		| 1 | 
| Quadratic 		| 1| 
| Asymmetrical logistic | 1 |

N.B. asymmetrical logistic not yet fitted.

