Intention: make this bundle available on a data repository (zenodo, figshare) and/or via my website for teaching

I have made plain csvs of all datasets and made a summary of each dataset using figure captions from book and harmonised x/y axis labels and titles. Code automatically produces coefficient tables and plots for logistic fits.

Not yet done: Chapter 5

A few small things I noticed while going through: 
* I noticed for 1.17 on Mozart compositions - my favourite example of dangers of using a good historical fit for prediction - that 1.17.2 has one additional data point (1791) compared to 1.17.3 and 1.17.4. It doesn't matter but just so you know. 
* R's automatic non-linear least-squares fitting fails for 4.6.1, 4.7, 4.19, 4.28 - because they are such early stage of logistic i.e. exponential. I presume when you fit with mycurvefit.com you input some estimated parameters to get it to work? (I haven't used that site before but tried now and found for e.g. 4.28 it does not succeed for five-parameter logistic on its own). I think these are a good example of perils of automatic fits; I would usually model them with lm(log(y) ~ x) and/or transform axes to more manageable numbers for fitting. 
* 6.8.xlsx I think corresponds to Figure 6.9 in my edition

I will add (probably next week):
* I have it set up to automatically fit models for the four-parameter logistic cases. I will add handling of linear/Gaussian/asymmetrical (five-parameter) logistic. 
* Improve figure presentation - maybe produce a single pdf with all figures with captions as in book, coefficient tables, page refs, data citations. 
Proper code walkthrough / demonstration of how to fit cases where default method fails. 



