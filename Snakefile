SAMPLES = [
    "SRR1552445",
    "SRR1552446",
    "SRR1552444",
    "SRR1552447",
    "SRR1552448",
    "SRR1552449",
    "SRR1552450",
    "SRR1552451",
    "SRR1552452",
    "SRR1552453",
    "SRR1552454",
    "SRR1552455",
]

rule all:
    input:
        expand("qc_results/{sample}_fastqc.html", sample=SAMPLES),
        "multi_report/multiqc_report.html",
        expand("trimmed_reads/{sample}_trimmed.fastq.gz", sample=SAMPLES),
        expand("qc_results_after_trimming/{sample}_trimmed_fastqc.html", sample=SAMPLES),
        "multi_report_after_trimming/multiqc_report.html",
        expand("bowtie2_aligned/{sample}.sam", sample=SAMPLES),
        expand("sorted/{sample}.bam", sample=SAMPLES),        
        expand("feature_counts/{sample}_counts.txt", sample=SAMPLES)

rule qc_control:
    input:
        "reads/{sample}.fastq.gz"
    output:
        "qc_results/{sample}_fastqc.html"
    shell:
        "fastqc -t 1 {input} -o qc_results/"

rule multiqc:
    input:
        expand("qc_results/{sample}_fastqc.html", sample=SAMPLES)
    output:
        "multi_report/multiqc_report.html"
    conda:
        "multiqc_env.yaml"
    shell:
        "multiqc qc_results/ -o multi_report/"

rule trimming:
    input:
        "reads/{sample}.fastq.gz"
    output:
        "trimmed_reads/{sample}_trimmed.fastq.gz"
    conda:
        "fastp_env.yaml"
    shell:
        """
        fastp \
            -i {input} \
            -o {output} \
            -w 1 \
            -q 30 \
            -l 30 \
            --trim_poly_g 
        """

rule qc_trimmed:
    input:
        "trimmed_reads/{sample}_trimmed.fastq.gz"
    output:
        "qc_results_after_trimming/{sample}_trimmed_fastqc.html"
    shell:
        "fastqc -t 1 {input} -o qc_results_after_trimming/"

rule multiqc_after_trimming:
    input:
        expand("qc_results_after_trimming/{sample}_trimmed_fastqc.html", sample=SAMPLES)
    output:
        "multi_report_after_trimming/multiqc_report.html"
    conda:
        "multiqc_env.yaml"
    shell:
        "multiqc qc_results_after_trimming/ -o multi_report_after_trimming/"

rule alignment:
    input:
        reads = "trimmed_reads/{sample}_trimmed.fastq.gz",
    output:
        sam = "bowtie2_aligned/{sample}.sam"
    params:
        index = "index_files/mm10"
    conda:
        "bowtie2_env.yaml"
    shell:
        """
        bowtie2 -x {params.index} -U {input.reads} -p 1 -S {output.sam}
        """

rule sam_to_bam:
    input: 
        sam = "bowtie2_aligned/{sample}.sam"
    output:
        bam = "sorted/{sample}.bam"
    conda:
        "bowtie2_env.yaml"
    shell:
        "samtools view -Sb {input.sam} | samtools sort -o {output.bam}"

rule feature_counts:
    input:
        bam = "sorted/{sample}.bam",
        gtf = "reference/mm10.refGene.gtf"
    output:
        counts = "feature_counts/{sample}_counts.txt"
    conda:
        "feature_counts.yaml"
    shell:
        "featureCounts -a {input.gtf} -o {output.counts} {input.bam}"