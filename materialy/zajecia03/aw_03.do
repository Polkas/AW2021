/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajecia 3                        ****/
/***********************************************************/
sysuse auto

/* 1. Analiza korelacji */
/* Test chi^2 */
tabulate rep78 foreign, chi2

/* Test V-Cramera */
tabulate rep78 foreign, V
/* Wszystkie testy zaleznosci */
tabulate rep78 foreign, all

/* Korelacja miedzy zmiennymi ciaglymi, wspolczynnik Pearsona */
corr price mpg
/* Oczywscie mozna tez obliczyc korelacje miedzy zmienna ciagla a dyskretna, ale jest to slabo uzasadnione */
corr price mpg rep78 foreign
/* Dla zmiennych 0-1 bedacych reprezentacja zmiennych ukrytych o rozkladzie normalnym lepsza miara jest korelacja tetrachoryczna */
/* Tworzymy zmienna 0-1 o wartosci 1 dla ceny powyzej 10.000$ */
gen price_10 = (price>10000)

/* Korelacja terachoryczna -- dla zmiennych 0-1 */
corr price_10 foreign
tetrachoric price_10 foreign

/* Wspolczynnik korelacji Kendalla */
ktau price mpg rep78 foreign
/* Parametr star definiuje przy jakiej wartosci p program wyswietla znak "*" oznaczajacy brak podstaw do odrzucenia hipotezy o braku korelacji */
ktau price mpg rep78 foreign, star(0.05)
/* Opcja stats(p) pozwala wyswietlic wartosc p dla kazdego wspolczynnika */
ktau price mpg rep78 foreign, star(0.05) stats(p)

/* Porownanie wartosci wspolczynnikow Pearsona i Kendala (tau-b) */
/* Dwie zmienne 0-1 */
corr price_10 foreign
ktau price_10 foreign
/* Zmienna 0-1 i ciagla */
corr price foreign
ktau price foreign
/* Dwie zmienne ciagle */
corr price gear_ratio
ktau price gear_ratio

/* Wspolczynnik korelacji Spearmana */
spearman price mpg rep78 foreign
/* Parametr star definuje przy jakiej wartosci p program wyswietla znak "*" oznaczajacy brak podstaw do odrzucenia hipotezy o braku korelacji */
spearman price mpg rep78 foreign, star(0.05)

/* Porownanie wartosci wspolczynnikow Pearsona i Spearmana */
/* Dwie zmienne 0-1 */
corr price_10 foreign
spearman price_10 foreign
/* Zmienna 0-1 i ciagla */
corr price foreign
spearman price foreign
/* Dwie zmienne ciagle */
corr price gear_ratio
spearman price gear_ratio

/* 2. Analiza zroznicowania */
/* Jednoczynnikowa analiza wariancji */
anova price foreign
/* I dla porownania regresja */
reg price foreign
/* Anova traktuje kazda zmienna "objasniajaca" jako dyskretna */
anova price mpg
/* opcerator c. sprawia ze zmienna traktowana jest jako zmienna o rozkladzie ciaglym */
anova price c.mpg

/* Wieloczynnikowa analiza wariancji */
anova price foreign c.mpg
/* "#" pozwala na proste uwzglednienie interakcji */
anova price foreign c.mpg foreign#c.mpg

/* 3. Cwiczenie **/
/* Bedziemy pracowac na danych z badania Diagnoza Spoleczna z 2005 roku */
/* Prosze sciagnac dane ze strony www.ekonometria.wne.uw.edu.pl i zaladowac zbior osob do Staty **/
clear
/* Prosze zapoznac sie z zawartoscia zbioru i odpowiedziec na pytania, przeprowadzajac odpowiednie testy */

/* Czy waga jest zwiazana z plcia? */


/* Czy wzrost jest zwiazany z plcia? */


/* Czy wyksztalcenie jest powiazane z plcia? */


/* Czy wsrod osob o wyzszym wyksztalceniu waga respondenta jest zwiazana z plcia? */


/* Czy wsrod osob o wyzszym wyksztalceniu wzrost respondenta jest zwiazany z plcia?*/


/* Czy wsrod osob o wyzszym wyksztalceniu deklarowane zarobki sa zwiazane z plcia?*/
