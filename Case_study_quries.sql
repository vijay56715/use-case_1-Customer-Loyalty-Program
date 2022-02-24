1)

select customer_id,sum(price) total_amount_spent from(select sales.customer_id,sales.product_id,menu.price from sales inner join menu on sales.product_id=menu.product_id) group by customer_id;



2)
select customer_id,count(distinct date_visited) no_of_days_visited from
(select sales.customer_id,sales.product_id,menu.price,sales.order_date date_visited from sales
inner join menu on sales.product_id=menu.product_id) 
group by customer_id;




3)
select distinct customer_id,product_name,order_date from(
select sales.customer_id customer_id,sales.product_id,menu.price,sales.order_date order_date,
rank() over(order by sales.order_date) rank_order_date,menu.product_name product_name
from sales inner join menu on sales.product_id=menu.product_id) where rank_order_date=1 order by customer_id ;


4)
select * from(
select product_id product_id,count(customer_id) no_of_orders,product_name product_name from (
select sales.customer_id customer_id,sales.product_id product_id,menu.price,sales.order_date order_date,
menu.product_name product_name
from sales inner join menu on sales.product_id=menu.product_id )  
group by product_id,product_name order by no_of_orders desc) where rownum=1;



5)
select customer_id,no_of_orders,product_name from(
select customer_id,count(product_id) no_of_orders,product_name product_name,
rank() over(partition by customer_id order by count(product_id) desc)  rank_prd from (
select sales.customer_id customer_id,sales.product_id product_id,menu.price,sales.order_date order_date,
menu.product_name product_name
from sales inner join menu on sales.product_id=menu.product_id ) 
group by customer_id,product_name order by no_of_orders desc  ) where rank_prd=1;

6)
select customer_id,product_id,product_name,to_char(join_date,'dd-mm-yy'),order_date from(
select sales.customer_id customer_id,sales.product_id product_id,sales.order_date order_date,menu.product_name product_name,
members.join_date join_date,rank() over(partition by sales.customer_id order by sales.order_date) rank_date
from sales inner join members on sales.customer_id=members.customer_id and sales.order_date>=members.join_date
inner join menu on sales.product_id=menu.product_id)  where rank_date=1;


7)
select customer_id,product_id,product_name,to_char(join_date,'dd-mm-yy') join_date,order_date from(
select sales.customer_id customer_id,sales.product_id product_id,sales.order_date order_date,menu.product_name product_name,
members.join_date join_date,rank() over(partition by sales.customer_id order by sales.order_date desc) rank_date
from sales inner join members on sales.customer_id=members.customer_id and sales.order_date<=members.join_date
inner join menu on sales.product_id=menu.product_id)  where rank_date=1;


8)
select customer_id,sum(price),count(product_id) total_till_member from(
select sales.customer_id customer_id,sales.product_id product_id,sales.order_date order_date,menu.product_name product_name,
members.join_date join_date,rank() over(partition by sales.customer_id order by sales.order_date desc) rank_date,menu.price
from sales inner join members on sales.customer_id=members.customer_id and sales.order_date<members.join_date
inner join menu on sales.product_id=menu.product_id) group by customer_id;

9)
select customer_id,sum(points) total_points from(
select sales.customer_id customer_id,sales.product_id product_id,menu.product_name product_name,menu.price,
case menu.product_name
when 'sushi' then menu.price*2*10
else menu.price*10
end points
from sales inner join members on sales.customer_id=members.customer_id 
inner join menu on sales.product_id=menu.product_id) group by customer_id;

10)
select customer_id,sum(points) total_points from (
 select sales.customer_id customer_id,sales.product_id product_id,menu.product_name product_name,menu.price,
sales.order_date-to_date(to_char(members.join_date,'dd-mm-yy')) no_of_days,sales.order_date order_date,
case
when 
(sales.order_date-to_date(to_char(members.join_date,'dd-mm-yy')) >0) and 
(sales.order_date-to_date(to_char(members.join_date,'dd-mm-yy'))<7) then menu.price*2*10
else(  case when product_name ='sushi' then price*10*2 else price*10 end )
end points
from sales inner join members on sales.customer_id=members.customer_id 
inner join menu on sales.product_id=menu.product_id ) where order_date < to_date('01-02-21','dd-mm-yy') group by customer_id ;
