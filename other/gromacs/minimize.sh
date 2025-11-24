#!/bin/bash

INPUT=$1
COORDINATES=coord.gro
TOPOLOGY=topo.top
FORCEFIELD=amber03
WATER=tip3p

pdb2gmx -f $INPUT -o $COORDINATES -p $TOPOLOGY -ignh -v -ff $FORCEFIELD -water $WATER

rm $COORDINATES $TOPOLOGY
