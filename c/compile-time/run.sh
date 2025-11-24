#!/usr/bin/env bash

function gen() {
    ./generate.py $1 > $1000.c
    { time gcc $1000.c -o $1; } 2> time.txt
    printf "%i lines: %s\n" $1 `sed -n "s/^real\t\(.*\)/\1/p" time.txt`
    rm time.txt
    rm $1
}

gen 1000
gen 10000
gen 100000
gen 1000000
