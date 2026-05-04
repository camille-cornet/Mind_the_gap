#!/usr/bin/env bash
# depth.bash – PanDepth per sample con throttling

#set -euo pipefail

# === Parametri ===
SAMPLE_LIST=${1:?Uso: $0 sample_list.txt lane_list.txt threads [max_jobs]}
LANE_LIST=${2:?Uso: $0 sample_list.txt lane_list.txt threads [max_jobs]}
HC_THREADS=${3:-4}         # thread per PanDepth (-t)
MAX_JOBS=${4:-20}          # max job concorrenti

# (opzionale) calcolo automatico per non over-commit (112 core totali)
#AUTO=$(( 112 / HC_THREADS )); [[ $AUTO -lt $MAX_JOBS ]] && MAX_JOBS=$AUTO

# === Reference paths ===
CHROM_REF="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/chrom/GCF_963924715.1_fThuThy2.1_genomic.fna.masked"
DRAFT_REF="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/draft/GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna"

# === Binari ===
PAND="/home/PERSONALE/piergiorgio.massa2/PanDepth/bin/pandepth"

mkdir -p log pandepth

# Throttling dei job in background
throttle() {
  while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
    wait -n || true
  done
}

for REF_TYPE in draft chrom; do
  case "$REF_TYPE" in
    chrom) REF="$CHROM_REF" ;;
    draft) REF="$DRAFT_REF" ;;
    *) echo "REF_TYPE sconosciuto: $REF_TYPE" >&2; exit 1 ;;
  esac

  while IFS= read -r LANE || [[ -n "${LANE:-}" ]]; do
    [[ -z "$LANE" ]] && continue

    INDIR="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/dedup/$REF_TYPE/$LANE"
    OUTDIR="pandepth/$REF_TYPE/$LANE"
    mkdir -p "$OUTDIR"

    # === PanDepth per tutti i sample (con throttling) ===
    while IFS= read -r SAMPLE || [[ -n "${SAMPLE:-}" ]]; do
      [[ -z "$SAMPLE" ]] && continue

      BAM="$INDIR/${SAMPLE}.dedup.bam"
      LOG="log/${SAMPLE}.${LANE}.${REF_TYPE}.pandepth.oe"

      if [[ ! -s "$BAM" ]]; then
        echo "[WARN] BAM mancante: $BAM — salto" | tee -a "$LOG"
        continue
      fi

      throttle
      "$PAND" -i "$BAM" -o "$OUTDIR/${SAMPLE}" -r "$REF" -t "$HC_THREADS" &> "$LOG" &
    done < "$SAMPLE_LIST"

    # aspetta che finiscano tutti i pandepth di questa LANE
    wait
  done < "$LANE_LIST"
done

# fine

