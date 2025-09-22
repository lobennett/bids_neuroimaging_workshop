# BIDS / Neuroimaging Workshop for Wu Tsai Neurosciences Institute

## Overview

This tutorial provides a hands-on introduction to neuroimaging data analysis for first-year neuroscience graduate students at Stanford University. Using fMRI data from the Haxby et al. (2001), students will learn the fundamentals of:

- **BIDS (Brain Imaging Data Structure)** data organization
- **fMRI preprocessing** with fMRIPrep
- **General Linear Model (GLM)** analysis for task fMRI
- **Statistical mapping** and data visualization

## Dataset

Haxby et al. (2001) investigates face and object representation in human ventral temporal cortex. The dataset includes:

- 3 subjects, each with multiple runs
- Block-design fMRI with 8 object categories (faces, houses, cats, bottles, scissors, shoes, chairs, scrambled images)
- 2.5s TR, 24s stimulus blocks
- Available from OpenNeuro [ds000105](https://openneuro.org/datasets/ds000105/versions/3.0.0)

## Learning Objectives

By the end of this tutorial, students will understand:

1. **BIDS Data Structure**: How neuroimaging data is organized using the BIDS standard and queried with PyBIDS
2. **NIfTI Format**: The standard neuroimaging data format and how to work with 4D (space + time) data
3. **fMRI Preprocessing**: Why preprocessing is necessary and what fMRIPrep does (motion correction, spatial normalization, confound estimation)
4. **Hemodynamic Response**: How neural activity relates to the BOLD signal and why we need to convolve task designs with the hemodynamic response function
5. **GLM Analysis**: How to create design matrices, fit statistical models, and interpret results
6. **Statistical Mapping**: How to threshold and visualize brain activation maps

## Key Concepts Covered

### Data Organization & Preprocessing

- BIDS layout and file organization
- NIfTI image headers and data structure
- fMRIPrep preprocessing pipeline
- Brain masks and template alignment

### Statistical Analysis

- Design matrix creation (boxcar and convolved)
- Hemodynamic response function (HRF) convolution
- Confound regression (motion, physiological noise)
- General Linear Model fitting
- Statistical thresholding with FDR correction

### Visualization

- Anatomical and functional image plotting
- Statistical map overlays
- Time series extraction from regions of interest
- Design matrix visualization

## Setup Instructions

### Local Installation

1. Clone this repository
2. Install dependencies: `pip install -r requirements.txt`
3. Run the data download script: `bash download.sh`
4. Open `tutorial.ipynb` in Jupyter

### Cloud Options

#### Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/lobennett/bids_neuroimaging_workshop/main?filepath=tutorial.ipynb)

Click the Binder badge to run this tutorial in your browser with no installation required. Binder will automatically install all dependencies from `requirements.txt`.

#### Google Colab

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/lobennett/bids_neuroimaging_workshop/blob/main/tutorial.ipynb)

To run in Google Colab:

1. Click the Colab badge above or manually upload `tutorial.ipynb`
2. Run the following setup cell first:

```python
# Install dependencies
!pip install -r https://raw.githubusercontent.com/lobennett/bids_neuroimaging_workshop/main/requirements.txt
# Download dataset
!wget https://raw.githubusercontent.com/lobennett/bids_neuroimaging_workshop/main/download.sh
!bash download.sh
```

## Files Structure

```
bids_neuroimaging_workshop/
├── tutorial.ipynb         # Main tutorial notebook
├── download.sh            # Script to download Haxby dataset
├── requirements.txt       # Python dependencies
├── utils/
    ├── spm_hrf.py        # SPM hemodynamic response function
├── images/
    ├── hrf.png           # Hemodynamic response example
    ├── fmriprep.jpg      # fMRIPrep workflow diagram
├── ds000105/             # Downloaded dataset (after running download.sh)
```

## Prerequisites

- Basic Python programming knowledge
- Familiarity with NumPy and Pandas
- Basic understanding of neuroimaging concepts (helpful but not required)

## Libraries Used

- **nilearn**: Neuroimaging analysis and visualization
- **nibabel**: NIfTI file I/O
- **pybids**: BIDS dataset queries
- **scikit-learn**: Statistical modeling
- **matplotlib**: Plotting and visualization
- **pandas/numpy**: Data manipulation

## References

- Haxby, J. V., et al. (2001). Distributed and overlapping representations of faces and objects in ventral temporal cortex. _Science_, 293(5539), 2425-2430.
- Gorgolewski, K. J., et al. (2016). The brain imaging data structure, a format for organizing and describing outputs of neuroimaging experiments. _Scientific Data_, 3, 160044.
- Esteban, O., et al. (2019). fMRIPrep: a robust preprocessing pipeline for functional MRI. _Nature Methods_, 16(1), 111-116.

---
