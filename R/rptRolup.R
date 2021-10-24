#' 计算累计数，意义不大，整体做的计算
#' rds_t_mrpt_res_cumsum_rpa
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_rollup_ytdCumsum()
rbu_rollup_ytdCumsum <- function(conn = tsda::conn_rds('jlrds'),
                               FYear = 2021 ,
                               FPeriod =6) {
#这种计算累计数的方法不再使用，意义不大
# 由于存在利润率等百分比指标，累加会造成数据异常
  sql_del <- paste0(" delete    from  rds_t_mrpt_res_cumsum_rpa
  where FYear = ",FYear," and FPeriod =   ", FPeriod)
  tsda::sql_update(conn,sql_del)
  sql_ins <- paste0("insert into  rds_t_mrpt_res_cumsum_rpa
SELECT [FYear]
      , ",FPeriod," as [FPeriod]
      ,[FBrand]
      ,[FChannel]
      ,[FSubChannel]
      ,[FRptItemNumber]
      ,[FRptItemName]
      ,sum(FAcualAmt) as FAcualCumAmt
      ,sum(FBudgetAmt) as FBudgetCumAmt
  ,case sum(FBudgetAmt) when 0 then 0 else sum(FAcualAmt)/sum(FBudgetAmt) end as  FAchiveCumRatio


      ,sum([FAcualAmt_Lag1]) as FAcualCumAmt_Lag1
  ,case  sum([FAcualAmt_Lag1]) when 0 then 0 else sum(FAcualAmt) /sum([FAcualAmt_Lag1]) end as FAchiveCumRatio_Lag1


      ,sum([FAcualAmt_Lag2]) as FAcualCumAmt_Lag2
  ,case  sum([FAcualAmt_Lag2]) when 0 then 0 else sum(FAcualAmt)/sum([FAcualAmt_Lag2]) end as FAchiveCumRatio_Lag2




  FROM [dbo].[rds_t_mrpt_res_current_rpa]
  where  FYear = ",FYear," and  FPeriod <=   ",FPeriod,"
  group by [FYear], FBrand,FChannel,FSubChannel,FRptItemNumber,FRptItemName")
  tsda::sql_update(conn,sql_ins)

}

# 计划结果计算-手工管报数据,自动计算其他级次数据-------
#' 计划结果计算-手工管报数据-当期数据
#' 1-6月数据采用target人工计算数据
#' mrpt_calc_runAll_target
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 月份
#' @param plan_table 计划表
#' @param src_table 来源表
#' @param res_table 结果表
#' @param data_table 数据表
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_rollup_target()
rbu_rollup_res_target <- function(conn=tsda::conn_rds('jlrds'),
                                    FYear =2021,
                                    FPeriod =1,
                                    plan_table ='t_mrpt2_calcPlan',
                                    src_table = 't_mrpt_target',
                                    res_table = 't_mrpt3_res',
                                    data_table = 'vw_mrpt_target_count'){
  #非正常函数，用于逻辑检查
  mrpt_calc_plan(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table,data_table = data_table)
  mrpt_calc_brandChannel_step1_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step1_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,src_table = src_table,plan_table = plan_table )
  mrpt_calc_brandChannel_step1_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table,src_table = src_table)
  mrpt_calc_brandChannel_step3_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  #添加集团管报中后台费用的计算
  mrpt_calc_mpv(conn = conn,data_table = res_table,FYear = FYear,FPeriod = FPeriod)

}

# 计划结果计算-RPA数据，自然计算其他品牌渠道------
#' 计划结果计算-RPA数据
#' 从7月开始计算，保留6月数据
#' mrpt_calc_runAll_rpa
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 月份
#' @param plan_table 计划表
#' @param src_table 来源表
#' @param res_table 结果表
#' @param data_table 数据表
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mrpt_calc_runAll()
rbu_rollup_res_rpa <- function(conn=tsda::conn_rds('jlrds'),
                                 FYear =2021,
                                 FPeriod =7,
                                 plan_table ='t_mrpt2_calcPlan',
                                 src_table = 'vw_fi_rpa',
                                 res_table = 't_mrpt3_res',
                                 data_table = 'vw_mrpt_rpa_count'){
  mrpt_calc_plan(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table,data_table = data_table)
  mrpt_calc_brandChannel_step1_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step1_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,src_table = src_table,plan_table = plan_table )
  mrpt_calc_brandChannel_step1_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table,src_table = src_table)
  mrpt_calc_brandChannel_step3_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  #添加集团管报中后台费用的计算
  mrpt_calc_mpv(conn = conn,data_table = res_table,FYear = FYear,FPeriod = FPeriod)

}

#' 计算累计数_实际数
#' mrpt_calc_cumSum_Period_res
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mrpt_calc_cumSum_Period_actual()
rbu_rollup_res_sumSum <- function(conn=tsda::conn_rds('jlrds'),
                                        FYear = 2019,
                                        FPeriod = 2




){
  #针对历史数据进行处理
  mrpt_calc_cumSum_Period(conn = conn,FYear = FYear,FPeriod = FPeriod,table_data = 't_mrpt3_res',
                          table_cumSum = 't_mrpt3_res_cumSum')

}



# 针对历史数据进行处理,自动计算其他级次--------
#' 针对历史数据进行处理
#' mrpt_calc_runAll_actual
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 月份
#' @param plan_table 计划表
#' @param src_table 来源表
#' @param res_table 结果表
#' @param data_table 数据表
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mrpt_calc_runAll_actual()
rbu_rollup_actual <- function(conn=tsda::conn_rds('jlrds'),
                                    FYear =2021,
                                    FPeriod =1,
                                    plan_table ='t_mrpt2_calcPlan_actual',
                                    src_table = 'vw_mrpt_actual',
                                    res_table = 't_mrpt3_res_actual',
                                    data_table = 'vw_mrpt_actual_count'){
  mrpt_calc_plan(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table,data_table = data_table)
  mrpt_calc_brandChannel_step1_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step1_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,src_table = src_table,plan_table = plan_table )
  mrpt_calc_brandChannel_step1_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table,src_table = src_table)
  mrpt_calc_brandChannel_step3_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)

}


#' 计算历史数据累计数
#' mrpt_calc_cumSum_Period
#'
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#' @param table_data 数据表明细
#' @param table_cumSum 数据表汇总
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mrpt_calc_cumSum_Period()
rbu_rollup_actual_cumSum <- function(conn=tsda::conn_rds('jlrds'),
                                    FYear = 2019,
                                    FPeriod = 2,
                                    table_data = 't_mrpt3_res_actual',
                                    table_cumSum = 't_mrpt3_res_actual_cumSum'




){

  sql = paste0("  select  distinct   FBrand,FChannel  from   ",table_data,"
   where FYear = ",FYear," and FPeriod  <=  ",FPeriod," ")
  data <- tsda::sql_select(conn,sql)
  ncount <- nrow(data)
  if(ncount  >0){
    #存在数据的情况下
    lapply(1:ncount, function(i){
      FBrand = data$FBrand[i]
      FChannel = data$FChannel[i]
      #针对第一项进行处理
      mrpt_calc_cumSum_item(conn = conn,FYear = FYear,FPeriod = FPeriod,FBrand = FBrand,FChannel = FChannel,table_data = table_data,table_cumSum = table_cumSum)





    })



  }





}


# 针对执行预算进行处理-------
#' 针对执行预算进行处理
#' mrpt_calc_runAll_budget
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 月份
#' @param plan_table 计划表
#' @param src_table 来源表
#' @param res_table 结果表
#' @param data_table 数据表
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mrpt_calc_runAll_actual()
rbu_rollup_budget <- function(conn=tsda::conn_rds('jlrds'),
                                    FYear =2021,
                                    FPeriod =1,
                                    plan_table ='t_mrpt2_calcPlan_budget',
                                    src_table = 'vw_mrpt_budget',
                                    res_table = 't_mrpt3_res_budget',
                                    data_table = 'vw_mrpt_budget_count'){
  mrpt_calc_plan(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table,data_table = data_table)
  mrpt_calc_brandChannel_step1_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step1_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,src_table = src_table,plan_table = plan_table )
  mrpt_calc_brandChannel_step1_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step2_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_setDone(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step3_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table,src_table = src_table)
  mrpt_calc_brandChannel_step3_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step4_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step5_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_writeRes(conn = conn,FYear = FYear,FPeriod = FPeriod,res_table = res_table,plan_table = plan_table)
  mrpt_calc_brandChannel_step6_updateStatus(conn = conn,FYear = FYear,FPeriod = FPeriod,plan_table = plan_table)

}


#计算累计数_执行预算--------
#' 计算累计数_执行预算
#' mrpt_calc_cumSum_Period_budget
#'
#' @param conn 连接
#' @param FYear 年份
#' @param FPeriod 期间
#'
#' @return 返回值
#' @export
#'
#' @examples
#' mrpt_calc_cumSum_Period_actual()
rbu_rollup_budget_sumSum <- function(conn=tsda::conn_rds('jlrds'),
                                           FYear = 2019,
                                           FPeriod = 2




){
  #针对历史数据进行处理
  mrpt_calc_cumSum_Period(conn = conn,FYear = FYear,FPeriod = FPeriod,table_data = 't_mrpt3_res_budget',
                          table_cumSum = 't_mrpt3_res_budget_cumSum')

}



#' 计算结果表,整合当期及累计期间数据
#' 基本不用这个方法了
#' rds_vw_T_FI_RPA_all
#'
#' @param variables 变量
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_rollup_res_all()
rbu_rollup_res_all <- function(variables) {
  #后续将不再使用
  .Deprecated()

  sql <- paste0("create view  rds_vw_T_FI_RPA_all
as
select a.*,b.FAcualCumAmt,b.FBudgetCumAmt,b.FAchiveCumRatio,b.FAcualCumAmt_Lag1,b.FAchiveCumRatio_Lag1,
b.FAcualCumAmt_Lag2,b.FAchiveCumRatio_Lag2
 from rds_t_mrpt_res_current_rpa a
left join rds_t_mrpt_res_cumsum_rpa b
on
a.FYear =b.FYear and a.FPeriod = b.FPeriod and a.FBrand =b.FBrand
and a.FChannel = b.FChannel and isnull(a.FSubChannel,'') =isnull(b.FSubChannel,'')
and a.FRptItemNumber = b.FRptItemNumber  ")

}
