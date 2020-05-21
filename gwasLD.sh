#!/bin/bash
#####################################

gwas_catalog_snp='/home/quanyi/dbSNP150/gwas_rsid.txt'
populations="CEU"
distance='100kb'
r2=0.01

gwas=("Bipolar_disorder" "Schizophrenia" "Atherosclerosis"  "Ulcerative_colitis" "Coronary_Heart" "Type_2_diabetes" "Body_mass_index" "Multiple_sclerosis" "Breast_cancer" "Asthma" "Triglycerides" "LDL_cholesterol" "Blood_pressure" "Coronary_Artery" "Coronary_artery_calcification" "Prostate_cancer" "Diastolic_blood_pressure" "Hypertension" "HDL_cholesterol" "QRS_duration" "Primary_biliary_cirrhosis" "BMI" "Type_1_diabetes" "Longevity"  "Lipid_metabolism_phenotypes" "Kawasaki_disease" "Pancreatic_cancer" "Celiac_disease" "Lupus" "Myocardial_infarction" "Insulin_resistance" "Fasting_plasma_glucose" "Menarche" "CardiogramplusC4D") #"Inflammatory_biomarkers" "Liver_enzyme_levels"

input=$(basename $1 .txt)
ldlists preprocess $1 ${input}.lookup

#touch ${input}.ld
touch ${input}.ldr.8
mkdir gwas_raw_ld

for i in ${gwas[@]};do
    grep -i $i $gwas_catalog_snp > ${i}.txt
    cut -f1 ${i}.txt|cut -f1 -d';' |grep -v chr|grep -v _ > ${i}.txt1
    ldlists preprocess ${i}.txt1 ${i}.lookup
    ldlists analyze --r2 $r2 --distance $distance --populations $populations ${input}.lookup ${i}.lookup ${i}.ld
    awk '$11>0.8' ${i}.ld > ${i}.ldr.pre.8
    awk 'NR==FNR{a[$1]}NR>FNR{if ($2 in a ||$5 in a){print $0}}' {i}.lookup ${i}.ldr.pre.8 ${i}.ldr.8
    #awk -v OFS="\t" '{print $11,"'"$i"'""}' ${i}.ld |sed '1d' >>${input}.ld
    num_r8=$(cut -f5 ${i}.ldr.8|sort -u| wc -l|awk '{print $1}')
    total=$(wc -l ${i}.lookup|awk '{print $1}')
    #total_dis=$(wc -l ${i}.ld|awk '{print $1}')
    echo -e "$num_r8\t$total\t$i" >>${input}.ldr.8
    #echo -e "$num_r8\t$total\t$total_dis\t$pre" >>${input}.ldr.8
    mv ${i}.* gwas_raw_ld
done

awk -v OFS="\t" '{print $1/$2, $3}' ${input}.ldr.8 |sort -k1,1n > ${input}.ld.8.ratio


cat >plot.R<<-EOF
#!/usr/bin/env Rscript
library("ggplot2")
options<-commandArgs(trailingOnly = T)
png_name<-unlist(strsplit(options[1],'.',fixed=T))[1]

ratio<-read.table(file=options[1],header=F)
ratio\$V2<-factor(ratio\$V2 , levels = ratio\$V2)
#box<-read.table(file=options[2],header=F)

ratio<-ggplot(ratio,aes(x=V2,y=V1,fill=V2))+
    geom_bar(stat='identity')+
    coord_flip()+
    theme(
        legend.position = "none",
        axis.text.y = element_text(size=8,colour = 'black'),
        axis.title.y = element_text(size=12,colour = 'black'),
        axis.text.x = element_text(size=8,colour = 'black'),
        axis.title.x = element_text(size=10,colour = 'black'))+
    xlab("GWAS catalog")+ylab(expression(paste("R"^2,">0.8 Portion")))
    
png(file=paste(png_name,'_bar.png',sep=''),height = 4, width = 4, res=600, units = "in", family="Arial")
ratio
dev.off()

#box<-ggplot(box,aes(x=V2,y=V1,fill=V2))+
#    geom_boxplot(outlier.colour = NA,notch = F)+
#    ylim(c(0,1.2))+
#    theme(
#        legend.position = "none",
#        axis.text.y = element_text(size=8,colour = 'black'),
#        axis.title.y = element_text(size=12,colour = 'black'),
#        axis.text.x = element_text(size=8,colour = 'black',angle = 45, hjust=1),
#        axis.title.x = element_text(size=10,colour = 'black',))+
#    xlab("GWAS catalog")+ylab(expression("Linkage Disequilibrium-R"^2))
#    
#png(file=paste(png_name,'_box.png',sep=''),height = 4, width = 8, res=600, units = "in", family="Arial")
#box
#dev.off()    
EOF

chmod 755 plot.R
./plot.R ${input}.ld.8.ratio #${input}.ld

mv plot.R gwas_raw_ld
mv ${input}.ldr.8 gwas_raw_ld
mv ${input}.ld.8.ratio gwas_raw_ld
#mv ${input}.ld gwas_raw_ld
mv ${input}.lookup gwas_raw_ld
################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################