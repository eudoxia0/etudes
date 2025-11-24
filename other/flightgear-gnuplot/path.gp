set terminal png font arial 12 size 1000,900
set output 'path.png'

set datafile separator ','
set title 'Path'
unset key

set xlabel 'Longitude'
set ylabel 'Latitude'
set zlabel 'Altitude (feet)'

set xyplane at 0
show xyplane

splot filename using 10:9:8:($9-$8) with filledcurves, \
      filename using 10:9:8 with lines lw 3 lc palette
