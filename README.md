# OsmAnd-UKpostcodes
Set of scripts to create UK-postcodes files for OsmAnd

Here are a few scripts to create either:
- a POI postcode file for the United Kingdom, being England, Northern Ireland, Scotland and Wales.
- or postcode address files per country.
 
POI postcode file UK_postcodes_poi_europe.obf<br>
Simply search for one of the 1.7 million postcodes in the UK via POI search.
The Postcodes are stored as user_defined -> postal_code.

\<Country\>_postcodes_address_europe.obf<br>
Since early 2015 or so OsmAnd can work with addresses (housenumbers) without a street. This make it possible to use (to fake) the postcode as housenumber. That's exactly what has been done with the address files.
If you know that a postcode os somewhere in a city, you can select that city and all postcodes will appear. If you don't know the city, you can directly search for the postcode.

Note that not all postcodes have a city assigned. This means that the total number of postcodes in the combined address files are roughly 56.000 less compared to the postcode_poi file.
