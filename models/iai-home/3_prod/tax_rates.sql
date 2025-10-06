{{ config(materialized='table') }}

select * from moodyhome.staging.tax_rates_staging