library(rbupkg)
# 示例1 使用标准数据
rbu_normalize_rpa() -> data_rpa
View(data_rpa)
# 示例2使用历史版本数据
rbu_normalize_rpa(rpa_table = 'T_FI_RPA_202107') -> data_rpa_202107
View(data_rpa_202107)
