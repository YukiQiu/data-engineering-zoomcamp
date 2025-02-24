{{
    config(
        materialized='table'
    )
}}

with tripdata as (
    select *,
           extract(YEAR from pickup_datetime) as pickup_year,
        extract(MONTH from pickup_datetime) as pickup_month   
    from {{ ref('fact_trips') }}
    where fare_amount > 0 and trip_distance > 0 and payment_type_description in ('Cash', 'Credit Card')
)

select  service_type,
        pickup_year,
        pickup_month,
        PERCENTILE_CONT(fare_amount,0.97) over (partition by service_type,pickup_year,pickup_month) as percen97,
        PERCENTILE_CONT(fare_amount,0.95) over (partition by service_type,pickup_year,pickup_month) as percen95,
        PERCENTILE_CONT(fare_amount,0.9) over (partition by service_type,pickup_year,pickup_month) as percen90
from tripdata


