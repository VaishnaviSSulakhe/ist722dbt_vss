with stg_customers as (
    select * from {{ source('northwind','customers')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_customers.customerid']) }} as customerkey,
    stg_customers.*
from stg_customers