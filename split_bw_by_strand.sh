#!/bin/bash

# Default genome
genome="hg38"
out_prefix=""

# Paths to chrom.sizes
chromsize_hg19='/nfs/baldar/quanyiz/genome/hg19/hg19.chrom.sizes'
chromsize_hg38='/nfs/baldar/quanyiz/genome/hg38/hg38.chrom.sizes'
chromsize_mm10='/nfs/baldar/quanyiz/genome/mm10/mm10.chrom.sizes'

# Usage
usage() {
    echo "Usage: $0 [-g genome: hg19|hg38|mm10] [-o output_prefix] <input.bam>"
    exit 1
}

# Parse options
while getopts "g:o:" opt; do
    case $opt in
        g) genome="$OPTARG" ;;
        o) out_prefix="$OPTARG" ;;
        *) usage ;;
    esac
done
shift $((OPTIND -1))

# Check input BAM
bamfile="$1"
if [[ -z "$bamfile" || ! -f "$bamfile" ]]; then
    echo "Error: valid BAM file required."
    usage
fi

# Set prefix
[[ -z "$out_prefix" ]] && out_prefix="${bamfile%.bam}"

# Determine chr size
case "$genome" in
    hg19) chr_size="$chromsize_hg19" ;;
    hg38) chr_size="$chromsize_hg38" ;;
    mm10) chr_size="$chromsize_mm10" ;;
    *) echo "Unsupported genome '$genome'"; exit 1 ;;
esac

# Prepare chrom list
chrom_list=$(mktemp)
cut -f1 "$chr_size" > "$chrom_list"

# Temp bedGraphs
pos_bedgraph=$(mktemp --suffix=.pos.bedGraph)
neg_bedgraph=$(mktemp --suffix=.neg.bedGraph)

# Run
bedtools genomecov -5 -bg -strand + -ibam "$bamfile" | grep -F -w -f "$chrom_list" | LC_COLLATE=C sort -k1,1 -k2,2n > "$pos_bedgraph"
bedtools genomecov -5 -bg -strand - -ibam "$bamfile" | grep -F -w -f "$chrom_list" | LC_COLLATE=C sort -k1,1 -k2,2n > "$neg_bedgraph"

bedGraphToBigWig "$pos_bedgraph" "$chr_size" "${out_prefix}_pos.bw"
bedGraphToBigWig "$neg_bedgraph" "$chr_size" "${out_prefix}_neg.bw"

# Cleanup
rm -f "$pos_bedgraph" "$neg_bedgraph" "$chrom_list"

echo "Finished: ${out_prefix}_pos.bw and ${out_prefix}_neg.bw generated."
