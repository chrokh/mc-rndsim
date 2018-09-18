df <- read.csv("./output/example.csv")

boxplot(df$enpv0, df$enpv1, df$enpv2, df$enpv3, df$enpv4, df$enpv5,
        ylab = 'ENPV',
        xlab = 'Development followed by sales',
        ylim = c(min(df$enpv0,df$enpv1,df$enpv2,df$enpv3,df$enpv4,df$enpv5), max(df$enpv5)),
        las = 1,
        xaxt = 'n',
        col = 'bisque1',
        type = 'n'
        )

axis(1, at = seq(1,6), labels = c('PC','P1','P2','P3','P4','Market'))