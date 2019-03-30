# Enrichment Analysis Scripts

-----
This repository has the following combined shell/awk/R scripts which can be used for GWAS/peaks/genes enrichment analysis and *P* value calculation.

 * [Bed2GwasCatalogBinomialMod1Ggplot.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#bed2gwascatalogbinomialmod1ggplotsh---runcategoriessh): Analyze GWAS lead SNPs enrichment in given catalogs of the genomic regions.
 * [runcategories.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#bed2gwascatalogbinomialmod1ggplotsh---runcategoriessh): wrappers of running Bed2GwasCatalogBinomialMod1Ggplot.sh with 43 GWAS catalogs.
 * [Genes_overlap_Fisher.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#genes_overlap_fishersh): *Fisher* test for two groups of genes overlapping.
 * [Peaks_overlap_Fisher.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#peaks_overlap_fishersh): *Fisher* test for two groups of peaks overlapping.

> Requirements:
awk, bedtools, R, R packages: ggplot2,wesanderson,directlabels



----

## Bed2GwasCatalogBinomialMod1Ggplot.sh &  runcategories.sh

This script was modified from [Milos' gwasanalytics](https://github.com/milospjanic/gwasanalytics/tree/master/bed2GwasCatalogBinomialMod1Ggplot). It interescts the genomic regions with GWAS lead SNPs and plots fold enrichment and *binomial P* values.

#### Usage
Put Bed2GwasCatalogBinomialMod1Ggplot.sh under your $PATH or edit its PATH in runcategories.sh. The GWAS catalogs can also be added/removed in runcategories.sh

    ./runcategories.sh regions.bed

#### Output

* output.pdf

[More informations](https://github.com/milospjanic/gwasanalytics)



-----
## Genes_overlap_Fisher.sh 
GWAS genes will be used as background.
#### Usage

    ./Genes_overlap_Fisher.sh genelist1.txt genelist2.txt

#### Output

*P* value will be printed.



------
##Peaks_overlap_Fisher.sh

#### Usage

    ./Genes_overlap_Fisher.sh region1.bed region2.bed background.bed

> [ENCODE common open chromation](https://github.com/milospjanic/fisherTestForGenomicOverlapsMilosPjanicMod/blob/master/background.bed.gz) regions are usually used as background.

#### Output

*P* value will be printed.



------


Author [@zhaoshuoxp](https://github.com/zhaoshuoxp)  
Mar 27 2019  

