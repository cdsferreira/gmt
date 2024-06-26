REM               GMT EXAMPLE 33
REM
REM Purpose:      Illustrate grdtrack's new cross-track and stacking options
REM GMT modules:  grdcut, makecpt, convert, grdimage, grdtrack, text, plot
REM DOS calls:	echo, del
REM
gmt begin ex33
	REM Extract a subset of earth_relief_01m for the East Pacific Rise
	gmt grdcut @earth_relief_01m -R118W/107W/49S/42S -Gspac_33.nc
	gmt makecpt -Crainbow -T-5000/-2000
	gmt grdimage spac_33.nc -I+a15+ne0.75 -JM15c -B --FORMAT_GEO_MAP=dddF
	REM Select two points along the ridge
	echo -111.6	-43.0 > ridge.txt
	echo -113.3	-47.5 >> ridge.txt
	REM Plot ridge segment and end points
	gmt plot -Rspac_33.nc -W2p,blue ridge.txt
	gmt plot -Sc0.25c -Gblue ridge.txt
	REM Generate cross-profiles 400 km long, spaced 10 km, samped every 2km
	REM and stack these using the median, write stacked profile
	gmt grdtrack ridge.txt -Gspac_33.nc -C400k/2k/10k+v -Sm+sstack.txt > table.txt
	gmt plot -W0.5p table.txt
	REM Show upper/lower values encountered as an envelope
	gmt convert stack.txt -o0,5 > env.txt
	gmt convert stack.txt -o0,6 -I -T >> env.txt
	gmt plot -R-200/200/-3500/-2000 -JX6i/3i -Glightgray env.txt -Yh+3c
	gmt plot -W3p stack.txt -Bxafg1000+l"Distance from ridge (km)" -Byaf+l"Depth (m)" -BWSne
	echo MEDIAN STACKED PROFILE | gmt text -Gwhite -F+cTC+f14p -Dj8p
	REM cleanup
	del ridge.txt table.txt env.txt stack.txt
gmt end show
