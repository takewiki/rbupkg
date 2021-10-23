#1.费用分配明细表-------
#' 费用分配明细表
#' mrpt2_vw_ds_all_Allocated
#'
#' @param variables
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllcation_detail()
rbu_feeAllcation_detail <- function(variables) {
  rbu_feeAllocation_marktNot()
  rbu_feeAllocation_market_toChannel()
  rbu_feeAllocation_ka()
  rbu_feeAllocation_TeTong()
  rbu_feeAllocation_Biorrier_minusRevenue()

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
sql <- paste0("select * from mrpt2_vw_ds_all_unAllocated_marketNot")

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

sql <- paste0("select * from vw_mrpt_res_MartetFee_toChannel")
}

# 1.3、费用分配明细KA数据(正常不会单独处理KA数据)-------
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
rbu_feeAllocation_ka <- function(variables) {

sql <- paste0("select * from mrpt2_vw_ds_all_kaTotal_detail")

}

# 1.4、费用分配处理特通数据-------
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
rbu_feeAllocation_TeTong <- function(variables) {
sql <- paste0("select * from mrpt2_vw_ds_all_TeTongTotal_detail")

}

# 1.5、费用分配药房冲减收入------
#' 费用分配药房冲减收入
#' mrpt2_vw_ds_all_biorrierYaoFang_RevenueMinus
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeAllocation_Biorrier_minusRevenue()
rbu_feeAllocation_Biorrier_minusRevenue <- function(){
sql <- paste0("select * from mrpt2_vw_ds_all_biorrierYaoFang_RevenueMinus ")
}





