@echo off

REM Version 1.0, 20150816, Harry van der Wolf

REM You don't need to run this script. I added the boundary osm files already in the workfiles folder
REM Only if you think that the administrative boundaries for the country and counties are not correct or updated,
REM you might need to run this script again.
REM It requires roughly 2.5 GB to work on the temporary files
REM All windows files with .exe as I almost completely copy&paste the scripts


set BINDIR=bin
set TOOLSDIR=tools

mkdir workfiles

echo "Downloading England, Ireland-Northern Ireland, Scotland and Wales"
REM echo Downloading Great Britain and Ireland-Northern Ireland.
echo Later we will get rid of Ireland as we only need Northern Ireland for our United Kingdom postcodes
echo 
%BINDIR%\wget.exe http://download.geofabrik.de/europe/great-britain/england-latest.osm.pbf -O workfiles\england-latest.osm.pbf
%BINDIR%\wget.exe http://download.geofabrik.de/europe/great-britain/scotland-latest.osm.pbf -O workfiles\scotland-latest.osm.pbf
%BINDIR%\wget.exe http://download.geofabrik.de/europe/great-britain/wales-latest.osm.pbf -O workfiles\wales-latest.osm.pbf
REM %BINDIR%\wget.exe http://download.geofabrik.de/europe/great-britain-latest.osm.pbf -O workfiles\great-britain-latest.osm.pbf
%BINDIR%\wget.exe http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.osm.pbf -O workfiles\ireland-and-northern-ireland-latest.osm.pbf
echo ===

echo Converting the countries
echo Also remove broken ways, nodes, (multi)polygons which result in OsmandMapCreator crashes due to double ids
%TOOLSDIR%\osmconvert.exe -v workfiles\england-latest.osm.pbf --drop-author --drop-version --complex-ways --drop-broken-refs --out-o5m > workfiles\england-latest.o5m
%TOOLSDIR%\osmconvert.exe -v workfiles\scotland-latest.osm.pbf --drop-author --drop-version --complex-ways --drop-broken-refs --complex-ways --drop-broken-refs --out-o5m > workfiles\scotland-latest.o5m
%TOOLSDIR%\osmconvert.exe -v workfiles\wales-latest.osm.pbf --drop-author --drop-version --complex-ways --drop-broken-refs --out-o5m > workfiles\wales-latest.o5m
REM %TOOLSDIR%\osmconvert.exe -v workfiles\great-britain-latest.osm.pbf --drop-author --drop-version --complex-ways --drop-broken-refs --out-o5m > workfiles\great-britain-latest.o5m
echo ===
echo Get rid of Ireland now from the combined Ireland-Northern-Ireland file
%TOOLSDIR%\osmconvert.exe -v workfiles\ireland-and-northern-ireland-latest.osm.pbf -B=basefiles\northern_ireland.poly --drop-author --drop-version --complex-ways --drop-broken-refs --out-o5m > workfiles\northern-ireland-latest.o5m
REM echo ===
REM echo now First merge them with osmconvert to get rid of double entries
REM %TOOLSDIR%\osmconvert.exe -v workfiles\great-britain-latest.o5m workfiles\northern-ireland-latest.o5m --out-o5m > workfiles\United-Kingdom.o5m

echo ===
echo Filtering the country o5m files to get the osm header and the boundaries  
%TOOLSDIR%\osmfilter.exe -v workfiles\england-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles\england-latest.osm
%TOOLSDIR%\osmfilter.exe -v workfiles\scotland-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles\scotland-latest.osm
%TOOLSDIR%\osmfilter.exe -v workfiles\wales-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles\wales-latest.osm
REM %TOOLSDIR%\osmfilter.exe -v workfiles\great-britain-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --keep-ways= --keep-nodes= --keep-relations= --out-osm -o=workfiles\great-britain-latest.osm
%TOOLSDIR%\osmfilter.exe -v workfiles\northern-ireland-latest.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --drop=highway --out-osm -o=workfiles\northern-ireland-latest.osm
REM %TOOLSDIR%\osmfilter.exe -v workfiles\United-Kingdom.o5m --keep="boundary=administrative place=" --keep-ways-relations="boundary=administrative" --keep-ways= --keep-nodes= --keep-relations= --out-osm -o=workfiles\United-Kingdom.osm

echo ===
echo prepare osm header text file for optional POI file
REM %BINDIR%\cat.exe workfiles\great-britain-latest.osm | %BINDIR%\grep.exe -v "xml version" | %BINDIR%\grep.exe -v "osm version" | %BINDIR%\grep.exe -v "bounds minlat" | %BINDIR%\grep.exe -v "</osm>" > workfiles\great-britain-boundaries.txt
REM %BINDIR%\cat.exe workfiles\United-Kingdom.osm | %BINDIR%\grep.exe -v "xml version" | %BINDIR%\grep.exe -v "osm version" | %BINDIR%\grep.exe -v "bounds minlat" | %BINDIR%\grep.exe -v "</osm>" > workfiles\United-Kingdom.txt
REM %BINDIR%\cat.exe basefiles\United_Kingdom-osm-header.txt workfiles\United-Kingdom.txt > basefiles\united_Kingdom-boundaries.txt
%BINDIR%\head.exe -3 workfiles\england-latest.osm > basefiles\england-osm-header.txt
%BINDIR%\head.exe -3 workfiles\northern-ireland-latest.osm > basefiles\northern-ireland-osm-header.txt
%BINDIR%\head.exe -3 workfiles\scotland-latest.osm > basefiles\scotland-osm-header.txt
%BINDIR%\head.exe -3 workfiles\wales-latest.osm > basefiles\wales-osm-header.txt
REM %BINDIR%\cat.exe workfiles\northern-ireland-latest.osm | %BINDIR%\grep.exe -v "xml version" | %BINDIR%\grep.exe -v "osm version" | %BINDIR%\grep.exe -v "bounds minlat" | %BINDIR%\grep.exe -v "</osm>" > workfiles\northern-ireland-boundaries.txt
REM %BINDIR%\cat.exe workfiles\scotland-latest.osm | %BINDIR%\grep.exe -v "xml version" | %BINDIR%\grep.exe -v "osm version" | %BINDIR%\grep.exe -v "bounds minlat" | %BINDIR%\grep.exe -v "</osm>" > workfiles\scotland-ireland-boundaries.txt
REM %BINDIR%\cat.exe workfiles\wales-ireland-latest.osm | %BINDIR%\grep.exe -v "xml version" | %BINDIR%\grep.exe -v "osm version" | %BINDIR%\grep.exe -v "bounds minlat" | %BINDIR%\grep.exe -v "</osm>" > workfiles\wales-ireland-boundaries.txt
echo ===
echo prepare boundary text file for address based files
%BINDIR%\cat.exe workfiles\england-latest.osm | %BINDIR%\grep.exe -v "</osm>" > basefiles\england-boundaries.txt
%BINDIR%\cat.exe workfiles\northern-ireland-latest.osm | %BINDIR%\grep.exe -v "</osm>" > basefiles\northern-ireland-boundaries.txt
%BINDIR%\cat.exe workfiles\scotland-latest.osm | %BINDIR%\grep.exe -v "</osm>" > basefiles\scotland-boundaries.txt
%BINDIR%\cat.exe workfiles\wales-latest.osm | %BINDIR%\grep.exe -v "</osm>" > basefiles\wales-boundaries.txt

echo ===
echo Clean up
%BINDIR%\rm workfiles\*.o5m
%BINDIR%\rm workfiles\*latest.o*
%BINDIR%\rm workfiles\*.osm
%BINDIR%\rm workfiles\*.txt

