{{ config(materialized='table') }}

SELECT 
    mortgage_rate_type,
    rate_date,
    rate / 100 as mortgage_rate,
    source,
    ingestion_timestamp
from  moodyhome.raw.mortgage_rates