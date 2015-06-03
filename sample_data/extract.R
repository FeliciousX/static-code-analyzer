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
data$version <- factor(data$version, levels=data$version)
detach(data)

library(ggplot2)

g <- ggplot(data, aes(date, y = '% Increase', col=Type)) +
    geom_point(aes(y = Cumulative.LOC, col = "LOC")) +
    geom_point(aes(y = Cumulative.NOM, col = "NOM")) +
    geom_point(aes(y = Cumulative.WMC, col = "WMC")) +
    geom_point(aes(y = Cumulative.WMCv, col = "WMCv")) +
    geom_point(aes(y = Cumulative.MVG, col = "MVG")) +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.LOC), formula = y ~ log(x), se=FALSE, color="red") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.NOM), formula = y ~ log(x), se=FALSE, color="green") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.WMC), formula = y ~ log(x), se=FALSE, color="deepskyblue") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.WMCv), formula = y ~ log(x), se=FALSE, color="magenta") +
    stat_smooth(mapping=aes(x=data$date, y=data$Cumulative.MVG), formula = y ~ log(x), se=FALSE, color="darkgoldenrod") +
    labs(x="Date", y="% Increase", title="NodeJS Code Analysis")

h <- ggplot(data, aes(date, y = LOC)) +
    geom_line() +
    labs(x="Date", y="Absolute", title="NodeJS Line of Code")

i <- ggplot(data, aes(date, y = NOM)) +
    geom_line() +
    labs(x="Date", y="Absolute", title="NodeJS Number of Modules")

j <- ggplot(data, aes(date, y = WMC)) +
    geom_line() +
    labs(x="Date", y="Absolute", title="NodeJS Total Number of Methods")

k <- ggplot(data, aes(date, y = WMCv)) +
    geom_line() +
    labs(x="Date", y="Absolute", title="NodeJS Total Number of Public Methods")

l <- ggplot(data, aes(date, y = MVG)) +
    geom_line() +
    labs(x="Date", y="Absolute", title="NodeJS Cyclomatic Complexity")

png(filename="relative.png", units="px", width=1980, height=1080, bg="white")
g
dev.off()

png(filename="loc.png", units="px", width=1980, height=1080, bg="white")
h
dev.off()

png(filename="nom.png", units="px", width=1980, height=1080, bg="white")
i
dev.off()

png(filename="wmc.png", units="px", width=1980, height=1080, bg="white")
j
dev.off()

png(filename="wmcv.png", units="px", width=1980, height=1080, bg="white")
k
dev.off()

png(filename="mvg.png", units="px", width=1980, height=1080, bg="white")
l
dev.off()
