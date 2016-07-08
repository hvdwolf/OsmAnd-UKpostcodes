-- Version 2.0, 201607, Harry van der Wolf
-- Version 1.0, 20150816, Harry van der Wolf

-- Set echo on to simply see what is going on
-- Remove if it annoys you
.echo on
-- First create our tables
create table if not exists PostcodeDistrictsSplit("prefix_pc","town");
-- Note that we create a field terminatedd as the word terminated is not an allowed field name
create table if not exists doogalpostcodes("Postcode" primary key, "InUse","Latitude", "Longitude", "Easting", "Northing", "GridRef", "County", "District", "Ward", "DistrictCode", "WardCode", "Country", "CountyCode", "Constituency", "Introduced", "Terminatedd", "Parish", "NationalPark", "Population", "Households", "Built_up_area", "Built_up_sub-division", "Lower_layer_super_output_area", "Rural_urban", "Region", "Altitude");

create table if not exists mypostcodes("Postcode" primary key, "Latitude", "Longitude","City","County","Country","IsoCountry");

-- Do the import of both CSV files
.mode csv
.headers on

-- district postcodes
.import 'workfiles/PostcodeDistrictsSplit.csv' PostcodeDistrictsSplit

-- Delete "double" records from PostcodeDistrictsSplit
delete from PostcodeDistrictsSplit where rowid not in (select min(rowid) from PostcodeDistrictsSplit group by prefix_pc);

-- doogalpostcodes takes long(er) as it contains more than 2.5 million lines
.import 'workfiles/postcodes.csv' doogalpostcodes

-- delete all records from doogal where the postcode is terminated(d) as they don't exist anymore
-- If a postcode is terminated this field has a date so we can simply delete the records that are not empty
-- delete from doogalpostcodes where Terminatedd <> "";
delete from doogalpostcodes where InUse = "No";

-- Make all prefix_PC fields 4 digits as some are three digits; add a space
-- If we don't we get unique errors due to AB1 being the same as AB11, AB12, etc. while 'AB ' is different
Update PostcodeDistrictsSplit set prefix_pc=(prefix_pc || ' ') where length(prefix_pc)=3;

-- Now insert what we need in our "mypostcodes" table

-- We need to trim a couple of fields as they can contain trailing spaces
insert into mypostcodes(Postcode,Latitude,Longitude,City,County,Country) select dpc.postcode, dpc.latitude, dpc.longitude, trim(PCDS.town), trim(dpc.county), trim(dpc.country) from doogalpostcodes dpc left join PostcodeDistrictsSplit PCDS on PCDS.prefix_pc=substr(dpc.postcode,1,4);

-- We now have 56.000 without city and county

-- For OSM we do need the ISO-3166-1 alpha-2 code for the country instead of the country name
-- In this case we are talking about the United Kingdom of Great Britain and Northern Ireland, which is UK
-- There is no further distinction 
-- (could have done in insert action, but split in 2 actions to make it clearer)
update mypostcodes set IsoCountry="UK";

-- Now drop our original tables as we don't need them anymore
--drop table doogalpostcodes;

-- Now "vacuum" the database to optimize it and regain roughly 0.5 GB disk space
--vacuum;

-- We are done with our Database import actions
