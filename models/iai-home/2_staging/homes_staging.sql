{{ config(materialized='table') }}

   select
        coalesce(h.id, h.zpid, h.zpid_hdpdata) as id,
        status_type,
        h.home_type,
        coalesce(h.price_hdpdata, h.price_for_hdp, h.unformatted_price, h.price) as price,
        h.tax_assessed_value,
        h.days_on_zillow,
        case 
            when h.status_type = 'FOR_SALE' then to_date(timeadd(milliseconds, -1 * h.time_on_zillow, current_timestamp()))
            else null
        end as listed_date,
        case 
            when h.flex_field_type = 'soldDate' 
                then  REGEXP_SUBSTR(h.flex_field_text, '\\d{2}/\\d{2}/\\d{4}')::date
            else null
        end as sold_date,
        h.url,
        h.address,
        coalesce(h.address_street, h.street_address) as street,
        coalesce(h.address_city, h.city) as city,
        coalesce(h.address_state, h.state) as state,
        coalesce(h.address_zipcode, h.zipcode) as zipcode,
        h.country,
        coalesce(h.area, h.living_area) as area,
        coalesce(h.baths, h.bathroom) as baths,
        coalesce(h.beds, h.bedrooms) as beds,
        h.latitude,
        h.longitude,
        h.flex_field_text,
        h.flex_field_type,
        h.lot_area_value,
        h.lot_area_unit,
        h.img_src,
        h.source,
        h.ingestion_timestamp
    from moodyhome.raw.homes as h