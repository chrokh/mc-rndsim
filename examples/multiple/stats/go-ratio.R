library(plyr)

df <- read.csv("./output/example.csv")

# Remove prize intervention since it's too broadly distributed to be useful here
tmp <- subset(df, df$group != 'prize')
tmp$group <- factor(tmp$group)

# Compute development cashflows (i.e. excluding the market)
tmp$cashflow0 <- tmp$revenue0 - tmp$cost0
tmp$cashflow1 <- tmp$revenue1 - tmp$cost1
tmp$cashflow2 <- tmp$revenue2 - tmp$cost2
tmp$cashflow3 <- tmp$revenue3 - tmp$cost3
tmp$cashflow4 <- tmp$revenue4 - tmp$cost4
tmp$cashflow5 <- tmp$revenue5 - tmp$cost5
tmp$cashflow  <- tmp$cashflow0+tmp$cashflow1+tmp$cashflow2+tmp$cashflow3+tmp$cashflow4+tmp$cashflow5

# Compute go-corrected development cashflow
tmp$go_corrected_cashflow0 <- ifelse(tmp$conseq_decision0=='true', tmp$cashflow0, 0)
tmp$go_corrected_cashflow1 <- ifelse(tmp$conseq_decision1=='true', tmp$cashflow1, 0)
tmp$go_corrected_cashflow2 <- ifelse(tmp$conseq_decision2=='true', tmp$cashflow2, 0)
tmp$go_corrected_cashflow3 <- ifelse(tmp$conseq_decision3=='true', tmp$cashflow3, 0)
tmp$go_corrected_cashflow4 <- ifelse(tmp$conseq_decision4=='true', tmp$cashflow4, 0)
tmp$go_corrected_cashflow5 <- ifelse(tmp$conseq_decision5=='true', tmp$cashflow5, 0)
tmp$go_corrected_cashflow <- tmp$go_corrected_cashflow0+tmp$go_corrected_cashflow1+tmp$go_corrected_cashflow2+tmp$go_corrected_cashflow3+tmp$go_corrected_cashflow4+tmp$go_corrected_cashflow5

# Compute expected development cashflows
tmp$expected_cashflow0 <- (tmp$revenue0 - tmp$cost0)
tmp$expected_cashflow1 <- (tmp$revenue1 - tmp$cost1) * tmp$prob0
tmp$expected_cashflow2 <- (tmp$revenue2 - tmp$cost2) * tmp$prob0 * tmp$prob1
tmp$expected_cashflow3 <- (tmp$revenue3 - tmp$cost3) * tmp$prob0 * tmp$prob1 * tmp$prob2
tmp$expected_cashflow4 <- (tmp$revenue4 - tmp$cost4) * tmp$prob0 * tmp$prob1 * tmp$prob2 * tmp$prob3
tmp$expected_cashflow5 <- (tmp$revenue5 - tmp$cost5) * tmp$prob0 * tmp$prob1 * tmp$prob2 * tmp$prob3 * tmp$prob4
tmp$expected_cashflow  <- tmp$expected_cashflow0+tmp$expected_cashflow1+tmp$expected_cashflow2+tmp$expected_cashflow3+tmp$expected_cashflow4+tmp$expected_cashflow5

# Compute "go-corrected" expected development cashflows
tmp$go_corrected_expected_cashflow0 <- ifelse(tmp$conseq_decision0=='true', tmp$expected_cashflow0, 0)
tmp$go_corrected_expected_cashflow1 <- ifelse(tmp$conseq_decision1=='true', tmp$expected_cashflow1, 0)
tmp$go_corrected_expected_cashflow2 <- ifelse(tmp$conseq_decision2=='true', tmp$expected_cashflow2, 0)
tmp$go_corrected_expected_cashflow3 <- ifelse(tmp$conseq_decision3=='true', tmp$expected_cashflow3, 0)
tmp$go_corrected_expected_cashflow4 <- ifelse(tmp$conseq_decision4=='true', tmp$expected_cashflow4, 0)
tmp$go_corrected_expected_cashflow5 <- ifelse(tmp$conseq_decision5=='true', tmp$expected_cashflow5, 0)
tmp$go_corrected_expected_cashflow  <- tmp$go_corrected_expected_cashflow0+tmp$go_corrected_expected_cashflow1+tmp$go_corrected_expected_cashflow2+tmp$go_corrected_expected_cashflow3+tmp$go_corrected_expected_cashflow4+tmp$go_corrected_expected_cashflow5

# Compute development probability
tmp$prob <- tmp$prob0*tmp$prob1*tmp$prob2*tmp$prob3*tmp$prob4*tmp$prob5

# Compute expected market count
tmp$expected_exits              <- tmp$prob
tmp$go_corrected_expected_exits <- ifelse(tmp$conseq_decision5 == 'true', tmp$prob, 0)

# Create base subset and rename columns to prepare for merge
base <- subset(tmp, tmp$group == 'base')
colnames(base) <- paste('x', colnames(base), sep='')

# Remove base from non-base subset and merge the two subsets
merged <- merge(subset(tmp, tmp$group != 'base'), base, by.x='id', by.y='xid')

# Compute intervention spend
merged$worst_case_spend0 <- merged$cashflow0 - merged$xcashflow0
merged$worst_case_spend1 <- merged$cashflow1 - merged$xcashflow1
merged$worst_case_spend2 <- merged$cashflow2 - merged$xcashflow2
merged$worst_case_spend3 <- merged$cashflow3 - merged$xcashflow3
merged$worst_case_spend4 <- merged$cashflow4 - merged$xcashflow4
merged$worst_case_spend5 <- merged$cashflow5 - merged$xcashflow5
merged$worst_case_spend <- merged$cashflow - merged$xcashflow

# Compute expected intervention spend
merged$expected_spend0 <- merged$worst_case_spend0
merged$expected_spend1 <- merged$worst_case_spend1 * merged$prob0
merged$expected_spend2 <- merged$worst_case_spend2 * merged$prob0 * merged$prob1
merged$expected_spend3 <- merged$worst_case_spend3 * merged$prob0 * merged$prob1 * merged$prob2
merged$expected_spend4 <- merged$worst_case_spend4 * merged$prob0 * merged$prob1 * merged$prob2 * merged$prob3
merged$expected_spend5 <- merged$worst_case_spend5 * merged$prob0 * merged$prob1 * merged$prob2 * merged$prob3 * merged$prob4
merged$expected_spend  <- merged$expected_spend0+merged$expected_spend1+merged$expected_spend2+merged$expected_spend3+merged$expected_spend4+merged$expected_spend5

# Compute go-corrected intervention spend
merged$go_corrected_worst_case_spend0 <- ifelse(merged$conseq_decision0=='true', merged$worst_case_spend0, 0)
merged$go_corrected_worst_case_spend1 <- ifelse(merged$conseq_decision1=='true', merged$worst_case_spend1, 0)
merged$go_corrected_worst_case_spend2 <- ifelse(merged$conseq_decision2=='true', merged$worst_case_spend2, 0)
merged$go_corrected_worst_case_spend3 <- ifelse(merged$conseq_decision3=='true', merged$worst_case_spend3, 0)
merged$go_corrected_worst_case_spend4 <- ifelse(merged$conseq_decision4=='true', merged$worst_case_spend4, 0)
merged$go_corrected_worst_case_spend5 <- ifelse(merged$conseq_decision5=='true', merged$worst_case_spend5, 0)
merged$go_corrected_worst_case_spend  <- merged$go_corrected_worst_case_spend0+merged$go_corrected_worst_case_spend1+merged$go_corrected_worst_case_spend2+merged$go_corrected_worst_case_spend3+merged$go_corrected_worst_case_spend4+merged$go_corrected_worst_case_spend5

# Compute go-corrected expected intervention spend
merged$go_corrected_expected_spend0 <- ifelse(merged$conseq_decision0=='true', merged$expected_spend0, 0)
merged$go_corrected_expected_spend1 <- ifelse(merged$conseq_decision1=='true', merged$expected_spend1, 0)
merged$go_corrected_expected_spend2 <- ifelse(merged$conseq_decision2=='true', merged$expected_spend2, 0)
merged$go_corrected_expected_spend3 <- ifelse(merged$conseq_decision3=='true', merged$expected_spend3, 0)
merged$go_corrected_expected_spend4 <- ifelse(merged$conseq_decision4=='true', merged$expected_spend4, 0)
merged$go_corrected_expected_spend5 <- ifelse(merged$conseq_decision5=='true', merged$expected_spend5, 0)
merged$go_corrected_expected_spend  <- merged$go_corrected_expected_spend0+merged$go_corrected_expected_spend1+merged$go_corrected_expected_spend2+merged$go_corrected_expected_spend3+merged$go_corrected_expected_spend4+merged$go_corrected_expected_spend5

# Count the number of go-decisions and the interventions' price-efficiencies in terms of go-decisions
# The word "spend" here refers to "intervention spend"
counted <- ddply(
  merged,
  .(group),
  summarize,

  # in and out
  entries                                                     =  length(id),
  expected_exits                                              =  sum(expected_exits),
  go_corrected_expected_exits                                 =  sum(go_corrected_expected_exits),

  # gos
  base_gos                                                    =  length(xconseq_decision5[xconseq_decision5 == 'true']),
  gos                                                         =  length(conseq_decision5[conseq_decision5   == 'true']),

  # spends
  worst_case_spend                                            =  sum(worst_case_spend),
  go_corrected_worst_case_spend                               =  sum(go_corrected_worst_case_spend),
  expected_spend                                              =  sum(expected_spend),
  go_corrected_expected_spend                                 =  sum(go_corrected_expected_spend),

  # go-rate
  gorate                                                      =  gos / entries,
  xgorate                                                     =  base_gos / entries,
  gorate_improvement                                          =  gorate / xgorate,

  # cost of go-rate improvement
  worst_case_spend_per_improvement                            =  worst_case_spend / gorate_improvement,
  expected_spend_per_improvement                              =  expected_spend / gorate_improvement,
  go_corrected_worst_case_spend_per_improvement               =  go_corrected_worst_case_spend / gorate_improvement,
  go_corrected_expected_spend_per_improvement                 =  go_corrected_expected_spend / gorate_improvement,

  # intervention spends per entry
  worst_case_spend_per_entry                                  =  worst_case_spend / entries,
  expected_spend_per_entry                                    =  expected_spend / entries,

  # intervention spends per exits
  expected_spend_per_expected_exit                            =  expected_spend / expected_exits,
  go_corrected_expected_spend_per_go_corrected_expected_exit  =  go_corrected_expected_spend / go_corrected_expected_exits
)
counted
