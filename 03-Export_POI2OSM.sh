#!/bin/bash

# Version 1.0, 20150821, Harry van der Wolf

# All windows files with .exe as I almost completely copy&paste the scripts


# Query DB and export to file
cat exportPOI.sql | sqlite3 workfiles/UK_postcodes.db
echo Done with the database actions
echo ===

# Remove the | between the values
echo Remove separating pipe sign from the file
sed "s+|+ +g"  workfiles/UK_postcodes_poi_europe.txt > workfiles/UK_postcodes_poi_europe2.txt
echo ===
echo Create osm file from our txt file
echo On low memory  machines use the --hash-memory=400-50-2 option
# Add the correct header and tail to our osm file
cat basefiles/osm-poi-header.txt workfiles/UK_postcodes_poi_europe2.txt basefiles/osm_close.txt > workfiles/UK_postcodes_poi_europe.osm
osmconvert -v --hash-memory=400-50-2 workfiles/UK_postcodes_poi_europe.osm --out-pbf > workfiles/United-Kingdom_postcodes_poi_europe.osm.pbf

echo ===
echo Removing intermediate text files and osm file
#rm workfiles/*.txt
#rm workfiles/*.osm
echo ===
echo Done!
echo Now we need to create our postcode poi file with OsmAndMapCreator
