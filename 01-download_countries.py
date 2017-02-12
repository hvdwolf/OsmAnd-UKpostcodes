#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Version 1.1, 20170213, Harry van der Wolf

# It requires roughly 2.5 GB to work on the temporary files
# Requirements: wget, osmconvert, osmfilter, zlib-dev

import os, sys, platform

try:
        # For python3
        from urllib.request import urlopen
        python3 = "YES"
except ImportError:
        # Use python2
        from urllib2 import urlopen
        python3 = "NO"

##########################################################
# download function
def pbf_download( var_dict, country ):
	map_url = "http://download.geofabrik.de/europe/great-britain/"
	if country == "ireland-and-northern-ireland":
		map_url = "http://download.geofabrik.de/europe/"
	map_url +=  country
	map_url += "-latest.osm.pbf"
	#print(map_url)
	countrymap = country
	countrymap += "-latest.osm.pbf"

	print("\n\nDownloading " + countrymap)
	mapfile = urlopen( map_url )
	with open(os.path.join(var_dict['WORKDIR'], countrymap),'wb') as output:
		output.write(mapfile.read())

def country_convert(var_dict, country ):
	print("\n== Converting " + country + " ==")
	wf_country_str = os.path.join(var_dict['WORKDIR'], country + "-latest")
	if country == "ireland-and-northern-ireland":
		os.system(var_dict['OSMCONVERT'] + " -v " + wf_country_str + ".osm.pbf -B=" + os.path.join(var_dict['BASEDIR'], "northern_ireland.poly") + " --hash-memory=400-50-2 --drop-author --drop-version  --out-o5m > " +  os.path.join(var_dict['WORKDIR'], "northern-ireland-latest.o5m") )
		# Now the orginal osm.pbf can be removed
		os.remove(wf_country_str + ".osm.pbf")
		wf_country_str = os.path.join(var_dict['WORKDIR'], "northern-ireland-latest")
	else:
		os.system(var_dict['OSMCONVERT'] + " -v " + wf_country_str + ".osm.pbf --hash-memory=400-50-2 --drop-author --drop-version  --out-o5m > " + wf_country_str + ".o5m")
		# Now the orginal osm.pbf can be removed
		os.remove(wf_country_str + ".osm.pbf")
	os.system(var_dict['OSMFILTER'] + ' -v ' + wf_country_str + '.o5m --hash-memory=400-50-2 --keep="boundary=administrative=6 =8 =10 place=" --drop="highway= waterway= route=" --out-osm -o=' + wf_country_str + '.osm')
	# Now the orginal o5m can be removed
	os.remove(wf_country_str + '.o5m')

	# Now create the boundary files
	print("== prepare boundary text file " + country + "-boundaries.txt for address based files ==")
	osm_file = wf_country_str + '.osm'
	if country == "ireland-and-northern-ireland":
		write_file = os.path.join(var_dict['BASEDIR'], "northern-ireland-boundaries.txt")
	else:
		write_file = os.path.join(var_dict['BASEDIR'], country + "-boundaries.txt")
	bound_file = open(write_file, 'w')
	with open(osm_file) as readfile:
		for line in readfile:
			if not "</osm>" in line:
				bound_file.write(line)
	bound_file.close()

##########################################################


# Initialize file paths
realfile_dir  = os.path.dirname(os.path.abspath(__file__))

# Use dictionary for our variables
var_dict = {}
var_dict['TOOLSDIR'] = os.path.join(realfile_dir, "tools")
var_dict['BASEDIR'] = os.path.join(realfile_dir, "basefiles")
var_dict['WORKDIR'] = os.path.join(realfile_dir, "workfiles")
if not os.path.exists(var_dict['WORKDIR']):
    os.makedirs(var_dict['WORKDIR'])


OSplatform = platform.system()
# check if the osmc tools exist
if OSplatform == "Windows":
	var_dict['OSMCONVERT'] = os.path.join(var_dict['TOOLSDIR'], "osmconvert.exe")
	var_dict['OSMFILTER'] = os.path.join(var_dict['TOOLSDIR'], "osmfilter.exe")
else:
	# for linux, *bsd, Mac OS /X, etc.
	print("== First  make sure we have our tools and otherwise download and compile them ==")
	os.chdir(var_dict['TOOLSDIR'])
	if not os.path.isfile("osmconvert"):
		print("\ndownloading and compiling osmconvert")
		# do a symple system call
		os.system("wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert")
	if not os.path.isfile("osmfilter"):
		#os.chdir(TOOLSDIR)
		print("\ndownloading and compiling osmfilter")
		# do a symple system call
		os.system("wget -O - http://m.m.i24.cc/osmfilter.c |cc -x c - -O3 -o osmfilter")
	# Make sure we are back in our normal folder
	os.chdir(realfile_dir)
	var_dict['OSMCONVERT'] = os.path.join(var_dict['TOOLSDIR'], "osmconvert")
	var_dict['OSMFILTER'] = os.path.join(var_dict['TOOLSDIR'], "osmfilter")

print("\n\n== Downloading England, Ireland-Northern Ireland, Scotland and Wales ==\n")
pbf_download( var_dict, "england" )
pbf_download( var_dict, "scotland" )
pbf_download( var_dict, "wales" )
pbf_download( var_dict, "ireland-and-northern-ireland" )
print("\n\nDone downloading the countries")

print("\n\nConverting the countries.")
print("Also remove broken ways, nodes which result in OsmandMapCreator crashes due to double ids.")
print("On low memory  machines (<= 1GB) use the --hash-memory=400-50-2 option.")
os.chdir(var_dict['TOOLSDIR'])

country_convert(var_dict, "england" )
country_convert(var_dict, "scotland" )
country_convert(var_dict, "wales" )
country_convert(var_dict, "ireland-and-northern-ireland" )

print("\n\nAll done.")
print("You should now proceed with 02-cr_postcodes_db.py")


