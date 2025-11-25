with stg_products as (
    select * from {{ source('northwind','products')}}
),
stg_suppliers as (
    select * from {{ source('northwind','suppliers')}}
),
stg_categories as (
    select * from {{ source('northwind','categories')}}
)
select
    {{ dbt_utils.generate_surrogate_key(['p.productid']) }} as productkey,
    p.productid, p.productname, p.quantityperunit, p.unitprice,
    s.companyname as suppliername,
    c.categoryname
from stg_products p
    left join stg_suppliers s on p.supplierid = s.supplierid
    left join stg_categories c on p.categoryid = c.categoryid