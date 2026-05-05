#!/usr/bin/env bash
# index.bash – indicizzazione BAM con throttling

#set -euo pipefail

SAMPLE_LIST=${1:?Uso: $0 sample_list.txt lane_list.txt threads [max_jobs]}
LANE_LIST=${2:?Uso: $0 sample_list.txt lane_list.txt threads [max_jobs]}
THREADS=${3:-4}            # -@ di samtools index
MAX_JOBS=${4:-20}          # max indicizzazioni concorrenti

mkdir -p log

throttle() {
  while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
    wait -n || true
  done
}

for REF_TYPE in draft chrom; do
  while IFS= read -r LANE || [[ -n "${LANE:-}" ]]; do
    [[ -z "$LANE" ]] && continue
    INDIR="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/dedup/$REF_TYPE/$LANE"

    while IFS= read -r SAMPLE || [[ -n "${SAMPLE:-}" ]]; do
      [[ -z "$SAMPLE" ]] && continue

      BAM="$INDIR/${SAMPLE}.dedup.bam"
      LOG="log/${SAMPLE}.${LANE}.${REF_TYPE}.index.oe"

      if [[ ! -s "$BAM" ]]; then
        echo "[WARN] BAM mancante: $BAM — salto" | tee -a "$LOG"
        continue
      fi

      # salta se l'indice esiste ed è più recente del BAM (BAI o CSI)
      if { [[ -s "${BAM}.bai" && "${BAM}.bai" -nt "$BAM" ]] \
        || [[ -s "${BAM}.csi" && "${BAM}.csi" -nt "$BAM" ]]; }; then
        echo "[SKIP] indice già aggiornato per $BAM" | tee -a "$LOG"
        continue
      fi

      throttle
      samtools index -@ "$THREADS" "$BAM" &> "$LOG" &
    done < "$SAMPLE_LIST"

    wait   # attendi fine indicizzazioni di questa LANE
  done < "$LANE_LIST"
done

wait       # sicurezza finale

