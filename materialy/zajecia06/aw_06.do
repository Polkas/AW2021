/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajecia 6                        ****/
/****             Analiza dyskryminacji                 ****/
/***********************************************************/ 
/// Podczas dzisiejszych zajec wykorzystujemy dane udostepnione przez Uniwersytet Kalifornijski w Los Angles (UCLA) 
/// Dane i ich opis mozna znalezc na stronie https://stats.idre.ucla.edu/stata/dae/discriminant-function-analysis/

/// Przyk³ad 1.

/// Duzy przewoznik lotniczy zebral informacje o osobach zatrudnionych na trzech stanowiskach
/// 1) obsluga klienta (customer service personnel)
/// 2) mechanik 
/// 3) dyspozytorzy (dispatchers) 

/// Dyrektor Dzialu Personalnego chcialby wiedziec, czy na kazdym stanowisku pracuja osoby o roznym typie osobowosci.
/// Kazdy pracownik zostal poddany serii testow psychologicznych obejmujacych zainteresowanie aktywnoscia, 
/// mierzacych towarzyskosc pracownika oraz okreslajacych poziom jego konserwatyzmu

/// Zaladowanie danych z Internetu
use https://stats.idre.ucla.edu/stat/stata/dae/discrim, clear
/// opis zbioru
des
/// Rozpoczynamy analize od podstawowych statystyk zmiennych psychologicznych
summarize outdoor social conservative
/// Podstawowe statystyki w podziale na typ wykonywanej pracy
/// opcja stat definiuje statystki do wyswietlenia
/// opcja col(stat) okresla ze maja one byc wyswietlone w kolumnach tabeli
tabstat outdoor social conservative, by(job) stat(n mean sd min max) col(stat)
/// Tablica korelacji. Opcja sig wyswietla wartosc p dla hipotezy o braku korelacji
pwcorr outdoor social conservative, sig
/// Analiza rozkladu zmiennej grupujacej
tabulate job
/// Kanoniczna analiza dyskryminacyjna
/// Wykonanie polecenia powoduje wykonanie kanonicznej analizy dyskryminacyjnej
/// Wyniki sa prezentowane w 6 tabelach
/// Tabela 1 - wartosci wlasne i statystyczna istotnosc kierunkow dyskryminacji
/// Tabela 2 - standaryzowane oszacowania kanonicznych wspolczynnikow dyskryminacji
/// Tabela 3 - tabela ladunkow kanonicznych
/// Tabela 4 - etykiety grup
/// Tabela 5 - srednie wartosci zmiennych kanonicznych dla grup
/// Tabela 6 - tabela klasyfikacji przy zalozonym jednostajnym rozkladzie a-priori.
/// Przyjmowany rozklad a-priori mozna zmienic wykorzystujac opcje prior

candisc outdoor social conservative, group(job)

/// Wyniki analizy mozna zaprezentowac na wykresie obrazujacym wartosci zmiennych kanonicznych
/// Dla przejrzystosci wykresu przed jego wykonaniem skracamy etykiety kategorii
label define job 1 "c" 2 "m" 3 "d", modify
scoreplot, msymbol(i)

/// Wykres rozrzutu standaryzowanych ladunkow czynnikowych funkcji dyskryminacyjnej
/// Pokazuje zaleznosc miedzy srednimi wartosciami oryginalnych zmiennych a wspolczynnikami korelacji kanonicznej
loadingplot


/// Te same wyniki mozna uzyskac poleceniem discrim lda
discrim lda outdoor social conservative, group(job)
/// W przypadku tego polecenia Stata wyswietla wylacznie tablice klasyfikacji
/// Wyswietlenie tablicy analizy wariancji
estat anova
/// Tabela wartosci wlasnych i statystyczna istotnosc kierunkow dyskryminacji
estat canontest
/// Tabela oszacowan parametrow funkcji klasyfikacyjnych
estat classfunctions 
/// Tabela klasyfikacji
estat classtable
/// Tabela korelacji miedzy zmiennymi
estat correlations
/// Tabela kowariancji miedzy zmiennymi
estat covariance
/// Tabela standaryzowanych oszacowan kanonicznych wspolczynnikow dyskryminacji
estat loadings
/// Macierz struktury kanonicznej
estat structure

/// Przyk³ad 2.
/// Jest to przyklad analizy dyskryminacyjnej, ktory mozna znalezc w niemal kazdym 
/// podreczniku analizy wielowymiarowej. Zostal opracowany przez Fishera w 1936 roku
/// Analiza obejmuje trzy odmiany irysow i cztery zmienne opisujace ich cechy 
/// Dlugosc platka [cm] (petal lenght)
/// Szerokosc platka [cm] (petal width)
/// Dlugosc listka kielicha [cm]
/// Szerokosc listka kielicha [cm]

di "Fisher example iris data"
use iris.dta, clear
/// Opis danych
des
/// Podstawowe statystyki opisowe
bysort iris: su seplen sepwid petlen petwid 
/// Analiza dyskryminacji
discrim lda seplen sepwid petlen petwid, group(iris)
/// Tabela nieprawidlowo klasyfikowanych obserwacji
estat list, misclassified
/// Tabela niestandaryzowanych i standaryzowanych oszacowan kanonicznych wspolczynnikow dyskrminacji
estat loadings, unstandardized standardized
loadingplot
scoreplot, msymbol(i)
/// Uzyskanie klasyfikacji
predict klasyfikacja
/// Tabela klasyfikacji
tab iris klasyfikacja

/// Przyk³ad 3.
/// Na podstawie danych z badania Diagnoza Spoleczna 2011 bedziemy analizowac stosunek obywateli do euro
use euro.dta, clear
/// Opis danych
des
/// Zbadajmy rozklad zmiennej zaleznej
tab euro
/// Jaki model nalezy wybrac?
bysort euro: su wiek klm kobieta wyksz zna_angielski partia_PO partia_PiS
corr wiek klm kobieta wyksz zna_angielski partia_PO partia_PiS
/// Przeprowadz odpowiednia analize dyskryminacyjna
/// Zastanow sie jaki model zastosowac oraz jaki dobrac rozklad a-priori

/// Zastanow sie czy wszystkie zmienne dobrze rozdzielaja zbior

/// Zbadaj stosunek do euro metoda najblizszych sasiadow
// losujemy 10% probe prosta by przyspieszyc obliczenia
sample 10
// Zastanow sie jaki rozklad a-priori wybrac aby zbadac poprawnosc klasyfikacji
discrim knn wiek klm kobieta wyksz zna_angielski partia_PO partia_PiS, group(euro) k(5)
