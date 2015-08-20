@echo off

REM Version 1.0, 20150816, Harry van der Wolf

REM All windows files with .exe as I almost completely copy&paste the scripts

set BINDIR=bin
set TOOLSDIR=tools

REM Query DB and export to file
%BINDIR%\cat.exe exportPOI.sql | %TOOLSDIR%\sqlite3.exe workfiles\UK_postcodes.db
echo Done with the database actions
echo ===

REM Remove the | between the values
ECHO Remove separating pipe sign from the file
%BINDIR%\sed.exe "s+|+ +g"  workfiles\UK_postcodes_poi_europe.txt > workfiles\UK_postcodes_poi_europe2.txt
echo ===
echo Create osm file from our txt file
REM Add the correct header and tail to our osm file
%BINDIR%\cat.exe basefiles\osm-poi-header.txt workfiles\UK_postcodes_poi_europe2.txt basefiles\osm_close.txt > workfiles\UK_postcodes_poi_europe.osm
%TOOLSDIR%\osmconvert -v workfiles\UK_postcodes_poi_europe.osm --out-pbf > workfiles\UK_postcodes_poi_europe.osm.pbf

echo ===
echo Removing intermediate text files and osm file
%BINDIR%\rm.exe workfiles\*.txt
%BINDIR%\rm.exe workfiles\*.osm
echo ===
echo Done!
echo Now we need to create our postcode poi file with OsmAndMapCreator
