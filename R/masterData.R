#1、共享成本中心的渠道费用分配比例-----
#' 共享成本中心的渠道费用分配比例
#'
#' @return
#' @export
#'
#' @examples
rbu_md_costCenter_shared_salesFee <- function(){

  sql <- paste0("create view mrpt2_vw_md_costCenter_salesFee
as
select FcostCenter,FType,FChannel,FValue,FBrand2,FChannel2,
FYear,FPeriod,'共享' as FAllocateType,'渠道费用待分配' as FFeeType
from t_mrpt_costCenterRatio_sap
where FValue <> 1  and FType = '渠道'")
}


# 2、报表项目基础表--------
#' 报表项目基础表
#' t_mrpt_rptItem
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_md_rptItem <- function(variables) {

sql <- paste0("t_mrpt_rptItem")

}



#' 成本中心
#' mrpt2_vw_md_costCenter_total
#'
#' @return
#' @export
#'
#' @examples
rbu_md_costCenter_total <-function(){

sql <- paste0("create view  mrpt2_vw_md_costCenter_total
as
select * from mrpt2_vw_md_costCenter_directFee
union all
select * from  mrpt2_vw_md_costCenter_marketFee
union all
select * from mrpt2_vw_md_costCenter_salesFee_total  ")

rbu_md_costCenter_directFee()
rbu_md_costCenter_marketFee()
rbu_md_costCenter_salesFee_total()


}


rbu_md_costCenter_directFee <- function(variables) {
sql <- paste0("create view mrpt2_vw_md_costCenter_directFee
as
select FcostCenter,FType,FChannel,FValue,FBrand2,FChannel2,
FYear,FPeriod,'独立' as FAllocateType,'直接费用归集' as FFeeType
from t_mrpt_costCenterRatio_sap
where FValue = 1  and FType = '渠道'  ")

}

rbu_md_costCenter_marketFee <- function(variables) {
sql <- paste0("create view mrpt2_vw_md_costCenter_marketFee
as
select FcostCenter,FType,FChannel,FValue,FBrand2,FChannel2,
FYear,FPeriod,'独立' as FAllocateType,'市场费用待分配' as FFeeType
from t_mrpt_costCenterRatio_sap
where FValue = 1  and FType = '市场'  ")

}

rbu_md_costCenter_salesFee_total <- function(variables) {
sql <- paste0("create view  mrpt2_vw_md_costCenter_salesFee_total
as
select * from  mrpt2_vw_md_costCenter_salesFee_maysu_total
union all
select * from  mrpt2_vw_md_costCenter_salesFee_chando_total
union all
select * from mrpt2_vw_md_costCenter_salesFee_SpringSummer_total")
# 后续再继续分解

}



# 品牌渠道基础表
#' 基础资料品牌渠道表
#' t_mrpt2_md_brandChannel
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
rbu_md_brandChannel <- function(variables) {
sql <- paste0("t_mrpt2_md_brandChannel")

}




