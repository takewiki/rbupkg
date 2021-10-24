#1、费用分配明细表A------
#' 1、费用分配明细表
#' rbu_feeAllcation_all_Allocated 同名的函数
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllcation()
rbu_feeAllcation <- function(variables) {
  #费用分配表与相对是相同的概念
  rbu_feeAllcation_all_Allocated()

}


#1、费用分配明细表B------
#' 费用分析明细表
#' mrpt2_vw_ds_all_Allocated 视图
#' mrpt2_t_ds_all_Allocated  表
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
#' rbu_feeAllcation_all_Allocated()
rbu_feeAllcation_all_Allocated <- function(variables) {
sql <- paste0("CREATE  view  mrpt2_vw_ds_all_Allocated
 as
 ---非市场费用
 select * from mrpt2_vw_ds_all_unAllocated_marketNot
 union all
 ---增加市场费用已分配
  select * from vw_mrpt_res_MartetFee_toChannel
--union all
--select * from  mrpt2_vw_ds_all_SuperCustomerTotal_detail
union all
select * from mrpt2_vw_ds_all_kaTotal_detail
union all
select * from mrpt2_vw_ds_all_TeTongTotal_detail
---需要增加珀芙研冲减收入的部分
union all
select * from mrpt2_vw_ds_all_biorrierYaoFang_RevenueMinus

  ")
# 使用调用部分
#非市场费用
rbu_feeAllocation_marktNot()
#市场费用
rbu_feeAllocation_market_toChannel()
#KA费用
rbu_feeCollection_all_kaTotal_detail()
#特通费用
rbu_feeAllocation_all_TeTongTotal_detail()
#珀芙研市场准减项
rbu_feeCollection_all_biorrierYaoFang_RevenueMinus()
}



# 1.1、非市场费用(即直接归集费用)-------
#' 非市场费用
#' mrpt2_vw_ds_all_unAllocated_marketNot
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllocation_marktNot()
rbu_feeAllocation_marktNot <- function(){
sql <- paste0("create view  mrpt2_vw_ds_all_unAllocated_marketNot
as
select * from mrpt2_vw_ds_all_unAllocated
where FFeeType <> '市场费用待分配'  ")

#调用对应的R函数
rbu_feeCollection_all_unAllocated()

}



#1.2、市场费用已分配到各渠道-------
#' 市场费用已分配到各渠道
#' vw_mrpt_res_MartetFee_toChannel
#'
#' @return 返回值
#' @export
#'
#' @examples
#'
#' rbu_feeAllocation_market_toChannel()
rbu_feeAllocation_market_toChannel <- function() {

sql <- paste0("CREATE  view vw_mrpt_res_MartetFee_toChannel
 as
select  a.FYear,a.FPeriod,a.FBrand, b.FChannel,
    a.FSubChannel
      ,a.[FRptItemNumber]
      ,a.[FRptItemName]
      ,a.FRptAmt*isnull(b.fmarketRatio,0) as  [FAllocAmt]
      ,a.[FDataSource]
      ,a.[FSolutionNumber]
      ,a.[FSubNumber]
      ,a.[FValueType]
      ,a.[F13_itemGroupNumber]
      ,a.[F13_itemGroupName]
      ,a.[F14_brandNumber]
      ,a.[F14_brandName]
      ,a.[F30_customerNumber]
      ,a.[F30_customerName]
      ,a.[F33_subChannelNumber]
      ,a.[F33_subChannelName]
      ,a.[F37_districtSaleDeptNumber]
      ,a.[F37_districtSaleDeptName]
      ,a.[F41_channelName]
      ,a.[F61_costCenterControlNumber]
      ,a.[F61_costCenterControlName]
      ,a.[FSAP_costCenterCode]
      ,a.[FSAP_costElementName]
      ,a.[FSAP_voucherNumber]
      ,a.[FRptAmt]
      ,'市场费用已分配' as [FFeeType]
      ,a.[FFeeName]
      ,b.fmarketRatio as [FFeeRate]
      ,a.[FAllocateType]
      ,a.[FCostCenterType]
      ,a.FBrand+b.FChannel as FBrandChannel  from
mrpt2_vw_ds_all_unAllocated_market a
left join   vw_mrpt_res_marketRatio b
 on a.FYear = b.FYear and a.FPeriod = b.FPeriod
 and a.FBrand = b.FBrand
 ---V1
 --select FYear,FPeriod,FBrand,isnull(FChannel,'电商') as FChannel,
 --FRptItemNumber,FRptItemName,FAmt,isnull(FMarketRatio,1) as FMarketRatio,
 --FAmt*isnull(FMarketRatio,1) as FAllocAmt
 --from
 --(select a.FYear,a.FPeriod,a.FBrand,
 --b.FChannel  ,
 --a.FRptItemNumber,a.FRptItemName,a.FAmt,B.FMarketRatio,
 --a.FAmt*B.FMarketRatio as FAllocAmt
 --from vw_mrpt_res_market_adjusted a
 --left join   vw_mrpt_res_marketRatio b
 --on a.FYear = b.FYear and a.FPeriod = b.FPeriod
 --and a.FBrand = b.FBrand) data
  ")


rbu_feeCollection_all_unAllocated_market()
rbu_feeAllocation_marketRatio()


}


#1.2.01、市场费用分配率-------
#' 市场费用分配率
#' vw_mrpt_res_marketRatio
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllocation_marketRatio()
rbu_feeAllocation_marketRatio <- function(variables) {


sql <- paste0("CREATE  view vw_mrpt_res_marketRatio
  as
  select a.*,t.FTotalAmt, case t.FTotalAmt when 0 then 0 else  round(a.FAmt/t.FTotalAmt,8) end  as FMarketRatio from vw_mrpt_res_cost a
  left join vw_mrpt_res_costTotal t
 on a.FYear = t.FYear and A.FPeriod = t.FPeriod
 and a.FBrand = t.FBrand and a.FRptItemNumber = t.FRptItemNumber")

rbu_feeAllocation_costTotal()
}


#1.2.02、品牌所有渠道营业成本汇总表-------
#' 品牌所有渠道营业成本汇总表
#' vw_mrpt_res_costTotal
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
#' rbu_feeAllocation_costTotal()
rbu_feeAllocation_costTotal <- function(variables) {
sql <- paste0("  create view vw_mrpt_res_costTotal
  as
  select FYear,FPeriod,FBrand,FRptItemNumber,FRptItemName,sum(FAmt) as FTotalAmt from vw_mrpt_res_cost
  group by FYear,FPeriod,FBrand,FRptItemNumber,FRptItemName")

}

#1.2.03、品牌所有渠道营业成本明细表-------
#' 费用分配市场费用
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllocation_cost()
rbu_feeAllocation_cost <- function(variables) {
sql <- paste0("Text
CREATE view vw_mrpt_res_cost
as
select FYear,FPeriod,FBrand,FChannel,FRptItemNumber,FRptItemName,sum(fallocAmt) as FAmt
from
mrpt2_vw_ds_all_unAllocated_withSuperCustomers_brandChannel
where frptItemNumber ='I05'
and FMarketAllocation = 1
--and  FChannel <> '国际事业部' and
--( fchannel  not like '%特通%' and  fchannel  not like '%KA%')
--and FChannel <> '大客户'
----使用大客户合计替代原有的大客户
---- and FChannel <> '市场'
group by FYear,FPeriod,FBrand,FChannel,FRptItemNumber,FRptItemName")

# 需要转入费用归集表

}






















