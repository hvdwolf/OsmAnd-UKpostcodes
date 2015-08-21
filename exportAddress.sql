-- Version 1.0, 20150816, Harry van der Wolf

.echo on


-- Export as OSM structured txt file to workfiles/<Country>_address_europe.txt

.echo off

--.output workfiles/UK_postcodes_address_europe.txt

-- We want to create a real address file. we do this by faking the postcode into a street.
-- As we need to merge it with real osm files we will make our node id negative, as that's 
-- the standard to describe your entries are not yet in OSM (yet).
-- England
.output workfiles/England_postcodes_address_europe.txt
select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>',
 '<tag k="addr:city" v="' || mpc.city || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city not null and country='England';

 -- Now select all postcodes that don't have a city (entry in postcodes but no entry in ukpostcodes)
  select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city is null  and country='England';
 
 -- Northern-Ireland
.output workfiles/Northern-Ireland_postcodes_address_europe.txt
select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>',
 '<tag k="addr:city" v="' || mpc.city || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city not null and country='Northern Ireland';

 -- Now select all postcodes that don't have a city (entry in postcodes but no entry in ukpostcodes)
 select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city is null  and country='Northern Ireland';
 
 -- Scotland
.output workfiles/Scotland_postcodes_address_europe.txt
select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>',
 '<tag k="addr:city" v="' || mpc.city || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city not null and country='Scotland';

 -- Now select all postcodes that don't have a city (entry in postcodes but no entry in ukpostcodes)
 select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city is null  and country='Scotland';
 
-- Wales
.output workfiles/Wales_postcodes_address_europe.txt
select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>',
 '<tag k="addr:city" v="' || mpc.city || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city not null and country='Wales';

 -- Now select all postcodes that don't have a city (entry in postcodes but no entry in ukpostcodes)
 select '<node id="-' || (ROWID + 1000000) || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="addr:postcode" v="' || mpc.postcode || '"/>', '<tag k="building" v="yes"/>',
 '<tag k="addr:housenumber" v="' || mpc.postcode || '"/>', '<tag k="addr:country" v="' || mpc.IsoCountry || '"/> </node>'
 from mypostcodes mpc where city is null  and country='Wales';
