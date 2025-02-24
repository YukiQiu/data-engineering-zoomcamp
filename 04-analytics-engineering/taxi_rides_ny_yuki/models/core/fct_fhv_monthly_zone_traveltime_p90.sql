{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('dim_fhv_trips') }}
),

trip_duration_get as (
    select 
          *,
          TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
    from trips_data
),
trip_duration_at as (
    select 
          *,
          cast(trip_duration as float64) as trip_duration_format
    from trip_duration_get
)

select *,
      PERCENTILE_CONT(trip_duration_format,0.9) over (partition by pickup_year,pickup_month,pickup_locationid,dropoff_locationid) as percen90
from trip_duration_at
