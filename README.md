# OsmAnd-UKpostcodes
Set of scripts to create UK-postcodes files for OsmAnd.

## No longer used.
This archive repo contains the scripts to create both address and a Postcode POI file. The address files are not usefull anymore. They are hard to create and very slow. The new general search screen in Osmand is ideal for the POI OBF. Simply type something like 'ct14 8eu' or 'EX34 7EX' (uppercase or lowercase), and it will find the postcode.<br>


Here are a few scripts to create either:
- a POI postcode file for the United Kingdom, being England, Northern Ireland, Scotland and Wales.
- or a postcode address files per country: one for England, for Scotland, for Northern-Ireland and for Wales.

Note that the scripts do not contain the final OsmAndMapCreator step. I leave that up to you (for now). For the POI file you only need to create a POI index. For the address file(s) you need to create a map and address index.


## With regard to the generated files:<br> 
### POI postcode file United-Kingdom_postcodes_poi_europe.obf<br>
Simply search for one of the 1.74 million postcodes in the UK via POI search.
The Postcodes are stored as user_defined_other_postcode. If you want to display them (always) on the map, use that POI filter.


### \<Country\>_postcodes_address_europe.obf<br>
Since early 2015 or so OsmAnd can work with addresses (housenumbers) without a street. This makes it possible to use (or actually to fake) the postcode as housenumber. That's exactly what has been done with the address files. You can either:
- search on a postcode in a city/neighborhood as if it is a housenumber without street
- and directly as postcode as a "Search more villages/postcode" like in all other address files.

If you know that a postcode is somewhere in a city or suburb, you can select that city and all postcodes will appear. If you don't know the city, you can directly search for the postcode from the address screen. When you start typing a postcode like `CB1 0AH` (or `cb1 0ah`), and the "city name" is not in the index, you get the "Search more villages/postcode".

Note that not all postcodes have a city assigned (about 56.000). This means that:
- Some postcodes can't be found by city, even though you know it is in that city.
- the total number of postcodes in the combined address files are roughly 1500 less (on 1.74 million) compared to the postcode_poi file as they simply can't be assigned. This might change in the future but this data is currently not available.

Requirements Linux/OS X/BSD: unzip, wget and sqlite3. Use your favorite package manager.
