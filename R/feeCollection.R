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
rbu_feeCollection_detail <- function(variables) {
sql <- paste0("select * from mrpt2_vw_ds_all_unAllocated  ")

}
# 1.1、费用归集-SAP-------
#' 费用归集-SAP
#' mrpt2_vw_ds_sap_all
#'
#' @return 返回值
#' @export
#'
#' @examples
#' rbu_feeCollection_sap()
rbu_feeCollection_sap <- function(){
sql <- paste0(" select  *   from mrpt2_vw_ds_sap_all  ")
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


