# Snakemake-Tutorial-Mouse-RNA-seq-Workflow

📦 Description

This repository contains a Snakemake-based workflow for practicing reproducible and modular RNA-seq analysis using publicly available mouse mammary gland data.

🐭 Dataset

The input data consists of RNA-seq FASTQ files from the GEO dataset GSE60450, which profiles gene expression in mouse mammary gland cells.

🔗 Direct download (Figshare): https://figshare.com/s/f5d63d8c265a05618137
Data set Source : https://bioinformatics-core-shared-training.github.io/RNAseq-R/align-and-count.nb.html (the data available on kaggle too)

Pre-built indices for alignment step were downloaded from https://benlangmead.github.io/aws-indexes/bowtie

The reference mm10 genome downloaded from https://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/genes/

📋 Workflow Overview

The Snakemake workflow includes the following steps:

Quality Control with FastQC and summary with MultiQC

Adapter and quality trimming with Fastp

Alignment to the mouse genome (mm10) using Bowtie2

Conversion and sorting of SAM to BAM files using Samtools

Strandedness checking with RSeQC

Gene-level quantification using featureCounts


