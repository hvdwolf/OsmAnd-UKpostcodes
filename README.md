# OsmAnd-UK postcodes
Script to create a UK-postcodes POI obf file for OsmAnd.

**As of September 2017 I dropped the address files.**<br>
They are hard to create and very slow. The new general search screen in Osmand is ideal for the POI OBF. Simply type something like 'ct14 8eu' or 'EX34 7EX' (uppercase or lowercase) in the white bar in the top of the search screen, and it will find the postcode(s).<br>

Note that the script does not contain the final OsmAndMapCreator step. For the POI file you only need to create a POI index.

## How to use
### POI postcode file United-Kingdom_postcodes_poi_europe.obf
Simply search for one of the 1.74 million postcodes in the UK via the white bar in the top of the search screen.
The Postcodes are stored as user_defined_other_postcode. If you want to display them (always) on the map, use that POI filter.
*Note*: These postcodes are POIs. It means that you can't use the postcode address search from the address pane. The postcodes in that screen are real postcodes connected to addresses.<br>
My postcodes POI file contains POIs with coordinates with the name of a postcode. Actually the same as searching for "Tower Bridge", "Eiffel tower" or likewise POIs.


## How to create
Requirements:
* Linux/OS X/BSD: python (standard installed) and sqlite3 (use your favorite package manager)
* Windows: Python
* OsmAndMapCreator (http://download.osmand.net/latest-night-build/OsmAndMapCreator-main.zip)

Steps:
* Clone my repository or download the zip from here
* Open a terminal (Linux) or command box (Windows)
* Inside the folder where you cloned or unzipped the zip file do:
  - Windows: `python 01_create_postcode_osm_pbf.py`
  - Linux: `./01_create_postcode_osm_pbf.py`

After some time you will find inside the "workfiles" the file "UK_postcodes_poi_europe.osm.pbf".

Now you need to create the OsmAnd obf file in OsmAndMapCreator or onthe command line using OsmAndMapCreator utilities script:
prerequisites:
* Using OsOsmAndMapCreator you need to open the OsmAndMapCreator.bat or OsmAndMapCreator.sh
* Using the utilities script you need to open the utilities.sh or utilities.bat
* Change the value "-Xmx720M" to something like "-Xmx2720M" (at least 2500M)
* Save the file.

**Using OsmAndMapCreator**
* Start the OsmAndMapCreator.bat or OsmAndMapCreator.sh
* Switch off all map options except "build POI index"
* Open the file "UK_postcodes_poi_europe.osm.pbf" from the "workfiles" folder.
* After some time you will have the "Uk_postcodes_poi_europe.obf" of around 98~100MB in the osmand data folder. By default this is the folder "osmand" in your home folder. Copy that obf file into your OsmAnd files folder where your other maps files are also located.

**Using the utilities script**
* Edit the "02_create_postcode_map.py" script
* Change the OMC variable to where you installed/unzipped your OsmAndMapCreator
* Inside the folder where you cloned or unzipped the zip file do:
  - Windows: `python 02_create_postcode_map.py`
  - Linux: `./02_create_postcode_map.py`
  - After some time you will have the "Uk_postcodes_poi_europe.obf" of around 98~100MB in this folder where you started the script
