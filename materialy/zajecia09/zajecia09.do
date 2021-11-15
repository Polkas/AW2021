/******************************************************************************************/
/*                                  Analiza czynnikowa				                      */
/******************************************************************************************/

//Przyklad 1 -- zaczerpniety z materialow pani Natalii Nehrebeckiej

/*Ponizej przedstawimy analize czynnikowa metoda najwiekszej wiarogodnosci. Zaleca
sie na wstepie analize skladowych glownych, aby ustalic przyblizona liczbe czynnikow*/

/*Dane wejsciowe do analizy czynnikowej moga miec postac macierzy kowariancji lub korelacji.
Posluzymy sie danymi pochodzacymi z badania przeprowadzonego na 123 osobach cierpiacych
z powodu silnych napadow bolu. Poproszono ich o wydanie opinii na skali od 1 do 6
(1-calkowicie sie zgadzam, 6-nie zgadzam sie) na temat 9 oswiadczen na temat bolu.

Ponizej lista zmiennych:
1. To, czy bede cierpial z powodu bolu w przyszlosci zalezy od lekarza.
2. To, czy bede cierpial z powodu bolu, zalezy zwykle od tego, czy cos zrobilem lub nie
   zrobilem.
3. To, czy bede cierpial z powodu bolu, zalezy od tego, co zrobi dla mnie lekarz.
4. Nie moge poradzic sobie z bolem, dopoki nie skorzystam z pomocy medycznej.
5. Jesli czuje bol, to jest to spowodowane tym, iz nie wykonywalem odpowiednich cwiczen lub
   nieprawidlowo sie odzywialem.
6. Bol jest wynikiem zaniedbania.
7. Jestem calkowicie odpowiedzialny za moj bol.
8. Pozbycie sie bolu jest kontrolowane przez doktora.
9. Ludzie, ktorzy nigdy nie cierpia z powodu bolu, sa szczesciarzami.*/

matrix C = ( 1.0000, -0.0385, 0.6066, 0.4507, 0.0320, -0.2877, -0.2974, 0.4526, 0.2952 \/*
*/ -0.0385, 1.0000, -0.0693, -0.1167, 0.4881, 0.4271, 0.3045, -0.3090, -0.1704 \/*
*/ 0.6066, -0.0693, 1.000, 0.5916, 0.0317, -0.1336, -0.2404, 0.5886, 0.3165 \ /*
*/0.4507, -0.1167, 0.5916, 1.0000, -0.0802,  -0.2073, -0.1850, 0.6286, 0.3680 \ /*
*/0.0320, 0.4881, 0.0317, -0.0802, 1.0000, 0.4731, 0.4138, -0.1397, -0.2367 \ /*
*/-0.2877, 0.4271, -0.1336, -0.2073, 0.4731, 1.0000, 0.6346, -0.1329, -0.1541 \ /*
*/-0.2974, 0.3045, -0.2404, -0.1850, 0.4138, 0.6346, 1.0000, -0.2599, -0.2893 \ /*
*/0.4526, -0.3090, 0.5886, 0.6286, -0.1397, -0.1329, -0.2599, 1.0000, 0.4047 \ /*
*/0.2952, -0.1704, 0.3165, 0.3680, -0.2367, -0.1541, -0.2893, 0.4047, 1.0000 )

/*Nie musimy nigdzie okreslac, iz na wejsciu mamy dane w postaci macierzy
korelacji. Rozpoczniemy od 2 czynnikow*/
/*Jesli wykorzystujemy dane w postaci macierzy korelacji, musimy okreslic liczbe obserwacji*/

factormat C, n(123) names(p1 p2 p3 p4 p5 p6 p7 p8 p9) fac(2) ml

/*
Factor analysis/correlation                        Number of obs    =      123
    Method: maximum likelihood                     Retained factors =        2
    Rotation: (unrotated)                          Number of params =       17
                                                   Schwarz's BIC    =  143.868
    Log likelihood = -31.03021                     (Akaike's) AIC   =  96.0604

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
	   -------------+------------------------------------------------------------
        Factor1  |      2.95049      1.49947            0.6703       0.6703
        Factor2  |      1.45101            .            0.3297       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(36) =  404.20 Prob>chi2 = 0.0000
    LR test:   2 factors vs. saturated:  chi2(19) =   59.45 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness
    -------------+--------------------+--------------
              p1 |   0.6430    0.2105 |      0.5423
              p2 |  -0.3609    0.4132 |      0.6990
              p3 |   0.7180    0.4007 |      0.3239
              p4 |   0.6872    0.2874 |      0.4451
              p5 |  -0.3106    0.5690 |      0.5798
              p6 |  -0.5206    0.6136 |      0.3524
              p7 |  -0.5625    0.4770 |      0.4560
              p8 |   0.7089    0.2536 |      0.4332
              p9 |   0.4822    0.0258 |      0.7668
    -------------------------------------------------
*/

/*Wyniki testu -- okazuje sie ze 2 czyniki nie wystarcza (p-value = 0.0000<0.05)*/
//Probujemy z 3 czynnikami

factormat C, n(123) names(p1 p2 p3 p4 p5 p6 p7 p8 p9) fac(3) ml

/*

Factor analysis/correlation                        Number of obs    =      123
    Method: maximum likelihood                     Retained factors =        3
    Rotation: (unrotated)                          Number of params =       24
                                                   Schwarz's BIC    =  134.755
    Log likelihood = -9.631368                     (Akaike's) AIC   =  67.2627

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      3.00744      1.50513            0.5864       0.5864
        Factor2  |      1.50231      0.88332            0.2929       0.8793
        Factor3  |      0.61900            .            0.1207       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(36) =  404.20 Prob>chi2 = 0.0000
    LR test:   3 factors vs. saturated:  chi2(12) =   18.35 Prob>chi2 = 0.1055

Factor loadings (pattern matrix) and unique variances

    -----------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3 |   Uniqueness
    -------------+------------------------------+--------------
              p1 |   0.6049    0.2948    0.3724 |      0.4085
              p2 |  -0.4548    0.2910    0.4310 |      0.5227
              p3 |   0.6134    0.4979    0.1918 |      0.3391
              p4 |   0.6212    0.3993   -0.0035 |      0.4546
              p5 |  -0.4067    0.4498    0.3717 |      0.4941
              p6 |  -0.6715    0.5934   -0.1488 |      0.1747
              p7 |  -0.6255    0.3422   -0.0628 |      0.4877
              p8 |   0.6805    0.4750   -0.2726 |      0.2370
              p9 |   0.4492    0.1622   -0.1385 |      0.7527
    -----------------------------------------------------------
*/

/*Na poziomie istotnosci 0,05 brak podstaw do odrzucenia H0 zakladajacej, ze model
trzyczynnikowy jest adekwatny (wystarczajacy). p-value 0.1055>0.05*/

/*Sprobujemy nadac czynnikom interpretacje. Przeprowadzamy rotacje czynnikow*/
rotate, varimax
rotate, varimax blanks(.3)
/*Rotated factor loadings (pattern matrix) and unique variances

    -----------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3 |   Uniqueness
    -------------+------------------------------+--------------
              p1 |   0.6578   -0.2822    0.2813 |      0.4085
              p2 |  -0.1153    0.3901    0.5584 |      0.5227
              p3 |   0.7953   -0.0957    0.1390 |      0.3391
              p4 |   0.7256   -0.1196   -0.0672 |      0.4546
              p5 |   0.0258    0.4874    0.5174 |      0.4941
              p6 |  -0.0907    0.8989    0.0946 |      0.1747
              p7 |  -0.2252    0.6675    0.1265 |      0.4877
              p8 |   0.8095   -0.0337   -0.3265 |      0.2370
              p9 |   0.4327   -0.1408   -0.2005 |      0.7527
    -----------------------------------------------------------
*/
/*pierwszy czynnik - stwierdzenia 1, 3, 4 i 8 - wszystkie zwiazane z lekarzami; mozemy  zinterpretowac jako "kontrola lekarska bolu"
  drugi czynnik - stwierdzenia 6 i 7 - bol jako wynik wlasnych dzialan
  trzeci czynnik - stwierdzenia 2 i 5 - znow bol jako wynik wlasnych dzialan.*/

/*Mozemy nastepnie wyznaczyc czynniki i zapisac je w zbiorze wynikowym*/
predict factor1-factor3

 estat smc
/*oszacowanie czesci wspólnej ->"communality" (jaka czesc zmiennej Xi  jest zwiazana z pozostalymi zmiennymi X)
estymowana jako kwadrat wspolczynnika korelacji wielorakiej
danej zmiennej z pozostalymi (czyli R2 z regresji tej zmiennej na pozostale)*/

estat kmo

/*statystyka adekwatnosci proby Kaiser-Meyer-Olkin.
Metoda ta polega na porownaniu korelacji i czastkowych korelacji pomiedzy zmiennymi.
Gdy korelacja czastkowa jest relatywnie wysoka w stosunku do zwyklej korelacji to KMO jest male,
co oznacza ze uzyskanie adekwatnego rozwiazania w przestrzeni malego wymiaru jest niewykonalne.

Wielkosci wspolczynnika:
0.00 to 0.49 nie do przyjecia
0.50 to 0.59 bardzo slaby
0.60 to 0.69 slaby
0.70 to 0.79 umiarkowany
0.80 to 0.89 dobry
0.90 to 1.00 znakomity*/

//Przyklad 2 -- Indeks kapitalu spolecznego i problemy z analiza czynnikowa

//Probujemy stworzyc indeks kapitalu spolecznego
//dane oryginalnie pochodzily z badania World Values Survey

matrix A = (1.0000, 0.31739179, 0.11002722, 0.31164688, 0.06110877, -0.00022813, 0.41180246, 0.07689832, 0.13960322, 0.06722203, 0.01410569, 0.05747134, 0.02062867, 0.19227893, 0.1114667, 0.03607295, 0.02593826, 0.02983058, 0.04775258, 0.02137888, 0.07118085, 0.02198962, 0.04588386, 0.191334, -0.21307815, -0.17982977, 0.16588866 \/*

*/ 0.31739179, 1.0000, 0.19517276, 0.04409028, 0.0623629, 0.13276354, 0.17782995, 0.31676242, 0.2811831, 0.16893098, 0.21586415, 0.19237187, 0.09333146, -0.01319075, 0.0543534, 0.01221301, -0.01714704, 0.05064535, 0.09900424, 0.07060609, 0.01835593, 0.05231463, 0.04159056, -0.00080052, -0.02922383, -0.08758622, 0.07186106 \/*

*/ 0.11002722, 0.19517276, 1.0000, 0.13635237, 0.17741658, 0.14911485, 0.03734096, 0.07415458, 0.13861633, 0.10456037, 0.1594323, 0.09980834, 0.0977059, 0.0563215, 0.09678343, 0.12907204, 0.10427281, 0.17424485, 0.10622999, 0.15056103, 0.18454805, 0.29539929, 0.21873731, 0.08639763, -0.02906868, -0.01629374, 0.09532789 \/*

*/ 0.31164688, 0.04409028, 0.13635237, 1.0000, 0.08483249, -0.21174129, 0.02088888, -0.09901742, 0.02356156, -0.01393937, -0.09534762, -0.09997669, -0.04415461, 0.60587042, 0.15386647, 0.0728067, 0.06624166, 0.00866467, -0.03443302, 0.01740376, 0.1115529, 0.04238132, 0.05292426, 0.66811138, -0.40710701, -0.18165107, 0.22587637 \/*

*/ 0.06110877, 0.0623629, 0.17741658, 0.08483249, 1.0000, 0.29404637, -0.03111034, 0.11388071, 0.0472276, 0.20506714, 0.13993301, 0.14986353, 0.0782416, 0.11784633, 0.01563742, 0.04504187, 0.0518135, 0.11377808, 0.06749696, 0.09272906, 0.09851663, 0.13442715, 0.11904923, 0.16229163, 0.01391243, -0.08422538, 0.05554853 )

matrix B= (-0.00022813, 0.13276354, 0.14911485, -0.21174129, 0.29404637, 1.0000, -0.02202091, 0.14290026, -0.0047422, 0.19921615, 0.14933806, 0.2160554, -0.02569926, -0.17586558, -0.08671883, -0.09883195, -0.13012298, 0.02966823, -0.02116702, -0.04053482, -0.09262193, -0.02402641, -0.03291981, -0.1434506, 0.16282966, -0.00517287, -0.05738801 \ /*

*/ 0.41180246, 0.17782995, 0.03734096, 0.02088888, -0.03111034, -0.02202091, 1.0000, 0.34064823, 0.43987553, 0.16532024, 0.15550421, 0.17185, 0.10458264, 0.13891979, 0.15614084, 0.11262954, 0.12333654, 0.10273652, 0.20837276, 0.17418978, 0.16897692, 0.12320517, 0.15821254, 0.00619697, -0.15032754, -0.09251913, 0.14237545 \ /*

*/ 0.07689832, 0.31676242, 0.07415458, -0.09901742, 0.11388071, 0.14290026, 0.34064823, 1.0000, 0.50367768, 0.41509935, 0.46817218, 0.42937742, 0.14161668, 0.02150876, 0.10991982, 0.08584509, 0.06615303, 0.11183088, 0.21322103, 0.16900776, 0.11776728, 0.12877693, 0.1282982, -0.08304407, -0.00873166, -0.08567678, 0.06125296 \ /*

*/ 0.13960322, 0.2811831, 0.13861633, 0.02356156, 0.0472276, -0.0047422, 0.43987553, 0.50367768, 1.0000, 0.34498706, 0.45476024, 0.34363721, 0.16770165, 0.1299345, 0.19507393, 0.1953393, 0.17889996, 0.18995484, 0.26406852, 0.23090693, 0.21339022, 0.23983505, 0.23569044, 0.0472304, -0.10517329, -0.0550692, 0.17049646 \ /*

*/ 0.06722203, 0.16893098, 0.10456037, -0.01393937, 0.20506714, 0.19921615, 0.16532024, 0.41509935, 0.34498706, 1.000, 0.56918518, 0.7971579, 0.11198488, 0.07902589, 0.07019918, 0.08765337, 0.07866535, 0.12663877, 0.15437895, 0.12228476, 0.1166518, 0.1378997, 0.12952519, -0.02616944, 0.02790849, -0.05778227, 0.03417813 \ /*

*/ 0.01410569, 0.21586415, 0.1594323, -0.09534762, 0.13993301, 0.14933806, 0.15550421, 0.46817218, 0.45476024, 0.56918518, 1.0000, 0.60098425, 0.18581771, 0.02791355, 0.08888223, 0.1359204, 0.10585228, 0.15845017, 0.19982198, 0.16038966, 0.13422674, 0.22388492, 0.17812152, -0.0524409, 0.0368568, 0.0052973, 0.05365876 )

matrix C = (0.05747134, 0.19237187, 0.09980834, -0.09997669, 0.14986353, 0.2160554, 0.17185, 0.42937742, 0.343637210, 0.7971579, 0.60098425, 1.0000, 0.12372349, -0.00302586, 0.03948344, 0.05626547, 0.03400767, 0.11068467, 0.15099019, 0.1063067, 0.07869681, 0.13144292, 0.11550802, -0.09851647, 0.05154893, -0.06032914, 0.0144864 \ /*

*/ 0.02062867, 0.09333146, 0.0977059, -0.04415461, 0.0782416, -0.02569926, 0.10458264, 0.14161668, 0.16770165, 0.11198488, 0.18581771, 0.12372349, 1.0000, 0.06614901, 0.07446558, 0.10896485, 0.12504848, 0.13100746, 0.16271679, 0.15314248, 0.1637847, 0.1561061, 0.15821168, -0.00349425, 0.00691207, 0.02701731, 0.0319296 \ /*

*/ 0.19227893, -0.01319075, 0.0563215, 0.60587042, 0.11784633, -0.17586558, 0.13891979, 0.02150876, 0.1299345, 0.07902589, 0.02791355, -0.00302586, 0.06614901, 1.0000, 0.36443012, 0.26937697, 0.27929476, 0.18665449, 0.18076308, 0.20325639, 0.27920766, 0.22491089, 0.24178181, 0.49459446, -0.35610713, -0.14581533, 0.20528902 \ /*

*/ 0.1114667, 0.0543534, 0.09678343, 0.15386647, 0.01563742, -0.08671883, 0.15614084, 0.10991982, 0.19507393, 0.07019918, 0.08888223, 0.03948344, 0.07446558, 0.36443012, 1.0000, 0.41398567, 0.37630395, 0.36304356, 0.52678274, 0.46722784, 0.46371828, 0.36296024, 0.42481001, 0.10313587, -0.20726671, -0.12160599, 0.18724592 \ /*

*/ 0.03607295, 0.01221301, 0.12907204, 0.0728067, 0.04504187, -0.09883195, 0.11262954, 0.08584509, 0.1953393, 0.08765337, 0.1359204, 0.05626547, 0.10896485, 0.26937697, 0.41398567, 1.0000, 0.78031808, 0.49646868, 0.39107541, 0.41750994, 0.44663113, 0.44839537, 0.44627761, 0.09822368, -0.12291318, -0.04245316, 0.11698625 \ /*

*/ 0.02593826, -0.01714704, 0.10427281, 0.06624166, 0.0518135, -0.13012298, 0.12333654, 0.06615303, 0.17889996, 0.07866535, 0.10585228, 0.03400767, 0.12504848, 0.27929476, 0.37630395, 0.78031808, 1.0000, 0.51865376, 0.41380418, 0.42346358, 0.47353562, 0.44331569, 0.4660923, 0.07575813, -0.12543043, -0.0520017, 0.12348619 \ /*

*/ 0.02983058, 0.05064535, 0.17424485, 0.00866467, 0.11377808, 0.02966823, 0.10273652, 0.11183088, 0.18995484, 0.12663877, 0.15845017, 0.11068467, 0.13100746, 0.18665449, 0.36304356, 0.49646868, 0.51865376, 1.0000, 0.47398455, 0.47234783, 0.44400526, 0.48330026, 0.49560302, 0.03511286, -0.06230561, -0.06696606, 0.1258887 )

matrix D = (0.04775258, 0.09900424, 0.10622999, -0.03443302, 0.06749696, -0.02116702, 0.20837276, 0.21322103, 0.26406852, 0.15437895, 0.19982198, 0.15099019, 0.16271679, 0.18076308, 0.52678274, 0.39107541, 0.41380418, 0.47398455, 1.0000, 0.70992775, 0.5730234, 0.47538947, 0.54055756, -0.00452854, -0.08556468, -0.085866, 0.12211592 \/*

*/ 0.02137888, 0.07060609, 0.15056103, 0.01740376, 0.09272906, -0.04053482, 0.17418978, 0.16900776, 0.23090693, 0.12228476, 0.16038966, 0.1063067, 0.15314248, 0.20325639, 0.46722784, 0.41750994, 0.42346358, 0.47234783, 0.70992775, 1.0000, 0.65500172, 0.52503962, 0.6199908, 0.04196836, -0.08155945, -0.06950276, 0.13787638 \/*

*/ 0.07118085, 0.01835593, 0.18454805, 0.1115529, 0.09851663, -0.09262193, 0.16897692, 0.11776728, 0.21339022, 0.1166518, 0.13422674, 0.07869681, 0.1637847, 0.27920766, 0.46371828, 0.44663113, 0.47353562, 0.44400526, 0.5730234, 0.65500172, 1.0000, 0.65025697, 0.74778155, 0.11803891, -0.13313373, -0.08201786, 0.18328075 \/*

*/ 0.02198962, 0.05231463, 0.29539929, 0.04238132, 0.13442715, -0.02402641, 0.12320517, 0.12877693, 0.23983505, 0.1378997, 0.22388492, 0.13144292, 0.1561061, 0.22491089, 0.36296024, 0.44839537, 0.44331569, 0.48330026, 0.47538947, 0.52503962, 0.65025697, 1.0000, 0.7465203, 0.05439284, -0.07797349, -0.03034427, 0.13886094 \ /*

*/ 0.04588386, 0.04159056, 0.21873731, 0.05292426, 0.11904923, -0.03291981, 0.15821254, 0.1282982, 0.23569044, 0.12952519, 0.17812152, 0.11550802, 0.15821168, 0.24178181, 0.42481001, 0.44627761, 0.4660923, 0.49560302, 0.54055756, 0.6199908, 0.74778155, 0.7465203, 1.0000, 0.06018512, -0.10803738, -0.07399832, 0.1821088 \ /*

*/ 0.191334, -0.00080052, 0.08639763, 0.66811138, 0.16229163, -0.1434506, 0.00619697, -0.08304407, 0.0472304, -0.02616944, -0.0524409, -0.09851647, -0.00349425, 0.49459446, 0.10313587, 0.09822368, 0.07575813, 0.03511286, -0.00452854, 0.04196836, 0.11803891, 0.05439284, 0.06018512, 1.0000, -0.27086614, -0.11218958, 0.19750266 )

matrix E = (-0.21307815, -0.02922383, -0.02906868, -0.40710701, 0.01391243, 0.16282966, -0.15032754, -0.00873166, -0.10517329, 0.02790849, 0.0368568, 0.05154893, 0.00691207, -0.35610713, -0.20726671, -0.12291318, -0.12543043, -0.06230561, -0.08556468, -0.08155945, -0.13313373, -0.07797349, -0.10803738, -0.27086614, 1.0000, 0.35836373, -0.26383987 \ /*

*/ -0.17982977, -0.08758622, -0.01629374, -0.18165107, -0.08422538, -0.00517287, -0.09251913, -0.08567678, -0.0550692, -0.05778227, 0.0052973, -0.06032914, 0.02701731, -0.14581533, -0.12160599, -0.04245316, -0.0520017, -0.06696606, -0.085866, -0.06950276, -0.08201786, -0.03034427, -0.07399832, -0.11218958, 0.35836373, 1.0000, -0.19515787 \ /*

*/ 0.16588866, 0.07186106, 0.09532789, 0.22587637, 0.05554853, -0.05738801, 0.14237545, 0.06125296, 0.17049646, 0.03417813, 0.05365876, 0.0144864, 0.0319296, 0.20528902, 0.18724592, 0.11698625, 0.12348619, 0.1258887, 0.12211592, 0.13787638, 0.18328075, 0.13886094, 0.1821088, 0.19750266, -0.26383987, -0.19515787, 1.0000 )

matrix F = (A\B\C\D\E)

//METODA NAJWIEKSZEJ WIARYGODNOSCI

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(7) ml
//za malo

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(8) ml
//za malo

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(9) ml
//HEYWOOD CASE -- negative variance estimate

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(10) ml
//HEYWOOD CASE

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(11) ml
//HEYWOOD CASE

//METODA PCA w factor analysis

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(4) pcf
//za malo

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(5) pcf
//za malo

factormat F, n(35312) names(imp_family imp_friends imp_politics imp_church member_dis political_dis trust_family trust_ppers trust_neighbour trust_arel trust_firsttime trust_anation fair conf_church conf_forces conf_press conf_tv conf_labour conf_police conf_courts conf_govern conf_parties conf_parl religion_freq tradition help local) fac(27) pcf
//tez nie

//ANALIZA SKLADOWYCH GLOWNYCH -- PCA

//Przyklad 3 -- seul1988 -- wyniki dziesiecioboju mezczyzn rozgrywanego w czasie olimpiady w Seulu w 1988*/

/*sprawdzamy czy w zbiorze danych sa obserwacje nietypowe*/
graph box wynik, title("Wykres pudelkowy")

/*Istnieje jedna obserwacja nietypowa.*/

/*Przygotowujemy zbior danych do analizy -- usuwamy obserwacje nietypowa oraz  przemnazamy wyniki uzyskane w konkurencjach biegowych przez -1, tak aby najnizsza
wartosc oznaczala najgorszy wynik*/
drop if wynik < 6000
gen bieg100_1 = bieg100*(-1)
gen bieg400_1 = bieg400*(-1)
gen plotki_1 = plotki*(-1)
gen bieg1500_1 = bieg1500*(-1)

replace  bieg100= bieg100_1
replace  bieg400= bieg400_1
replace   bieg1500= bieg1500_1
replace  plotki= plotki_1
drop  bieg100_1 bieg400_1 plotki_1 bieg1500_1

/*Przeprowadzamy analize glownych skladowych. Domyslnie wykorzystywana jest macierz korelacji*/
corr bieg100-bieg1500
sum bieg100-bieg1500
pca bieg100-bieg1500

/*Tylko pierwsze dwie glowne skladowe maja wartosci wlasne wieksze od 1 (co jest rownoznaczne z wyjasniona wariancja wieksza niz srednia) i wyjasniaja ponad
60% calkowitej wariancji.*/

/*Interpretacja dwoch pierwszych skladowych:
pierwsza -- mierzy osiagniety wynik (wszystkie wspolczynniki dodatnie)
druga -- ma wysokie wartosci dla konkurencji zwiazanych z rzucaniem i sila (kula, dysk, oszczep) i
duze ujemne dla wytrzymalosciowych (biegi na 400 i 1500 metrow)*/

/*Okreslenie liczby skladowych glownych, ktore dobrze opisuja wariancje wyjsciowych zmiennych*/

/*Wykres osypiska*/
pca  bieg100 - bieg1500
screeplot, mean /*Wykres kolejnych wartosci wlasnych; "mean" - zostaje naniesiona prosta odpowiadajaca sredniej z wartosci wlasnych*/
screeplot, ci /*Dodatkowo zostaje nalozony przedzial ufnosci*/

/*Wykres wspólczynników dla poszczegolnych zmiennych - przydatne przy interpretacji skladowych glownych*/
pca  bieg100 - bieg1500
loadingplot /*Tylko dla dwóch pierwszych wektorów wlasnych*/

mvtest normality  bieg100-bieg1500, stats(all)
pca bieg100-bieg1500, cov vce(normal)
testparm bieg100-bieg1500, equal eq(Comp1)

/*niestety, nie jest spelnione zalozenie o wielowymiarowym rozkladzie normalnym*/

/*Dalej analizujemy tylko dwie pierwsze glowne skladowe. */

predict comp1-comp2

gen obs=_n
scatter comp2 comp1, mlabel(obs)

scatter wynik comp1
/*Potwierdzenie, iz pierwsza glowna skladowa mierzy ogolny wynik*/

scatter wynik comp2

/*Jeszcze wyznaczmy macierz korelacji*/
pwcorr bieg100-bieg1500 wynik comp2 comp1
sum bieg100-bieg1500 wynik comp2 comp1

/*Zapiszmy zbior danych, zeby porownac, jaki wplyw na uzyskane wyniki ma wlaczenie obserwacji nietypowej*/

gen bieg100_1 = bieg100*(-1)
gen bieg400_1 = bieg400*(-1)
gen plotki_1 = plotki*(-1)
gen bieg1500_1 = bieg1500*(-1)

replace  bieg100= bieg100_1
replace  bieg400= bieg400_1
replace   bieg1500= bieg1500_1
replace  plotki= plotki_1
drop  bieg100_1 bieg400_1 plotki_1 bieg1500_1

pca bieg100-bieg1500

/*Dwie pierwsze skladowe wyjasniaja ponad 70% wariancji; interpretacja pierwszej glownej
skladowej sie nie zmienia; w przypadku drugiej znaki zostaja zmienione na przeciwne*/

predict comp1-comp2
gen obs=_n
scatter comp2 comp1, mlabel(obs)

/*Na plaszczyznie 2 pierwszych skladowych glownych wyraznie widac, ze obserwacja o
numerze 34 jest outlierem.*/

//Wrocmy do poprzednich danych

//DIAGNOSTYKA PCA

/*Aby sprawdzic, czy wystarczajaco dobrze odtworzylismy zmiennosc wykorzystamy "reszty" -
roznice pomiedzy zaobserwowanymi korelacjami a tymi odtworzonymi za pomoca tylko kilku pierwszych skladowych*/

pca  bieg100 - bieg1500, components(3) /*Rozwiazanie skladajace sie z 3 pierwszych skladowych glownych*/
estat residual, fit /*Macierz "resztowa" oraz macierz korelacji odtworzona za pomoca 3 pierwszych skladowych*/
corr bieg100 - bieg1500

/*Sprawdzenie, czy zmienne wejsciowe sa ze soba skorelowane.
Czyli sprawdzamy czy ma sens w ogole przeprwowadzenie analizy skladowych glownych*/

/*1. Pierwszy sposob to analiza R^2*/
estat smc
reg  bieg100 skok_w_dal - bieg1500  /*sprawdzenie, skad sie biora te wartosci*/

//WNIOSEK: "Skok wzwyz" wykazuje najmniejsza zaleznosc z pozostalymi konkurencjami

/*2. Drugi sposób:  "anti-image correlation" (minus korelacja czastkowa).*/

/*Korelacja czastkowa pokazuje "czysta" zaleznosc miedzy dwoma zmiennymi, traktujac pozostale jako stale.
Dazymy do uzyskania malej korelacji czastkowej!
Jesli wiele tych korelacji jest relatywnie duzych, to zaleznosc pomiedzy niektorymi zmiennymi nie zalezy od poziomu pozostalych zmiennych.
Tym samym moze byc trudno uzyskac wlasciwe rozwiazanie malego wymiaru. */

pca  bieg100 - bieg1500
estat anti, nocov /*"anti-image correlation" (minus korelacja czastkowa)*/
pcorr  bieg100  skok_w_dal - bieg1500 /*Korelacje czastkowe zmiennej bieg100 z pozostalymi*/

/*3. Trzeci sposób: statystyka adekwatnosci proby Kaiser-Meyer-Olkin.*/
estat kmo

/*Bez  zmiennej "skok_wzwyz"*/
pca bieg100 - kula bieg400 - bieg1500
estat kmo /*Wielkosc statystyki ulegla nieznacznej poprawie*/

/*Wykres wspolczynnikow dla poszczegolnych zmiennych -- przydatne przy interpretacji skladowych glownych*/
pca  bieg100 - bieg1500
loadingplot, comp(3) combined /*3 pierwsze skladowe glowne*/

pca bieg100 - kula bieg400 - bieg1500
loadingplot, comp(3) combined /*bez "skoku wzwyz"*/

//Przyklad 4 -- Objawy depresji (Dane z Diagnoza Spoleczna 2011)

//1. Wczytaj zbior danych "depresja.dta"

//2. Przeprowadz analize glownych skladowych w oparciu o macierz korelacji.

//3. Utworz wykres osypiska z nalozonym przedzialem ufnosci Ile powinismy wyroznic glownych skladowych?

//4. Przeprowadz jeszcze raz analize, ale tylko dla ustalonej w punkcie 3 liczby glownych skladowych. Zapisz glowne skladowe oraz wyjsciowe zmienne w pliku.

//5. Zinterpretuj glowne skladowe. Interpretacje poprzyj macierza korelacji.

//6. Sprawdz, czy zmienne wejsciowe sa ze soba skorelowane (zweryfikuj, czy ma sens w ogole przeprwowadzenie analizy skladowych glownych).
//    Uzyj: R^2, "anti-image correlation" oraz statystyki adekwatnosci Kaisera-Meyera-Olkina.
