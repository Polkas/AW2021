/****************************************************************************/
/*                       Analiza korespondencji	                    			   */
/****************************************************************************/

//ZADANIE 1
//Stan cywilny a kraj pochodzenia samochodu (przyklad zaczerpniety z http://v8doc.sas.com/sashtml/stat/chap24/sect26.htm)
//Wykorzystujemy zbior danych, zawierajacy informacje o pochodzeniu samochodu (origin: USA, JAPONIA, EUROPA) 
//i stanie cywilnym jego wlasiciela (marital: 1 'Wolny z dziecmi' 2 'Malzenstwo z dziecmi' 3 'Wolny' 4 'Malzenstwo'*/  

//0. Wczytanie danych
use samochody.dta,clear

//1. Nadanie etykiet*/
  
label define origin 1 "USA" 2 "Japonia" 3 "Europa"
label values origin origin

label define marital 1 "Wolny z dziecmi" 2 "Malz z dziecmi" 3 "Wolny" 4 "Malzenstwo"
label values marital marital

//2. Czy miedzy zmiennymi wystepuje zaleznosc?
tab origin marital, chi2 lrchi2

/*lrchi2 - Likelihood Ratio Chi-Square - test ilorazu wiarygodnosci, opiera sie na sumowaniu po wszystkich komorkach wyrazenia postaci: 
Nij*ln(Nij/Eij), 
gdzie Nij - liczebnosci zaobserwowane, Eij - liczebnosci oczekiwane*/

//      	    |                   Marital
//    Origin  | Wolny z d  Malozenst  Wolny  Malozenst |     Total
//--------------+-------------------------------------------------------------+----------
//       USA |         6         52         33                      37 |       128 
//  Japonia  |         8         44         63                      51 |       166 
//   Europa  |         1         15         15                      14 |        45 
//---------------+-------------------------------------------------------------+----------
//     Total   |         15        111        111                  102 |       339 
//
//         Pearson chi2(6) =   8.3495   Pr = 0.214
// 		 likelihood-ratio chi2(6) =   8.5068   Pr = 0.203

//nie ma podstaw do odrzucenia hipotezy zerowej o niezaleznosci -- nie powinno sie stosowac analizy korespondencji!

tab origin marital, V

//               Cramér's V =   0.1110
// pomiedzy zmiennymi wystepuje bardzo slaby zwiazek (wartosci wspolczynnika V-Cramera <0.30)

//3. Analiza korespondencji*/
ca marital origin

// uzywamy kiedy dane wejsciowe sa  w postaci standardowego arkusza danych - w wierszach obserwacje a w kolumnach  kolejne zmienne.*/ 

/* ca marital origin

Correspondence analysis                          Number of obs     =      339
															  Pearson chi2(6)   =     8.35
															  Prob > chi2       =   0.2136
															  Total inertia     =   0.0246
    4 active rows                                		  Number of dim.    =        2
    3 active columns                                  Expl. inertia (%) =   100.00

                |   singular    principal                             cumul  
      Dimension |    value       inertia           chi2    percent   percent 
    ------------+------------------------------------------------------------
          dim 1 |   .1512153    .0228661           7.75      92.84     92.84
          dim 2 |   .0419957    .0017636           0.60       7.16    100.00
    ------------+------------------------------------------------------------
          total |               .0246297           8.35     100

Statistics for row and column categories in symmetric normalization

                       |          overall          |        dimension_1        |        dimension_2        
      Categories |    mass  quality   %inert |   coord   sqcorr  contrib |   coord   sqcorr  contrib 
    -------------+---------------------------+---------------------------+---------------------------
    marital      |                           |                           |                           
    Wolny z dz~i |   0.044    1.000    0.068 |   0.037    0.005    0.000 |   0.950    0.995    0.951 
    Malozenstw~i |   0.327    1.000    0.528 |  -0.512    0.999    0.568 |  -0.031    0.001    0.008 
           Wolny |   0.327    1.000    0.392 |   0.441    0.998    0.422 |  -0.037    0.002    0.011 
     Malozenstwo |   0.301    1.000    0.012 |   0.072    0.812    0.010 |  -0.065    0.188    0.031 
    -------------+---------------------------+---------------------------+---------------------------
    origin       |                           |                           |                           
             USA |   0.378    1.000    0.527 |  -0.475    0.992    0.563 |   0.081    0.008    0.059 
         Japonia |   0.490    1.000    0.411 |   0.367    0.987    0.437 |   0.080    0.013    0.074 
          Europa |   0.133    1.000    0.062 |  -0.003    0.000    0.000 |  -0.524    1.000    0.867 
    -------------------------------------------------------------------------------------------------
*/
/*1. "Inertia and Chi-Square Decomposition"
Singular value - wartosci wlasne uzyskane podczas dekompozycji SVD
Principal Inertia - wartosci wlasne podniesione do kwadratu - czesc inercji ("wariancji")
zwiazana z danym wymiarem
Chi-Square - "Inercja"*"liczba obserwacji" - czesc statystyki chi2 zwiazana z danym wymiarem
Percent - inercja danego wymiaru podzielona przez calkowita inercje - procent inercji ("zmiennosci") wyjasniony przez dany wymiar
Cumulative Percent - skumulowana poprzednia kolumna*/

/*2. "Row Coordinates"
Wspolrzedne odpowiadajace wierszom w przestrzeni dwuwymiarowej, czyli sa to kolumny 
macierzy U uzyskanych w wyniku dekompozycji SVD*/

/*3. "Summary Statistics for the Row Points"
QUALITY - miara ta przyjmuje wartosci z przedzialu [0,1] i mowi nam o jakosci 
reprezentacji poszczegolnych wierszy (kolumn) w przestrzeni o mniejszej liczbie wymiarow
Im blizej jednosci sa jej wartosci, tym lepiej reprezentowany jest analizowany punkt
w danej przestrzeni. U nas oczywiscie wartosc 1, bo tablica wymiaru 3x4 jest dokladnie 
reprezentowana w przestrzeni 2 wymiarowej (2 = min(3-2,4-1)).
MASS - Masa wiersza (lub kolumny) - mozna interpretowac jako range waznosci 
poszczegolnych wieszy. 
INERTIA - wzgledna bezwladnosc punktu, okresla udzial danego punktu w ogolnej inercji 
(bezwladnosci). Np. 'Malzenstwo z dziecmi' i 'Wolny' maja najwiekszy udzial w 
bezwladnosci (czyli zmiennosci) wsrod wierszy*/

/*4. "Partial Contributions to Inertia for the Row Points"
Rozklad ogolnej bezwladnosci na poszczegolne wymiary (osie). Jest to udzial punktu
w bezwladnosci wymiaru. Interpretujemy jako czesc bezwladnosci zwiazanej z konkretnym 
wymiarem, ktora jest wyjasniona przez dany punkt. Punkty z duzymi wartosciami udzialu 
w bezwladnosci w relatywnie duzym stopniu przyczynily sie do definicji danego wymiaru.
Sposob obliczenia: (masa wiersza) * (wspolrzedna wiersza w danym wymiarze)^2 / (wartosc
wlasna podniesiona do kwadratu dla danego wymiaru, czyli inercja danego wymiaru). 
Np. 'Malzenstwo' i I wymiar:
0.301 *(0.072)^2 / 0.02287 = 0.01016824. 
Interpretacja: 'Malzenstwo z dziecmi' i 'Wolny' w najwiekszym stopniu przyczynily sie do
zdefiniowania pierwszego wymiaru*/

/*5. Squared Cosines for the Row Points
Udzial wymiaru w bezwladnosci punktu. Definiujemy jako:
(wspolrzedna punktu w danym wymiarze)^2 / (kwadrat odleglosci punktu od srodka ukladu wspolrzednych
 - czyli przecietnego profila wierszowego lub kolumnowego). Jest to kwadrat cosinusa
kata miedzy odcinkiem laczacym srodek ukladu wspolrzednych z rozwazanym punktem a dana 
osia ukladu wspolrzednych.
Obliczenia dla 'Malzenstwo' i I wymiaru:
(-0.0278)^2 / ((-0.0278)^2 + (0.0134)^2) = 0.81
Interpretacja: I wymiar dobrze opisuje punkty reprezentujace 'Malzenstwo z dziecmi'
i 'Wolny'*/
//II wymiar dobrze opisuje punkt 'Wolny z dziecmi'

//W przypadku kolumn:
// I wymiar dobrze opisuje punkty 'USA' i 'Japonia'
// II wymiar dobrze opisuje  punkty 'USA' i 'Europa'

/*Przechodzimy do interpretacji wykresu 'Status rodzinny vs. pochodzenie samochodu'*/
cabiplot , norow yline(0) xline(0)
cabiplot , nocolumn yline(0) xline(0)
cabiplot, yline(0) xline(0)

/*Interpretacja: Zaczynamy od osobnej interpretacji punktow odpowiadajacych wierszom i kolumnom.
Wiersze:
EUROPA - wsporzedna dla wymiaru I bliska 0 - praktycznie brak wkladu w inercje I wymiaru; w ogole wklad w calkowita inercje jest nie wielki (bo wazniejszy jest I pierwszy wymiar),
duzy udzial w inercji II wymiaru (bo wspolrzedna dla drugiego wymiaru ma duza wartosc w porownaniu z pozostalymi punktami odpowiadajacymi wierszom). Polozenie tego punktu 
jest calkowicie determinowane przez II wymiar (potwierdza to kwadrat cosinusa). 
JAPONIA i USA - leza wzdluz I osi, maja duzy wklad do statystyki chi2 i do inercji I  wymiaru. Os pozioma rozroznia samochody Japonskie od Amerykanskich.
Kolumny:
'Malzenstwo' i 'Wolny z dziecmi' maja pierwsza wspolrzedna praktycznie rowna 0. Os pozioma rozroznia 'Wolnych' od 'Malzenstwo z dziecmi'
Interpetacja I osi wskazuje zatem na zaleznosc miedzy 'malzenstwo z dziecmi' a posiadanie samochodu produkcji amarykanskiej oraz byciu 'Wolnym' i posiadanie samochodu produkcji 
japonskiej. 

Podumowujac, analiza korespondencji wskazuje, iz osoby w zwiazku malzenskim posiadajace dzieci czesciej niz przy zalozeniu niezaleznosci miedzy wierszami 
a kolumnami tablicy kontyngencji kupuja samochody produkcji amerykanskiej, natomiast osoby stanu wolnego, bez dzieci czesciej niz przy zalozeniu niezaleznosci
miedzy wierszami a kolumnami tablicy kontyngencji uzywaja samochodow marki japonskiej.*/

//ZADANIE 2
//Kontrowersje -- czy wartosci Polakow zmienily sie pomiedzy 1989 a 2012 rokiem?

//Baza do zadania zostala stworzona na podstawie badania World Values Survey (http://www.worldvaluessurvey.org/wvs.jsp [dostep 20 marca 2015]),
// a dokladnie jego 4 fal, w ktorych brala udzial Polska:
// fali 2 : 1989 (938 osob)
// fali 3 : 1997 (1153 osoby)
// fali 5 : 2005 (1000 osob)
// fali 6 : 2012 (966)
 
// W kazdym badaniu respondentom zadano pytania, jak bardzo akceptowalne sa zjawiska z okreslonej puli.
// Respondenci odpowiadali wybierajac jedna z kilku mozliwych odpowiedzi, porzadkujacych ich stopien akceptacji danego zjawiska
// Dla potrzeb tego zadania policzono osoby, ktore na pytania udzielily odpowiedzi "calkowicie nieakceptowalne". Nastepnie przeliczono
// jaki procent wszystkich odpowiedzi stanowi tak zdecydowanie okreslony brak akceptacji.

//Uzyte zmienne:
//kontrowersja: zjawisko, ktore wywoluje kontrowersje, gdzie	1 -- pobieranie niezasluzonych swiadczen od rzadu; 2 -- oszustwo podatkowe;
//3 -- kupno skradzionych rzeczy; 4 -- lapowkarstwo; 5 -- homoseksualnosc; 6 -- prostytucja; 7 -- aborcja; 8 -- rozwod; 9 -- eutanazja; 10 -- samobojstwo

//rok -- rok, w ktorym przeprowadzono wywiad, gdzie 1 -- 1989; 2 -- 1997; 3 -- 2005; 4 --2012;

//wartosc -- procent respondentow, ktorzy na pytanie o okreslone zjawisko odpowiedzieli, ze jest "calkowicie nieakceptowalne"

// 0. Uzycie bazy danych
use kontrowersje.dta, clear

//1. Nadanie etykiet wartosciom zmiennych "kontrowersja" i "rok"
label define pytania 1 "niezasluzone swiadczenia" 2 "oszustwo podatkowe" 3 "kupno skradzionych rzeczy" 4 "lapowkarstwo" 5 "homoseksualnosc" 6 "prostytucja" 7 "aborcja" 8 "rozwod" 9 "eutanazja" 10 "samobojstwo"
label values kontrowersja pytania

label define rok 1 "1989" 2 "1997" 3 "2005" 4 "2012"
label values rok rok

//2. Czy miedzy zmiennymi wystepuje zaleznosc?
tabulate rok kontrowersja [fw=wartosc], chi2 lrchi2 
tabulate rok kontrowersja [fw=wartosc], V

//3. Analiza korespondencji
ca kontrowersja rok [fw=wartosc)

//4. Prezentacja graficzna wynikow
cabiplot , norow yline(0) xline(0)
cabiplot , nocolumn yline(0) xline(0)
cabiplot, yline(0) xline(0)

//ZADANIE 3
//Wypadki przy pracy  -- czy istnieje zwiazek pomiedzy powodem wypadku a branza?

//Baza do zadania zostala stworzona na podstawie danych udostepnionych przez GUS z ankiety Z11
//http://stat.gov.pl/obszary-tematyczne/rynek-pracy/warunki-pracy-wypadki-przy-pracy/wypadki-przy-pracy-w-2013-r-,4,6.html [dostep dnia 15 marca 2015]
//Wybrano 11 branz (branza) : 1 "rolnictwo" 2 "gornictwo" 3 "przetworstwo" 4 "profesjonalisci" 5 "budownictwo" 6 "handel" 7 "gastronomia" 8 "transport" 9 "finanse i ubezpieczenia" 10 "edukacja" 11 "zdrowie"
//oraz 9 powodow (powod): 1 "niewlasciwy stan czynnika materialnego" 2 "niewlasciwa organizacja pracy" 3 "niewlasciwa organizacja stanowiska pracy" 4 "niewlasciwe poslugiwanie sie czynnikiem materialnym" 5 "brak sprzetu ochronnego" 6 "samowola pracownika" 7 "zly stan psychofizyczny pracownika" 8 "nieprawidlowe zachowanie pracownika" 9 "inne"

//0. Uzycie bazy danych
insheet using "wypadki.csv", delimiter(";")

//1. Nadaj etykiety wartosciom zmiennych "branza" i "powod"

//2. Czy pomiedzy zmiennymi wystepuje zaleznosc? Zinterpretuj wyniki testu chi-kwadrat i wspolczynnik V-Cramera

//3.Przeprowadz analize korespondencji. Jaki procent inercji tlumaczy rozwiazanie dwuwymiarowe?

//4. Zinterpretuj uzyskane wyniki prezentacji graficznej.
