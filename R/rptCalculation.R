#' 计算结果从明细表到汇总表部分
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_level1 <- function(variables) {
sql <- paste0("CREATE  view  vw_mrpt_res_level1
 as

 select FYear,FPeriod,FBrand,FChannel,FRptItemNumber,FRptItemName,sum(FAllocAmt)
 as FAmt
 from  mrpt2_t_ds_all_Allocated
 group by FYear,FPeriod,FBrand,FChannel,FRptItemNumber,FRptItemName  ")

}

#结果表，增加了零售额及回款信息------
#' 结果表，增加了零售额及回款信息
#' 使用得不是很规范，
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_level12   <- function(variables) {
sql <- paste0("create view vw_mrpt_res_level12
as
select * from vw_mrpt_res_level1
union all
select * from vw_mrpt_res_I02_RetailSales
union all
select * from vw_mrpt_res_I03_receive")

}


#' 计算结果表强制为万元
#' vw_mrpt_res_level_ALL
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_ALL <- function(variables) {
sql <- paste0("CREATE view vw_mrpt_res_level_ALL as

select FYear,FPeriod,FBrand,FChannel,FRptItemNumber,FRptItemName,round(sum(Famt)/10000,2) as FAMT from  vw_mrpt_res_level12

group by FYear,FPeriod,FBrand,FChannel,FRptItemNumber,FRptItemName")
}

#' 结果表的处理内容，扣除报表项目为空的问题
#' vw_mrpt_res_level_ALL_original
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_ALL_original   <- function(variables) {
sql <- paste0("  create view  vw_mrpt_res_level_ALL_original
as
select FYear,FPeriod,FBrand,FChannel,'' as FSubChannel,FRptItemNumber,FRptItemName,FAMT from vw_mrpt_res_level_ALL
where   FRptItemNumber is not null")
}


#' Title
#'
#' @param variables
#' vw_mrpt_res_level_ALL_zero
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_ALL_zero   <- function(variables) {

  sql <- paste0("create  view vw_mrpt_res_level_ALL_zero
as
select  a.* ,b.FRptItemNumber,b.FRptItemName,0 as FAmt
from vw_mrpt_res_level_ALL_unique a, t_mrpt_rptItem b  ")
}


rbu_calc_level_I06_profit <- function(variables) {
sql <- paste0("create view rds_vw_res_I06_profit
as
select a.FYear,a.FPeriod,a.FBrand,a.FChannel,a.FSubChannel,
( select FRptItemNumber from t_mrpt_rptItem
 where FRptItemNumber ='I06') as FRptItemNumber,
 (select FRptItemName from t_mrpt_rptItem
 where FRptItemNumber ='I06') as FRptItemName,
a.FAMT - b.FAMT as FAmt
from rds_vw_res_I04_revenue a
left   join rds_vw_res_I05_cost b
on a.FYear = b.FYear and a.FPeriod = b.FPeriod and a.FBrand = b.FBrand
and a.FChannel = b.FChannel and a.FSubChannel = b.FSubChannel  ")

}

rbu_calc_level_I07_profitRate <- function(variables) {
sql <- paste0("create view rds_vw_res_I07_profitRate
as
select a.FYear,a.FPeriod,a.FBrand,a.FChannel,a.FSubChannel,
( select FRptItemNumber from t_mrpt_rptItem
 where FRptItemNumber ='I07') as FRptItemNumber,
 (select FRptItemName from t_mrpt_rptItem
 where FRptItemNumber ='I07') as FRptItemName,
case a.FAMT  when 0 then 0 else round(1-b.FAMT/a.FAMT,4) end   as FAmt
from rds_vw_res_I04_revenue a
left   join rds_vw_res_I05_cost b
on a.FYear = b.FYear and a.FPeriod = b.FPeriod and a.FBrand = b.FBrand
and a.FChannel = b.FChannel and a.FSubChannel = b.FSubChannel  ")

}

rbu_calc_level_I08_salesFee <- function(variables) {
  sql <- paste0("create view  rds_vw_res_I08_salesFee
as
select FYear,FPeriod,FBrand,FChannel,FSubChannel,
( select FRptItemNumber from t_mrpt_rptItem
 where FRptItemNumber ='I08') as FRptItemNumber,
 (select FRptItemName from t_mrpt_rptItem
 where FRptItemNumber ='I08') as FRptItemName,
 sum(FAMT) AS FAMT
from vw_mrpt_res_level_ALL_original
where FRptItemNumber between  'I09' and 'I25'
group by FYear,FPeriod,FBrand,FChannel,FSubChannel  ")
}

rbu_calc_level_I26_Salesprofit <- function(variables) {
  sql <- paste0("create view rds_vw_res_I26_Salesprofit
as
select a.FYear,a.FPeriod,a.FBrand,a.FChannel,a.FSubChannel,
( select FRptItemNumber from t_mrpt_rptItem
 where FRptItemNumber ='I26') as FRptItemNumber,
 (select FRptItemName from t_mrpt_rptItem
 where FRptItemNumber ='I26') as FRptItemName,
a.FAMT - b.FAMT as FAmt
from rds_vw_res_I06_profit a
left   join rds_vw_res_I08_salesFee b
on a.FYear = b.FYear and a.FPeriod = b.FPeriod and a.FBrand = b.FBrand
and a.FChannel = b.FChannel and a.FSubChannel = b.FSubChannel  ")
}

rbu_calc_level_I27_marketFee <- function(variables) {
  sql <- paste0("create view  rds_vw_res_I27_marketFee
as
select FYear,FPeriod,FBrand,FChannel,FSubChannel,
( select FRptItemNumber from t_mrpt_rptItem
 where FRptItemNumber ='I27') as FRptItemNumber,
 (select FRptItemName from t_mrpt_rptItem
 where FRptItemNumber ='I27') as FRptItemName,
 sum(FAMT) AS FAMT
from vw_mrpt_res_level_ALL_original
where FRptItemNumber between  'I28' and 'I43'
group by FYear,FPeriod,FBrand,FChannel,FSubChannel  ")
}

rbu_calc_level_I44_marketProfit <- function(variables) {
  sql <- paste0("create view rds_vw_res_I44_marketProfit
as
select a.FYear,a.FPeriod,a.FBrand,a.FChannel,a.FSubChannel,
( select FRptItemNumber from t_mrpt_rptItem
 where FRptItemNumber ='I44') as FRptItemNumber,
 (select FRptItemName from t_mrpt_rptItem
 where FRptItemNumber ='I44') as FRptItemName,
a.FAMT - b.FAMT as FAmt
from rds_vw_res_I26_Salesprofit  a
left   join rds_vw_res_I27_marketFee b
on a.FYear = b.FYear and a.FPeriod = b.FPeriod and a.FBrand = b.FBrand
and a.FChannel = b.FChannel and a.FSubChannel = b.FSubChannel  ")
}





#' 计算结果结果,最接近结果的内容
#'
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_ALL2     <- function(variables) {
sql <- paste0("CREATE  view vw_mrpt_res_level_ALL2
as
select data.FYear,data.FPeriod,data.FBrand,data.FChannel,data.FSubChannel,data.FRptItemNumber,data.FRptItemName,
sum(data.FAmt) as FAcualAmt
 from
(select * from vw_mrpt_res_level_ALL_zero
union all
select * from vw_mrpt_res_level_ALL_original
union all
select * from rds_vw_res_I06_profit
union all
select * from rds_vw_res_I07_profitRate
union all
select * from rds_vw_res_I08_salesFee
union all
select * from rds_vw_res_I26_Salesprofit
union all
select * from rds_vw_res_I27_marketFee
union all
select * from rds_vw_res_I44_marketProfit
) data
group by data.FYear,data.FPeriod,data.FBrand,data.FChannel,data.FSubChannel,data.FRptItemNumber,data.FRptItemName
  ")

}






# 计算结果增加了同步数据-----------
#' 计算结果增加了执行预算数据
#' vw_mrpt_res_level_ALL3
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_ALL3   <- function(variables) {
sql <- paste0("create view vw_mrpt_res_level_ALL3
as
select a.* ,  isnull(b.FAmt,0)  as FBudgetAmt,  case isnull(b.FAmt,0)  when 0 then 0 else a.FAcualAmt/b.FAmt end
as FAchiveRatio        from  vw_mrpt_res_level_ALL2 a
left join t_mrpt_budget b
on a.FYear =b.FYear and a.FPeriod = b.FPeriod and a.FBrand =b.FBrand
and a.FChannel = b.FChannel and isnull(a.FSubChannel,'') =isnull(b.FSubChannel,'')
and a.FRptItemNumber = b.FRptItemNumber  ")
}




# 计算结果增加了同步数据-----------
#' 计算结果增加了同比数据,19与20年数据
#' vw_mrpt_res_level_ALL4
#'
#' @return
#' @export
#'
#' @examples
rbu_calc_level_ALL4 <- function(){

# 这一部分应该不再使用
sql <- paste0("CREATE  view vw_mrpt_res_level_ALL4
as
select a.*,isnull(b.FAcualAmt_Lag1,0)FAcualAmt_Lag1    , case isnull(b.FAcualAmt_Lag1,0)  when 0 then 0 else a.FAcualAmt/b.FAcualAmt_Lag1 end
as FAchiveRatio_Lag1 ,
isnull(c.FAcualAmt_Lag2,0) as FAcualAmt_Lag2  , case isnull(c.FAcualAmt_Lag2,0)  when 0 then 0 else a.FAcualAmt/c.FAcualAmt_Lag2 end
as FAchiveRatio_Lag2

from  vw_mrpt_res_level_ALL3  a
left join t_mrpt_actual_2020 b
on a.FYear =b.FYear and a.FPeriod = b.FPeriod and a.FBrand =b.FBrand
and a.FChannel = b.FChannel and isnull(a.FSubChannel,'') =isnull(b.FSubChannel,'')
and a.FRptItemNumber = b.FRptItemNumber

left join t_mrpt_actual_2019  c
on a.FYear =c.FYear and a.FPeriod = c.FPeriod and a.FBrand =c.FBrand
and a.FChannel = c.FChannel and isnull(a.FSubChannel,'') =isnull(c.FSubChannel,'')
and a.FRptItemNumber = c.FRptItemNumber
  ")
}
