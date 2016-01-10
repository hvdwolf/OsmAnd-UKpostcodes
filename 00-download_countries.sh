#!/bin/bash

# Version 1.0, 20150821, Harry van der Wolf

# It requires roughly 2.5 GB to work on the temporary files

export TOOLSDIR=tools

echo First  make sure we have our tools and otherwise download and compile them
if [ ! -f tools/osmconvert ]; then
   cd tools
   wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert
   cd ..
fi

if [ ! -f tools/osmfilter ]; then
   cd tools
   wget -O - http://m.m.i24.cc/osmfilter.c |cc -x c - -O3 -o osmfilter
   cd ..
fi



mkdir workfiles

echo "Downloading England, Ireland-Northern Ireland, Scotland and Wales"
# echo Downloading Great Britain and Ireland-Northern Ireland.
echo Later we will get rid of Ireland as we only need Northern Ireland for our United Kingdom postcodes
echo 
wget http://download.geofabrik.de/europe/great-britain/england-latest.osm.pbf -O workfiles/england-latest.osm.pbf
wget http://download.geofabrik.de/europe/great-britain/scotland-latest.osm.pbf -O workfiles/scotland-latest.osm.pbf
wget http://download.geofabrik.de/europe/great-britain/wales-latest.osm.pbf -O workfiles/wales-latest.osm.pbf
# wget http://download.geofabrik.de/europe/great-britain-latest.osm.pbf -O workfiles/great-britain-latest.osm.pbf
wget http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.osm.pbf -O workfiles/ireland-and-northern-ireland-latest.osm.pbf
echo ===

echo Converting the countries
echo Also remove broken ways, nodes which result in OsmandMapCreator crashes due to double ids
echo On low memory  machines use the --hash-memory=400-50-2 option 
./$TOOLSDIR/osmconvert -v workfiles/england-latest.osm.pbf --hash-memory=400-50-2 --drop-author --drop-version  --out-o5m > workfiles/england-latest.o5m
./$TOOLSDIR/osmconvert -v workfiles/scotland-latest.osm.pbf --hash-memory=400-50-2 --drop-author --drop-version  --out-o5m > workfiles/scotland-latest.o5m
./$TOOLSDIR/osmconvert -v workfiles/wales-latest.osm.pbf --hash-memory=400-50-2 --drop-author --drop-version  --out-o5m > workfiles/wales-latest.o5m
# .$TOOLSDIR/osmconvert -v workfiles/great-britain-latest.osm.pbf --drop-author --drop-version  --out-o5m > workfiles/great-britain-latest.o5m
echo ===
echo Get rid of Ireland now from the combined Ireland-Northern-Ireland file
./$TOOLSDIR/osmconvert -v workfiles/ireland-and-northern-ireland-latest.osm.pbf -B=basefiles/northern_ireland.poly --hash-memory=400-50-2 --drop-author --drop-version  --out-o5m > workfiles/northern-ireland-latest.o5m
# echo ===
# echo now First merge them with osmconvert to get rid of double entries
# ./$TOOLSDIR/osmconvert -v workfiles/great-britain-latest.o5m workfiles/northern-ireland-latest.o5m --out-o5m > workfiles/United-Kingdom.o5m

echo ===
echo Filtering the country o5m files to get the osm header and the boundaries  
echo On low memory  machines use the --hash-memory=400-50-2 option 
./$TOOLSDIR/osmfilter -v workfiles/england-latest.o5m --hash-memory=400-50-2 --keep="boundary=administrative=6 =8 =10 place=" --drop="highway= waterway= route=" --out-osm -o=workfiles/england-latest.osm
./$TOOLSDIR/osmfilter -v workfiles/scotland-latest.o5m --hash-memory=400-50-2 --keep="boundary=administrative=6 =8 =10 place=" --drop="highway= waterway= route=" --out-osm -o=workfiles/scotland-latest.osm
./$TOOLSDIR/osmfilter -v workfiles/wales-latest.o5m --hash-memory=400-50-2 --keep="boundary=administrative=6 =8 =10 place=" --drop="highway= waterway= route=" --out-osm -o=workfiles/wales-latest.osm
# ./$TOOLSDIR/osmfilter -v workfiles/great-britain-latest.o5m --keep="boundary=administrative=6 =8 =10 place=" --keep-ways= --keep-nodes= --keep-relations= --out-osm -o=workfiles/great-britain-latest.osm
./$TOOLSDIR/osmfilter -v workfiles/northern-ireland-latest.o5m --hash-memory=400-50-2 --keep="boundary=administrative=6 =8 =10 place=" --drop="highway= waterway= route=" --out-osm -o=workfiles/northern-ireland-latest.osm
# ./$TOOLSDIR/osmfilter -v workfiles/United-Kingdom.o5m --keep="boundary=administrative=6 =8 =10 place=" --keep-ways= --keep-nodes= --keep-relations= --out-osm -o=workfiles/United-Kingdom.osm

echo ===
echo prepare osm header text file for optional POI file
# cat workfiles/great-britain-latest.osm | grep -v "xml version" | grep -v "osm version" | grep -v "bounds minlat" | grep -v "</osm>" > workfiles/great-britain-boundaries.txt
# cat workfiles/United-Kingdom.osm | grep -v "xml version" | grep -v "osm version" | grep -v "bounds minlat" | grep -v "</osm>" > workfiles/United-Kingdom.txt
# cat basefiles/United_Kingdom-osm-header.txt workfiles/United-Kingdom.txt > basefiles/united_Kingdom-boundaries.txt
head -3 workfiles/england-latest.osm > basefiles/england-osm-header.txt
head -3 workfiles/northern-ireland-latest.osm > basefiles/northern-ireland-osm-header.txt
head -3 workfiles/scotland-latest.osm > basefiles/scotland-osm-header.txt
head -3 workfiles/wales-latest.osm > basefiles/wales-osm-header.txt
# cat workfiles/northern-ireland-latest.osm | grep -v "xml version" | grep -v "osm version" | grep -v "bounds minlat" | grep -v "</osm>" > workfiles/northern-ireland-boundaries.txt
# cat workfiles/scotland-latest.osm | grep -v "xml version" | grep -v "osm version" | grep -v "bounds minlat" | grep -v "</osm>" > workfiles/scotland-ireland-boundaries.txt
# cat workfiles/wales-ireland-latest.osm | grep -v "xml version" | grep -v "osm version" | grep -v "bounds minlat" | grep -v "</osm>" > workfiles/wales-ireland-boundaries.txt
echo ===
echo prepare boundary text file for address based files
cat workfiles/england-latest.osm | grep -v "</osm>" > basefiles/england-boundaries.txt
cat workfiles/northern-ireland-latest.osm | grep -v "</osm>" > basefiles/northern-ireland-boundaries.txt
cat workfiles/scotland-latest.osm | grep -v "</osm>" > basefiles/scotland-boundaries.txt
cat workfiles/wales-latest.osm | grep -v "</osm>" > basefiles/wales-boundaries.txt

echo ===
echo Clean up
rm workfiles/*.o5m
rm workfiles/*latest.o*
rm workfiles/*.osm
rm workfiles/*.txt

