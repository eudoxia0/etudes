set terminal png font arial 12 size 1800, 900
set output 'plot.png'
set title font ',16'
set datafile separator ','

set multiplot

set size 0.5,1
set origin 0,0
# Altitude
set title 'Path'
unset key
set xlabel 'Longitude'
set ylabel 'Latitude'
set zlabel 'Altitude (feet)'
set xyplane at 0
show xyplane

splot filename using 10:9:8:($9-$8) with filledcurves, \
      filename using 10:9:8 with lines lw 3 lc palette

set size 0.5,0.5
set origin 0.5,0.5
# Throttle
set title 'Throttle'
set key
set xlabel 'Time (s)'
set ylabel 'Percentage'
plot filename using 4 with line title 'Left', \
     filename using 5 with line title 'Right'

set size 0.5,0.5
set origin 0.5,0.0
# Orientation
set title 'Orientation'
set key
set xlabel 'Time (s)'
set ylabel 'Degree'
set yrange[-90:90]
plot filename using 2 with line title 'Roll', \
     filename using 3 with line title 'Pitch'

unset multiplot
