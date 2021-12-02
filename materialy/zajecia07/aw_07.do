/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajecia 7                        ****/
/****               Analiza skupien                     ****/
/****          kod poprawiony: 18.04.2015               ****/
/***********************************************************/
// Przyklad 1.
// Dane i przyklad zostaly pozyczone z podrecznika
// Sophia Rabe-Hesketh i Brian Everitt
// "A Handbook of Statistical Analyses using Stata".
// Dane dotycza miast w Stanach Zjednoczonych Ameryki Polnocnej.
use uscities.dta, clear
// precipitaion = opady
des
sum
// jak widac kazda zmienna ilosciowa jest mierzona na innej skali.
// W celu wyeliminowania wplywu wariancji standaryzujemy zmienne.

foreach zmienna of varlist so2 temp manuf pop wind precip days {
egen `zmienna'_s = std(`zmienna')
}

// Nie majac przeslanek do ustalenia liczby skupien przeanalizujemy modele
// dla 2 do 6 skupien.

// Uruchamiamy generator liczb losowych dla znalezienia poczatkowego rozwiazania.
set seed 20150413

cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(2) name(cl2_mean)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(3) name(cl3_mean)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(4) name(cl4_mean)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(5) name(cl5_mean)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(6) name(cl6_mean)

forvalues i=2(1)6 {
cluster stop cl`i'_mean
}

// Dla kazdego podzialu mozemy obliczyc statystyki opisowe skupien.
// W ten sposob stwierdzamy, czy rozwiazanie jest sensowne.
bysort cl2_mean: su so2 temp manuf pop wind precip days
bysort cl3_mean: su so2 temp manuf pop wind precip days
bysort cl4_mean: su so2 temp manuf pop wind precip days
bysort cl5_mean: su so2 temp manuf pop wind precip days
bysort cl6_mean: su so2 temp manuf pop wind precip days
// Obecnosc skupien o malej liczbie obserwacji wskazuje na wystepowanie obserwacji nietypowych.
// Warto sie zastanowic, czy takich obserwacji nie pominac.

// Srednie sa malo odporne na obserwacje nietypowe.
// Mozliwe, ze w przypadku tego zbioru analiza oparta o mediany da lepsze rezultaty.

cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(2) name(cl2_median)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(3) name(cl3_median)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(4) name(cl4_median)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(5) name(cl5_median)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(6) name(cl6_median)

forvalues i=2(1)6 {
cluster stop cl`i'_median
}

// Warto jest przeprowadzic analize wykorzystujac rozne metryki.
// Celem jest sprawdzenie, czy wyniki nie sa przypadkowe.
// Jezeli rzeczywiscie dane sa pogrupowane to grupowania ukaza sie niezaleznie od wyboru metryki.
// Zmieniamy metryke na miejska.

cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(2) name(cl12_mean) measure(L1)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(3) name(cl13_mean) measure(L1)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(4) name(cl14_mean) measure(L1)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(5) name(cl15_mean) measure(L1)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(6) name(cl16_mean) measure(L1)

/// Polecenie "cluster stop" oblicza i wyswietla wartosc kryterium Calinskiego-Harabasza
/// dla podzialu zbiory danych o zadeklarowanej nazwie

forvalues i=2(1)6 {
cluster stop cl1`i'_mean
}


cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(2) name(cl12_median) measure(L1)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(3) name(cl13_median) measure(L1)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(4) name(cl14_median) measure(L1)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(5) name(cl15_median) measure(L1)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(6) name(cl16_median) measure(L1)

forvalues i=2(1)6 {
cluster stop cl1`i'_median
}

// Zmieniamy metryke na maksimum.

cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(2) name(cl22_mean) measure(Linfinity)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(3) name(cl23_mean) measure(Linfinity)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(4) name(cl24_mean) measure(Linfinity)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(5) name(cl25_mean) measure(Linfinity)
cluster kmeans so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(6) name(cl26_mean) measure(Linfinity)

forvalues i=2(1)6 {
cluster stop cl2`i'_mean
}


cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(2) name(cl22_median) measure(Linfinity)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(3) name(cl23_median) measure(Linfinity)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(4) name(cl24_median) measure(Linfinity)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(5) name(cl25_median) measure(Linfinity)
cluster kmedian so2_s temp_s manuf_s pop_s wind_s precip_s days_s, k(6) name(cl26_median) measure(Linfinity)

forvalues i=2(1)6 {
cluster stop cl2`i'_median
}

// Przyklad 2.
// Jest to przyklad bazujacy na artykule Herczynski i Strawinski (2014)
// "Postawy zawodowe nauczycieli. Próba typologii".

use nauczyciele.dta, clear
// Obejrzyjmy dane.
describe
summarize

// Chcemy znalezc grupy wsrod nauczycieli. Wczesniejesze badania pozakaly ze czesc nauczycieli deklaruje,
// ze bardzo duzo czasu spedza w szkole; inni godza obowiazki szkole z praca w innym miejscu.
// Z drugiej strony nauczyciele o wiekszym stazu pracy czesciej otrzymuja nadgodziny od dyrektora szkoly.
// Chcemy na podstawie czasu poswiecanego na 4 czynnnosci zawodowe (przygotowanie lekcji i innych zajec,
// prowadzenie innych zajec, sprawdzanie prac) oraz ich stazu pracy pogrupowac nauczycieli.
// Prawidlowosc podzialu bedzie weryfikowana na podstawie zmiennych metryczkowych oraz opinii nauczycieli.

// Wybor poczatkowej liczby skupien. Poniewaz mamy dwie cechy nauczycieli, zalozylismy ze beda co najmniej 4.
forvalues i=4(1)9 {
set seed 1234

cluster kmeans staz_c_std czas0205_std, k(`i') name(means_6_`i')
}

forvalues i=4(1)9 {
cluster stop means_6_`i'
}

graph twoway (sc czas0205 staz_c, msize(vsmall)), ylabel(, angle(horizontal)) scheme(s1mono)

// Wedlug algorytmu optymalna liczba skupien jest 6, ale dla jednego skupienia nie moglismy znalezc sensownej interpretacji.
// Postanowilismy rozdzielic obserwacje z tego skupienia do innych.
gen tmp=means_6_6
recode tmp (5=.)

set seed 1234
cluster kmeans staz_c_std czas0205_std, k(5) name(means_6_5a) start(group(tmp))

/* rozklady dla definiujacych skupienia. */

bysort means_6_5a: su staz czas0205 czas02_std czas03_std czas04_std czas05_std

/* Opinie nauczycieli. */

bysort means_6_5a: su j4 j6_*

/* Srednie wartosci zmiennych metryczkowowych dla poszczegolnych skupien */

bysort means_6_5a: tab m6
bysort means_6_5a: tab m21

bysort means_6_5a: tab m12
bysort means_6_5a: tab m25a
bysort means_6_5a: tab m30
bysort means_6_5a: tab m27a

bysort means_6_5a: su liczba_dzieci [aw=waga]
bysort means_6_5a: tab m1 [aw=waga]
