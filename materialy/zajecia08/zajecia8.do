/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajecia 8                        ****/
/****         Hierarchiczna analiza skupień             ****/
/***********************************************************/ 
/// Przykład 1.
/// Dane i przykład zostały pożyczone z podręcznika 
/// Sophia Rabe-Hesketh i Brian Everitt
/// "A Handobook of Statistical Analyses using Stata"
/// Dane dotyczą czaszek ludzkich znalezionych w Tybecie
use tibetan.dta, clear  
/// opis danych
des
sum
/// Zmienne sa mierzone w identycznych jednostkach (mm)
/// Nie ma potrzeby standaryzacji wartosci zmiennych

/// Metoda pojedynczego wiazania
cluster singlelinkage length breadth height upper face, name(pojedyncze)
cluster dendrogram
/// Metoda pelnego wiazania
cluster completelinkage length breadth height upper face, name(pelne)
cluster dendrogram
/// ten dendrogram wskazuje na hierarchiczny charakter danych
/// dlugosc pionowych linii pokazuje roznice miedzy skupieniami
/// im linie sa dluzsze tym obiekty bardziej roznia sie
/// Metoda przecietnego wiazania
cluster averagelinkage length breadth height upper face, name(przecietne)
cluster dendrogram
/// ten dendrogram wskazuje na hierarchiczny charakter danych
/// Metoda medianowego wiazania
cluster medianlinkage length breadth height upper face, name(medianowe)
cluster dendrogram
/// Metoda Warda
cluster wardslinkage length breadth height upper face, name(Warda)
cluster dendrogram
/// ten dendrogram wskazuje na hierarchiczny charakter danych
/// prosze zwrocic uwage ze metoda Warda wykorzystuje inna miare odleglosci

/// Kryterium wyboru optymalnej liczby grup
cluster stop pojedyncze, rule(duda)
cluster stop pojedyncze, rule(calinski)
cluster dendrogram pojedyncze 
cluster dendrogram pojedyncze, cutn(6) showcount

cluster stop pelne, rule(duda)
cluster stop pelne, rule(calinski)
cluster dendrogram pelne 
cluster dendrogram pelne, cutn(3) showcount

cluster stop przecietne, rule(duda)
cluster stop przecietne, rule(calinski)

cluster stop medianowe, rule(duda)
cluster stop medianowe, rule(calinski)

cluster stop Warda, rule(duda)
cluster stop Warda, rule(calinski)

/// Chcmy zobaczyc charakterystyki grup czaszek uzyskanych metoda pelnego wiazania
/// Tworzymy identyfikatory grup
cluster generate grupa = groups(3), name(pelne)
/// Tabela liczebnosci
tabulate grupa
/// Tabela statystyk opisowych
table grupa, c(mean length mean breadth mean height mean upper mean face) format(%4.1f)

/// Przykład 2.
/// W tym przykladzie wykorzystamy znane juz Panstwu dane dotyczace trzech odmian irysow
/// Ich cechy to:
/// Dlugosc platka [cm] (petal lenght)
/// Szerokosc platka [cm] (petal width)
/// Dlugosc listka kielicha [cm]
/// Szerokosc listka kielicha [cm]

use iris.dta, clear
/// Opis danych
des
/// Podstawowe statystyki opisowe
bysort iris: su seplen sepwid petlen petwid 

cluster singlelinkage seplen sepwid petlen petwid , name(pojedyncze)
cluster dendrogram
/// dla zbioru o wiekszej liczbie obserwacji nie mozna wyswietlic pelnego dendrogramu
/// przydatne sa opcje
///      cutnumber(#)           wyswietla okreslona liczbe galezi
///      cutvalue(#)            wyswietla tylko rozniace sie galezie o zadana wartosc
cluster dendrogram, cutnumber(10)
cluster dendrogram, cutvalue(0.5)
/// opcja showcount pokazuje liczbe obserwacji w kazdej galezi
cluster dendrogram, cutvalue(0.5) showcount
/// tworzymy identyfikator 3 grup
cluster generate gr_single = groups(3), name(pojedyncze)
/// Czy klasyfikacja jest poprawna?
tab iris gr_single

/// Sprobujmy inna metoda
cluster completelinkage seplen sepwid petlen petwid , name(pelne)
cluster dendrogram, cutnumber(10)
cluster dendrogram, cutvalue(0.5)
/// tworzymy identyfikator 3 grup
cluster generate gr_complete = groups(3), name(pelne)
/// Czy klasyfikacja jest poprawna?
tab iris gr_complete

/// Sprobujmy inna metoda
cluster wardslinkage seplen sepwid petlen petwid , name(ward)
cluster dendrogram, cutnumber(10)
cluster dendrogram, cutvalue(0.5)
/// tworzymy identyfikator 3 grup
cluster generate gr_ward = groups(3), name(ward)
/// Czy klasyfikacja jest poprawna?
tab iris gr_ward


