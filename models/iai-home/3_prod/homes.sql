{{ config(materialized='table') }}

with mortgage_rate as (
    select 
        current_date() as current_rate_date,
        mortgage_rate 
    from moodyhome.staging.mortgage_rates where mortgage_rate_type = 'va_30' order by rate_date desc limit 1
    )
select 
    h.id,
    h.price,
    h.url,
    h.days_on_zillow,
    h.status_type,
    h.home_type,
    h.listed_date,
    h.sold_date,
    h.address,
    h.street,
    h.city,
    h.state,
    h.zipcode,
    z.county,
    h.beds,
    h.baths,
    h.latitude,
    h.longitude,
    h.photos,
    h.img_src,
    t.avg_tax_rate,
    t.mdn_annual_tax_payment,
    h.price * t.avg_tax_rate as projected_annual_tax_payment,
    date_trunc('week', current_timestamp())::date as current_rate_date,
    m.mortgage_rate,
    0 as down_payment,
    30 as year_term,
    projected_annual_tax_payment / 12 as monthly_tax_payment,
    (
        (h.price - down_payment) * 
        (mortgage_rate / 12) * POWER(1 + mortgage_rate / 12, year_term * 12)) /
        (POWER(1 + mortgage_rate / 12, year_term * 12) - 1
    ) AS monthly_mortgage_payment,
    round(monthly_tax_payment + monthly_mortgage_payment) as total_monthly_payment,
    h.source,
    h.ingestion_timestamp
    
    
from moodyhome.staging.homes as h
left join moodyhome.staging.zipcodes as z on h.zipcode = z.zipcode
left join moodyhome.staging.taxrates as t on z.county = t.county
left join mortgage_rate as m on current_rate_date = m.current_rate_date
-- where h.status_type = 'FOR_SALE'
-- and home_type = 'SINGLE_FAMILY'
order by listed_date desc