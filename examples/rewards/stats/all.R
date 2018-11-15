library(plyr)

# =============== Options ==================
options(scipen=999)                     # Turn off scientific notation
DISCOUNT_RATE <- 0.04                   # State discount rate assumption
WASTE         <- 0.35                   # State inefficiency asspumption
GAMING        <- 0.1                    # Risk of gaming assumption
df <- read.csv("./output/example.csv")  # Input data
write_to_file <- TRUE                   # Write to file?
# ==========================================


# =========== Setup ========================
if (write_to_file) {
  pdf('plots/summary.pdf', 7, 6)  # 9, 8
}

tmp <- df
#===========================================


# =========== Helper functions ==============
mround <- function(x,base){  base * round(x / base) } # round to nearest
bin_into <- function(vec, n) { mround(vec, round((max(vec) - min(vec)) / n)) }
log_bin <- function(vec, div=1) {
  bot <- floor(log10(min(vec)))
  top <- ceiling(log10(max(vec)))
  f <- function (x) {
    i <- bot
    while (i <= top) {
      if (x >= 10^i & x < 10^(i+1)) {
        return ( mround(x, 10^i / div) )
      }
      i <- i+1
    }
    print(x)
    print(i)
    stop('error')
  }
  sapply(vec, f)
}

# source: https://gist.github.com/cavvia/811206
# TODO: Min is not respected. Seems to always start from 1.
log_tick_marks <- function(min,max)
{
  nsplit <- abs(round(log10(max-min)))
  i <- 0
  nurange <- c()
  while(i<=nsplit) {
    f <- function(x) x*(10^i)
    nurange <- c(nurange,sapply(1:10,f))
    i <- i+1;
  }
  nurange
}
# =========================================


# Sum up development costs, revenues, and PoS (i.e. excluding the market)
tmp$prob     <- tmp$prob0 * tmp$prob1 * tmp$prob2 * tmp$prob3 * tmp$prob4 * tmp$prob5
tmp$cost     <- tmp$cost0 + tmp$cost1 + tmp$cost2 + tmp$cost3 + tmp$cost4 + tmp$cost5
tmp$revenue  <- tmp$revenue0 + tmp$revenue1 + tmp$revenue2 + tmp$revenue3 + tmp$revenue4 + tmp$revenue5

# Sum up cashflows
tmp$cashflow0 <- tmp$revenue0 - tmp$cost0
tmp$cashflow1 <- tmp$revenue1 - tmp$cost1
tmp$cashflow2 <- tmp$revenue2 - tmp$cost2
tmp$cashflow3 <- tmp$revenue3 - tmp$cost3
tmp$cashflow4 <- tmp$revenue4 - tmp$cost4
tmp$cashflow5 <- tmp$revenue5 - tmp$cost5
tmp$cashflow  <- tmp$revenue - tmp$cost

# Compute cumulative time spent at different points from PC
tmp$timeto0 <- 0
tmp$timeto1 <- tmp$time0
tmp$timeto2 <- tmp$time0 + tmp$time1
tmp$timeto3 <- tmp$time0 + tmp$time1 + tmp$time2
tmp$timeto4 <- tmp$time0 + tmp$time1 + tmp$time2 + tmp$time3
tmp$timeto5 <- tmp$time0 + tmp$time1 + tmp$time2 + tmp$time3 + tmp$time4

# Compute inefficiency-corrected cumulative time spent at different points from PC
tmp$ineff_timeto0 <- 0
tmp$ineff_timeto1 <- tmp$ineff_timeto0 + (tmp$time0 * (1+WASTE))
tmp$ineff_timeto2 <- tmp$ineff_timeto1 + (tmp$time1 * (1+WASTE))
tmp$ineff_timeto3 <- tmp$ineff_timeto2 + (tmp$time2 * (1+WASTE))
tmp$ineff_timeto4 <- tmp$ineff_timeto3 + (tmp$time3 * (1+WASTE))
tmp$ineff_timeto5 <- tmp$ineff_timeto4 + (tmp$time4 * (1+WASTE))

# Compute public ENPV (TODO: IS PROB HANDLED CORRECTLY IN THE ENPV CALCULATIONS ???)
tmp$public_epv0 <- (tmp$revenue0-tmp$cost0)/((1+DISCOUNT_RATE)^tmp$timeto0) * 1
tmp$public_epv1 <- (tmp$revenue1-tmp$cost1)/((1+DISCOUNT_RATE)^tmp$timeto1) * tmp$prob0
tmp$public_epv2 <- (tmp$revenue2-tmp$cost2)/((1+DISCOUNT_RATE)^tmp$timeto2) * tmp$prob1
tmp$public_epv3 <- (tmp$revenue3-tmp$cost3)/((1+DISCOUNT_RATE)^tmp$timeto3) * tmp$prob2
tmp$public_epv4 <- (tmp$revenue4-tmp$cost4)/((1+DISCOUNT_RATE)^tmp$timeto4) * tmp$prob3
tmp$public_epv5 <- (tmp$revenue5-tmp$cost5)/((1+DISCOUNT_RATE)^tmp$timeto5) * tmp$prob4
tmp$public_enpv0 <- tmp$public_epv0 + tmp$public_epv1 + tmp$public_epv2 + tmp$public_epv3 + tmp$public_epv4 + tmp$public_epv5

# Compute inefficiency-corrected public ENPV
tmp$ineff_public_epv0 <- (tmp$revenue0-tmp$cost0*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto0)) * 1
tmp$ineff_public_epv1 <- (tmp$revenue1-tmp$cost1*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto1)) * (tmp$prob0*(1-WASTE))
tmp$ineff_public_epv2 <- (tmp$revenue2-tmp$cost2*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto2)) * (tmp$prob1*(1-WASTE))
tmp$ineff_public_epv3 <- (tmp$revenue3-tmp$cost3*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto3)) * (tmp$prob2*(1-WASTE))
tmp$ineff_public_epv4 <- (tmp$revenue4-tmp$cost4*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto4)) * (tmp$prob3*(1-WASTE))
tmp$ineff_public_epv5 <- (tmp$revenue5-tmp$cost5*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto5)) * (tmp$prob4*(1-WASTE))
tmp$ineff_public_enpv0 <- tmp$ineff_public_epv0 + tmp$ineff_public_epv1 + tmp$ineff_public_epv2 + tmp$ineff_public_epv3 + tmp$ineff_public_epv4 + tmp$ineff_public_epv5

# Compute inefficiency-corrected public ENPV (IS PROB HANDLED CORRECTLY HERE?)
tmp$ineff_cash_only_public_epv0  <- (tmp$revenue0-tmp$cost0*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto0)) * 1
tmp$ineff_cash_only_public_epv1  <- (tmp$revenue1-tmp$cost1*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto1)) * (tmp$prob0)
tmp$ineff_cash_only_public_epv2  <- (tmp$revenue2-tmp$cost2*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto2)) * (tmp$prob1)
tmp$ineff_cash_only_public_epv3  <- (tmp$revenue3-tmp$cost3*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto3)) * (tmp$prob2)
tmp$ineff_cash_only_public_epv4  <- (tmp$revenue4-tmp$cost4*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto4)) * (tmp$prob3)
tmp$ineff_cash_only_public_epv5  <- (tmp$revenue5-tmp$cost5*(1+WASTE))/((1+DISCOUNT_RATE)^(tmp$ineff_timeto5)) * (tmp$prob4)
tmp$ineff_cash_only_public_enpv0 <- tmp$ineff_cash_only_public_epv0 + tmp$ineff_cash_only_public_epv1 + tmp$ineff_cash_only_public_epv2 + tmp$ineff_cash_only_public_epv3 + tmp$ineff_cash_only_public_epv4 + tmp$ineff_cash_only_public_epv5

# Split on intervention/base and join horizontally to allow comparisons
tmp0 <- subset(tmp, tmp$group == 'base')              # base
tmp1 <- subset(tmp, tmp$group != 'base')              # interventions
colnames(tmp1) <- paste('i', colnames(tmp1), sep='')  # prepend letter to intervention col names
merged <- merge(tmp0, tmp1, by.x='id', by.y='iid')    # merge
base <- tmp0                                          # alias (TODO: don't use 2 vars)

# Pre-compute input ranges for printing
discount_rates = paste('[', min(merged$discount_rate), ',', max(merged$discount_rate), ']', sep='')
thresholds     = paste('[', min(merged$threshold), ',', max(merged$threshold), ']', sep='')

# Compute non-capitalized intervention spend
merged$spend0 <- merged$icashflow0 - merged$cashflow0
merged$spend1 <- merged$icashflow1 - merged$cashflow1
merged$spend2 <- merged$icashflow2 - merged$cashflow2
merged$spend3 <- merged$icashflow3 - merged$cashflow3
merged$spend4 <- merged$icashflow4 - merged$cashflow4
merged$spend5 <- merged$icashflow5 - merged$cashflow5
merged$spend  <- merged$icashflow - merged$cashflow

# Compute enpv spend (NOT SURE IF PROB HERE IS CORRECT. I could not figure out R0/Ri properly)
merged$epv_spend0 <- -(merged$spend0 / ((1+DISCOUNT_RATE)^merged$itimeto0)) * 1
merged$epv_spend1 <- -(merged$spend1 / ((1+DISCOUNT_RATE)^merged$itimeto1)) * merged$iprob0
merged$epv_spend2 <- -(merged$spend2 / ((1+DISCOUNT_RATE)^merged$itimeto2)) * merged$iprob1
merged$epv_spend3 <- -(merged$spend3 / ((1+DISCOUNT_RATE)^merged$itimeto3)) * merged$iprob2
merged$epv_spend4 <- -(merged$spend4 / ((1+DISCOUNT_RATE)^merged$itimeto4)) * merged$iprob3
merged$epv_spend5 <- -(merged$spend5 / ((1+DISCOUNT_RATE)^merged$itimeto5)) * merged$iprob4
merged$enpv_spend <- merged$epv_spend0 + merged$epv_spend1 + merged$epv_spend2 + merged$epv_spend3 + merged$epv_spend4 + merged$epv_spend5

# Compute gaming-corrected prob (TODO: This is not an appropriate calculation but I need to think a bit more about it)
# TODO: I'm not sure this calculation actually reflects what I want to describe. I actually want to describe something like:
# If they fail there's an X risk that they will lie about it. What is the prob that it looks like a success to us?
merged$gaming_corrected_iprob0 <- ifelse(merged$spend1>0, 1-(1-merged$prob0)*(1-GAMING), merged$prob0)
merged$gaming_corrected_iprob1 <- ifelse(merged$spend2>0, 1-(1-merged$prob1)*(1-GAMING), merged$prob1)
merged$gaming_corrected_iprob2 <- ifelse(merged$spend3>0, 1-(1-merged$prob2)*(1-GAMING), merged$prob2)
merged$gaming_corrected_iprob3 <- ifelse(merged$spend4>0, 1-(1-merged$prob3)*(1-GAMING), merged$prob3)
merged$gaming_corrected_iprob4 <- ifelse(merged$spend5>0, 1-(1-merged$prob4)*(1-GAMING), merged$prob4)

# Compute gaming-corrected enpv spend
merged$gaming_corrected_epv_spend0 <- -(merged$spend0 / ((1+DISCOUNT_RATE)^merged$itimeto0)) * 1
merged$gaming_corrected_epv_spend1 <- -(merged$spend1 / ((1+DISCOUNT_RATE)^merged$itimeto1)) * merged$gaming_corrected_iprob0
merged$gaming_corrected_epv_spend2 <- -(merged$spend2 / ((1+DISCOUNT_RATE)^merged$itimeto2)) * merged$gaming_corrected_iprob1
merged$gaming_corrected_epv_spend3 <- -(merged$spend3 / ((1+DISCOUNT_RATE)^merged$itimeto3)) * merged$gaming_corrected_iprob2
merged$gaming_corrected_epv_spend4 <- -(merged$spend4 / ((1+DISCOUNT_RATE)^merged$itimeto4)) * merged$gaming_corrected_iprob3
merged$gaming_corrected_epv_spend5 <- -(merged$spend5 / ((1+DISCOUNT_RATE)^merged$itimeto5)) * merged$gaming_corrected_iprob4
merged$gaming_corrected_enpv_spend <- merged$gaming_corrected_epv_spend0 + merged$gaming_corrected_epv_spend1 + merged$gaming_corrected_epv_spend2 + merged$gaming_corrected_epv_spend3 + merged$gaming_corrected_epv_spend4 + merged$gaming_corrected_epv_spend5

# Compute enpv improvements
merged$enpv0diff  <- merged$ienpv0 - merged$enpv0
bottom <- abs(min(merged$enpv0, merged$ienpv0)) + 1
merged$enpv0ratio <- (merged$ienpv0 + bottom) / (merged$enpv0 + bottom)

# Compute go-corrected prob (i.e. LOMA)
merged$go_corrected_prob <- ifelse(merged$idecision0=='true', merged$iprob, 0)

# Compute go- and gaming corrected ENPV spend (i.e. actual expected cost of intervention)
merged$go_corrected_enpv_spend            <- ifelse(merged$idecision0=='true', merged$enpv_spend, 0)
merged$go_and_gaming_corrected_enpv_spend <- ifelse(merged$idecision0=='true', merged$gaming_corrected_enpv_spend, 0)


# Bin
merged$spend_bin      <- mround(merged$spend, 10)
merged$spend_logbin   <- log_bin(merged$spend, 2)
merged$enpv0diff_bin  <- bin_into(merged$enpv0diff, 500)
merged$enpv0ratio_bin <- bin_into(merged$enpv0ratio, 500)

# Prepare go decisions for summing
merged$go  <- merged$enpv0  >= merged$threshold
merged$igo <- merged$ienpv0 >= merged$ithreshold

# ======== Aggregate ===============
byGroupAnd <- function(df, spend_key) {
  ddply(
    merged,
    c('igroup', spend_key),
    summarize,

    count     = length(prob),
    go_count  = sum(go),
    igo_count = sum(igo),
    go_ratio  = go_count / count * 100,
    igo_ratio = igo_count / count * 100,
    go_ratio_improvement = igo_ratio / go_ratio,

    enpv_spend_max  = max(enpv_spend),
    enpv_spend_min  = min(enpv_spend),
    enpv_spend_mean = mean(enpv_spend),

    public_enpv0_max  = max(public_enpv0),
    public_enpv0_min  = min(public_enpv0),
    public_enpv0_mean = mean(public_enpv0),

    ineff_public_enpv0_max  = max(ineff_public_enpv0),
    ineff_public_enpv0_min  = min(ineff_public_enpv0),
    ineff_public_enpv0_mean = mean(ineff_public_enpv0),

    ineff_cash_only_public_enpv0_max  = max(ineff_cash_only_public_enpv0),
    ineff_cash_only_public_enpv0_min  = min(ineff_cash_only_public_enpv0),
    ineff_cash_only_public_enpv0_mean = mean(ineff_cash_only_public_enpv0),

    enpv0diff_mean  = mean(enpv0diff),
    enpv0diff_min   = min(enpv0diff),
    enpv0diff_max   = max(enpv0diff),

    enpv0ratio_mean = mean(enpv0ratio),
    enpv0ratio_min  = min(enpv0ratio),
    enpv0ratio_max  = max(enpv0ratio),

    go_corrected_enpv_spend_max  = max(go_corrected_enpv_spend),
    go_corrected_enpv_spend_min  = min(go_corrected_enpv_spend),
    go_corrected_enpv_spend_mean = mean(go_corrected_enpv_spend),
    
    gaming_and_go_corrected_enpv_spend_max  = max(go_and_gaming_corrected_enpv_spend),
    gaming_and_go_corrected_enpv_spend_min  = min(go_and_gaming_corrected_enpv_spend),
    gaming_and_go_corrected_enpv_spend_mean = mean(go_and_gaming_corrected_enpv_spend),
    
    go_corrected_prob_mean = mean(go_corrected_prob),
    go_corrected_prob_min  = min(go_corrected_prob),
    go_corrected_prob_max  = max(go_corrected_prob)
  )
}

byInterventionBin    <- byGroupAnd(merged, 'spend_bin')
byInterventionLogBin <- byGroupAnd(merged, 'spend_logbin')

byGroupAndEnpv0DiffBin <- ddply(
  merged,
  .(igroup, enpv0diff_bin),
  summarize,
  count     = length(prob),
  igo_count = sum(igo),
  igo_ratio = igo_count / count * 100
)

# =====================================


# go-rate ~ non-capitalized intervention size
# ===========================================
pf <- byInterventionLogBin
plot(
  pf$spend_logbin,
  pf$igo_ratio,
  col = as.factor(pf$igroup),
  log = 'x',
  las = 1,
  pch = 16,
  xaxt = 'n',
  xlim = c(50, 25000),
  xlab = 'Non-capitalized public intervention expenditure (binned)',
  ylab = 'Go-decisions (%)'
)
axis(1, log_tick_marks(1,1000) * 10, las=2)
abline(v=c(min(base$cost), mean(base$cost), max(base$cost)), col='black', lty=c(3,2,3), lwd=1.5)
abline(v=c(min(base$cost*(1+WASTE)), mean(base$cost*(1+WASTE)), max(base$cost*(1+WASTE))), col='darkgrey', lty=c(3,2,3), lwd=1.5)
legend('bottomright', legend=unique(pf$igroup), pch=16, col=unique(pf$igroup))
for (group in unique(pf$igroup)) {
  sub <- pf[pf$igroup == group,]
  lines(sub$spend_logbin, sub$igo_ratio, col=sub$igroup)
}


# go-rate ~ rNPV (grouped by intervention spend)
# ==============================================
pf <- byInterventionLogBin
# Note: cutting off some of the data for visual purposes
pf <- pf[-pf$enpv_spend_mean >= 1 & -pf$enpv_spend_mean <= 5000,]
plot(
  -pf$enpv_spend_mean,
  pf$igo_ratio,
  col = as.factor(pf$igroup),
  log = 'x',
  las = 2,
  pch = 16,
  xaxt = 'n',
  xlim = c(20, 5000),
  xlab = 'Mean rNPV of public intervention expenditure',
  ylab = 'Go-decisions (%)'
)
axis(1, log_tick_marks(10, 4000), las=2)
abline(v=c(min(-base$public_enpv0), mean(-base$public_enpv0), max(-base$public_enpv0)), col='black', lty=c(3,2,3), lwd=1.5)
abline(v=c( min(-base$ineff_public_enpv0), mean(-base$ineff_public_enpv0), max(-base$ineff_public_enpv0)), col='darkgrey', lty=c(3,2,3), lwd=1.5)
legend('bottomright', legend=unique(pf$igroup), pch=16, col=unique(pf$igroup))
for (group in unique(pf$igroup)) {
  sub <- pf[pf$igroup == group,]
  lines(-sub$enpv_spend_mean, sub$igo_ratio, col = sub$igroup)
}


# entries ~ rNPV (go-corrected)
# =============================
pf <- byInterventionLogBin
# Note: cutting off some of the data for visual purposes
pf <- pf[-pf$go_corrected_enpv_spend_mean >= 1, ]
plot(
  -pf$go_corrected_enpv_spend_mean,
  pf$go_corrected_prob_mean * 100,
  col = as.factor(pf$igroup),
  log = 'x',
  las = 2,
  pch = 16,
  xaxt = 'n',
  xlab = 'Mean rNPV of public intervention expenditure',
  ylab = 'Mean likelihood of market entry per PC entry (%)'
)
axis(1, log_tick_marks(10, 4000), las=2)
mtext(side=2, line=2, text='(go-corrected)')
mtext(side=1, line=4, text='(go-corrected)')
legend('bottomright', legend=unique(pf$igroup), pch=16, col=unique(pf$igroup))
for (group in unique(pf$igroup)) {
  sub <- subset(pf, pf$igroup == group)
  lines(-sub$go_corrected_enpv_spend_mean, sub$go_corrected_prob_mean * 100, col = sub$igroup)
}
abline(h=mean(base$prob*(1-WASTE)*100), lty=2, col='darkgrey')
abline(v=mean(-base$ineff_public_enpv0), lty=2, col='darkgrey')
points(mean(-base$ineff_public_enpv0), mean(base$prob*(1-WASTE)*100), pch=15)


# entries ~ rNPV (gaming + go-corrected)
# ======================================
pf <- byInterventionLogBin
# Note: cutting off some of the data for visual purposes
pf <- pf[-pf$gaming_and_go_corrected_enpv_spend_mean >= 1, ]
plot(
  -pf$gaming_and_go_corrected_enpv_spend_mean,
  pf$go_corrected_prob_mean * 100,
  col = as.factor(pf$igroup),
  log = 'x',
  las = 2,
  pch = 16,
  xaxt = 'n',
  xlab = 'Mean rNPV of public intervention expenditure',
  ylab = 'Mean likelihood of market entry per PC entry (%)'
)
axis(1, log_tick_marks(10, 4000), las=2)
mtext(side=2, line=2, text='(go-corrected)')
mtext(side=1, line=4, text='(go- and gaming-corrected)')
legend('bottomright', legend=unique(pf$igroup), pch=16, col=unique(pf$igroup))
for (group in unique(pf$igroup)) {
  sub <- subset(pf, pf$igroup == group)
  lines(-sub$gaming_and_go_corrected_enpv_spend_mean, sub$go_corrected_prob_mean * 100, col = sub$igroup)
}
abline(h=mean(base$prob*(1-WASTE)*100), lty=2, col='darkgrey')
abline(v=mean(-base$ineff_public_enpv0), lty=2, col='darkgrey')
points(mean(-base$ineff_public_enpv0), mean(base$prob*(1-WASTE)*100), pch=15)


# go-rate ~ rNPV (go-corrected)
# =============================
pf<- byInterventionLogBin
pf <- subset(pf, pf$go_corrected_enpv_spend_mean <= -1) # cutoffs for visual purposes
plot(
  -pf$go_corrected_enpv_spend_mean,
  pf$igo_ratio,
  col = as.factor(pf$igroup),
  log = 'x',
  las = 2,
  pch = 16,
  xaxt = 'n',
  xlim = c(1, 15000),
  xlab = 'Mean rNPV of public intervention expenditure',
  ylab = 'Go-decisions (%)'
)
axis(1, log_tick_marks(10, 4000), las=2)
mtext(side=1, line=4, text='(go-corrected)')
abline(v=c(min(-base$public_enpv0), mean(-base$public_enpv0), max(-base$public_enpv0)), col='black', lty=c(3,2,3), lwd=1.5)
abline(v=c( min(-base$ineff_public_enpv0), mean(-base$ineff_public_enpv0), max(-base$ineff_public_enpv0)), col='darkgrey', lty=c(3,2,3), lwd=1.5)
legend('bottomright', legend=unique(pf$igroup), pch=16, col=unique(pf$igroup))
for (group in unique(pf$igroup)) {
  sub = pf[pf$igroup == group, ]
  lines(-sub$go_corrected_enpv_spend_mean, sub$igo_ratio, col = sub$igroup)
}


# rNPV (not go-corrected) ~ intervention size
# ===========================================
layout(mat = matrix(c(1,2,3,4,5,6), ncol = 3, byrow = TRUE))
pf <- byInterventionBin
pf <- pf[pf$spend_bin <= 1000 & pf$spend_bin >= 50, ]
not0 <- subset(pf, pf$igroup != 'prize0')
for(group in unique(not0$igroup)) {
  sub <- subset(pf, pf$igroup == group)
  mod <- lm(-sub$enpv_spend_mean ~ sub$spend_bin)
  plot(
    sub$spend_bin, -sub$enpv_spend_mean,
    #main = sprintf('%s (mean: y = %sx + %s)', group, round(mod$coefficients[2],4), round(mod$coefficients[1],4)),
    main = group,
    xlab = 'Intervention size',
    ylab = 'Inverse rNPV of intervention (min/mean/max)',
    xlim = c(min(not0$spend_bin),        max(not0$spend_bin)),
    ylim = c(min(-not0$enpv_spend_mean), max(-not0$enpv_spend_mean)),
    type='l')
  if (group != 'prize0') {
    lines(sub$spend_bin, -sub$enpv_spend_max, lty=3)
    lines(sub$spend_bin, -sub$enpv_spend_min, lty=3)
  }
}
plot(
  pf$spend_bin,
  -pf$enpv_spend_mean,
  col = 'white',
  log = 'xy',
  las = 2,
  pch = 16,
  main = 'all means (log-log)',
  xlab = 'Intervention size',
  ylab = 'Negative rNPV of spend'
)
for (group in pf$igroup) {
  sub <- subset(pf, pf$igroup == group)
  lines(sub$spend_bin, -sub$enpv_spend_mean, col=sub$igroup, pch=15)
}
legend('bottomright', legend=unique(pf$igroup), pch=16, col=unique(pf$igroup))
par(mfrow=c(1,1)) # reset layout


# go-ratio ~ PC rNPV diff
# =======================
pf <- byGroupAndEnpv0DiffBin
plot(pf$enpv0diff_bin, pf$igo_ratio, log = 'x', col = pf$igroup)
for (group in unique(pf$igroup)) {
  sub <- pf[pf$igroup == group,]
  lines(sub$enpv0diff_bin, sub$igo_ratio, col = sub$igroup)
}


# rNPV ~ PC rNPV diff
# ===================
less <- merged[c(1:min(20000, nrow(merged))),]
layout(mat = matrix(c(1,2,3,4,5,6), ncol = 3, byrow = TRUE))
for ( group in unique(less$igroup)[unique(less$igroup)!='prize0'] ) {
  sub <- less[less$igroup == group & -less$enpv_spend>0 & less$enpv0diff_bin>0,]
  plot(
    -sub$enpv_spend,
    sub$enpv0diff_bin,
    log  ='xy',
    col  = sub$igroup,
    main = group
  )
}
plot(
  -less$enpv_spend,
  less$enpv0diff_bin,
  log = 'xy',
  ylim = c(5, 5000),
  col = less$igroup
)
legend('bottomright', legend=unique(less$igroup), pch=16, col=unique(less$igroup))
par(mfrow=c(1,1)) # reset layout


# rNPV improvement ~ intervention size
# ====================================
grouped <- byInterventionBin
fewer <- merged[c(1:min(10000, nrow(merged))),]
layout(mat = matrix(c(1,2,3,4,5,6), ncol = 3, byrow = TRUE))
yMin <- min(fewer[fewer$igroup!='base' & fewer$spend_bin>0 & fewer$spend_bin<2000,]$enpv0diff)
yMax <- max(fewer$enpv0diff)
for (group in unique(fewer$igroup[fewer$igroup != 'prize0'])) {
  sub  <- fewer[fewer$igroup==group & fewer$spend_bin > 0 & fewer$spend_bin<2000,]
  plot(
    sub$spend_bin,
    sub$enpv0diff,
    log = 'xy',
    xlab = 'Intervention size',
    ylab = 'Absolute rNPV improvement',
    ylim = c(yMin, yMax),
    yaxt = 'n',
    main = group
  )
  full <- merged[merged$igroup==group & merged$spend_bin > 0,]
  mod <- lm(log(full$enpv0diff) ~ log(full$spend_bin))
  sub$pred <- exp( log(sub$spend_bin) * mod$coefficients[2] + mod$coefficients[1] )
  lines(sub$spend_bin, sub$pred, col='grey')
  axis(2, c(0.01, 0.1, 1, 10, 100))
}
plot(
  grouped$spend_bin,
  grouped$enpv0diff_mean,
  log = 'xy',
  type = 'n',
  xlab = 'Intervention size',
  ylab = 'Absolute rNPV improvement',
  main = 'all means (log-log)'
)
for (group in unique(grouped$igroup)) {
  sub <- grouped[grouped$igroup == group,]
  lines(sub$spend_bin, sub$enpv0diff_mean, col = sub$igroup)
}
legend('bottomright', legend=unique(grouped$igroup), pch=16, col=unique(grouped$igroup))
par(mfrow=c(1,1)) # reset layout


# rNPV improvement (min/mean/max) ~ intervention size
# ===================================================
grouped <- byInterventionLogBin
layout(mat = matrix(c(1,2,3,4,5,6), ncol = 3, byrow = TRUE))
for (group in unique(grouped[grouped$igroup!='prize0',]$igroup)) {
  plot(
    grouped$spend_logbin,
    grouped$enpv0diff_mean,
    ylim = c(min(grouped$enpv0diff_min), max(grouped$enpv0diff_max)),
    log = 'xy',
    type = 'n',
    xlim = c(10, 5000),
    xlab = 'Intervention size (log)',
    ylab = 'rNPV (min/mean/max) (log)',
    main = group
  )
  sub <- grouped[grouped$igroup==group,]
  lines(sub$spend_logbin, sub$enpv0diff_mean)
  lines(sub$spend_logbin, sub$enpv0diff_max, lty=3)
  lines(sub$spend_logbin, sub$enpv0diff_min, lty=3)
}
plot(
  grouped$spend_logbin,
  grouped$enpv0diff_mean,
  log = 'xy',
  type = 'n',
  xlim = c(10, 5000),
  ylim = c(min(grouped$enpv0diff_min), max(grouped$enpv0diff_max)),
  xlab = 'Intervention size',
  ylab = 'Absolute rNPV improvement',
  main = 'all means'
)
for (group in unique(grouped$igroup)) {
  sub <- grouped[grouped$igroup == group,]
  lines(sub$spend_logbin, sub$enpv0diff_mean, col = sub$igroup)
}
legend('bottomright', legend=unique(grouped$igroup), pch=16, col=unique(grouped$igroup))
par(mfrow=c(1,1)) # reset layout



# Correlation between spend and enpv spend for different subsets
# ===================================================
N = 100000
pf0 <- subset(merged, merged$spend0 > 0)[c(1:N),]
pf1 <- subset(merged, merged$spend1 > 0)[c(1:N),]
pf2 <- subset(merged, merged$spend2 > 0)[c(1:N),]
pf3 <- subset(merged, merged$spend3 > 0)[c(1:N),]
pf4 <- subset(merged, merged$spend4 > 0)[c(1:N),]
pf5 <- subset(merged, merged$spend5 > 0)[c(1:N),]
pfx <- merged[c(1:N),]

# Log-log
cor.test(log(pf0$spend), log(-pf0$enpv_spend))
cor.test(log(pf1$spend), log(-pf1$enpv_spend))
cor.test(log(pf2$spend), log(-pf2$enpv_spend))
cor.test(log(pf3$spend), log(-pf3$enpv_spend))
cor.test(log(pf4$spend), log(-pf4$enpv_spend))
cor.test(log(pf5$spend), log(-pf5$enpv_spend))
cor.test(log(pfx$cost),  log(-pfx$public_enpv0))

# No log
cor.test(pf0$spend, -pf0$enpv_spend)
cor.test(pf1$spend, -pf1$enpv_spend)
cor.test(pf2$spend, -pf2$enpv_spend)
cor.test(pf3$spend, -pf3$enpv_spend)
cor.test(pf4$spend, -pf4$enpv_spend)
cor.test(pf5$spend, -pf5$enpv_spend)
cor.test(pfx$cost,  -pfx$public_enpv0)


if (write_to_file)
  dev.off()

# TODO:
# - The MC sim itself needs to support expressions so that we can do log10 sampling... syntax: [1-9]*10**[0-4]/2
# - Compute quartiles instead of min/mean/max (use quartile/quantile lib from other example) and create a similar plot but where I print the field in a semi-transparent color so that the overlap is more evident.
