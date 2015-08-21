#!/bin/bash

# Version 1.0, 20150821, Harry van der Wolf

# It requires roughly 2.5 GB to work on the temporary files
# All windows files with .exe as I almost completely copy&paste the scripts


export TOOLSDIR=tools

mkdir workfiles

echo "Downloading England, Ireland-Northern Ireland, Scotland and Wales"
# echo Downloading Great Britain and Ireland-Northern Ireland.
echo Later we will get rid of Ireland as we only need Northern Ireland for our United Kingdom postcodes
echo 
#wget http://download.geofabrik.de/europe/great-britain/england-latest.osm.pbf -O workfiles/england-latest.osm.pbf
#wget http://download.geofabrik.de/europe/great-britain/scotland-latest.osm.pbf -O workfiles/scotland-latest.osm.pbf
#wget http://download.geofabrik.de/europe/great-britain/wales-latest.osm.pbf -O workfiles/wales-latest.osm.pbf
# wget http://download.geofabrik.de/europe/great-britain-latest.osm.pbf -O workfiles/great-britain-latest.osm.pbf
#wget http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.osm.pbf -O workfiles/ireland-and-northern-ireland-latest.osm.pbf
echo ===

echo Converting the countries
echo Also remove broken ways, nodes which result in OsmandMapCreator crashes due to double ids
$TOOLSDIR/osmconvert32 -v workfiles/england-latest.osm.pbf --drop-author --drop-version  --drop-broken-refs --out-o5m > workfiles/england-latest.o5m
$TOOLSDIR/osmconvert32 -v workfiles/scotland-latest.osm.pbf --drop-author --drop-version  --drop-broken-refs --complex-ways --drop-broken-refs --out-o5m > workfiles/scotland-latest.o5m
$TOOLSDIR/osmconvert32 -v workfiles/wales-latest.osm.pbf --drop-author --drop-version  --drop-broken-refs --out-o5m > workfiles/wales-latest.o5m
# $TOOLSDIR/osmconvert32 -v workfiles/great-britain-latest.osm.pbf --drop-author --drop-version  --drop-broken-refs --out-o5m > workfiles/great-britain-latest.o5m
echo ===
echo Get rid of Ireland now from the combined Ireland-Northern-Ireland file
$TOOLSDIR/osmconvert32 -v workfiles/ireland-and-northern-ireland-latest.osm.pbf -B=basefiles/northern_ireland.poly --drop-author --drop-version  --drop-broken-refs --out-o5m > workfiles/northern-ireland-latest.o5m
# echo ===
# echo now First merge them with osmconvert32 to get rid of double entries
# $TOOLSDIR/osmconvert32 -v workfiles/great-britain-latest.o5m workfiles/northern-ireland-latest.o5m --out-o5m > workfiles/United-Kingdom.o5m

echo ===
echo Filtering the country o5m files to get the osm header and the boundaries  
$TOOLSDIR/omfilter32 -v workfiles/england-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles/england-latest.osm
$TOOLSDIR/omfilter32 -v workfiles/scotland-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles/scotland-latest.osm
$TOOLSDIR/omfilter32 -v workfiles/wales-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles/wales-latest.osm
# $TOOLSDIR/omfilter32 -v workfiles/great-britain-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --keep-ways= --keep-nodes= --keep-relations= --out-osm -o=workfiles/great-britain-latest.osm
$TOOLSDIR/omfilter32 -v workfiles/northern-ireland-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles/northern-ireland-latest.osm
# $TOOLSDIR/omfilter32 -v workfiles/United-Kingdom.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --keep-ways= --keep-nodes= --keep-relations= --out-osm -o=workfiles/United-Kingdom.osm

echo ===
echo prepare osm header text file for optional POI file
# cat workfiles/great-britain-latest.osm | %BINDIR%/grep -v "xml version" | %BINDIR%/grep -v "osm version" | %BINDIR%/grep -v "bounds minlat" | %BINDIR%/grep -v "</osm>" > workfiles/great-britain-boundaries.txt
# cat workfiles/United-Kingdom.osm | %BINDIR%/grep -v "xml version" | %BINDIR%/grep -v "osm version" | %BINDIR%/grep -v "bounds minlat" | %BINDIR%/grep -v "</osm>" > workfiles/United-Kingdom.txt
# cat basefiles/United_Kingdom-osm-header.txt workfiles/United-Kingdom.txt > basefiles/united_Kingdom-boundaries.txt
head -3 workfiles/england-latest.osm > basefiles/england-osm-header.txt
head -3 workfiles/northern-ireland-latest.osm > basefiles/northern-ireland-osm-header.txt
head -3 workfiles/scotland-latest.osm > basefiles/scotland-osm-header.txt
head -3 workfiles/wales-latest.osm > basefiles/wales-osm-header.txt
# cat workfiles/northern-ireland-latest.osm | %BINDIR%/grep -v "xml version" | %BINDIR%/grep -v "osm version" | %BINDIR%/grep -v "bounds minlat" | %BINDIR%/grep -v "</osm>" > workfiles/northern-ireland-boundaries.txt
# cat workfiles/scotland-latest.osm | %BINDIR%/grep -v "xml version" | %BINDIR%/grep -v "osm version" | %BINDIR%/grep -v "bounds minlat" | %BINDIR%/grep -v "</osm>" > workfiles/scotland-ireland-boundaries.txt
# cat workfiles/wales-ireland-latest.osm | %BINDIR%/grep -v "xml version" | %BINDIR%/grep -v "osm version" | %BINDIR%/grep -v "bounds minlat" | %BINDIR%/grep -v "</osm>" > workfiles/wales-ireland-boundaries.txt
echo ===
echo prepare boundary text file for address based files
cat workfiles/england-latest.osm | %BINDIR%/grep -v "</osm>" > basefiles/england-boundaries.txt
cat workfiles/northern-ireland-latest.osm | %BINDIR%/grep -v "</osm>" > basefiles/northern-ireland-boundaries.txt
cat workfiles/scotland-latest.osm | %BINDIR%/grep -v "</osm>" > basefiles/scotland-boundaries.txt
cat workfiles/wales-latest.osm | %BINDIR%/grep -v "</osm>" > basefiles/wales-boundaries.txt

echo ===
echo Clean up
rm workfiles/*.o5m
rm workfiles/*latest.o*
rm workfiles/*.osm
rm workfiles/*.txt

