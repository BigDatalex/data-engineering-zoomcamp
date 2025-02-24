{{ config(materialized="view") }}

with
    tripdata as (
        select
            *,
            row_number() over (partition by dispatching_base_num, pickup_datetime) as rn
        from {{ source("staging", "fhv_tripdata") }}
        where dispatching_base_num is not null
    )
select
    -- field description: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_fhv.pdf
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(["dispatching_base_num", "pickup_datetime"]) }}
    as tripid,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }}
    as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }}
    as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- renaming
    cast(sr_flag as numeric) as sr_flag,
    affiliated_base_number as affiliated_base_number

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}
