with stg_orders as (
    select orderid,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from {{ source('northwind','orders') }}
),
stg_order_details as (
    select orderid, productid,
        {{ dbt_utils.generate_surrogate_key(['productid']) }} as productkey,
        unitprice, quantity, discount,
        quantity * unitprice * (1 - discount) as extendedprice
    from {{ source('northwind','order_details') }}
)
select
    o.customerkey, o.employeekey, od.productkey, o.orderdatekey,
    o.orderid, od.quantity, od.unitprice, od.discount, od.extendedprice
from stg_order_details od
    join stg_orders o on od.orderid = o.orderid