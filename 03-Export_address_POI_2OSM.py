#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Version 1.0, 201607, Harry van der Wolf

# It requires roughly 2.5 GB to work on the temporary files
# Requirements: osmconvert, osmfilter

import os, sys, platform, sqlite3

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
	var_dict['path_sep'] = "\\"
	var_dict['OSMCONVERT'] = os.path.join(var_dict['TOOLSDIR'], "osmconvert.exe")
	var_dict['OSMFILTER'] = os.path.join(var_dict['TOOLSDIR'], "osmfilter.exe")
else:
	var_dict['path_sep'] = "/"
	var_dict['OSMCONVERT'] = os.path.join(var_dict['TOOLSDIR'], "osmconvert")
	var_dict['OSMFILTER'] = os.path.join(var_dict['TOOLSDIR'], "osmfilter")


#####################################################################
def addressExport(var_dict, country):
	DB_file = var_dict['WORKDIR'] + var_dict['path_sep'] + "UK_postcodes.db"
	connection = sqlite3.connect(DB_file)
	connection.text_factory = str  # allows utf-8 data to be stored
	cursor = connection.cursor()

	file_name = var_dict['WORKDIR'] + var_dict['path_sep'] + country + "_postcodes_address_europe.txt"
	txt_file = open(file_name, 'w')
	print("\n\n== Now exporting " + country + " to " + country + "_postcodes_address_europe.txt ==")
	# First write the postcodes that contain a city
	sql = "select '<node id=\"-' || ROWID || '\" lon=\"' || mpc.longitude || '\" lat=\"' || mpc.latitude || '\" visible=\"true\">',"
	sql += "'<tag k=\"addr:postcode\" v=\"' || mpc.postcode || '\"/>', '<tag k=\"building\" v=\"yes\"/>','<tag k=\"addr:housenumber\" v=\"' || mpc.postcode || '\"/>',"
	sql += "'<tag k=\"addr:city\" v=\"' || mpc.city || '\"/>', '<tag k=\"addr:country\" v=\"' || mpc.IsoCountry || '\"/> </node>'"
	csql = sql + "from mypostcodes mpc where city not null and country='" + country + "'"
	#print(sql)
	# fetch 1000 rows at a time
	cursor.execute(csql)
	while True:
		rows = cursor.fetchmany(1000)
		if not rows: break
		for row in rows:
			str_row = str(row)
			txt_file.write(str_row.replace("|"," ") + "\n")
	# Now write the postcodes that don't contain a city
	ncsql = sql + "from mypostcodes mpc where city is null and country='" + country + "'"
	cursor.execute(ncsql)
	while True:
		rows = cursor.fetchmany(1000)
		if not rows: break
		for row in rows:
			str_row = str(row)
			txt_file.write(str_row.replace("|"," ") + "\n")
	# Close file and database connection
	txt_file.close()
	connection.close()

def MergeConvert(var_dict, country):
	print("\n\n== Merging and Converting " + country + " ==")
	print("\n== Merge")
	if country == "Northern Ireland":
		filenames = [var_dict['BASEDIR'] + var_dict['path_sep'] + "northern-ireland-boundaries.txt", var_dict['WORKDIR'] + var_dict['path_sep'] + country + "_postcodes_address_europe.txt"]
		country= "Northern-Ireland"
	else:
		filenames = [var_dict['BASEDIR'] + var_dict['path_sep'] + country.lower()+ "-boundaries.txt", var_dict['WORKDIR'] + var_dict['path_sep'] + country + "_postcodes_address_europe.txt"]
	file_name = var_dict['WORKDIR'] + var_dict['path_sep'] + country + "_postcodes_address_europe.osm"
	with open(file_name, "w") as osm_file:
		for fname in filenames:
			with open(fname) as infile:
				# As we are dealing with big files we read line by line. It is definitely slower but
				# as we don't do this every day I don't care if it takes 1 minute longer
				# This way this script can even run on a raspberry pi
				for line in infile:
					osm_file.write(line)
	osm_file= open(file_name, 'a')
	osm_file.write("\n</osm>\n")
	osm_file.close()
	print("\n== Convert")
	country_str = var_dict['WORKDIR'] + var_dict['path_sep'] + country + "_postcodes_address_europe.osm"
	os.system(var_dict['OSMCONVERT'] + " -v --hash-memory=400-50-2 " + country_str + " --out-pbf > " + country_str + ".pbf")
	# Cleanup
	if country == "Northern-Ireland":
		os.remove(var_dict['WORKDIR'] + var_dict['path_sep'] + "Northern Ireland_postcodes_address_europe.txt")
	else:
		os.remove(var_dict['WORKDIR'] + var_dict['path_sep'] + country + "_postcodes_address_europe.txt")
	os.remove(country_str)

#####################################################################
# Create the postcode address files
# export to file
addressExport(var_dict, "England")
addressExport(var_dict, "Northern Ireland")
addressExport(var_dict, "Scotland")
addressExport(var_dict, "Wales")

# merge base files and convert
MergeConvert(var_dict, "England")
MergeConvert(var_dict, "Northern Ireland")
MergeConvert(var_dict, "Scotland")
MergeConvert(var_dict, "Wales")

# Create the postcode POI file
DB_file = var_dict['WORKDIR'] + var_dict['path_sep'] + "UK_postcodes.db"
connection = sqlite3.connect(DB_file)
connection.text_factory = str  # allows utf-8 data to be stored
cursor = connection.cursor()

file_name = var_dict['WORKDIR'] + var_dict['path_sep'] + "UK_postcodes_poi_europe.osm"
txt_file = open(file_name, 'w')
# First write the header
txt_file.write("<?xml version='1.0' encoding='UTF-8'?>")
txt_file.write("<osm version=\"0.6\" generator=\"osmfilter 1.4.0\">")
txt_file.write("	<bounds minlat=\"49.7\" minlon=\"-10.9\" maxlat=\"61.35131\" maxlon=\"2.0\"/>")

print("\n\n== Creating the POI file UK_postcodes_poi_europe.osm ==")
# First write the postcodes that contain a city
sql = "select '<node id=\"-' || ROWID || '\" lon=\"' || mpc.longitude || '\" lat=\"' || mpc.latitude || '\" visible=\"true\">',"
sql += "'<tag k=\"name\" v=\"' || mpc.postcode || '\"/>', '<tag k=\"user_defined_other\" v=\"postcode\"/> </node>' from mypostcodes mpc"
csql = sql + " where city not null"
# fetch 1000 rows at a time
cursor.execute(csql)
while True:
	rows = cursor.fetchmany(1000)
	if not rows: break
	for row in rows:
		str_row = str(row)
		txt_file.write(str_row.replace("|"," ") + "\n")
# Now write the postcodes that don't contain a city
ncsql = sql + " where city is null"
cursor.execute(ncsql)
while True:
	rows = cursor.fetchmany(1000)
	if not rows: break
	for row in rows:
		str_row = str(row)
		txt_file.write(str_row.replace("|"," ") + "\n")
osm_file= open(file_name, 'a')
osm_file.write("\n</osm>\n")
osm_file.close()

# Close file and database connection
txt_file.close()
connection.close()

print("\n\n== Convert POI file")
os.system(var_dict['OSMCONVERT'] + " -v --hash-memory=400-50-2 " + file_name + " --out-pbf > " + file_name + ".pbf")

