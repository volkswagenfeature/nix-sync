#!/bin/sh

MAX=$blmax
INTERVALS=$steps
WOB_FIFO=$wobfifo
BL_PATH=$blpath


# Gets squirly with too many steps.
# Error accumulates due to floating point error.
# the odd comparison value prevents this. 
# j <= doesn't work because floating poitn error
# j < m*res doesn't work because the error tends to undershoot (so you still get extra)
# j < m+1 doesn't work because... shut up.
# Thus j < m*res^0.9
#equation: base=$MAX*(1/$INTERVALS)
RES=$( awk -v m="$MAX"\
           -v i="$((INTERVALS - 2))"\
           'BEGIN { res = m^(1/i);printf "0 ";for(j=1; j<(m+1); j *= res) printf"%.f ",j }'
     )

echo $RES
