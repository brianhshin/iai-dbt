{{ config(materialized='table') }}

select * from moodyhome.staging.mortgage_rates_staging