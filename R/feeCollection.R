# 1、费用归集所有明细-------
#' 费用归集所有明细
#' mrpt2_vw_ds_all_unAllocated
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_detail()
rbu_feeCollection <- function(variables) {
   #费用归集
   rbu_feeCollection_all_unAllocated()

}

# 1、费用归集所有明细-------
#' 费用归集明细表
#' mrpt2_vw_ds_all_unAllocated
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_all_unAllocated <- function(variables) {
sql <- paste0("CREATE  view  mrpt2_vw_ds_all_unAllocated
 as
 select  *   from mrpt2_vw_ds_sap_all
 union all
  select  *   from mrpt2_vw_ds_bw_all
  union all
  select * from mrpt2_vw_ds_adj_all  ")

}



#' 市场费用待分配
#' mrpt2_vw_ds_all_unAllocated_market
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
rbu_feeCollection_all_unAllocated_market  <- function(variables) {
sql <- paste0("
create view  mrpt2_vw_ds_all_unAllocated_market
as
select * from mrpt2_vw_ds_all_unAllocated
where FFeeType = '市场费用待分配'  ")


rbu_feeCollection_all_unAllocated()

}


#' 匹配了品牌渠道费用及品牌渠道基础表
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
#' rbu_feeCollection_all_unAllocated_withSuperCustomers_brandChannel()
rbu_feeCollection_all_unAllocated_withSuperCustomers_brandChannel <- function(variables) {
sql <- paste0("create view mrpt2_vw_ds_all_unAllocated_withSuperCustomers_brandChannel
as
select a.*,b.FBrandChannelNumber,b.FBrandChannelName,b.FCalcStep,b.FIsDetail,b.FIsSubChannel,b.FMarketAllocation from mrpt2_vw_ds_all_unAllocated_withSuperCustomers a
left join t_mrpt2_md_brandChannel b
on a.FBrand = b.FBrandName and a.FChannel = b.FChannelName  ")


rbu_md_brandChannel()

}



#' 费用待分配包括KA，特通及大客户----
#' 本质在处理第一级与第二级的费用问题
#' mrpt2_vw_ds_all_unAllocated_withSuperCustomers
#'
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_all_unAllocated_withSuperCustomers()
rbu_feeCollection_all_unAllocated_withSuperCustomers  <- function(variables) {
sql <- paste0("CREATE  view  mrpt2_vw_ds_all_unAllocated_withSuperCustomers
as
select * from  mrpt2_vw_ds_all_unAllocated
---union all
----select * from  mrpt2_vw_ds_all_SuperCustomerTotal_detail
union all
select * from mrpt2_vw_ds_all_kaTotal_detail
union all
select * from mrpt2_vw_ds_all_TeTongTotal_detail  ")

rbu_feeCollection_all_unAllocated()
rbu_feeCollection_all_kaTotal_detail()
rbu_feeAllocation_all_TeTongTotal_detail()
}



# 1.3、费用归集明细KA数据(正常不会单独处理KA数据)-------
#' 费用分配明细KA数据
#' mrpt2_vw_ds_all_kaTotal_detail
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllocation_ka()
rbu_feeCollection_all_kaTotal_detail <- function(variables) {

   sql <- paste0("CREATE  view  mrpt2_vw_ds_all_kaTotal_detail
as
select FYear,FPeriod,'自然堂' as FBrand,'大客户KA小计' FChannal,
FBrandChannel as FSubChannel
      ,[FRptItemNumber]
      ,[FRptItemName]
      ,[FAllocAmt]
      ,[FDataSource]
      ,[FSolutionNumber]
      ,[FSubNumber]
      ,[FValueType]
      ,[F13_itemGroupNumber]
      ,[F13_itemGroupName]
      ,[F14_brandNumber]
      ,[F14_brandName]
      ,[F30_customerNumber]
      ,[F30_customerName]
      ,[F33_subChannelNumber]
      ,[F33_subChannelName]
      ,[F37_districtSaleDeptNumber]
      ,[F37_districtSaleDeptName]
      ,[F41_channelName]
      ,[F61_costCenterControlNumber]
      ,[F61_costCenterControlName]
      ,[FSAP_costCenterCode]
      ,[FSAP_costElementName]
      ,[FSAP_voucherNumber]
      ,[FRptAmt]
      ,[FFeeType]
      ,[FFeeName]
      ,[FFeeRate]
      ,[FAllocateType]
      ,[FCostCenterType]
      ,'自然堂大客户KA小计' as [FBrandChannel]
  FROM [dbo].[mrpt2_vw_ds_all_ka_detail]  ")

}


# 1.4、费用分配处理特通小计数据-------
#' 费用分配处理特通数据
#' mrpt2_vw_ds_all_TeTongTotal_detail
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllocation_TeTong()
rbu_feeAllocation_all_TeTongTotal_detail <- function(variables) {
   sql <- paste0("CREATE   view  mrpt2_vw_ds_all_TeTongTotal_detail
as
select FYear,FPeriod,'自然堂' as FBrand,'大客户特通小计' FChannal,
FBrandChannel as FSubChannel
      ,[FRptItemNumber]
      ,[FRptItemName]
      ,[FAllocAmt]
      ,[FDataSource]
      ,[FSolutionNumber]
      ,[FSubNumber]
      ,[FValueType]
      ,[F13_itemGroupNumber]
      ,[F13_itemGroupName]
      ,[F14_brandNumber]
      ,[F14_brandName]
      ,[F30_customerNumber]
      ,[F30_customerName]
      ,[F33_subChannelNumber]
      ,[F33_subChannelName]
      ,[F37_districtSaleDeptNumber]
      ,[F37_districtSaleDeptName]
      ,[F41_channelName]
      ,[F61_costCenterControlNumber]
      ,[F61_costCenterControlName]
      ,[FSAP_costCenterCode]
      ,[FSAP_costElementName]
      ,[FSAP_voucherNumber]
      ,[FRptAmt]
      ,[FFeeType]
      ,[FFeeName]
      ,[FFeeRate]
      ,[FAllocateType]
      ,[FCostCenterType]
      ,'自然堂大客户特通小计' as [FBrandChannel]
  FROM [dbo].[mrpt2_vw_ds_all_TeTong_detail]  ")

}


# 1.5、费用归集药房冲减收入------
#' 费用分配药房冲减收入
#' mrpt2_vw_ds_all_biorrierYaoFang_RevenueMinus
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_all_biorrierYaoFang_RevenueMinus()
rbu_feeCollection_all_biorrierYaoFang_RevenueMinus <- function(){
   sql <- paste0("create view mrpt2_vw_ds_all_biorrierYaoFang_RevenueMinus
as
select FYear,FPeriod,FBrand2 as FBrand,FChannel2 as FChannel,'' as FSubChannel,
 'I04' FRptItemNumber,'四、营业收入' FRptItemName,FAllocAmt*(-1) as FAllocAmt,'SAP凭证' as FDataSource,
 '' as FSolutionNumber,
 0 as FSubNumber,
 '' as FValueType,
 '' as F13_itemGroupNumber,
 '' as F13_itemGroupName,
 '' as F14_brandNumber,
 '' as F14_brandName,
 '' as F30_customerNumber,
 '' as F30_customerName,
 '' as F33_subChannelNumber,
 '' as F33_subChannelName,
 '' as F37_districtSaleDeptNumber,
 '' as F37_districtSaleDeptName,
 '' as F41_channelName,
 '' as F61_costCenterControlNumber,
 '' as F61_costCenterControlName,
 FCostCenterNo as FSAP_costCenterCode,
 FCostItemNumber as  FSAP_costElementName,
 FVchNo as FSAP_voucherNumber,
 FRptAmt ,
 FFeeType ,
 '冲减营业收入'FFeeName ,
 -1  as FFeeRate,
 FAllocateType,
 FType as FCostCenterType,
 FChannel as FBrandChannel
from mrpt2_vw_data_sap_BrandChannel_biorrierYaoFang_RevenueMinus
   ")
}













# 1.1A、费用归集-SAP-------
#' 费用归集-SAP
#' mrpt2_vw_ds_sap_all
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_sap()
rbu_feeCollection_sap <- function(){
  #示例化后的格式
   rbu_feeCollection_sap_all()
}



# 1.1B、费用归集-SAP-------
#' 1.1.01费用归集SAP凭证
#' mrpt2_vw_ds_sap_all
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_all <- function(variables) {

sql <- paste0(" CREATE  view mrpt2_vw_ds_sap_all
as
 select FYear,FPeriod,FBrand2 as FBrand,FChannel2 as FChannel,'' as FSubChannel,
 FRptItemNumber,FRptItemName,FAllocAmt,'SAP凭证' as FDataSource,
 '' as FSolutionNumber,
 0 as FSubNumber,
 '' as FValueType,
 '' as F13_itemGroupNumber,
 '' as F13_itemGroupName,
 '' as F14_brandNumber,
 '' as F14_brandName,
 '' as F30_customerNumber,
 '' as F30_customerName,
 '' as F33_subChannelNumber,
 '' as F33_subChannelName,
 '' as F37_districtSaleDeptNumber,
 '' as F37_districtSaleDeptName,
 '' as F41_channelName,
 '' as F61_costCenterControlNumber,
 '' as F61_costCenterControlName,
 FCostCenterNo as FSAP_costCenterCode,
 FCostItemNumber as  FSAP_costElementName,
 FVchNo as FSAP_voucherNumber,
 FRptAmt ,
 FFeeType ,
 FFeeName ,
 FValue as FFeeRate,
 FAllocateType,
 FType as FCostCenterType,
 FChannel as FBrandChannel
 from
mrpt2_vw_data_sap_rptItem_all_allocated ")

rbu_feeCollection_sap_rptItem_all_allocated()




}

#' SAP费用分配表
#' mrpt2_vw_data_sap_rptItem_all_allocated
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_all_allocated <- function(variables) {
sql <- paste0("create view mrpt2_vw_data_sap_rptItem_all_allocated
as
select * from mrpt2_vw_data_sap_rptItem_all_unique
union all
select * from  mrpt2_vw_data_sap_salesFee_allocated")


rbu_feeCollection_sap_rptItem_all_unique()
rbu_feeCollection_sap_rptItem_shared_allocated()

}





# 1.1.01.01.01、SAP独立费用--------
#' 独占的费用
#' mrpt2_vw_data_sap_rptItem_all_unique
#'
#' @return 返回值
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_all_unique <- function(){
sql <- paste0("create view  mrpt2_vw_data_sap_rptItem_all_unique
as
select * from  mrpt2_vw_data_sap_rptItem_all
where  FAllocateType='独立'   ")

}




# 1.1.01.02.01、SAP 凭证费用-共享成本中心的渠道费用分配部分-----
#' SAP 凭证费用-分配部分
#' mrpt2_vw_data_sap_salesFee_allocated
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_shared_allocated <- function(variables) {

sql <- paste0("CREATE  view mrpt2_vw_data_sap_salesFee_allocated
as
select a.FYear,a.FPeriod,a.FCostCenterNo,a.FCostItemNumber,a.FCostItemName,
a.FRptAmt,a.FType,b.FBrand2,b.FChannel2,b.FValue,a.fRptAmt*b.FValue as FAllocAmt,
a.FVchNo,a.FAllocateType,'渠道费用已分配' as FFeeType,b.FChannel,a.FFeeName,a.FRptItemNumber,a.FRptItemName
from mrpt2_vw_data_sap_rptItem_all_shared a
left join   mrpt2_vw_md_costCenter_salesFee b
on a.fcostCenterNo = b.FcostCenter and a.FYear = b.FYear and a.FPeriod = b.FPeriod  ")

# 在主数据模块masterData.R中进行定义
rbu_md_costCenter_shared_salesFee()
rbu_feeCollection_sap_rptItem_all_shared()

}








# SAP凭证共享成本中心费用待分配-----------
#' SAP凭证共享成本中心费用待分配
#' mrpt2_vw_data_sap_rptItem_all_shared
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_all_shared <- function(){

sql <- paste0("Text
create view  mrpt2_vw_data_sap_rptItem_all_shared
as
select * from  mrpt2_vw_data_sap_rptItem_all
where  FAllocateType='共享'   ")

}


#1.1.01.03、SAP凭证项目-----------
#' 1.1.01.03、SAP凭证项目-----------
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_all <- function(){
sap <- paste0("
              create view mrpt2_vw_data_sap_rptItem_all
as
SELECT [FYear]
      ,[FPeriod]
      ,[FCostCenterNo]
      ,[FCostItemNumber]
      ,[FCostItemName]
      ,[FRptAmt]
      ,[FType]
      ,[FBrand2]
      ,[FChannel2]
      ,[FValue]
      ,[FAllocAmt]
      ,[FVchNo]
      ,[FAllocateType]
      ,[FFeeType]
      ,[FChannel]
      ,[FFeeName]
      ,[FRptItemNumber]
      ,[FRptItemName]
  FROM [dbo].[mrpt2_vw_data_sap_rptItem_GeneralOthers_notNull]
union all
 select
 [FYear]
      ,[FPeriod]
      ,[FCostCenterNo]
      ,[FCostItemNumber]
      ,[FCostItemName]
      ,[FRptAmt]
      ,[FType]
      ,[FBrand2]
      ,[FChannel2]
      ,[FValue]
      ,[FAllocAmt]
      ,[FVchNo]
      ,[FAllocateType]
      ,[FFeeType]
      ,[FChannel]
      ,'' as  [FFeeName]
      ,[FRptItemNumber]
      ,[FRptItemName]
   from  mrpt2_vw_data_sap_rptItem_chandoEcom_notnull
              ")
rbu_feeCollection_sap_rptItem_GeneralOthers_notNull()
rbu_feeCollection_sap_rptItem_chandoEcom_notnull()

}

#1.1.01.03.01、除自然堂电商外的内容-------
#' 除自然堂电商外的内容
#' mrpt2_vw_data_sap_rptItem_GeneralOthers_notNull
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_GeneralOthers_notNull <- function(variables) {

sql <- paste0("create view  mrpt2_vw_data_sap_rptItem_GeneralOthers_notNull
as
select * from mrpt2_vw_data_sap_rptItem_GeneralOthers_all
where FRptItemNumber is not null
  ")
}

#1.1.01.03.01.01---------
#' Title
#' mrpt2_vw_data_sap_rptItem_GeneralOthers_all
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_GeneralOthers_all <- function(variables) {

sql <- paste0("create view  mrpt2_vw_data_sap_rptItem_GeneralOthers_all
as
select a.*,b.FRptItemNumber,b.FRptItemName
from  mrpt2_vw_data_sap_FeeName_generalOthers_notNull a
left join t_mrpt_rptItem b
on a.FFeeName = b.FFeeName and a.ftype = b.FChannelType  ")

rbu_feeCollection_sap_FeeName_generalOthers_notNull()
rbu_md_rptItem()
}

#1.1.01.03.01.01.01、
#' Title
#' mrpt2_vw_data_sap_FeeName_generalOthers_notNull
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_FeeName_generalOthers_notNull <- function(variables) {
sql <- paste0("create view  mrpt2_vw_data_sap_FeeName_generalOthers_notNull
as
select * from  mrpt2_vw_data_sap_FeeName_generalOthers_all
where FFeeName is not null  ")

}


#' Title
#' mrpt2_vw_data_sap_FeeName_generalOthers_all
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_FeeName_generalOthers_all <- function(variables) {
sql <- paste0("create view  mrpt2_vw_data_sap_FeeName_generalOthers_all
as
select a.* ,b.FRptItemName as FFeeName
from mrpt2_vw_data_sap_BrandChannel_GeneralOthers a
left join t_mrpt_costItem_sap b
on a.FCostItemNumber = b.FCostItemNumber and a.FYear =b.FYear and a.FPeriod = b.FPeriod    ")

}


#' 除自然堂电商的费用
#' mrpt2_vw_data_sap_BrandChannel_GeneralOthers
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_BrandChannel_GeneralOthers   <- function(variables) {

sql <- paste0("CREATE  view  mrpt2_vw_data_sap_BrandChannel_GeneralOthers
as
select * from  mrpt2_vw_data_sap_BrandChannel_notnull
where FChannel  not in ('珀芙研药房','自然堂电商')
union all
select * from mrpt2_vw_data_sap_BrandChannel_biorrierYaoFang_other  ")

}


rbu_feeCollection_sap_BrandChannel_notnull <- function(variables) {
sql <- paste0("create view mrpt2_vw_data_sap_BrandChannel_notnull
as
select * from mrpt2_vw_data_sap_BrandChannel_all
where ftype  is not null   ")

}


#' Title
#' mrpt2_vw_data_sap_BrandChannel_all
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_BrandChannel_all <- function(variables) {
sql <- paste0("CREATE    view  mrpt2_vw_data_sap_BrandChannel_all
as
select   a.FYear,a.FPeriod, a.FCostCenterNo,a.FCostItemNumber,a.FCostItemName,a.FRptAmt ,
c.FType,c.FBrand2,c.FChannel2,c.FValue,a.FRptAmt*c.FValue as FAllocAmt ,a.FVchNo ,
c.FAllocateType,c.FFeeType,c.FChannel
from  t_mrpt_data_sap  a
left join mrpt2_vw_md_costCenter_total c
on a.FCostCenterNo = c.FcostCenter and   a.FYear =c.FYear and a.FPeriod = c.FPeriod     ")

rbu_ds_sap()
rbu_md_costCenter_total()


}

#1.1.01.03.02、自然堂电商外的内容-------
#' Title
#' mrpt2_vw_data_sap_rptItem_chandoEcom_notnull
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_chandoEcom_notnull  <- function(variables) {
sql <- paste0("create view mrpt2_vw_data_sap_rptItem_chandoEcom_notnull
as
select *  from mrpt2_vw_data_sap_rptItem_chandoEcom_all
where FRptItemNumber is not null  ")

}


#' Title
#' mrpt2_vw_data_sap_rptItem_chandoEcom_all
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_rptItem_chandoEcom_all <- function(variables) {
sql <- paste0("create view mrpt2_vw_data_sap_rptItem_chandoEcom_all
as
select a.*,b.FRptItemNumber,b.FRptItemName
from mrpt2_vw_data_sap_BrandChannel_chandoEcom a
left join t_mrpt_chando_acctRptItem b
on a.FCostItemNumber =  b.FAcctNumber  ")



}

#' Title
#' mrpt2_vw_data_sap_BrandChannel_chandoEcom
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_sap_BrandChannel_chandoEcom <- function(variables) {
sql <- paste0("create view  mrpt2_vw_data_sap_BrandChannel_chandoEcom
as
select * from  mrpt2_vw_data_sap_BrandChannel_notnull
where FChannel ='自然堂电商'")

}




























# 1.2、费用归集-BW-----
#' 费用归集-BW
#' mrpt2_vw_ds_bw_all
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_bw()
rbu_feeCollection_bw <-function(){
sql <- paste0("  select  *   from mrpt2_vw_ds_bw_all ")
}


#' Title
#' mrpt2_vw_ds_bw_all
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_bw_all    <- function(variables) {
sql <- paste0("CREATE  view  mrpt2_vw_ds_bw_all
as
select FYear,FPeriod,
FBrand_o as FBrand,
FChannel_o as FChannel,
'' as FSubChannel,
FRptItemNumber_o as FRptItemNumber,
FRptItemName_o as FRptItemName,
FValue*FRate as FAllocAmt,
'BW报表' as FDataSource,
FSolutionNumber,
FSubNumber,
FValueType,
F13_itemGroupNumber,
F13_itemGroupName,
F14_brandNumer,
F14_brandName,
F30_customerNumber,
F30_customerName,
F33_subChannelNumber,
F33_subChannelName,
F37_disctrictSaleDeptNumber,
F37_disctrictSaleDeptName,
F41_channelName,
F61_costCenterControlNumber,
F61_costCenterControlName,
'' as FSAP_costCenterCode,
'' as FSAP_costElementName,
'' as FSAP_voucherNumber,
FValue as FRptAmt,
case FChannel_o  when '市场' then '市场费用待分配'  else '直接费用归集' end as FFeeType,
'' as FFeeName,
FRate as FFeeRate,
'' as FAllocateType,
'' as FCostCenterType,
FBrand_o + FChannel_o as FBrandChannel
from  rds_t_mrpt_ds_bw_rpa_ruled ")

}





#' BW写入的结果表
#' 这应该是BW核对核法写入的结果
#' rds_t_mrpt_ds_bw_rpa_ruled
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_feeCollection_bw_rpa_ruled <- function(variables) {
# 这是一个表，应该是BW报表的云计算结果,写入了这个表
sql <- paste0("rds_t_mrpt_ds_bw_rpa_ruled")

}






# 1.3、费用归集-手调凭证--------
#' 费用归集-手调凭证
#' mrpt2_vw_ds_adj_all
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_adj()
rbu_feeCollection_adj <- function(variables) {
sql <- paste0("select * from mrpt2_vw_ds_adj_all ")

}


rbu_feeCollection_adj_all <- function(variables) {
sql <- paste0("create view mrpt2_vw_ds_adj_all
as
 select
 FYear,FPeriod,FBrand,FChannel,
 '' as FSubChannel,
 FRptItemNumber,
 FRptItemName,
 FRptAmt as FAllocAmt,
 '手调凭证' as FDataSource,
  '' as FSolutionNumber,
 0 as FSubNumber,
 '' as FValueType,
 '' as F13_itemGroupNumber,
 '' as F13_itemGroupName,
 '' as F14_brandNumber,
 '' as F14_brandName,
 '' as F30_customerNumber,
 '' as F30_customerName,
 '' as F33_subChannelNumber,
 '' as F33_subChannelName,
 '' as F37_districtSaleDeptNumber,
 '' as F37_districtSaleDeptName,
 '' as F41_channelName,
 '' as F61_costCenterControlNumber,
 '' as F61_costCenterControlName,
 FCostCenter as FSAP_costCenterCode,
 '' as  FSAP_costElementName,
 FVchNumber as FSAP_voucherNumber,
 FRptAmt ,
case FChannel  when '市场' then '市场费用待分配'  else '直接费用归集' end as FFeeType,
 '' as FFeeName,
1 as FFeeRate,
'' as FAllocateType,
'' as FCostCenterType,
FBrand + FChannel as FBrandChannel
 from t_mrpt_adj   ")

#从 手调凭证基础表开始计取
rbu_ds_adj()

}


