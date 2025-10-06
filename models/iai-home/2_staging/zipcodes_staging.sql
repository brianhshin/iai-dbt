{{ config(materialized='table') }}

select zipcode::string as zipcode, county from moodyhome.raw.zipcodes_ma
union all
select zipcode::string as zipcode, county_name as county from moodyhome.raw.zipcodes_ny