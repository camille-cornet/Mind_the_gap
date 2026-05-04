#!/bin/bash
# Uso: bash merge_lanes.bash [threads]
# default: 8 thread

THREADS=${1:-8}
SAMPLE_LIST=sample_list.txt
LANE_LIST=lane_list.txt

OUTDIR="bammerged"
mkdir -p "$OUTDIR"

# prendo le lane escludendo eventualmente una voce "merged"
mapfile -t LANES < <(grep -v '^merged$' "$LANE_LIST")

while read -r SAMPLE; do
  [ -z "$SAMPLE" ] && continue

  BAM_ARRAY=()

  for LANE in "${LANES[@]}"; do
    BAM="${LANE}/${SAMPLE}.sorted.bam"
    if [ -s "$BAM" ]; then
      BAM_ARRAY+=("$BAM")
    fi
  done

  if [ ${#BAM_ARRAY[@]} -eq 0 ]; then
    echo "[WARN] Nessun BAM trovato per sample $SAMPLE, salto" >&2
    continue
  fi

  OUT_BAM="${OUTDIR}/${SAMPLE}.bammerged.bam"

  if [ ${#BAM_ARRAY[@]} -eq 1 ]; then
    echo "[INFO] Solo una lane per $SAMPLE, copio ${BAM_ARRAY[0]} → $OUT_BAM"
    cp "${BAM_ARRAY[0]}" "$OUT_BAM"
  else
    echo "[INFO] Merging ${#BAM_ARRAY[@]} BAM per $SAMPLE → $OUT_BAM"
    samtools merge -@ "$THREADS" "$OUT_BAM" "${BAM_ARRAY[@]}"
  fi

  echo "[INFO] Indicizzo $OUT_BAM"
  samtools index -@ "$THREADS" "$OUT_BAM"

done < "$SAMPLE_LIST"

