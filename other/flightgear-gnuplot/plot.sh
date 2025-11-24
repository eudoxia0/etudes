#!/usr/bin/env bash
# Usage: plot [file]

FILE=$1

gnuplot -e "filename='${FILE}'" -p script.gp
