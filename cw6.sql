use AdventureWorksDW2019;

--zad 1
with cte as(
select OrderDate, sum(SalesAmount) as DailyAmount
from FactInternetSales
group by OrderDate)

select OrderDate, DailyAmount, avg(DailyAmount) over (order by OrderDate rows between 3 preceding and current row ) as AvgSales
from cte;

--zad 2
select month_of_year, [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10]
from 
(
select SalesTerritoryKey, SalesAmount, month(OrderDate) as month_of_year
from FactInternetSales
where year(OrderDate) = 2011
) as SourceTable
pivot
(
 sum(SalesAmount)
  for SalesTerritoryKey in ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10])
) as PivotTable
order by month_of_year;

--zad 3
select OrganizationKey, DepartmentGroupKey, sum(Amount) as amount
from FactFinance
group by rollup(OrganizationKey, DepartmentGroupKey)
order by OrganizationKey;

--zad 4
select OrganizationKey, DepartmentGroupKey, sum(Amount) as amount
from FactFinance
group by cube(OrganizationKey, DepartmentGroupKey)
order by OrganizationKey;

--zad 5
  with cte2 as
 (
 select OrganizationKey, sum(Amount) as AmountSum
 from FactFinance
 where year(date) = 2011
 group by OrganizationKey
 )

select cte2.OrganizationKey, cte2.AmountSum, DimOrganization.OrganizationName, 
percent_rank() over(order by AmountSum) as PercentRank
  from cte2
  join DimOrganization on cte2.OrganizationKey = DimOrganization.OrganizationKey
  order by cte2.OrganizationKey

--zad 6
  with cte2 as
 (
 select OrganizationKey, sum(Amount) as AmountSum
 from FactFinance
 where year(date) = 2011
 group by OrganizationKey
 )

select cte2.OrganizationKey, cte2.AmountSum, DimOrganization.OrganizationName, 
percent_rank() over(order by AmountSum) as PercentRank,
stdev(AmountSum) over(order by cte2.OrganizationKey) as Std
  from cte2
  join DimOrganization on cte2.OrganizationKey = DimOrganization.OrganizationKey
  order by cte2.OrganizationKey