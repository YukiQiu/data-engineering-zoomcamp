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
)

select  service_type,
        pickup_year,
        case when pickup_month between 1 and 3 then 'Q1'
             when pickup_month between 4 and 6 then 'Q2'
             when pickup_month between 7 and 9 then 'Q3'
             when pickup_month between 10 and 12 then 'Q4' end as quarters,
        sum(total_amount) as revenue
from tripdata
group by 1,2,3