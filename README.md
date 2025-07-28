# Enrichment Analysis Scripts

-----
This repository has the following combined shell/awk/R scripts which can be used for GWAS/peaks/genes enrichment analysis and *P* value calculation.

 * [gwasLD.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#gwasLDsh): Analyze GWAS lead SNPs High LD enrichment with given SNPs list .
 * [Genes_overlap_Fisher.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#genes_overlap_fishersh): *Fisher* test for two groups of genes overlapping.
 * [Peaks_overlap_Fisher.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#peaks_overlap_fishersh): *Fisher* test for two groups of peaks overlapping.
 * [split_bw_by_strand.sh](https://github.com/zhaoshuoxp/Enrichment-Analysis#split_bw_by_strandsh): Generate strand-specific BigWig from a BAM file.

> Requirements:
awk, bedtools, bedGraphToBigWig, plink, Python3, Python packages: LDDirection, dbSNP, plink, Cython, R, R packages: ggplot2,wesanderson,directlabels

[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu) [![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

----

## gwasLD.sh

This script requires [LDDirection](https://github.com/MikeDacre/LDDirection) for LD calculation. 

#### Input

SNPs, a rsID per line.

#### Usage

Modify line4 for the GWAS catalog with rsID file. Line5 for population, line6 for maximum distance of the two SNP pair, and line 7 for R-square cutoff (0.2 minimal).

```
./gwasLD.sh SNP.txt
```

#### Output

- SNP_bar.png



-----
## Genes_overlap_Fisher.sh 
GWAS genes will be used as background.
#### Usage

    ./Genes_overlap_Fisher.sh genelist1.txt genelist2.txt

#### Output

*P* value will be printed.



------
 ## Peaks_overlap_Fisher.sh

#### Usage

    ./Genes_overlap_Fisher.sh region1.bed region2.bed background.bed

> [ENCODE common open chromation](https://github.com/milospjanic/fisherTestForGenomicOverlapsMilosPjanicMod/blob/master/background.bed.gz) regions are usually used as background.

#### Output

*P* value will be printed.



------

 ## split_bw_by_strand.sh

#### Usage

    split_bw_by_strand.sh -g hg38 -o test test.bam

------

Author [@zhaoshuoxp](https://github.com/zhaoshuoxp)  
Mar 27 2019  

