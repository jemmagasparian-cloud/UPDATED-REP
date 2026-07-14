name: Run Table1 Script

on:
  workflow_dispatch:
  push:
    paths:
      - 'table1_script.R'
      - 'NYCCHS2019.xlsx'

jobs:
  run-table1:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup R
        uses: r-lib/actions/setup-r@v2

      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-dev libgdal-dev libgeos-dev libproj-dev

      - name: Install R packages
        run: |
          Rscript -e 'options(repos="https://cloud.r-project.org"); req <- c("readxl","dplyr","gtsummary","gt","flextable"); inst <- rownames(installed.packages()); to_install <- setdiff(req, inst); if(length(to_install)) install.packages(to_install)'

      - name: Run table1 script
        run: Rscript table1_script.R

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: table1-artifacts
          path: |
            table1.html
            table1.docx
