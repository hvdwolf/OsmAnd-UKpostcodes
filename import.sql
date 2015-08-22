-- Version 1.0, 20150816, Harry van der Wolf

-- Set echo on to simply see what is going on
-- Remove if it annoys you
.echo on
-- First create our tables
create table if not exists ukpostcodes("prefix_PC" primary key, "Easting", "Northing", "Latitude", "Longitude", "City", "County");

-- Note that we create a field terminatedd as the word terminated is not an allowed field name
create table if not exists doogalpostcodes("Postcode" primary key, "Latitude", "Longitude", "Easting", "Northing", "GridRef", "County", "District", "Ward", "DistrictCode", "WardCode", "Country", "CountyCode", "Constituency", "Introduced", "Terminatedd", "Parish", "NationalPark", "Population", "Households", "Built_up_area", "Built_up_sub-division", "Lower_layer_super_output_area", "Rural_urban", "Region");

create table if not exists mypostcodes("Postcode" primary key, "Latitude", "Longitude","City","County","Country","IsoCountry");

-- Do the import of both CSV files
.mode csv
.headers on

-- ukpostcodes is only some 2800+ lines
.import 'workfiles\uk-postcode-database-csv.csv' ukpostcodes

-- doogalpostcodes takes long(er) as it contains more than 2.5 million lines
.import 'workfiles\postcodes.csv' doogalpostcodes

-- delete all records from doogal where the postcode is terminated(d) as they don't exist anymore
-- If a postcode is terminated this field has a date so we can simply delete the records that are not empty
delete from doogalpostcodes where Terminatedd <> "";

-- Make all prefix_PC fields 4 digits as some are three digits; add a space
-- If we don't we get unique errors due to AB1 being the same as AB11, AB12, etc. while 'AB ' is different
Update ukpostcodes set prefix_PC=(prefix_PC || ' ') where length(prefix_pc)=3;

-- Now insert what we need in our "mypostcodes" table
-- As the ukpostcode prefix table does not contain all all postcodes (too old?) we need to do a left join in our query
-- Otherwise we will miss roughly 56.000 postcodes
-- We need to trim a couple of fields as they can contain trailing spaces
insert into mypostcodes(Postcode,Latitude,Longitude,City,County,Country) select dpc.postcode, dpc.latitude, dpc.longitude, trim(ukpc.city), trim(dpc.county), trim(dpc.country) from doogalpostcodes dpc left join ukpostcodes ukpc on ukpc.prefix_pc=substr(dpc.postcode,1,4);
-- We now have 56.000 without city and county

-- For OSM we do need the ISO-3166-1 alpha-2 code for the country instead of the country name
-- In this case we are talking about the United Kingdom of Great Britain and Northern Ireland, which is UK
-- There is no further distinction 
-- (could have done in insert action, but split in 2 actions to make it clearer)
update mypostcodes set IsoCountry="UK";

-- Now drop our original tables as we don't need them anymore
drop table ukpostcodes;
drop table doogalpostcodes;

-- Now "vacuum" the database to optimize it and regain roughly 0.5 GB disk space
vacuum;

-- We are done with our Database import actions