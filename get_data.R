# ------------------------------------------------------------------
# Download / prepare external datasets for the course
# Everything else ships inside R packages (agridat, BGLR, sommer).
# ------------------------------------------------------------------
# Week 5: real Brassica napus RNA-seq counts from NCBI GEO.
# Browse GEO for a canola stress study with a counts matrix
# (e.g., search: "Brassica napus RNA-seq counts"), then set:
geo_url <- ""   # paste the *_counts.txt.gz supplementary-file URL here

if (nzchar(geo_url)) {
  dir.create("data", showWarnings = FALSE)
  destfile <- file.path("data", basename(geo_url))
  download.file(geo_url, destfile)
  counts <- as.matrix(read.delim(destfile, row.names = 1))
  saveRDS(counts, "data/bnapus_counts.rds")
  message("Saved data/bnapus_counts.rds: ", nrow(counts), " genes x ",
          ncol(counts), " samples")
} else {
  message("Set geo_url first. Weeks 1-4 need no downloads (package data).")
}

# Optional Week 2 upgrade: USDA Pea Single Plant Plus Collection
# (Holdsworth et al. 2017, Scientific Data) - genotype/phenotype files
# are linked from the paper; place them under data/pea/.
