/****************************************************************************
    Copyright (C) 2019  Dorota Celinska-Kopczynska <dot at mimuw dot edu dot pl>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
*****************************************************************************/


/******************************************************************************************/
/*                                  Analiza kanoniczna                                    */
/******************************************************************************************/

/* Do zobrazowania idei analizy kanonicznej przeprowadzimy analize analogiczna do Celinska, Olszewski [2013].

Wykorzystamy baze danych "zadowolenie.dta" oparta na bazie z badania Diagnoza Spoleczna
W badaniu wykorzystujemy jedynie obserwacje dotyczace glow gospodarstwa domowego

numer_gd - do diagnostyki, nr gospodarstwa

plec - plec respondenta (1 -- kobieta, 0 -- mezczyzna)
wiek2011 - wiek w roku 2011
edukacja - wyksztalcenie respondenta
stanciv- stan cywilny
dochod - sredni (estymowany przez repondenta) dochod z ostatnich 3 miesiecy
zaufanie - czy respondent czuje sie kochany i darzony zaufaniem (1 -- tak, 0 -- nie)
dep_x - wskazniki z testu Becka dotyczace oznak depresji: wyglad, zapal do pracy, sen, meczenie sie, zdrowie
zaleznosc -- kto ma wplyw na zycie respondenta (1 -- jestem kowalem swojego losu; 0 -- moje zycie zalezy od wladz, od innych ludzi, od losu-opatrznosci)
kontakty -- liczba kontaktow spolecznych miesiecznie
aktywnosc -- liczba przypadkow aktywnosci spolecznej (wizyty w kinie, teatrze, na koncertach; restauracjach, kawiarniach, pubach; spotkania towarzyskie)

rodzina -- zadowolenie ze stosunkow z rodzina
przyjaciele -- zadowolenie ze stosunkow ze znajomymi
zdrowie -- zadowolenie ze stanu zdrowia
sukces -- zadowolenie z osiagniec zyciowych

Zbior zmiennych zaleznych: rodzina przyjaciele zdrowie sukces
Zbior zmiennych niezaleznych: plec wiek2011, edukacja, stanciv, dochod, zaufanie, dep_x, zaleznosc, kontakty, aktywnosc */

/******************************************************************************************
         KROK 1 - podstawowe charakterystyki statystyczne i obejrzenie zbioru danych

*******************************************************************************************/
codebook rodzina przyjaciele zdrowie sukces
/* zmienne dotyczace zadowolenia z zycia sa zakodowane w porzadku rosnacym -- im wieksza wartosc zmiennej tym dana osoba jest bardziej zadowolona z danej czesci swojego zycia */

centile rodzina przyjaciele zdrowie sukces, level(50)
sum rodzina  przyjaciele zdrowie sukces

hist rodzina, name(q)
hist przyjaciele, name(er)
hist zdrowie, name(t)
hist sukces, name(qy)
graph combine q er t qy
graph drop q er t qy

centile wiek2011 dochod edukacja kontakty aktywnosc, level(50)
sum wiek2011 dochod edukacja kontakty aktywnosc
hist dochod, normal
hist wiek2011, normal
hist kontakty, normal
hist aktywnosc, normal

sktest dochod, noadjust
sktest wiek2011, noadjust
sktest edukacja, noadjust
sktest kontakty, noadjust
sktest aktywnosc,noadjust

graph pie, over(stanciv)

tabulate stanciv
tab plec
tab zaufanie

/*********************************************************************************
            		KROK 2 -- obejrzyjmy korelacje!

**********************************************************************************/

/* Czym silniejsze korelacje pomiedzy dwoma wyroznionymi zbiorami zmiennych tym lepszy efekt da analiza kanoniczna. */

/* zmienne zalezne sa typowo porzadkowe, wiec uzywamy wspolczynnika kendala */

ktau rodzina przyjaciele zdrowie sukces, stats(taub p)

/*

             |     rodzina     przyjaciele     zdrowie     sukces
-------------+---------------------------------------------------
 rodzina 	 |     1.0000
		     |
			 |
 przyjaciele |     0.3390       1.0000
			 |     0.0000
			 |
     zdrowie |     0.1895       0.2640     1.0000
			 |     0.0000       0.0000
			 |
      sukces |     0.2965       0.3313     0.3739     1.0000
			 |     0.0000       0.0000     0.0000
*/

/*zmienne nie wykazuja bardzo silnej korelacji*/

/*zmienne niezalezne - nie cechowaly sie rozkladem normalnym, wiec dla bezpieczenstwa spearman*/

spearman wiek2011 edukacja stanciv dochod zaleznosc kontakty aktywnosc plec zaufanie

/*
             | wiek2011 edukacja     stanciv     dochod zalezn~c kontakty aktywn~c     plec     zaufanie
-------------+---------------------------------------------------------------------------------
    wiek2011 |   1.0000
    edukacja |  -0.4197   1.0000
     stanciv |   0.3482  -0.1833   1.0000
      dochod |  -0.2876   0.4949  -0.1770   1.0000
   zaleznosc |  -0.1081   0.0868  -0.0602   0.1383   1.0000
    kontakty |  -0.1860   0.2238  -0.1178   0.2109   0.0503   1.0000
   aktywnosc |  -0.3111   0.4194  -0.1256   0.3555   0.0865   0.3658   1.0000
        plec |   0.1939  -0.0269   0.4074  -0.2301  -0.0821  -0.0877  -0.0145   1.0000
    zaufanie |  -0.0106   0.0573  -0.0460   0.1148   0.0658   0.1496   0.0794  -0.0408   1.0000

*/

/* najwyzsze korelacje - lata nauki a wiek, dochod a lata nauki - nie sa one dziwne, jednoczesnie nie przekraczaja
niebezpiecznego 0.5, wiec mozna przyjac, ze ogolnie w zbiorze zmiennych niezaleznych nie ma istotnych korelacji*/

/*******************************************************************************************
                            KROK 3 -- analiza kanoniczna

*******************************************************************************************/

/*Przechodzimy do analizy pomiedzy zbiorem zmiennych zaleznych a zbiorem zmiennych
niezaleznych - narzedzie: analiza kanoniczna.*/

/*canon -- Canonical correlations*/
/* liczba zmiennych zaleznych: 4*/
/* liczba zmiennych niezaleznych: 14*/
/*1. Dla kazdego zbioru danych zostaly utworzone cztery zmienne kanoniczne (minimum z
wyjsciowej liczby zmiennych w kazdym ze zbiorow zmiennych wyjsciowych - min(4, 14) = 4*/

xi:canon ( rodzina przyjaciele zdrowie sukces)(dep_wyglad dep_zapal dep_zdrowie dep_sen dep_meczenie i.plec wiek2011 kontakty aktywnosc edukacja i.zaufanie i.zaleznosc i.stanciv dochod), test(1 2 3 4) stdcoef

/*pierwszy zbior analizowanych zmiennych; bedziemy interpretowac go jako zbior zmiennych zaleznych*/
/*drugi zbior analizowanych zmiennych; bedziemy interpretowac go jako zbior zmiennych niezaleznych*/

/* UZYWAM ZESTANDARYZOWANYCH WAG!!  -- opcja stdcoef*/
/* interpretuje jesli nie ma wspoliniowosci*/

/* 3.1 Diagnostyka -- ile par zmiennych kanonicznych wybrac?

----------------------------------------------------------------------------
Tests of significance of all canonical correlations

                         Statistic      df1      df2            F     Prob>F
         Wilks' lambda     .425082       68  33959.1     121.6441     0.0000 a
        Pillai's trace       .6943       68    34624     106.9429     0.0000 a
Lawley-Hotelling trace      1.0868       68    34606     138.2711     0.0000 a
    Roy's largest root     .793569       17     8656     404.0668     0.0000 u
----------------------------------------------------------------------------
Test of significance of canonical correlations 1-4

                         Statistic      df1      df2            F     Prob>F
         Wilks' lambda     .425082       68  33959.1     121.6441     0.0000 a
----------------------------------------------------------------------------
Test of significance of canonical correlations 2-4

                         Statistic      df1      df2            F     Prob>F
         Wilks' lambda     .762413       48  25739.9      51.2083     0.0000 a
----------------------------------------------------------------------------
Test of significance of canonical correlations 3-4

                         Statistic      df1      df2            F     Prob>F
         Wilks' lambda     .927227       30    17310      22.2150     0.0000 e
----------------------------------------------------------------------------
Test of significance of canonical correlation 4

                         Statistic      df1      df2            F     Prob>F
         Wilks' lambda      .96983       14     8656      19.2342     0.0000 e
----------------------------------------------------------------------------
                            e = exact, a = approximate, u = upper bound on F
*/

/*Testowanie istotnosci koreacji kanonicznych.
Najpierw testowana jest H0, ze oba wsp. korelacji kanonicznych sa nieistotne
wobec alternatywy, ze przynajmniej pierwsza para zmiennych kanonicznych jest istotna
- st. testowa = 121.64 i p-value < .0001.
Odrzucamy H0 -
czyli pierwsza korelacja kanoniczna jest istotnie rozna od zera.

Nastepnie testowana jest istotnosc drugiego wsp. korelacji kanonicznej - st. testowa = 51.20
i p-value < .0001. Odrzucamy H0 - czyli druga korelacja kanoniczna jest rowniez
istotnie rozna od zera.

Nastepnie testowana jest istotnosc trzeciego wsp. korelacji kanonicznej - st. testowa = 22.21
i p-value < .0001. Odrzucamy H0 - czyli trzecia korelacja kanoniczna jest rowniez
istotnie rozna od zera.

Nastepnie testowana
jest istotnosc czwartego wsp. korelacji kanonicznej - st. testowa = 19.23
i p-value < .0001. Odrzucamy H0 - czyli czwarta korelacja kanoniczna jest rowniez
istotnie rozna od zera.

Wniosek: wszystkie wsp. korelacji kanonicznej sa istotnie rozne od zera. */

/*Omowiona procedura moze byc wazna wskazowka w przypadku analiz na wiekszych
zbiorach danych i wyboru najwazniejszych (istotnych) zmiennych kanonicznych
do dalszej analizy.
Test wskazuje na ktorym etapie mozna przyjac, ze pozostale
(najmniejsze) wsp. korelacji kanonicznej sa nieistotnie rozne od zera.*/

/* 3.2 Wspolczynniki korelacji kanonicznej */
/* ----------------------------------------------------------------------------
 Canonical correlations:
  0.6652  0.4216  0.2096  0.1737
*/
/* I wsp korelacj kanonicznej = 0.6652. Jest to najwiekszy mozliwy do osiagniecia
wsp. korelacji miedzy liniowymi kombinacjami zmiennych z obu zbiorow. Wielkosc ta jest
wieksza niz kazdy wsp. korelacji miedzy zmienna ze zbioru X, a zmienna ze zbioru
Y.*/

/*3.3. Wagi kanonicze - pokazuja wklad poszczegolnych zmiennych do zmiennych kanonicznych.
Poniewaz wyjsciowe zmienne sa mierzone na roznych skalach oraz maja rozna wariancje
nalezy interpretowac "standaryzowane wagi kanoniczne" */

/*Ze wzgledu na operowanie wystandaryzowanymi wartosciami zmiennych wejsciowych odpowiadaja one wspolczynnikom
beta w regresji wielorakiej.
Czym wieksza wartosc bezwzgledna wagi danej zmiennej wejsciowej tym wiekszy jej wklad do danej zmiennej kanonicznej*/

/*3.4. Standaryzowane wagi kanoniczne - wagi kanoniczne przemnozone przez odchylenia
standardowe wyjsciowych zmiennych. Wspolczynniki te sa wykorzystywane do interpretacji
uzyskanych liniowych kombinacji (zmiennych kanonicznych). */


/*Standardized coefficients for the first variable set*/

/*
i.plec            _Iplec_0-1          (naturally coded; _Iplec_0 omitted)
i.zaufanie            _Ifp38_0-1          (naturally coded; _Ifp38_0 omitted)
i.zaleznosc       _Izaleznosc_0-1     (naturally coded; _Izaleznosc_0 omitted)
i.stanciv         _Ifc11_1-5        (naturally coded; _Ifc11_1 omitted)

Canonical correlation analysis                         Number of obs =    8674

Standardized coefficients for the first variable set

                 |        1         2         3         4
    -------------+----------------------------------------
         rodzina |   0.0813    0.6026   -0.9298    0.0290
     przyjaciele |   0.0869    0.1751    0.5251    0.9817
         zdrowie |   0.9007   -0.6068   -0.2594   -0.0253
          sukces |   0.0953    0.6011    0.6714   -0.7395
    ------------------------------------------------------

Standardized coefficients for the second variable set

                 |        1         2         3         4
    -------------+---------------------------------------
      dep_wyglad |   0.1208    0.2604    0.1667   -0.1938
       dep_zapal |   0.1680    0.0780    0.1546    0.1119
     dep_zdrowie |   0.4866   -0.3354   -0.1957    0.0009
         dep_sen |   0.1005    0.0327   -0.0559    0.1626
    dep_meczenie |   0.2405   -0.0222   -0.0669   -0.0061
        _Iplec_1 |  -0.0295    0.1457   -0.0514    0.4286
        wiek2011 |  -0.0278    0.5774    0.2994   -0.2360
        kontakty |   0.0352    0.2166    0.1121    0.4538
       aktywnosc |   0.0580    0.0721    0.3290    0.1388
        edukacja |   0.0255    0.1830    0.4487   -0.2897
    _Izaufanie_1 |   0.1302    0.6032   -0.5618    0.1392
    _Izaleznos~1 |   0.0822    0.1095    0.0870   -0.0355
     _Istanciv_2 |  -0.0102    0.1090   -0.1933   -0.4957
     _Istanciv_3 |   0.0041    0.0997    0.1553   -0.1654
     _Istanciv_4 |  -0.0563   -0.1172    0.0674    0.0379
     _Istanciv_5 |  -0.0088   -0.0351    0.0574    0.0703
          dochod |   0.0791    0.1377    0.3321   -0.2830
    ------------------------------------------------------

/* 3.5. INTERPRETACJA */

/* Wybor jest subiektywny -- wybieramy kilka zmiennych o najwyzszych co do wartosci bezwglednej wartosciach wspolczynnikow

Pierwsza zmienna kanoniczna -- postrzeganie zdrowia (bo f63_4 wysokie)
zdrowie -- osoby lepiej oceniajace swoje zdrowie sa bardziej zadowolone ze swojego stanu zdrowia (0.49)
zmeczenie -- osoby mniej odczuwajace zmeczenie sa bardziej zadowolone ze swojego stanu zdrowia (0.24)
zapal do pracy -- osoby majace nie mniej zapalu do pracy niz dawniej sa bardziej zadowolone ze swojego stanu zdrowia (0,17)
zaufanie -- poczucie ze mozna komus zaufac wplywa pozytywnie na poziom zadowolenia (0.13)
wyglad -- lepsza ocena swojego wygladu wiaze sie z wiekszym zadowoleniem  (0.12)

Druga zmienna kanoniczna -- zadowolenie z zycia rodzinnego (0.60), swoich sukcesow (0.60) i niezadowolenie ze stanu zdrowia (-0.61)
bycie kochanym -- osoby czujace sie bardziej kochane sa bardziej zadowolone z zycia rodzinnego ,etc(0.60)
wiek --  osoby starsze sa bardziej zadowolone z zycia rodzinnego ale mniej ze stanu zdrowia (0.58)
zdrowie -- wieksze martwienie sie o zdrowie to mniejsza satysfakcja z niego (-0.34)
wyglad -- lepsze zdanie o swoim wygladzie wiaze sie z wyzszymi wartosciami 2 zmiennej (0.26)
kontakty -- wieksza liczba kontaktow spolecznych wiaze sie z wyzszymi wartosciami 2 zmiennej (0.22)

Tutaj moglismy miec artefakt wplywu wieku, jesli spojrzymy na wplyw stanu cywilnego!

Trzecia zmienna kanoniczna -- niezadowolenie z zycia rodzinnego, ale satysfakcja z przyjaciol i osiagniec zyciowych
bycie kochanym -- osoby czujace sie kochane maja nizsze wartosci tej zmiennej (-0.56)
edukacja -- wieksze zadowolenie z przyjaciol i osiagniec zyciowych (0.45)
aktywnosc -- wieksza aktywnosc wieksze zadowolenie z przyjaciol (0.33)
dochod -- wieksze zadowolenie z osiagniec zyciowych(0.33)

osoby ktore sie dluzej uczyly, sa bardziej aktywne spolecznie, starsze i maja wyzszy dochod sa bardziej zadowolone z zycia z przyjaciolmi i osiagniec
zyciowych ale mniej z zycia rodzinnego
zamezne kobiety/zonaci mezczyzni maja nizsze wartosci tej zmiennej kanonicznej; wdowy/wdowcy wyzsze
rozwod/separacja wiaze sie z niezadowoleniem z zycia rodzinnego */

/* Czwarta zmienna kanoniczna -- zadowolenie z przyjaciol i osiagniec zyciowych
osoby zamezne/zonate maja nizsze wartosci tej zmiennej (-0.50)
kobiety (0.43) majace wiecej kontaktow spolecznych (0.45) o nizszym dochodzie (-0.28) i mniej wyedukowane (-0.29) do tego mlodsze (-0.24) maja nizsze
wartosci tej zmiennej */

/*6. Interpretowanie standaryzowanych wag kanonicznych moze byc utrudnione, jezeli
w ktoryms ze zbiorow wyjsciowych zmienych sa zmienne bardzo silnie ze soba skorelowane
(w kontekscie naszego zbioru danych tak nie jest). Np. jezeli w zbiorze X-ow sa
dwie zmienne silnie dodatnio ze soba skorelowane oraz kazda z tych zmiennych jest silnie
dodatnio skorelowana ze zmienna kanoniczna, to moze zdarzyc sie, iz korelacje miedzy
tymi X-ami a zmienna kanoniczna sa dodatnie, natomiast jedna ze standaryzowanych wag
kanonicznych jest dodatnia a druga ujemna. Wowczas zaleca sie intepretowac korelacje
miedzy zmiennymi wyjsciowymi a zmiennymi kanonicznymi.*/

/* 3.6 Ladunki kanoniczne*/

estat loadings

/*
Canonical loadings for variable list 1

                 |        1         2         3         4
    -------------+----------------------------------------
         rodzina |   0.3418    0.7414   -0.5609    0.1375
     przyjaciele |   0.4141    0.4381    0.3426    0.7206
         zdrowie |   0.9834   -0.1744   -0.0283   -0.0408
          sukces |   0.5295    0.6167    0.4338   -0.3889
    ------------------------------------------------------

Canonical loadings for variable list 2

                 |        1         2         3         4
    -------------+---------------------------------------
      dep_wyglad |   0.6149    0.1558    0.1056   -0.0893
       dep_zapal |   0.7352    0.0353    0.1024    0.0970
     dep_zdrowie |   0.8470   -0.2563   -0.0845   -0.0046
         dep_sen |   0.6116   -0.0244   -0.0340    0.1118
    dep_meczenie |   0.7745   -0.1047   -0.0105    0.0569
        _Iplec_1 |  -0.1952    0.1295    0.1418    0.6241
        wiek2011 |  -0.5196    0.4405    0.0145   -0.0957
        kontakty |   0.2218    0.2845    0.2207    0.3857
       aktywnosc |   0.2730    0.0971    0.4772    0.2268
        edukacja |   0.3920    0.0890    0.5148   -0.1718
    _Izaufanie_1 |   0.2880    0.6924   -0.4978    0.0787
    _Izaleznos~1 |   0.2738    0.1234    0.1020   -0.0709
     _Istanciv_2 |   0.1951    0.0626   -0.3042   -0.6394
     _Istanciv_3 |  -0.2903    0.2352    0.1421    0.2848
     _Istanciv_4 |  -0.0610   -0.2029    0.1610    0.3054
     _Istanciv_5 |  -0.0298   -0.0966    0.1137    0.1665
          dochod |   0.3529    0.1629    0.4543   -0.3572
    ------------------------------------------------------

Correlation between variable list 1 and canonical variates from list 2

                 |        1         2         3         4
    -------------+----------------------------------------
         rodzina |   0.2274    0.3126   -0.1176    0.0239
     przyjaciele |   0.2754    0.1847    0.0718    0.1252
         zdrowie |   0.6541   -0.0735   -0.0059   -0.0071
          sukces |   0.3522    0.2600    0.0909   -0.0675
    ------------------------------------------------------

Correlation between variable list 2 and canonical variates from list 1

                 |        1         2         3         4
    -------------+----------------------------------------
      dep_wyglad |   0.4090    0.0657    0.0221   -0.0155
       dep_zapal |   0.4890    0.0149    0.0215    0.0168
     dep_zdrowie |   0.5634   -0.1081   -0.0177   -0.0008
         dep_sen |   0.4068   -0.0103   -0.0071    0.0194
    dep_meczenie |   0.5152   -0.0442   -0.0022    0.0099
        _Iplec_1 |  -0.1298    0.0546    0.0297    0.1084
        wiek2011 |  -0.3456    0.1857    0.0030   -0.0166
        kontakty |   0.1476    0.1199    0.0462    0.0670
       aktywnosc |   0.1816    0.0409    0.1000    0.0394
        edukacja |   0.2607    0.0375    0.1079   -0.0298
    _Izaufanie_1 |   0.1916    0.2919   -0.1043    0.0137
    _Izaleznos~1 |   0.1821    0.0520    0.0214   -0.0123
     _Istanciv_2 |   0.1297    0.0264   -0.0638   -0.1111
     _Istanciv_3 |  -0.1931    0.0992    0.0298    0.0495
     _Istanciv_4 |  -0.0406   -0.0856    0.0337    0.0531
     _Istanciv_5 |  -0.0198   -0.0407    0.0238    0.0289
          dochod |   0.2347    0.0687    0.0952   -0.0620
    ------------------------------------------------------

*/

estat correlations

/*
estat correlations

Correlations for variable list 1

                 |   rodzina  przyjaciele zdrowie  sukces
    -------------+----------------------------------------
         rodzina |   1.0000
     przyjaciele |   0.3733    1.0000
         zdrowie |   0.2171    0.2917    1.0000
          sukces |   0.3414    0.3578    0.4167    1.0000
    ------------------------------------------------------

Correlations for variable list 2

                 | dep_wyglad  dep_zapal  dep_zdrowie  dep_sen  dep_meczenie  _Iplec_1  wiek2011  kontakty  aktywn~c  edukacja  _Ifp38_1  _Izale~1  _Istan~2
    -------------+------------------------------------------------------------------------------------------------------------------------------------------
      dep_wyglad |   1.0000
       dep_zapal |   0.4869    1.0000
     dep_zdrowie |   0.3833    0.4841    1.0000
         dep_sen |   0.3743    0.4501    0.4123    1.0000
    dep_meczenie |   0.4648    0.5947    0.5166    0.4958    1.0000
        _Iplec_1 |  -0.1176   -0.0762   -0.1154   -0.1215   -0.1211    1.0000
        wiek2011 |  -0.3613   -0.4031   -0.3544   -0.3605   -0.4603    0.1885    1.0000
        kontakty |   0.1401    0.1747    0.0743    0.1248    0.1293   -0.0785   -0.1784    1.0000
       aktywnosc |   0.1466    0.1647    0.1355    0.1129    0.1697   -0.0098   -0.2436    0.2824    1.0000
        edukacja |   0.2329    0.2941    0.2413    0.2419    0.2797   -0.0371   -0.4120    0.1963    0.2959    1.0000
    _Izaufanie_1 |   0.1530    0.1567    0.0953    0.1222    0.1215   -0.0408   -0.0104    0.1108    0.0487    0.0594    1.0000
    _Izaleznos~1 |   0.1539    0.1651    0.1407    0.1388    0.1395   -0.0821   -0.1104    0.0418    0.0638    0.0821    0.0658    1.0000
     _Istanciv_2 |   0.1233    0.1288    0.1072    0.1162    0.1023   -0.5819   -0.1746    0.1061   -0.0501    0.0992    0.1281    0.0649    1.0000
     _Istanciv_3 |  -0.1953   -0.2302   -0.2036   -0.2096   -0.2393    0.4920    0.4308   -0.1160   -0.1026   -0.2702   -0.0261   -0.0879   -0.6187
     _Istanciv_4 |  -0.0039    0.0133    0.0008   -0.0086    0.0272    0.2110   -0.0326   -0.0325    0.0437    0.0611   -0.0787   -0.0002   -0.3521
     _Istanciv_5 |  -0.0225   -0.0031   -0.0125   -0.0054   -0.0066    0.0677   -0.0073   -0.0199    0.0101    0.0206   -0.0745    0.0002   -0.1463
          dochod |   0.1587    0.2135    0.1910    0.1755    0.1902   -0.1911   -0.2479    0.1723    0.2257    0.4378    0.0799    0.1143    0.1807
    --------------------------------------------------------------------------------------------------------------------------------------------------------

                 | _Istanciv~3  _Istanciv~4  _Istanciv~5  dochod
    -------------+----------------------------------------------
     _Istanciv_3 |   1.0000
     _Istanciv_4 |  -0.1355    1.0000
     _Istanciv_5 |  -0.0563   -0.0320    1.0000
          dochod |  -0.1883   -0.0400   -0.0199    1.0000
    ------------------------------------------------------------

Correlations between variable lists 1 and 2

                 |   rodzina  przyjaciele  zdrowie  sukces
    -------------+----------------------------------------
      dep_wyglad |   0.1740    0.1945    0.3908    0.2727
       dep_zapal |   0.1685    0.2285    0.4770    0.2708
     dep_zdrowie |   0.1223    0.1793    0.5735    0.2243
         dep_sen |   0.1381    0.1755    0.4013    0.1984
    dep_meczenie |   0.1460    0.2003    0.5140    0.2407
        _Iplec_1 |  -0.0057    0.0585   -0.1425   -0.0643
        wiek2011 |   0.0156   -0.0727   -0.3717   -0.0607
        kontakty |   0.1226    0.1778    0.1202    0.1461
       aktywnosc |   0.0417    0.1558    0.1670    0.1495
        edukacja |   0.0523    0.1399    0.2480    0.2196
        _Ifp38_1 |   0.3423    0.1813    0.1399    0.2309
    _Izaleznos~1 |   0.0872    0.0967    0.1699    0.1426
     _Istanciv_2 |   0.0844   -0.0366    0.1293    0.1005
     _Istanciv_3 |  -0.0024    0.0093   -0.2101   -0.0474
     _Istanciv_4 |  -0.0889   -0.0045   -0.0281   -0.0802
     _Istanciv_5 |  -0.0464    0.0029   -0.0143   -0.0365
          dochod |   0.0692    0.1152    0.2187    0.2321
    ------------------------------------------------------
*/

/* 3.7 Redundancja i wariancja wyodrebniona */

/*Interpretacja dla zmiennych niezaleznych.
Wariancja wyodrebniona: dla kazdej zmiennej kanonicznej obliczamy srednia z kwadratow
wsp. korelacji miedzy ta zmienna kanoniczna a zmiennymi z odpowiadajacego jej zbioru
zmiennych.

Redundacja: iloczyn kwadratu korelacji kanonicznej i wariancji wyodrebnionej:

Redundacja mowi nam ile przecietnie wariancji w jednym zbiorze jest wyjasnione przez dana
zmienna kanoniczna  przy danym innym zbiorze zmiennych. Wartosc redundacji calkowitej
moze byc wazna analityczna informacja o naszym modelu. Mowi o procencie calkowitej
wariancji jednego zbioru wyjasniona w ramach modelu. Moze byc pomocna w ocenie, czy
poprzez dolaczenie nowych zmiennych, uzyskamy wiekszy zakres wyjasnienia niz poprzednio.*/

net install canred
canred 1

/*
Canonical redundancy analysis for canonical correlation 1

Canonical correlation coefficient          0.6652
Squared canonical correlation coefficient  0.4425

                                       own    opposite
Proportion of standardized variance  variate   variate
           of u variables with ...    0.3839    0.1699
           of v variables with ...    0.2121    0.0938

*/
/* 1 zmienna kanoniczna wyjasnia przecietnie 21.21% zmiennosci w zbiorze Y w oparciu o X
   Redundancja wynosi 9.38%*/

canred 2

/*
Canonical redundancy analysis for canonical correlation 2

Canonical correlation coefficient          0.4216
Squared canonical correlation coefficient  0.1777

                                       own    opposite
Proportion of standardized variance  variate   variate
           of u variables with ...    0.2881    0.0512
           of v variables with ...    0.0613    0.0109
*/

/* 2 zmienna kanoniczna wyjasnia przecietnie 6.13% zmiennosci w zbiorze Y w oparciu o X
   Redundancja wynosi 1.09% */

canred 3

/*

Canonical redundancy analysis for canonical correlation 3

Canonical correlation coefficient          0.2096
Squared canonical correlation coefficient  0.0439

                                       own    opposite
Proportion of standardized variance  variate   variate
           of u variables with ...    0.1552    0.0068
           of v variables with ...    0.0711    0.0031
*/

/* 3 zmienna kanoniczna wyjasnia przecietnie 7.11% zmiennosci w zbiorze Y w oparciu o X
   Redundancja wynosi 0.31% */

canred 4
/*
Canonical redundancy analysis for canonical correlation 4

Canonical correlation coefficient          0.1737
Squared canonical correlation coefficient  0.0302

                                       own    opposite
Proportion of standardized variance  variate   variate
           of u variables with ...    0.1727    0.0052
           of v variables with ...    0.0830    0.0025

*/
/* 4 zmienna kanoniczna wyjasnia przecietnie 8.30% zmiennosci w zbiorze Y w oparciu o X
   Redundancja wynosi 0.25% */


/*******************************************************************************************
                            KROK 4 - diagnostyka modelu

*******************************************************************************************/
/*obserwacje odstajace
  zapisujemy poszczegolne zmienne kanoniczne */
  
predict u1, u corr(1)
predict u2, u corr(2)
predict u3, u corr(3)
predict u4, u corr(4)
predict v1, v corr(1)
predict v2, v corr(2)
predict v3, v corr(3)
predict v4, v corr(4)

/*Sprawdzamy, czy rzeczywiscie korelacje miedzy zmiennymi kanonicznymi w obrebie jednego
zbioru zmiennych wyjsciowych wynosza 0.*/
correlate u1 u2 u3 u4 v1 v2 v3 v4

/*
             |       u1       u2       u3       u4       v1       v2       v3       v4
-------------+------------------------------------------------------------------------
          u1 |   1.0000
          u2 |  -0.0000   1.0000
          u3 |   0.0000  -0.0000   1.0000
          u4 |   0.0000   0.0000   0.0000   1.0000
          v1 |   0.6652  -0.0000   0.0000   0.0000   1.0000
          v2 |   0.0000   0.4216  -0.0000   0.0000  -0.0000   1.0000
          v3 |  -0.0000  -0.0000   0.2096  -0.0000   0.0000   0.0000   1.0000
          v4 |  -0.0000   0.0000   0.0000   0.1737  -0.0000  -0.0000   0.0000   1.0000

i tak dokladnie jest
*/
/*szukamy outlierow
  rysujemy wykresy par zmiennych kanonicznych jako etykiet uzywamy numeru gospodarstwa */

scatter u1 v1, mlabel(numer_gd) //chmura (:
scatter u2 v2, mlabel(numer_gd) //chmura
scatter u3 v3, mlabel(numer_gd) //jeden by sie znalazl
scatter u4 v4, mlabel(numer_gd) //chmura

/* zobaczmy co z nim nie tak */
list  wiek2011 edukacja dochod zaleznosc kontakty aktywnosc rodzina przyjaciele zdrowie sukces plec zaufanie if numer_gd==43497
/* nie jest specjalnie dziwna obserwacja
   w zasadzie mamy tutaj chmurki w kazdym wykresie, wiec nie wyrozniaja sie specjalnie oberwacje odstajace*/
