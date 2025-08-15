# EMImR: a Shiny Application for Identifying Transcriptomic and Epigenomic Changes


[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic_2.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13453182.svg)](https://doi.org/10.5281/zenodo.13453182)



<p align="center">
  <img src="https://raw.githubusercontent.com/omicscodeathon/emimr/main/assets/emimr-logo.png" alt="emimr logo" width="300"  />
</p>


## Table of Contents
1.  [About EMImR](#About-EMImR])
2.  [Demonstration Video](#Demonstration_Video)
3.  [Implementation and  Operation](#Implementation_and_Operation)
4.  [Installation Guides](#Installation_Guide)
5.  [Licence](#Licence)
6.  [Citation](#Citation)
<br>


## About EMImR

EMImR is a Shiny Application for Transcriptomic and Epigenomic Changes Identification and data correlation.

The application's main function is to identify the intersection between genetic and epigenetic modififcations, including :

* Identify the differentially expressed genes (DEGs)

* Identify the differentially methylated genes (DMGs)  

* Determine DEGs associated with DMGs

* Identify the genes associated to differentially expressed interfering miRNA (GDEImRs).

* Determine DEGs associated with  differentially expressed interfering miRNA

## Demonstration Video

<p align="center">
  <a href="https://www.youtube.com/watch?v=S7r2rj4tWVo">
    <img src="https://github.com/omicscodeathon/emimr/blob/main/assets/emimr_yt.png?raw=true" alt="emimr" width="700" />
  </a>
</p> 



## Implementation and  Operation

    - platform-independent
    - all dependencies are installed automatically with the tool
    - Internet requirement: Only if using an online server
    - Third-party tools requirement: R studio or an online Server
    - Pre-requirements: R  installation


## Installation Guide


**Step 1 :** Install dependencies

    Install the latest version of R if your computer does not have it: [R](https://cran.r-project.org/bin/windows/base/)   

            ### How To Install R and RStudio
            - Go to This Website : https://posit.co/download/rstudio-desktop/
![image](https://github.com/omicscodeathon/Exvar/assets/73958439/62b7eda6-c7af-47a2-aec9-fe14aae68e50)

            -  Download R for you specific Operating System (OS). R 4.2.1 version is recommended [Link to version 4.2.1](https://cran.r-project.org/bin/windows/base/old/4.2.1/)

![image](https://github.com/omicscodeathon/Exvar/assets/73958439/258e6366-4cf9-45a9-ba39-ebaf4212af71)

           - Download RStudio

**Step 2 :** Download the application

    Download the application folder   

**Step 3 :** Open the application

    - Open the application folder using RStudio   

    - Set the folder as a working directory

    - Then open the file named "Run_App.R"

**Step 4 :** Run The Application

Run the app code by cicking on the "Run APP" button

All dependencies will be installed automaticly and the application's dashboard will appear.

## Licence

The scripts are under the artistic-2.0 license, and the CSV data are under the CC0 public domain waiver.

## Citation

Ben Aribi, H., Ayadi, F., Naitore, C., & Awe, O. I. (2024). EMImR: a Shiny Application for Identifying Transcriptomic and Epigenomic Changes. Zenodo. https://doi.org/10.5281/zenodo.16881955




