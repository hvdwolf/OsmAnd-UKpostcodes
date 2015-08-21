@echo off

REM Version 1.0, 20150816, Harry van der Wolf

REM All windows files with .exe as I almost completely copy&paste the scripts

set BINDIR=bin
set toolsdir=tools

mkdir workfiles

REM Get the postcode zips
REM Below the UK postcodes database. It only contains the prefix
%BINDIR%\wget.exe http://www.ukpostcodes.org/downloads/uk-postcode-database-csv.zip -O workfiles\uk-postcode-database-csv.zip
%BINDIR%\unzip.exe -o workfiles\uk-postcode-database-csv.zip -d workfiles

REM Below the "Doogal" (Cris Bell) UK postcodes download
%BINDIR%\wget.exe http://www.doogal.co.uk/files/postcodes.zip -O workfiles\postcodes.zip
%BINDIR%\unzip.exe -o workfiles\postcodes.zip -d workfiles
echo =====
echo Remove the header from the the postcodes.csv file
echo =====
%BINDIR%\grep.exe -v "Introduced,Terminated" workfiles\postcodes.csv > workfiles\postcodes2.csv
%BINDIR%\mv.exe -f workfiles\postcodes2.csv workfiles\postcodes.csv

echo ===== 
echo Your postcode files are now ready for further processing in sqlite.