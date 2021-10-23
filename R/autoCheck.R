#' 针对管报的RPA结果进行标准化
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 月份
#' @param FBrand 品牌
#' @param FChannel 渠道
#' @param rpa_table rpa所在表,由于进行了版本化可能存在多个表
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_normalize_rpa()
rbu_normalize_rpa <- function(conn=tsda::conn_rds('jlrds'),
                              FYear =2021,
                              FPeriod =7,
                              FBrand ='自然堂',
                              FChannel='美妆',
                              rpa_table = 'T_FI_RPA') {
  #针对品牌渠道数据进行标准化
  sql <- paste0("select FYear,FPeriod,b.FBrandNumber,b.FBrandName,b.FChannelNumber,b.FChannelName,b.FBrandChannelNumber,b.FBrandChannelName,FRptItemNumber,FRptItemName,FAcualAmt as FRptAmt from
",rpa_table,"  a
left join t_mrpt3_md_brandChannel b
on a.FBrand = b.FBrandName and a.FChannel =b.FChannelName
where  FYear= ",FYear," and FPeriod = ",FPeriod,"
and FBrand ='",FBrand,"' and FChannel ='",FChannel,"'
order by FRptItemNumber")
  res <- tsda::sql_select(conn,sql)
  return(res)

}

rbu_autoCheck_rpa_vs_target <- function(conn=tsda::conn_rds('jlrds'),
                                        FYear =2021,
                                        FPeriod =7,
                                        FBrand ='',
                                        FChannel=''

                                        ) {

}



