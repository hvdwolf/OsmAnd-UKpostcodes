#!/bin/bash

# Version 1.0, 20150816, Harry van der Wolf

# All windows files with  as I almost completely copy&paste the scripts


# Create DB, import csv files, do the rest of the stuff
cat exportAddress.sql | sqlite3 workfiles/UK_postcodes.db
echo Done with the database actions
echo ===

# Remove the | between the values
echo Remove separating pipe sign from the files
# sed "s+|+ +g"  workfiles/UK_postcodes_address_europe.txt > workfiles/UK_postcodes_address_europe2.txt
sed "s+|+ +g"  workfiles/England_postcodes_address_europe.txt > workfiles/England_postcodes_address_europe2.txt
sed "s+|+ +g"  workfiles/Northern-Ireland_postcodes_address_europe.txt > workfiles/Northern-Ireland_postcodes_address_europe2.txt
sed "s+|+ +g"  workfiles/Scotland_postcodes_address_europe.txt > workfiles/Scotland_postcodes_address_europe2.txt
sed "s+|+ +g"  workfiles/Wales_postcodes_address_europe.txt > workfiles/Wales_postcodes_address_europe2.txt
echo ===
echo Create osm files from our txt files
echo On low memory  machines use the --hash-memory=400-50-2 option
# Add the correct header and tail to our osm file and merge them
# cat basefiles/united_kingdom-boundaries.txt workfiles/UK_postcodes_address_europe2.txt basefiles/osm_close.txt > workfiles/UK_postcodes_address_europe.osm
# $TOOLDIR/osmconvert -v workfiles/UK_postcodes_address_europe.osm --out-pbf > workfiles/UK_postcodes_address_europe.osm.pbf
cat basefiles/england-boundaries.txt workfiles/England_postcodes_address_europe2.txt basefiles/osm_close.txt > workfiles/England_postcodes_address_europe.osm
osmconvert -v --hash-memory=400-50-2 workfiles/England_postcodes_address_europe.osm --out-pbf > workfiles/England_postcodes_address_europe.osm.pbf
cat basefiles/northern-ireland-boundaries.txt workfiles/Northern-Ireland_postcodes_address_europe2.txt basefiles/osm_close.txt > workfiles/Northern-Ireland_postcodes_address_europe.osm
osmconvert -v --hash-memory=400-50-2 workfiles/Northern-Ireland_postcodes_address_europe.osm --out-pbf > workfiles/Northern-Ireland_postcodes_address_europe.osm.pbf
cat basefiles/scotland-boundaries.txt workfiles/Scotland_postcodes_address_europe2.txt basefiles/osm_close.txt > workfiles/Scotland_postcodes_address_europe.osm
osmconvert -v --hash-memory=400-50-2 workfiles/Scotland_postcodes_address_europe.osm --out-pbf > workfiles/Scotland_postcodes_address_europe.osm.pbf
cat basefiles/wales-boundaries.txt workfiles/Wales_postcodes_address_europe2.txt basefiles/osm_close.txt > workfiles/Wales_postcodes_address_europe.osm
osmconvert -v --hash-memory=400-50-2 workfiles/Wales_postcodes_address_europe.osm --out-pbf > workfiles/Wales_postcodes_address_europe.osm.pbf

echo ===
echo Removing intermediate text files and osm file
#rm workfiles/*.txt
#rm workfiles/*.osm
echo ===
echo Done!
echo Now we need to create our postcode poi file with OsmAndMapCreator
