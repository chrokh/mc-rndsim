df <- read.csv("./output/example.csv")

# Remove prize intervention since it's too broadly distributed to be useful here
tmp <- subset(df, df$group != 'prize')
tmp$group <- factor(tmp$group)

# Plot ENPV
boxplot(tmp$enpv0 ~ tmp$group, ylab='PC ENPV', col='lightgrey', las=2)
boxplot(tmp$enpv1 ~ tmp$group, ylab='P1 ENPV', col='lightgrey', las=2)
boxplot(tmp$enpv2 ~ tmp$group, ylab='P2 ENPV', col='lightgrey', las=2)
boxplot(tmp$enpv3 ~ tmp$group, ylab='P3 ENPV', col='lightgrey', las=2)
boxplot(tmp$enpv4 ~ tmp$group, ylab='P4 ENPV', col='lightgrey', las=2)
boxplot(tmp$enpv5 ~ tmp$group, ylab='Market ENPV', col='lightgrey', las=2)

# Create base subset and rename columns to prepare for merge
base <- subset(tmp, tmp$group == 'base')
colnames(base) <- paste('x', colnames(base), sep='')
names(base)[names(base) == 'xid'] <- 'id'

# Merge the two subsets
merged <- merge(tmp, base, by='id')

# Compute ENPV improvements 
merged$enpv0diff <- merged$enpv0 - merged$xenpv0
merged$enpv1diff <- merged$enpv1 - merged$xenpv1
merged$enpv2diff <- merged$enpv2 - merged$xenpv2
merged$enpv3diff <- merged$enpv3 - merged$xenpv3
merged$enpv4diff <- merged$enpv4 - merged$xenpv4
merged$enpv5diff <- merged$enpv5 - merged$xenpv5

# Plot ENPV diffs
boxplot(merged$enpv0diff ~ tmp$group, ylab='PC ENPV improvement', col='lightgrey', las=2)
boxplot(merged$enpv1diff ~ tmp$group, ylab='P1 ENPV improvement', col='lightgrey', las=2)
boxplot(merged$enpv2diff ~ tmp$group, ylab='P2 ENPV improvement', col='lightgrey', las=2)
boxplot(merged$enpv3diff ~ tmp$group, ylab='P3 ENPV improvement', col='lightgrey', las=2)
boxplot(merged$enpv4diff ~ tmp$group, ylab='P4 ENPV improvement', col='lightgrey', las=2)
boxplot(merged$enpv5diff ~ tmp$group, ylab='Market ENPV improvement', col='lightgrey', las=2)