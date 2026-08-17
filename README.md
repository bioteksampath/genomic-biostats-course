# Applied Biostatistics & Machine Learning for Crop Genomics

**Author: Sampath Perumal, PhD** — NRC Saskatoon

🌐 **[View the course website](https://bioteksampath.github.io/genomic-biostats-course/)**

An open 8-week, hands-on course using **real canola, wheat, pea, and maize data**: mixed models → multivariate statistics → Bayesian inference → machine learning → multi-omics → Shiny apps → databases/APIs → HPC pipelines. Built with [Quarto](https://quarto.org).

## Quick start

```r
# 1. Install everything (R >= 4.3)
source("setup/install.R")

# 2. Preview the site locally
quarto preview
```

## Publish to GitHub Pages

```bash
git init && git add -A && git commit -m "Course v1"
git remote add origin git@github.com:bioteksampath/genomic-biostats-course.git
git push -u origin main
quarto publish gh-pages        # renders and pushes the website
```

Then in repo **Settings → Pages**, confirm source = `gh-pages` branch. Site appears at
`https://bioteksampath.github.io/genomic-biostats-course/`.

## Structure

| Path | Contents |
|---|---|
| `weeks/` | Week 0a–8 Quarto notebooks (each opens with a flow diagram) |
| `setup/` | `install.R` (one-shot R installer) · `environment.yml` (conda) |
| `shiny-app/` | Deployable GWAS & GS explorer (`rsconnect::deployApp("shiny-app/")`) |
| `data/` | `get_data.R` download script (most data ships in R packages) |
| `R/` | Shared helper functions |

## License

Code: MIT · Content: CC BY 4.0 · Datasets belong to their original authors (credited on each page).
