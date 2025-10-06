{{ config(materialized='table') }}

SELECT 
    t.$1:county::string as county,
    t.$1:state::string as state,
    t.$1:average_effective_property_tax_rate::string as avg_tax_rate,
    t.$1:median_annual_property_tax_payment::number as mdn_annual_tax_payment,
    t.$1:source::string as source,
    t.$1:ingestion_timestamp::timestamp as ingestion_timestamp
from  @moodyhome.utils.moodyhome_s3_stage (file_format => 'json_format') as t
where t.$1:source = 'smartasset'