setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

wineUrl <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
wine <- read.table(wineUrl, header=FALSE, sep=',', stringsAsFactors=FALSE,
                   col.names=c('Cultivar', 'Alcohol', 'Malic.acid','Ash', 'Alcalinity.of.ash',
                               'Magnesium', 'Total.phenols','Flavanoids', 'Nonflavanoid.phenols',
                               'Proanthocyanin', 'Color.intensity', 'Hue', 'OD280.OD315.of.diluted.wines',
                               'Proline'))