df <- read.csv("./output/example.csv")

# Remove prize intervention since it's too broadly distributed to be useful here
tmp <- subset(df, df$group != 'prize')
tmp$group <- factor(tmp$group)



# JUST ENPV

# Reorder groups based on their relative enpv
groups0 <- reorder(tmp$group, tmp$enpv0, median)
groups1 <- reorder(tmp$group, tmp$enpv1, median)
groups2 <- reorder(tmp$group, tmp$enpv2, median)
groups3 <- reorder(tmp$group, tmp$enpv3, median)
groups4 <- reorder(tmp$group, tmp$enpv4, median)
groups5 <- reorder(tmp$group, tmp$enpv5, median)

# Plot ENPV
boxplot(tmp$enpv0 ~ groups0, col='lightgrey', outline=FALSE, las=2, ylab='PC ENPV')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(tmp$enpv1 ~ groups1, col='lightgrey', outline=FALSE, las=2, ylab='P1 ENPV')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(tmp$enpv2 ~ groups2, col='lightgrey', outline=FALSE, las=2, ylab='P2 ENPV')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(tmp$enpv3 ~ groups3, col='lightgrey', outline=FALSE, las=2, ylab='P3 ENPV')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(tmp$enpv4 ~ groups4, col='lightgrey', outline=FALSE, las=2, ylab='P4 ENPV')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(tmp$enpv5 ~ groups5, col='lightgrey', outline=FALSE, las=2, ylab='Market ENPV')
mtext(side=3, line=0.5, text='(no outliers)')



# ABSOLUTE IMPROVEMENT

# Create base subset and rename columns to prepare for merge
base <- subset(tmp, tmp$group == 'base')
colnames(base) <- paste('x', colnames(base), sep='')
names(base)[names(base) == 'xid'] <- 'id'

# Merge the two subsets
merged <- merge(tmp, base, by='id')

# Compute improvements (diffs)
merged$enpv0diff <- merged$enpv0 - merged$xenpv0
merged$enpv1diff <- merged$enpv1 - merged$xenpv1
merged$enpv2diff <- merged$enpv2 - merged$xenpv2
merged$enpv3diff <- merged$enpv3 - merged$xenpv3
merged$enpv4diff <- merged$enpv4 - merged$xenpv4
merged$enpv5diff <- merged$enpv5 - merged$xenpv5

# Reorder diffgroups based on their relative enpv diff
diffgroups0 <- reorder(merged$group, merged$enpv0diff, median)
diffgroups1 <- reorder(merged$group, merged$enpv1diff, median)
diffgroups2 <- reorder(merged$group, merged$enpv2diff, median)
diffgroups3 <- reorder(merged$group, merged$enpv3diff, median)
diffgroups4 <- reorder(merged$group, merged$enpv4diff, median)
diffgroups5 <- reorder(merged$group, merged$enpv5diff, median)

# Plot ENPV improvements ordered by relative effect
boxplot(merged$enpv0diff ~ diffgroups0, col='lightgrey', outline=FALSE, las=2, ylab='PC ENPV improvement')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv1diff ~ diffgroups1, col='lightgrey', outline=FALSE, las=2, ylab='P1 ENPV improvement')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv2diff ~ diffgroups2, col='lightgrey', outline=FALSE, las=2, ylab='P2 ENPV improvement')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv3diff ~ diffgroups3, col='lightgrey', outline=FALSE, las=2, ylab='P3 ENPV improvement')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv4diff ~ diffgroups4, col='lightgrey', outline=FALSE, las=2, ylab='P4 ENPV improvement')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv5diff ~ diffgroups5, col='lightgrey', outline=FALSE, las=2, ylab='Market ENPV improvement')
mtext(side=3, line=0.5, text='(no outliers)')



# RELATIVE IMPROVEMENT

# Compute relative improvements (ratios) (we're adding the abs-min-value to translate all numbers to >= 0)
merged$enpv0ratio <- (merged$enpv0 + abs(min(merged$enpv0))) / (merged$xenpv0 + abs(min(merged$enpv0)))
merged$enpv1ratio <- (merged$enpv1 + abs(min(merged$enpv1))) / (merged$xenpv1 + abs(min(merged$enpv1)))
merged$enpv2ratio <- (merged$enpv2 + abs(min(merged$enpv2))) / (merged$xenpv2 + abs(min(merged$enpv2)))
merged$enpv3ratio <- (merged$enpv3 + abs(min(merged$enpv3))) / (merged$xenpv3 + abs(min(merged$enpv3)))
merged$enpv4ratio <- (merged$enpv4 + abs(min(merged$enpv4))) / (merged$xenpv4 + abs(min(merged$enpv4)))
merged$enpv5ratio <- (merged$enpv5 + abs(min(merged$enpv5))) / (merged$xenpv5 + abs(min(merged$enpv5)))

# Reorder groups based on their relative enpv ratio
groups0 <- reorder(merged$group, merged$enpv0ratio, median)
groups1 <- reorder(merged$group, merged$enpv1ratio, median)
groups2 <- reorder(merged$group, merged$enpv2ratio, median)
groups3 <- reorder(merged$group, merged$enpv3ratio, median)
groups4 <- reorder(merged$group, merged$enpv4ratio, median)
groups5 <- reorder(merged$group, merged$enpv5ratio, median)

# Plot ENPV ratios ordered by relative effect
boxplot(merged$enpv0ratio ~ groups0, col='lightgrey', outline=FALSE, las=2, ylab='PC ENPV ratio compared to baseline')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv1ratio ~ groups1, col='lightgrey', outline=FALSE, las=2, ylab='P1 ENPV ratio compared to baseline')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv2ratio ~ groups2, col='lightgrey', outline=FALSE, las=2, ylab='P2 ENPV ratio compared to baseline')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv3ratio ~ groups3, col='lightgrey', outline=FALSE, las=2, ylab='P3 ENPV ratio compared to baseline')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv4ratio ~ groups4, col='lightgrey', outline=FALSE, las=2, ylab='P4 ENPV ratio compared to baseline')
mtext(side=3, line=0.5, text='(no outliers)')
boxplot(merged$enpv5ratio ~ groups5, col='lightgrey', outline=FALSE, las=2, ylab='Market ENPV ratio compared to baseline')
mtext(side=3, line=0.5, text='(no outliers)')

