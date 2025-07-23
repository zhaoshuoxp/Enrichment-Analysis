#!/bin/bash

# Default genome
genome="hg38"
out_prefix=""

# Paths to chrom.sizes
chromsize_hg19='/nfs/baldar/quanyiz/genome/hg19/hg19.chrom.sizes'
chromsize_hg38='/nfs/baldar/quanyiz/genome/hg38/hg38.chrom.sizes'
chromsize_mm10='/nfs/baldar/quanyiz/genome/mm10/mm10.chrom.sizes'

# Print usage
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

# Check input BAM file
bamfile="$1"
if [[ -z "$bamfile" || ! -f "$bamfile" ]]; then
    echo "Error: valid BAM file required."
    usage
fi

# Set output prefix if not provided
if [[ -z "$out_prefix" ]]; then
    out_prefix="${bamfile%.bam}"
fi

# Determine chrom.sizes
case "$genome" in
    hg19) chr_size="$chromsize_hg19" ;;
    hg38) chr_size="$chromsize_hg38" ;;
    mm10) chr_size="$chromsize_mm10" ;;
    *)
        echo "Error: unsupported genome '$genome'. Choose from hg19, hg38, mm10."
        exit 1
        ;;
esac

# Temp bedGraph filenames
pos_bedgraph="alignments.pos.bedGraph"
neg_bedgraph="alignments.neg.bedGraph"

# Generate bedGraph and bigWig
bedtools genomecov -5 -bg -strand + -ibam "$bamfile" | grep ^chr | LC_COLLATE=C sort -k1,1 -k2,2n > "$pos_bedgraph"
bedtools genomecov -5 -bg -strand - -ibam "$bamfile" | grep ^chr | LC_COLLATE=C sort -k1,1 -k2,2n > "$neg_bedgraph"

bedGraphToBigWig "$pos_bedgraph" "$chr_size" "${out_prefix}_pos.bw"
bedGraphToBigWig "$neg_bedgraph" "$chr_size" "${out_prefix}_neg.bw"

# Remove intermediate bedGraph files
rm -f "$pos_bedgraph" "$neg_bedgraph"

echo "Finished: ${out_prefix}_pos.bw and ${out_prefix}_neg.bw generated."
