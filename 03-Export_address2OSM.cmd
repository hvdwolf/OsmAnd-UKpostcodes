@echo off

REM Version 1.0, 20150816, Harry van der Wolf

REM All windows files with .exe as I almost completely copy&paste the scripts

set BINDIR=bin
set TOOLSDIR=tools

REM Create DB, import csv files, do the rest of the stuff
%BINDIR%\cat.exe exportAddress.sql | %TOOLSDIR%\sqlite3.exe workfiles\UK_postcodes.db
echo Done with the database actions
echo ===

REM Remove the | between the values
ECHO Remove separating pipe sign from the files
REM %BINDIR%\sed.exe "s+|+ +g"  workfiles\UK_postcodes_address_europe.txt > workfiles\UK_postcodes_address_europe2.txt
%BINDIR%\sed.exe "s+|+ +g"  workfiles\England_postcodes_address_europe.txt > workfiles\England_postcodes_address_europe2.txt
%BINDIR%\sed.exe "s+|+ +g"  workfiles\Northern-Ireland_postcodes_address_europe.txt > workfiles\Northern-Ireland_postcodes_address_europe2.txt
%BINDIR%\sed.exe "s+|+ +g"  workfiles\Scotland_postcodes_address_europe.txt > workfiles\Scotland_postcodes_address_europe2.txt
%BINDIR%\sed.exe "s+|+ +g"  workfiles\Wales_postcodes_address_europe.txt > workfiles\Wales_postcodes_address_europe2.txt
echo ===
echo Create osm files from our txt files
REM Add the correct header and tail to our osm file and merge them
REM %BINDIR%\cat.exe basefiles\united_kingdom-boundaries.txt workfiles\UK_postcodes_address_europe2.txt basefiles\osm_close.txt > workfiles\UK_postcodes_address_europe.osm
REM %TOOLSDIR%\osmconvert -v workfiles\UK_postcodes_address_europe.osm --out-pbf > workfiles\UK_postcodes_address_europe.osm.pbf
%BINDIR%\cat.exe basefiles\england-boundaries.txt workfiles\England_postcodes_address_europe2.txt basefiles\osm_close.txt > workfiles\England_postcodes_address_europe.osm
%TOOLSDIR%\osmconvert -v workfiles\England_postcodes_address_europe.osm --out-pbf > workfiles\England_postcodes_address_europe.osm.pbf
%BINDIR%\cat.exe basefiles\northern-Ireland-boundaries.txt workfiles\Northern-Ireland_postcodes_address_europe2.txt basefiles\osm_close.txt > workfiles\Northern-Ireland_postcodes_address_europe.osm
%TOOLSDIR%\osmconvert -v workfiles\Northern-Ireland_postcodes_address_europe.osm --out-pbf > workfiles\Northern-Ireland_postcodes_address_europe.osm.pbf
%BINDIR%\cat.exe basefiles\scotland-boundaries.txt workfiles\Scotland_postcodes_address_europe2.txt basefiles\osm_close.txt > workfiles\Scotland_postcodes_address_europe.osm
%TOOLSDIR%\osmconvert -v workfiles\Scotland_postcodes_address_europe.osm --out-pbf > workfiles\Scotland_postcodes_address_europe.osm.pbf
%BINDIR%\cat.exe basefiles\wales-boundaries.txt workfiles\Wales_postcodes_address_europe2.txt basefiles\osm_close.txt > workfiles\Wales_postcodes_address_europe.osm
%TOOLSDIR%\osmconvert -v workfiles\Wales_postcodes_address_europe.osm --out-pbf > workfiles\Wales_postcodes_address_europe.osm.pbf

echo ===
echo Removing intermediate text files and osm file
%BINDIR%\rm.exe workfiles\*.txt
%BINDIR%\rm.exe workfiles\*.osm
echo ===
echo Done!
echo Now we need to create our postcode poi file with OsmAndMapCreator
