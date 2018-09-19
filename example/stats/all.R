pdf('plots/summary.pdf', 9, 8)

print('stats/enpv-01.R')
source('stats/enpv-01.R')

print('stats/enpv-02.R')
source('stats/enpv-02.R')

print('stats/enpv.R')
source('stats/enpv.R')

print('stats/cashflow.R')
source('stats/cashflow.R')

print('stats/cumulative-cashflow-01.R')
source('stats/cumulative-cashflow-01.R')

print('stats/cumulative-cashflow-02.R')
source('stats/cumulative-cashflow-02.R')

print('stats/cashflow.R')
source('stats/cashflow.R')

print('stats/notogo.R')
source('stats/notogo.R')


dev.off()
