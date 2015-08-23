-- Version 1.0, 20150821, Harry van der Wolf

.echo on


-- Export to POI file as txt file to workfiles/Gb_postcodes_poi_europe.txt

.echo off

.output workfiles/UK_postcodes_poi_europe.txt

-- First select all postcodes that do have a city (link between postcodes and ukpostcodes)
select '<node id="-' || ROWID || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="name" v="' || mpc.postcode || '"/>',
 '<tag k="user_defined" v="postal_code"/> </node>' from mypostcodes mpc
 where city not null ;

 -- Now select all postcodes that don't have a city (entry in postcodes but no entry in ukpostcodes)
 select '<node id="-' || ROWID || '" lon="' || mpc.longitude || '" lat="' || mpc.latitude || '" visible="true">',
 '<tag k="name" v="' || mpc.postcode || '"/>',
 '<tag k="user_defined" v="postal_code"/> </node>' from mypostcodes mpc
 where city is null ;
