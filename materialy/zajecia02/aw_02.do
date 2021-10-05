
sysuse auto
/* 1. Sposoby zapoznania sie z zawartoscia zbioru */
/* Opis zawartosci zbioru danych */
describe
/* Ksiazka kodowa zbioru */
codebook
/* Wyswietlenie danych */
list
/* ja polecam do przegladania danych */
browse
/* Szybki przeglad zmiennych */
inspect
/* Statystyki opisowe */
summarize

/* 2. Testy parametryczne i nieparametryczne dla srednich */
/* test t dla srednich przy zalozeniu rownej wariancji */
ttest price, by(foreign)
/* test t dla srednich bez zalozenia o rownej wariancji */
ttest price, by(foreign) unequal
/* Histogram zmiennej price */
histogram price, bin(10)
/* Czy rozklad zmiennej jest zblizony do rozkladu normalnego, jesli nie, to jaki ma rozklad? */
gen lprice = ln(price)
/* Czy po transformacji zmienna ma rozklad zblizony do normalnego? */

/* Przeprowadzmy test dla przeksztalconej zmiennej */
ttest lprice, by(foreign)
ttest lprice, by(foreign) unequal

/* Test dla proporcji */
/* Dla jednej proby */
prtest foreign==.4
/* Tworzymy zmienna 0-1 o wartosci 1 dla ceny pow. 10.000$ */
gen price_10 = (price>10000)
/* Sprawdzamy, czy udzial samochodow o cenie pow. 10.000$ jest taki sam jak zagranicznych */
prtest price_10==foreign

/* Testy dla wariancji */
/* Test F */
sdtest price,by(foreign)

/* Test Levene **/
/* W0 - wartosc statystyki Levene */
/* W50 - wartosc statystyki dla testu, w ktorym zamiast sredniej wykorzystano mediane */
/* W10 - wartosc statystyki dla testu, w ktorym zamiast sredniej wykorzystano ucieta srednia  */
robvar price, by(foreign)

/* Testy dla rozkladow */
/* Test Kurskalla - Wallisa */
kwallis price,by(foreign)

/* Test Kolmogorowa - Smirnowa */
ksmirnov price,by(foreign)


/* 3. Cwiczenie **/
/* Na postawie danych z 4 kwartalu 2009 roku bedziemy porownywac: */
/* (a) place kobiet i mezczyzn w Polsce */
/* (b) wyksztalcenie kobiet i mezczyzn w Polsce */
/* Prosze pobrac dane ze strony www.ekonometria.wne.uw.edu.pl i zaladowac do Staty */
clear

/* Kilka ulatwien */
/* Zmiana nazwy zmiennej */
rename pl plec
/* Utworzenie etykiety */
label define plec_lab 1 "Mezczyzna" 2 "Kobieta"
/* Nadanie etykiety wartosciom zmiennej */
label values plec plec_lab
/* utworzenie zmiennej placa, w bazie wartosc "99999" oznacza odmowe odpowiedzi */
gen placa = P37 if (P37!=99999)

/* Korzystajac z odpowiednich testow, prosze sprawdzic: */

/* Czy srednia placa kobiet jest rowna sredniej placy mezczyzn? */

/* Czy zroznicowanie plac kobiet jest rowne zroznicowaniu plac mezczyzn? */

/* Czy rozklad plac kobiet jest rowny rozkladowi plac mezczyzn? */

/* Kto jest lepiej wyksztalcony: kobiety czy mezczyzni? */

/* Czy zroznicowanie poziomu wyksztalcenia jest wieksze wsrod kobiet czy wsrod mezczyzn? */

/* Czy rozklad wyksztalcenia kobiet jest rowny rozkladowi wyksztalcenia mezczyzn? */


/* 4. Cwiczenie **/
/* Bedziemy pracowac na danych z badania Diagnoza Spoleczna z 2011 roku */
/* Prosze pobrac dane ze strony www.ekonometria.wne.uw.edu.pl i zaladowac zbior osob do Staty **/
clear
/* Prosze zapoznac sie z zawartoscia zbioru i odpowiedziec na pytania, przeprowadzajac odpowiednie testy */

/* Czy kobiety przecietnie wiecej waza od mezczyzn? */


/* Czy kobiety sa przecietnie wyzsze od mezczyzn? */


/* Czy kobiety sa lepiej wyksztalcone od mezczyzn? */


/* Czy wsrod osob o wyzszym wyksztalceniu kobiety przecietnie wiecej waza od mezczyzn? */


/* Czy wsrod osob o wyzszym wyksztalceniu kobiety sa przecietnie wyzsze od mezczyzn? */


/* Czy wsrod osob o wyzszym wyksztalceniu kobiety wiecej zarabiaja od mezczyzn? */
