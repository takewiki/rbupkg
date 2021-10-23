
# 管报自动化处理差异表------
#' 管报自动化处理差异表
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#' @param FBrand 品牌
#' @param FChannel 渠道
#' @param rpa_table rpa表名
#'
#' @return 返回值
#' @export
#'
#' @examples
#' library(rbupkg)
#' rbu_autoCheck_rpa_vs_target() -> mydata
#' View(mydata)
rbu_autoCheck_rpa_vs_target <- function(conn=tsda::conn_rds('jlrds'),
                                        FYear =2021,
                                        FPeriod =7,
                                        FBrand ='自然堂',
                                        FChannel='美妆',
                                        rpa_table = 'T_FI_RPA'
                                        ) {
data_rpa = rbu_normalize_rpa(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,rpa_table = rpa_table)
data_target = rbu_normalize_target(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel)
data_target <- data_target[,c('FRptItemNumber','FRptAmt','FRptAmt_orginal','FRemark')]
View(data_target)


data_all = left_join(data_rpa,data_target,by=c('FRptItemNumber'),suffix=c('_rpa','_target'))
#针对数据的缺少值进行处理
data_all$FRptAmt_rpa = tsdo::na_replace(data_all$FRptAmt_rpa,0)
data_all$FRptAmt_target = tsdo::na_replace(data_all$FRptAmt_target,0)
data_all$FRptAmt_orginal = tsdo::na_replace(data_all$FRptAmt_orginal,0)
data_all$FRemark  = tsdo::na_replace(data_all$FRemark,'')
#计算统计指标
data_all$FDiff_amt = round(data_all$FRptAmt_rpa - data_all$FRptAmt_target,4)
value_percent = round(data_all$FRptAmt_rpa / data_all$FRptAmt_target,2)
data_all$FDiff_percent = ifelse(is.infinite(value_percent),0,value_percent)
data_all$FDiff_percent = ifelse(is.nan(data_all$FDiff_percent),1,data_all$FDiff_percent)
#计算其他指标
data_all$FDiff_amt_original = round(data_all$FRptAmt_rpa - data_all$FRptAmt_orginal,4)
value_percent_original = round(data_all$FRptAmt_rpa / data_all$FRptAmt_orginal,2)
data_all$FDiff_percent_original = ifelse(is.infinite(value_percent_original),0,value_percent_original)
#针对数据已经修改了
data_all$FDiff_percent_original = ifelse(is.nan(data_all$FDiff_percent_original),1,data_all$FDiff_percent_original)
return(data_all)

}



