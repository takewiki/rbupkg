

#' 写入结果表至RDS
#' T_FI_RPA
#' rds_vw_T_FI_RPA_all
#'
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_api_res_rds()
rbu_api_res_rds <- function(conn = tsda::conn_rds('jlrds'),
                              FYear = 2021 ,
                              FPeriod =6) {
  sql_del <- paste0(" delete    from  T_FI_RPA
  where FYear = ",FYear," and FPeriod =   ", FPeriod)
  tsda::sql_update(conn,sql_del)
  sql_ins <- paste0("insert into T_FI_RPA
select * from  rds_vw_T_FI_RPA_all
where  FYear =  ",FYear," and  FPeriod =  ",FPeriod)
  tsda::sql_update(conn,sql_ins)



}



#' 向BW报表写入结果数据至hana
#'
#' @param FYear 年份
#' @param FPeriod 月份
#' @param conn  连接信息
#' @param view_name mrpt3_vw_FI_RPA mrpt2_vw_FI_RPA
#'
#' @return 返回结果
#' @export
#'
#' @examples
#'rbu_api_res_hana()
rbu_api_res_hana <- function(conn=tsda::conn_rds('jlrds'),
                           FYear = 2021,
                           FPeriod = 6,
                           view_name = 'mrpt3_vw_FI_RPA') {

  sql_str <- paste0("  select  [FYear]
      ,[FPeriod]
      ,[FBrandNumber]
      ,[FBrand]
      ,[FChannelNumber]
      ,[FChannel]
      ,[FSubChannel]
      ,[FRptItemNumber]
      ,[FRptItemName]
      ,[FAcualAmt]
      ,[FBudgetAmt]
      ,[FAchiveRatio]
      ,[FAcualAmt_Lag1]
      ,[FAchiveRatio_Lag1]
      ,[FAcualAmt_Lag2]
      ,[FAchiveRatio_Lag2]
      ,[FAcualCumAmt]
      ,[FBudgetCumAmt]
      ,[FAchiveCumRatio]
      ,[FAcualCumAmt_Lag1]
      ,[FAchiveCumRatio_Lag1]
      ,[FAcualCumAmt_Lag2]
      ,[FAchiveCumRatio_Lag2]
      ,[FBrandChannelNumber]
      ,[FBrandChannelName]
                    from ",view_name," where FYear = ",FYear," and FPeriod =  ",FPeriod,"
                    and FBrandNumber is not null and FChannelNumber is not null
                    ")
  data <- tsda::sql_select(conn, sql_str)
  print('data1')
  print(str(data))
  print(head(data))


  conn_hana= hana::hana_conn(user_name = "ZFI_RPA",pwd ="QAZwsx12")
  #删除数据
  print('bug')
  sql_del <- paste0("delete    from T_FI_RPA where FYear = ",FYear," and FPeriod =  ",FPeriod,"")
  hana::hana_update(conn_hana,sql_del)

  sql <- paste0("select top 10 *    from T_DETAILFI_RPA
              where fyear =2021 and fperiod =1 ")
  mydata <- hana::hana_select(conn_hana,sql)
  print('data2')
  print(str(mydata))

  #写入数据
  RJDBC::dbWriteTable(conn_hana,'T_FI_RPA', data,append=T, row.names=F, overwrite=F)
  #hana::hana_writeTable(var_hana_conn = conn_hana,table_name = 'T_FI_RPA',r_object = data,append = TRUE)



}



#' 将过程表写入至RDS
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_api_detail_rds()
rbu_api_detail_rds <- function(conn = tsda::conn_rds('jlrds'),
                                    FYear = 2021 ,
                                    FPeriod =6) {
  sql_del <- paste0(" delete    from  T_DETAILFI_RPA
  where FYear = ",FYear," and FPeriod =   ", FPeriod)
  tsda::sql_update(conn,sql_del)
  sql_ins <- paste0("insert into T_DETAILFI_RPA
SELECT [FYear]
      ,[FPeriod]
      ,[FBrand]
      ,[FChannel]
      ,[FSubChannel]
      ,[FRptItemNumber]
      ,[FRptItemName]
      ,[FAllocAmt]  as FAcualAmt
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
      ,[FRptAmt] as FSap_vchAmt,
	  '' as FSAP_vchTxt
      ,[FFeeRate] as FSap_ChannelFeeRate
      ,FFeeType as FSap_costCenterType
      ,FRptAmt as FJL_marketFeeAmt
      ,FFeeRate as FJL_marketFeeRate
  FROM [dbo].[mrpt2_t_ds_all_Allocated]
where  FYear =  ",FYear," and  FPeriod =  ",FPeriod)
  tsda::sql_update(conn,sql_ins)



}



#' 向BW报表写入明细数据至hana
#'
#' @param FYear 年份
#' @param FPeriod 月份
#' @param conn  连接信息
#' @param page_count 每页数量
#'
#' @return 返回结果
#' @export
#'
#' @examples
#'rbu_api_detail_hana()
rbu_api_detail_hana <- function(conn=tsda::conn_rds('jlrds'),FYear = 2021,FPeriod = 6,page_count =10000) {

  sql_count <- paste0(" select   isnull(min(rowId),0)-1 as min_count,count(1) as FCount
                    from mrpt2_vw_DETAILFI_RPA  where FYear = ",FYear," and FPeriod =  ",FPeriod,"")
  res_count <- tsda::sql_select(conn,sql_count)
  FCount <- res_count$FCount
  intial_id <- res_count$min_count
  if (FCount >0){

    #针对数据进行处理
    #先进行分页
    data_paging = tsdo::paging_setting(volume = FCount,each_page = page_count) + intial_id
    ls_paging = 1:nrow(data_paging)
    conn_hana= hana::hana_conn(user_name = "ZFI_RPA",pwd ="QAZwsx12")
    #删除数据
    sql_del <- paste0("delete   from T_DETAILFI_RPA where FYear = ",FYear," and FPeriod =  ",FPeriod,"")
    hana::hana_update(conn_hana,sql_del)

    lapply(ls_paging, function(page){
      FStart = data_paging$FStart[page]
      FEnd = data_paging$FEnd[page]

      sql_str <- paste0("  select [FYear]
      ,[FPeriod]
      ,[FBrandNumber]
      ,[FBrand]
      ,[FChannelNumber]
      ,[FChannel]
      ,[FSubChannel]
      ,[FRptItemNumber]
      ,[FRptItemName]
      ,[FAcualAmt]
      ,[FDataSource]
      ,[FSolutionNumber]
      ,[FSubNumber]
      ,[FValueType]
      ,[F13_itemGroupNumber]
      ,[F13_itemGroupName]
      ,[F14_brandNumer]
      ,[F14_brandName]
      ,[F30_customerNumber]
      ,[F30_customerName]
      ,[F33_subChannelNumber]
      ,[F33_subChannelName]
      ,[F37_disctrictSaleDeptNumber]
      ,[F37_disctrictSaleDeptName]
      ,[F41_channelName]
      ,[F61_costCenterControlNumber]
      ,[F61_costCenterControlName]
      ,[FSAP_costCenterCode]
      ,[FSAP_costElementName]
      ,[FSAP_voucherNumber]
      ,[FSAP_vchAmt]
      ,[FSAP_vchTxt]
      ,[FSAP_ChannelFeeRate]
      ,[FSAP_CostCenterType]
      ,[FJL_marketFeeAmt]
      ,[FJL_marketFeeRate]
      ,[FBrandChannelNumber]
      ,[FBrandChannelName]
                    from mrpt2_vw_DETAILFI_RPA  where FYear = ",FYear," and FPeriod =  ",FPeriod," and rowId >= ",FStart," and rowId <=  ",FEnd,"" )
      print(sql_str)
      data <- tsda::sql_select(conn, sql_str)

      #conn_hana= hana::hana_conn(user_name = "ZFI_RPA",pwd ="QAZwsx12")

      #写入数据
      hana::hana_writeTable(var_hana_conn = conn_hana,table_name = 'T_DETAILFI_RPA',r_object = data,append = TRUE)


    })



  }





}
