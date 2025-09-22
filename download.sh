#!/bin/bash
#
# This script downloads the necessary raw BIDS and fMRIPrep derivatives
# for customizable subjects and runs from the OpenNeuro Haxby dataset (ds000105).
#
# Usage: ./download.sh [OPTIONS]
#   -s, --subjects SUBJECTS    Comma-separated list of subject numbers (default: 1)
#   -r, --runs RUNS           Comma-separated list of run numbers (default: 1)
#   -h, --help                Show this help message
#
# Examples:
#   ./download.sh                           # Download subject 1, run 1
#   ./download.sh -s 1,2 -r 1,2,3          # Download subjects 1-2, runs 1-3
#   ./download.sh --subjects 1 --runs 1,2   # Download subject 1, runs 1-2
#

# Exit immediately if a command exits with a non-zero status.
set -e

## ——— Default Configuration ———
DEFAULT_SUBJECTS="1"
DEFAULT_RUNS="1"
DATASET="ds000105"
BIDS_DIR="./${DATASET}"
DERIVS_DIR="${BIDS_DIR}/derivatives/fmriprep"

## ——— Help Function ———
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Download raw BIDS and fMRIPrep derivatives from OpenNeuro Haxby dataset (ds000105)"
    echo ""
    echo "Options:"
    echo "  -s, --subjects SUBJECTS    Comma-separated list of subject numbers (default: ${DEFAULT_SUBJECTS})"
    echo "  -r, --runs RUNS           Comma-separated list of run numbers (default: ${DEFAULT_RUNS})"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                           # Download subject 1, run 1"
    echo "  $0 -s 1,2 -r 1,2,3          # Download subjects 1-2, runs 1-3"
    echo "  $0 --subjects 1 --runs 1,2   # Download subject 1, runs 1-2"
    echo "  $0 -s 1,2,3,4,5,6 -r 1,2,3  # Download all 6 subjects, first 3 runs"
}

## ——— Argument Parsing ———
SUBJECTS="${DEFAULT_SUBJECTS}"
RUNS="${DEFAULT_RUNS}"

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--subjects)
            SUBJECTS="$2"
            shift 2
            ;;
        -r|--runs)
            RUNS="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1"
            show_help
            exit 1
            ;;
    esac
done

# Convert comma-separated lists to arrays
IFS=',' read -ra SUBJECT_ARRAY <<< "$SUBJECTS"
IFS=',' read -ra RUN_ARRAY <<< "$RUNS"

## ——— Script Start ———
echo "Starting download for subjects [${SUBJECTS}] and runs [${RUNS}] from dataset ${DATASET}..."
echo "Total subjects: ${#SUBJECT_ARRAY[@]}, Total runs: ${#RUN_ARRAY[@]}"
echo ""

# Create output directory
mkdir -p "${BIDS_DIR}"

# Build include patterns for all subjects and runs
BIDS_INCLUDES=()
FMRIPREP_INCLUDES=()

# Add common files (only once)
BIDS_INCLUDES+=(
    "--include" "dataset_description.json"
    "--include" "participants.tsv"
    "--include" "README"
    "--include" "CHANGES"
    "--include" "task-*_*.json"
)

FMRIPREP_INCLUDES+=(
    "--include" "dataset_description.json"
)

# Add subject-specific files
for SUBJECT in "${SUBJECT_ARRAY[@]}"; do
    echo "Preparing downloads for subject ${SUBJECT}..."

    # Add anatomical data for each subject (only once per subject)
    BIDS_INCLUDES+=(
        "--include" "sub-${SUBJECT}/anat/*"
    )

    FMRIPREP_INCLUDES+=(
        "--include" "sub-${SUBJECT}/anat/*space-MNI152NLin2009cAsym_res-2_desc-preproc_T1w.*"
    )

    # Add functional data for each run
    for RUN in "${RUN_ARRAY[@]}"; do
        # Format runs (BIDS uses zero-padded, fMRIPrep uses non-padded)
        RUN_BIDS=$(printf "%02d" $RUN)
        RUN_FMRIPREP=$RUN

        echo "  Adding patterns for subject ${SUBJECT}, run ${RUN} (BIDS: ${RUN_BIDS}, fMRIPrep: ${RUN_FMRIPREP})"

        # Raw BIDS functional files
        BIDS_INCLUDES+=(
            "--include" "sub-${SUBJECT}/func/*_run-${RUN_BIDS}_*"
        )

        # fMRIPrep derivative files
        FMRIPREP_INCLUDES+=(
            "--include" "sub-${SUBJECT}/func/*run-${RUN_FMRIPREP}_space-MNI152NLin2009cAsym_res-2_boldref*"
            "--include" "sub-${SUBJECT}/func/*run-${RUN_FMRIPREP}_space-MNI152NLin2009cAsym_res-2_desc-brain_mask*"
            "--include" "sub-${SUBJECT}/func/*run-${RUN_FMRIPREP}_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold*"
            "--include" "sub-${SUBJECT}/func/*run-${RUN_FMRIPREP}_space-T1w_desc-preproc_bold*"
            "--include" "sub-${SUBJECT}/func/*run-${RUN_FMRIPREP}_desc-confounds_timeseries*"
        )
    done
done

# 1. Download the raw BIDS data
echo ""
echo "=================================================="
echo "Step 1: Downloading raw BIDS data..."
echo "=================================================="
aws s3 sync --no-sign-request \
  "s3://openneuro.org/${DATASET}/" \
  "${BIDS_DIR}" \
  --exclude "*" \
  "${BIDS_INCLUDES[@]}"

echo ""
echo "Raw BIDS data download complete."

# 2. Download the fMRIPrep derivatives
echo ""
echo "=================================================="
echo "Step 2: Downloading fMRIPrep derivatives..."
echo "=================================================="
aws s3 sync --no-sign-request \
  "s3://openneuro-derivatives/fmriprep/${DATASET}-fmriprep/" \
  "${DERIVS_DIR}" \
  --exclude "*" \
  "${FMRIPREP_INCLUDES[@]}"

echo ""
echo "fMRIPrep derivatives download complete."
echo "=================================================="
echo "All files downloaded successfully!"
echo ""
echo "Summary:"
echo "  • Subjects: ${SUBJECTS}"
echo "  • Runs: ${RUNS}"
echo "  • Data location: ${BIDS_DIR}"
echo "  • Derivatives location: ${DERIVS_DIR}"
echo ""
echo "You can now run your analysis scripts on this data!"