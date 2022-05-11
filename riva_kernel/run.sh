#!/usr/bin/bash

module load singularity

singularity exec --nv riva-speech_2.1.0-server.sif python -m ipykernel "$@"
