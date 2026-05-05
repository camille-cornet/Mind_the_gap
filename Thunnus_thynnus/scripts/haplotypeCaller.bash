#!/usr/bin/env bash
# haplotypeCaller.bash – versione migliorata

#set -euo pipefail

# === Parametri ===
SAMPLE_LIST=${1:?Uso: $0 sample_list.txt lane_list.txt threads [max_jobs]}
LANE_LIST=${2:?Uso: $0 sample_list.txt lane_list.txt threads [max_jobs]}
HC_THREADS=${3:-4}         # thread per --native-pair-hmm-threads (default 4)
MAX_JOBS=${4:-30}          # limite massimo di job concorrenti (default 30)

# === Reference paths ===
CHROM_REF="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/chrom/GCF_963924715.1_fThuThy2.1_genomic.fna.masked.fna"
DRAFT_REF="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/draft/GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna"

mkdir -p log

# Funzione: lancia un job e applica il throttling a MAX_JOBS
launch_job() {
  # mentre i job attivi >= MAX_JOBS, aspetta che ne finisca uno
  while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
    # richiede bash >= 4.3; attende che termini un job qualsiasi
    wait -n || true
  done
}

for REF_TYPE in draft chrom; do
  # scegli il reference corretto
  case "$REF_TYPE" in
    chrom) REF="$CHROM_REF" ;;
    draft) REF="$DRAFT_REF" ;;
    *) echo "REF_TYPE sconosciuto: $REF_TYPE" >&2; exit 1 ;;
  esac

  mkdir -p "$REF_TYPE"

  # loop sulle lane
  while IFS= read -r LANE || [[ -n "${LANE:-}" ]]; do
    [[ -z "$LANE" ]] && continue
    mkdir -p "$REF_TYPE/$LANE"
    INDIR="/media/root/GenoD/piergiorgio.massa2/mind_the_gap/dedup/$REF_TYPE/$LANE"

    # loop sui sample
    while IFS= read -r SAMPLE || [[ -n "${SAMPLE:-}" ]]; do
      [[ -z "$SAMPLE" ]] && continue

      BAM="$INDIR/${SAMPLE}.dedup.noeq.bam"
      OUT="$REF_TYPE/$LANE/${SAMPLE}.g.vcf.gz"
      LOG="log/${SAMPLE}.${LANE}.${REF_TYPE}.oe"

      if [[ ! -s "$BAM" ]]; then
        echo "[WARN] BAM mancante: $BAM — salto" | tee -a "$LOG"
        continue
      fi

      # lancia il job con throttling
      gatk HaplotypeCaller \
        -R "$REF" \
        -I "$BAM" \
        -ERC GVCF \
        --native-pair-hmm-threads "$HC_THREADS" \
        -O "$OUT" &> "$LOG" &

      launch_job
    done < "$SAMPLE_LIST"

    # aspetta i job rimanenti di questa LANE
    wait
  done < "$LANE_LIST"

  # per sicurezza, aspetta eventuali job pendenti di questo REF_TYPE
  wait
done

# fine: assicurati che tutto sia completato
wait

