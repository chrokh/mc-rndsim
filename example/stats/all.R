# ====== DEPENDENCIES ======
#
# install.packages('gplots')
#
# ==========================

library(gplots)

pdf('plots/summary.pdf', 9, 8)

print('stats/cashflow.R')
source('stats/cashflow.R')

print('stats/cumulative-cashflow-01.R')
source('stats/cumulative-cashflow-01.R')

print('stats/cumulative-cashflow-02.R')
source('stats/cumulative-cashflow-02.R')

print('stats/predict-enpv.R')
source('stats/predict-enpv.R')

print('stats/enpv-per-phase.R')
source('stats/enpv-per-phase.R')

print('stats/notogo.R')
source('stats/notogo.R')

print('stats/interventions-enpv.R')
source('stats/interventions-enpv.R')

print('stats/go-ratio.R')
tmp <- source('stats/go-ratio.R')$value
write.table(tmp, 'plots/summary.csv', sep=',', row.names=FALSE)
textplot(tmp)

dev.off()
