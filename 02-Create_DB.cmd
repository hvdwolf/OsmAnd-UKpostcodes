@echo off

REM Version 1.0, 20150816, Harry van der Wolf

REM All windows files with .exe as I almost completely copy&paste the scripts

set BINDIR=bin
set TOOLSDIR=tools

REM First remove any existing Database
echo Remove existing database as I want to start clean
echo ===

%BINDIR%\rm.exe workfiles\UK_postcodes.db
REM Create DB, import csv files, do the rest of the stuff
%BINDIR%\cat.exe import.sql | %TOOLSDIR%\sqlite3.exe workfiles\UK_postcodes.db

Echo Now we can get rid of our csv files as especially the postcodes.csv is 600MB+ in size
%BINDIR%\rm.exe workfiles\*.csv
%BINDIR%\rm.exe workfiles\*.zip

echo ===
echo Done importing! Now you can continue with the 03 script