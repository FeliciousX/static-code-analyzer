data <- read.csv("data.csv")
data$date <- as.Date(data$date, "%d/%m/%Y")

getPerc <- function(x) {
    perc <- numeric(length(x))
    perc[1] = 0;
    for (i in 2:length(x)) {
        perc[i] <- (x[i] - x[i-1]) / x[i-1] * 100
    }
    return(perc)
}

getCumulativePerc <- function(x) {
    perc <- numeric(length(x))
    perc[1] = 0;
    for (i in 2:length(x)) {
        perc[i] <- sum(perc[i-1], x[i])
    }
    return(perc)
}

attach(data)
percLOC <- getPerc(LOC)
percNOM <- getPerc(NOM)
percWMC <- getPerc(WMC)
percWMCv <- getPerc(WMCv)
percMVG <- getPerc(MVG)

data$Cumulative.LOC <- getCumulativePerc(percLOC)
data$Cumulative.NOM <- getCumulativePerc(percNOM)
data$Cumulative.WMC <- getCumulativePerc(percWMC)
data$Cumulative.WMCv <- getCumulativePerc(percWMCv)
data$Cumulative.MVG <- getCumulativePerc(percMVG)
detach(data)

library(ggplot2)

g <- ggplot(data, aes(date, y = '% Increase', col=Type)) +
    geom_line(aes(y = Cumulative.LOC, col = "LOC")) +
    geom_line(aes(y = Cumulative.NOM, col = "NOM")) +
    geom_line(aes(y = Cumulative.WMC, col = "WMC")) +
    geom_line(aes(y = Cumulative.WMCv, col = "WMCv")) +
    geom_line(aes(y = Cumulative.MVG, col = "MVG")) +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.LOC), method="gam", formula = y ~ s(x), se=FALSE, color="red") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.NOM), method="gam", formula = y ~ s(x), se=FALSE, color="green") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.WMC), method="gam", formula = y ~ s(x), se=FALSE, color="deepskyblue") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.WMCv), method="gam", formula = y ~ s(x), se=FALSE, color="magenta") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.MVG), method="gam", formula = y ~ s(x), se=FALSE, color="darkgoldenrod")
