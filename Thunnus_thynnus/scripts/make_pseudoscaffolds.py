#!/usr/bin/env python3
import sys
import os

GAP = "N" * 10  # 10 N tra i contig

# Definizione dei bin:
# min_len incluso, max_len escluso (tranne l'ultimo che ha max_len=None = infinito)
BIN_DEFS = [
    (0,     300,   "pseudoscaffold_300_lt300bp"),
    (300,   600,   "pseudoscaffold_600_300-600bp"),
    (600,   1200,  "pseudoscaffold_1200_600-1200bp"),
    (1200,  2400,  "pseudoscaffold_2400_1200-2400bp"),
    (2400,  4800,  "pseudoscaffold_4800_2400-4800bp"),
    (4800,  9600,  "pseudoscaffold_9600_4800-9600bp"),
    (9600,  None,  "pseudoscaffold_gt9600_ge9600bp"),  # NUOVO: tutti i contig >=9600
]


def fasta_iter(handle):
    """Generatore di record FASTA (header, seq)."""
    name = None
    seq_chunks = []
    for line in handle:
        line = line.rstrip("\n")
        if not line:
            continue
        if line.startswith(">"):
            if name is not None:
                yield name, "".join(seq_chunks)
            name = line[1:].strip()
            seq_chunks = []
        else:
            seq_chunks.append(line.strip())
    if name is not None:
        yield name, "".join(seq_chunks)


def write_fasta_record(out_handle, header, seq, width=60):
    """Scrive una sequenza FASTA con wrapping a 'width' colonne."""
    out_handle.write(">" + header + "\n")
    for i in range(0, len(seq), width):
        out_handle.write(seq[i:i + width] + "\n")


def main():
    if len(sys.argv) != 3:
        sys.stderr.write(
            f"Uso: {sys.argv[0]} input.fasta output.fasta\n"
        )
        sys.exit(1)

    in_fa = sys.argv[1]
    out_fa = sys.argv[2]

    # Decidi il nome del file di summary
    if out_fa.endswith(".masked.fna"):
        summary_path = out_fa[: -len(".masked.fna")] + ".summary.txt"
    elif out_fa.endswith((".fna", ".fa", ".fasta")):
        summary_path = out_fa.rsplit(".", 1)[0] + ".summary.txt"
    else:
        summary_path = out_fa + ".summary.txt"

    sys.stderr.write(f"[INFO] Input FASTA : {in_fa}\n")
    sys.stderr.write(f"[INFO] Output FASTA: {out_fa}\n")
    sys.stderr.write(f"[INFO] Summary     : {summary_path}\n")

    # Strutture per accumulare le sequenze per bin
    bin_seqs = {name: [] for (_, _, name) in BIN_DEFS}
    bin_stats = {
        name: {"min": min_len, "max": max_len, "n_contigs": 0, "bp": 0}
        for (min_len, max_len, name) in BIN_DEFS
    }

    total_contigs = 0
    total_bp = 0

    # Lettura FASTA e assegnazione contig ai bin
    with open(in_fa) as fh:
        for header, seq in fasta_iter(fh):
            L = len(seq)
            if L == 0:
                continue

            total_contigs += 1
            total_bp += L

            # Trova il bin corrispondente
            bin_name = None
            for (min_len, max_len, name) in BIN_DEFS:
                if max_len is None:
                    if L >= min_len:
                        bin_name = name
                        break
                else:
                    if (L >= min_len) and (L < max_len):
                        bin_name = name
                        break

            if bin_name is None:
                # Non dovrebbe mai succedere
                sys.stderr.write(
                    f"[WARN] Contig '{header}' (len={L}) non assegnato ad alcun bin!\n"
                )
                continue

            bin_seqs[bin_name].append(seq)
            bin_stats[bin_name]["n_contigs"] += 1
            bin_stats[bin_name]["bp"] += L

            if total_contigs % 50000 == 0:
                sys.stderr.write(
                    f"[INFO] Processati {total_contigs} contig, bp totali finora = {total_bp}\n"
                )

    sys.stderr.write(
        f"[INFO] Finita lettura FASTA. Contig totali={total_contigs}, bp totali={total_bp}\n"
    )

    # Scrittura FASTA di output: un pseudoscaffold per ciascun bin (se non vuoto)
    with open(out_fa, "w") as out_fh:
        for (min_len, max_len, name) in BIN_DEFS:
            n = bin_stats[name]["n_contigs"]
            bp_no_gap = bin_stats[name]["bp"]
            if n == 0:
                continue

            sys.stderr.write(
                f"[INFO] Creo {name}: contig={n}, bp (senza gap)={bp_no_gap}\n"
            )

            # Concatena i contig con 10 N fra uno e l'altro
            merged_seq = GAP.join(bin_seqs[name])
            # Lunghezza teorica = bp originali + 10N * (n_contigs - 1)
            merged_len = bp_no_gap + (n - 1) * len(GAP)

            header = f"{name}_n_contigs={n}_len={merged_len}"
            write_fasta_record(out_fh, header, merged_seq)

    # Scrittura summary
    with open(summary_path, "w") as sfh:
        sfh.write("# Riepilogo pseudoscaffold\n")
        sfh.write(f"Totale contig originali : {total_contigs}\n")
        sfh.write(f"Totale bp originali     : {total_bp}\n\n")
        sfh.write("Bin (per range di lunghezza):\n")
        sfh.write("bin\tmin\tmax\tcontig\tbp\t%bp\n")

        for (min_len, max_len, name) in BIN_DEFS:
            n = bin_stats[name]["n_contigs"]
            bp = bin_stats[name]["bp"]
            if total_bp > 0:
                pct = 100.0 * bp / total_bp
            else:
                pct = 0.0
            max_str = "" if max_len is None else str(max_len)
            sfh.write(
                f"{name}\t{min_len}\t{max_str}\t{n}\t{bp}\t{pct:.2f}\n"
            )

    sys.stderr.write("[INFO] Completato. FASTA e summary scritti.\n")


if __name__ == "__main__":
    main()

