# Image and Data Analysis Scripts for "Cell state-specific cytoplasmic density controls spindle architecture and scaling" (Kletter et al. 2025)

This repository contains the image analysis and data analysis scripts used in the publication **"Cell state-specific cytoplasmic density controls spindle architecture and scaling"**. The study is composed of various microscopy-based experiments, and the scripts provided here facilitate reproducibility and further analysis. 

Note: the code that was developed to perform long-term adaptive feedback microscopy using Zeiss LSM 800/900 microscopes is located at https://git.embl.de/grp-almf/automictools-zenblue-spindle-kletter


## Repository Structure

Experiments are grouped into subfolders and per usual contain various scripts. 
- `Macros/` – Contains **ImageJ macro language scripts** used for processing and analysing microscopy images.
- `Notebooks/` – Contains **Jupyter notebooks** for curation, statistical analysis and visualisation of extracted data.

## Requirements

### ImageJ/Fiji Installation
1. Download and install **Fiji (ImageJ with plugins)** from [https://imagej.net/software/fiji/downloads](https://imagej.net/software/fiji/downloads).
2. Open Fiji and navigate to `Plugins > Macros > Run...` to execute a script.
3. Select the relevant macro script from the `Macros/` directory and run it. Alternatively, scripts can simply be drag-and-dropped into Fiji.
4. Several scripts rely on third-party plugins (Spindle3D, MorphoLibJ, 3D Imagej suite, Ilastik). These can be activated by updating Fiji `Help > Update...`. 

### Jupyter Notebook Installation
1. Install **Python** (preferably version 3.x) from [https://www.python.org/downloads/](https://www.python.org/downloads/).
2. Install Jupyter Notebook by running the following command in the terminal:
   ```bash
   pip install jupyter
   ```
3. Navigate to the `data_analysis/` directory in the terminal and start Jupyter Notebook:
   ```bash
   jupyter notebook
   ```
4. Open the relevant notebook (`.ipynb` file) and execute the code cells.

## Usage
- Image analysis scripts (`.ijm` files) should be run in **Fiji (ImageJ)** for preprocessing and quantifying microscopy images.
- Data analysis scripts (`.ipynb` files) should be executed in **Jupyter Notebook** for statistical analysis and visualisation.
- Note: scripts are highly customised. Please feel encouraged to contact me for assistance. 

## Citation
If you use these scripts in your research, please cite our preprint:

> Cell State-Specific Cytoplasmic Material Properties Control Spindle Architecture and Scaling

> Tobias Kletter, Omar Muñoz, Sebastian Reusch, Abin Biswas, Aliaksandr Halavatyi, Beate Neumann, Benno Kuropka, Vasily Zaburdaev, Simone Reber
bioRxiv 2024.07.22.604615; doi: https://doi.org/10.1101/2024.07.22.604615 
