library(plyr)

df <- read.csv("./output/example.csv")

# Remove prize intervention since it's too broadly distributed to be useful here
tmp <- subset(df, df$group != 'prize')
tmp$group <- factor(tmp$group)

# Sum up cashflows
tmp$revenue  <- tmp$revenue0+tmp$revenue1+tmp$revenue2+tmp$revenue3+tmp$revenue4+tmp$revenue5 # NOTE: Not including market
tmp$cost     <- tmp$cost0+tmp$cost1+tmp$cost2+tmp$cost3+tmp$cost4+tmp$cost5 # NOTE: Not including market
tmp$cashflow <- tmp$revenue - tmp$cost

# Compute expected (probabilistic) cashflows
tmp$EXcashflow0 <- (tmp$revenue0 - tmp$cost0)
tmp$EXcashflow1 <- (tmp$revenue1 - tmp$cost1) * tmp$prob0
tmp$EXcashflow2 <- (tmp$revenue2 - tmp$cost2) * tmp$prob0 * tmp$prob1
tmp$EXcashflow3 <- (tmp$revenue3 - tmp$cost3) * tmp$prob0 * tmp$prob1 * tmp$prob2
tmp$EXcashflow4 <- (tmp$revenue4 - tmp$cost4) * tmp$prob0 * tmp$prob1 * tmp$prob2 * tmp$prob3
tmp$EXcashflow5 <- (tmp$revenue5 - tmp$cost5) * tmp$prob0 * tmp$prob1 * tmp$prob2 * tmp$prob3 * tmp$prob4
tmp$EXcashflow  <- tmp$EXcashflow0+tmp$EXcashflow1+tmp$EXcashflow2+tmp$EXcashflow3+tmp$EXcashflow4+tmp$EXcashflow5

# Sum up PoS
tmp$prob <- tmp$prob0*tmp$prob1*tmp$prob2*tmp$prob3*tmp$prob4*tmp$prob5 # NOTE: Not including market

# Compute expected market count
tmp$EXmarket_count <- ifelse(tmp$conseq_decision5 == 'true', tmp$prob, 0)

# Create base subset and rename columns to prepare for merge
base <- subset(tmp, tmp$group == 'base')
colnames(base) <- paste('x', colnames(base), sep='')

# Merge the two subsets
merged <- merge(tmp, base, by.x='id', by.y='xid')

# Compute promised and expected intervention spends
merged$spend <- merged$cashflow - merged$xcashflow
merged$EXspend <- merged$EXcashflow - merged$xEXcashflow

# Count the number of go-decisions and the interventions' price-efficiencies in terms of go-decisions
counted <- ddply(merged, .(group), summarize,
                 
                 # totals
                 xgos         = length(xconseq_decision5[xconseq_decision5 == 'true']),
                 gos          = length(conseq_decision5[conseq_decision5 == 'true']),
                 n            = length(id),
                 m            = sum(EXmarket_count),
                 tot_spend    = sum(spend),
                 tot_EXspend  = sum(EXspend),
                 
                 # go-rate
                 gorate           = gos / n,
                 xgorate          = xgos / n,
                 gorateimpr       = gorate / xgorate,
                 spend_per_impr   = tot_spend / gorateimpr,
                 EXspend_per_impr = tot_EXspend / gorateimpr,
                 
                 # per entry / exit
                 spend_per_entry    = tot_spend / n,
                 spend_per_EXexit   = tot_spend / m,
                 EXspend_per_entry  = tot_EXspend / n,
                 EXspend_per_EXexit = tot_EXspend / m
)
counted
