#!/bin/csh -f

# Usage :  
#  prompt> skdetsim.sh [card name] [output file] [input file] [# of sukipped event]
#

set DIR="$SKOFL_ROOT/../skdetsim/"

## SUBRUN number is input from enviromment variable.
setenv MC_SUBNUM 0

echo $#argv

# Check over each input argument and set the appropriate variables

if ($#argv>0) then
    set CARD=$1
else
    set CARD=supersim.card
endif

if ($#argv>1) then
    set FNAME_OUT=$2
else
    set FNAME_OUT=dummy.output
endif

if ($#argv>2) then
    set FNAME_IN=$3
else
    set FNAME_IN=dummy.input
endif

if ($#argv>3) then
$DIR/skdetsim $CARD $FNAME_OUT $FNAME_IN $4
else
$DIR/skdetsim $CARD $FNAME_OUT $FNAME_IN
endif






