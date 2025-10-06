{{ config(materialized='table') }}

SELECT 
    county,
    state,
    replace(avg_tax_rate, '%', '')::float / 100  as avg_tax_rate,
    mdn_annual_tax_payment,
    source,
    ingestion_timestamp
from  moodyhome.raw.tax_rates_raw