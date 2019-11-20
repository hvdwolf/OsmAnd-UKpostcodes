#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Version 1.0, 201911, Harry van der Wolf

# You can use this script to do a simple command line build of the postcodes file, or simply do it via the OsmAndMapCreator GUI.

import os, sys, platform, shutil
if sys.version_info<(3,0,0):
	# Fall back to Python 2's urllib2
	from urllib2 import urlopen
else:
	# For Python 3.0 and later
	from urllib.request import urlopen

#Full path to the OsmAndMapCreator folder
# For example Linux or Mac OS/X
OMC = "/media/harryvanderwolf/64GB/OpenStreetMap/OsmAndMapCreator"
# For example for windows; Note the double backslashes
#OMC = "C:\\Users\\harryvanderwolf\\Downloads\\OpenStreetMap-Osmadm\\OsmAndMapCreator"


##### DO NOT CHANGE BELOW THIS Line #####
# Initialize file paths
realfile_dir  = os.path.dirname(os.path.abspath(__file__))

# Use dictionary for our variables
WORKDIR = os.path.join(realfile_dir, "workfiles")
if not os.path.exists(WORKDIR):
    os.makedirs(WORKDIR)


OSplatform = platform.system()
if OSplatform == "Windows":
	path_sep = "\\"
	#INSP = 'inspector.bat'
	UTIL = 'utilities.bat'
else:
	path_sep = "/"
	#INSP = 'inspector.sh'
	UTIL = 'utilities.sh'

# Copy our batch.xml to the OsmAndMapCreator folder 
shutil.copyfile( "./UK_postcodes_batch.xml" , os.path.join(OMC,'UK_postcodes_batch.xml') );
# Copy our previously created UK_postcodes_poi_europe.osm.pbf to the OsmAndMapCreator folder
shutil.copyfile( os.path.join(WORKDIR,'UK_postcodes_poi_europe.osm.pbf'), os.path.join(OMC,'UK_postcodes_poi_europe.osm.pbf') );

# Now  make the POI map
print("\n\n== Now  make the POI UK_postcode map  ==")
os.chdir(OMC)
print("\n== Now  running OsmAndMapCreator utilities to create the UK_postcodes_poi_europe.obf POI map ==")
os.system(os.path.join(OMC,UTIL) + ' generate-poi UK_postcodes_poi_europe.osm.pbf')
shutil.move(os.path.join(OMC,'UK_postcodes_poi_europe.obf'), os.path.join(WORKDIR,'UK_postcodes_poi_europe.obf'))


