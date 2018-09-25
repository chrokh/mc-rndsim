df <- read.csv("./output/example.csv")

# Remove prize intervention since it's too broadly distributed to be useful here
tmp <- subset(df, df$group != 'prize')
tmp$group <- factor(tmp$group)

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
