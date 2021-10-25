##############################################################################
# Copyright (C) 2015 Maciej Nasinski                                         #
#                    Dorota Celinska <dot at mimuw dot edu dot pl>           #
#                                                                            #
# This program is free software: you can redistribute it and/or modify       #
# it under the terms of the GNU General Public License as published by       #
# the Free Software Foundation, either version 3 of the License, or          #
# (at your option) any later version.                                        #
#                                                                            #
# This program is distributed in the hope that it will be useful,            #
# but WITHOUT ANY WARRANTY; without even the implied warranty of             #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
# GNU General Public License for more details.                               #
#                                                                            #
# You should have received a copy of the GNU General Public License          #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.      #
##############################################################################

# Analiza kanoniczna na przykładzie Celinska, Olszewski [2013].
# Wykorzystamy baze danych "zadowolenie.dta" oparta na bazie z badania Diagnoza Spoleczna
# W badaniu wykorzystujemy jedynie obserwacje dotyczace glow gospodarstwa domowego

# numer_gd - do diagnostyki, nr gospodarstwa

# plec - plec respondenta (1 -- kobieta, 0 -- mezczyzna)
# wiek2011 - wiek w roku 2011
# edukacja - wyksztalcenie respondenta
# stanciv- stan cywilny
# dochod - sredni (estymowany przez repondenta) dochod z ostatnich 3 miesiecy
# zaufanie - czy respondent czuje sie kochany i darzony zaufaniem (1 -- tak, 0 -- nie)
# dep_x - wskazniki z testu Becka dotyczace oznak depresji: wyglad, zapal do pracy, sen, meczenie sie, zdrowie
# zaleznosc -- kto ma wplyw na zycie respondenta (1 -- jestem kowalem swojego losu; 0 -- moje zycie zalezy od wladz, od innych ludzi, od losu-opatrznosci)
# kontakty -- liczba kontaktow spolecznych miesiecznie
# aktywnosc -- liczba przypadkow aktywnosci spolecznej (wizyty w kinie, teatrze, na koncertach; restauracjach, kawiarniach, pubach; spotkania towarzyskie)

# rodzina -- zadowolenie ze stosunkow z rodzina
# przyjaciele -- zadowolenie ze stosunkow ze znajomymi
# zdrowie -- zadowolenie ze stanu zdrowia
# sukces -- zadowolenie z osiagniec zyciowych

# Zbior zmiennych zaleznych: rodzina przyjaciele zdrowie sukces
# Zbior zmiennych niezaleznych: plec wiek2011, edukacja, stanciv, dochod, zaufanie, dep_x, zaleznosc, kontakty, aktywnosc*/

# Zainstalowanie (o ile wczesniej tego nie zrobiono) potrzebnych pakietow

install.packages(setdiff(c("foreign", "CCA", "candisc"), installed.packages()[, 1]))

# Wczytanie pakietow

library(CCA)
library(foreign)

# Krok opcjonalny -- mozna ustawic working directory, w ktorym znajduja sie wykorzystywane pliki
# setwd("~/Documents/AW//materialy/zajecia04/")

# wczytanie zbioru danych i nazwanie zmiennych

zadowo <- as.data.frame(read.dta("~/Documents/AW/dane/zadowolenie.dta", convert.factors = FALSE))
nazwy01 <- c("rodzina", "przyjaciele", "zdrowie", "sukces")
nazwy02 <- c("dep_wyglad", "dep_zapal", "dep_zdrowie", "dep_sen", "dep_meczenie", "plec", "wiek2011", "kontakty", "aktywnosc", "edukacja", "zaufanie", "zaleznosc", "stanciv", "dochod")
factor_vars <- c("plec", "zaleznosc", "stanciv", "zaufanie")
zadowo[, factor_vars] <- Map(as.factor, zadowo[, factor_vars])

# Rozkodowanie zmiennych dyskretnych na poziomy

zadowo <- as.data.frame(model.matrix(~ ., zadowo, na.action = "na.pass", 
                                     contrasts.arg = as.list(setNames(rep("contr.treatment", length(factor_vars)), factor_vars)))[, -1])

# Stworzenie macierzy zmiennych objasniajacych (X) i macierzy zmiennych objasnianych (Y)

nazwy1 <- c("rodzina", "przyjaciele", "zdrowie", "sukces")
nazwy2 <- c("dep_wyglad", "dep_zapal", "dep_zdrowie", "dep_sen", "dep_meczenie", "plec1", "wiek2011", "kontakty",
            "aktywnosc", "edukacja", "zaufanie1", "zaleznosc1", "stanciv2", "stanciv3", "stanciv4", "stanciv5", "dochod")
matY <- zadowo[, nazwy1]
matX <- zadowo[, nazwy2]

matcor(matX, matY)

# ANALIZA KANONICZNA

cc1 <- cc(matX, matY)

# WYSTANDARYZOWANE WYNIKI

wyniki <- list()
wyniki[[1]] <- diag(sqrt(diag(cov(matY)))) %*% cc1$ycoef
rownames(wyniki[[1]]) <- nazwy1
wyniki[[2]] <- diag(sqrt(diag(cov(matX)))) %*% cc1$xcoef
rownames(wyniki[[2]]) <- nazwy2
wyniki

# Diagnostyka: Wilks' lambda

WILKSL <- function(matX, matY, cc1) {
  ev <- (1 - cc1$cor^2)
  n <- dim(matX)[1]
  p <- length(matX)
  q <- length(matY)
  k <- min(p, q)
  m <- n - 3 / 2 - (p + q) / 2
  w <- rev(cumprod(rev(ev)))
  # initialize
  d1 <- d2 <- f <- vector("numeric", k)
  
  for (i in 1:k) {
    s <- sqrt((p^2 * q^2 - 4) / (p^2 + q^2 - 5))
    si <- 1 / s
    d1[i] <- p * q
    d2[i] <- m * s - p * q / 2 + 1
    r <- (1 - w[i]^si) / w[i]^si
    f[i] <- r * d2[i] / d1[i]
    p <- p - 1
    q <- q - 1
  }
  pv <- pf(f, d1, d2, lower.tail = FALSE)
  dmat <- cbind(WilksL = w, F = f, df1 = d1, df2 = d2, p = pv)
  return(dmat)
  ## source: http://www.ats.ucla.edu/stat/r/dae/canonical.htm
}

WILKSL(matX, matY, cc1)

# Inny zapis

WILKS2 <- function(cc1) {
  dmat2 <- matrix(0, nrow = ncol(matY), ncol = 2)
  sapply(1:ncol(matY), function(i) dmat2[i, 1] <<- prod((1 - cc1$cor^2)[i:(ncol(matY))]))
  return(dmat2)
}

WILKS2(cc1)

# Redundancja

REDUNT <- function(matX, matY, cc1) {
  eigenmatY <- cc1$cor
  vector1 <- eigenmatY^2
  names1 <- c("opposite variance", "own variance")
  names2 <- c("prop stdvar x", "prop stdvar y")
  matim <<- list()
  for (i in (1:ncol(matY))) {
    a <- sum((cc1$scores$corr.Y.xscores[, i])^2) / ncol(matY)
    b <- a / vector1[i]
    c <- sum((cc1$scores$corr.X.yscores[, i])^2) / ncol(matX)
    d <- c / vector1[i]
    matim[[i]] <- matrix(c(c, d, a, b), byrow = TRUE, nrow = 2, ncol = 2, dimnames = list(names2, names1))
  }
  return(matim)
}

REDUNT(matX, matY, cc1)

cc2 <- candisc::cancor(matX, matY)

candisc::redundancy(cc2)
