#!/usr/bin/env bash

fasta_contigs  = $1
fastq_reads_ec = $2
fn=$(basename fasta_contigs)
bn="${fasta_contigs%.*}"
bwa_out=${bn}_bwa_out
sambamba_out=${bn}_reads.ref.bam
vcf_out=${bn}_reads.ref.vcf

bwa mem -t8 fasta_contigs fastq_reads_ec > $bwa_out
sambamba view -t8 -S -f bam -o /dev/stdout $bwa_out |sambamba sort -t8 -o $sambamba_out /dev/stdin
samtools mpileup $sambamba_out |bcftools view -vg - > $vcf_out