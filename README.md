# symulator_wind
Projekt symulacji wind starszego typu (opartych na stycznikach i przekaźnikach)


Cel projektu:

Stworzyć program symulujący pracę wind, który będzie dokładnie odwzorowywał:

1. Pracę takich wind.
2. Udźwiękowienie i video pracy takich jej elementów jak silnik, lampki, przyciski, przekaźniki itp.
3. Pokaz na schemacie ideowym pracę wszystkich jej elementów.


Kroki budowy:

1. Zacząłem od stworzenia pliku konfiguracyjnego.

Program po uruchomieniu to czysta w zasadzie forma w której należy załadować plik konfiguracji,
w zasadzie plik projektu danej windy/wind, czyli cały schemat układowy pracy. Przykład takiego projektu
możesz zobaczyć w katalogu DEMO. Składa się z trzech w zasadzie sekcji:
 - sekcja elementów
 - sekcja zdarzeń wizualno-dźwiękowych (czyli to co widać i słychać)
 - sekcja logiki układu (czyli schemat logiczny połączęń)


Założenia:

Na początku widziałem to jako grupę obiektów, ew. wątków, które mają symulować dokładnie pracę każdego
elementu z osobna. Właściwie będą to obiekty. Zacząłem od najprostszego przycisku, przekaźnika i żarówki.
To co chcę osiągnąć, to zobaczyć na ekranie prawidłową pracę prostych dwóch układów sumy tych trzech elementów:

1. Cewka przekaźnika załącza żarówkę, przycisk załącza zasilanie cewki.

(+) -------- 1 Włącznik 2 ---------------------- 1 Cewka przekażnika 2 ------------- (-)

(+) -------- 4 Zestyk przekaźnika 5 ------------ 1 Żarówka 2 ----------------------- (-)

2. Cewka przekaźnika mostkuje przycisk włącznika, przez co przekaźnik pracuje jako włącznik bistabilny.

(+) -------- 1 Włącznik 2 ---------------------- 1 Cewka przekażnika 2 ------------- (-)

(+) -------- 4 Zestyk przekaźnika 5 ------------ 1 Cewka przekaźnika 2 ------------- (-)

(+) -------- 7 Zestyk przekaźnika 8 ------------ 1 Żarówka 2 ----------------------- (-)     #(zostanie ujęte)

To co powyżej to projekt dostępny w katalogu DEMO. Dopiero teraz zwróciłem uwagę, że przy drugim obwodzie
pominąłem przez nieuwagę linii z żarówką - dołożę ją przy najbliższej okazji.


Co jest?

1. Zacząłem od stworzenia pierwszych obiektów, tj. przycisku, przekaźnika i żarówki. W tym zwizualizowany został
   tylko przycisk, bo posłuzył mi do zaprojektowania kodu obsługującego cały algorytm obsługujący powyższe.
2. Powstał cały system ładowania i wyładowywania projektów, w tym wszystkich obiektów użytych w projekcie.


Odkrycia:

1. Właśnie przyszła mi odpowiedź w jaki sposób będę chciał aby wszystko pracowało. Wstępnie myślałem o pracy wątku,
   lub kilku, które będą na żądanie i w czasie odpalać żądane części kodu by symulować pracę windy.
   Teraz odkryłem, że nie ma potrzeby pisania jakich kolwiek wątków, przecież każdy element może odpalać kolejne, np.

   Dodaję element zasilania, które domyślnie zawsze będzie wstawiane i będzie miało Nr elementu = 0 i dwa piny: 1 i 2.
   I teraz ustalam trzy stany napięciowe na poszczególnych pinach/obwodach:    +..0..-
   Domyślnie wszystko będzie zaczynało się od stanu 0.
   Gdy stan na jakimś pinie elementu zmieni się, odpala zdarzenie, które podaje je w obwodzie dalej.
   Po włączeniu zasilania głównego na końcówkach zasilania 1,2 pojawią się stany + i -, reszta zadziała z automatu!
   Aby jakaś cewka została zasilona, żarówka się zaświeciła itp. - na obu jej końcówkach muszą się pojawić dwa przeciwne
   stany (+ i -). Jeśli tak nie będzie, dany element nie będzie zasilony - w ten sposób sobie obmyśliłem logiczną pracę
   pomiędzy elementami obwodu i w teorii to zamknie temat pracy, a w praktyce się okaże.

2. W niedalekiej przyszłości, to jak już będą działały pierwsze proste układy, dodać sekcję USES w plikach projektów.
   I za jej pomocą dodawać predefiniowane w programie części kodów odpowiedzialne za różne rzeczy globalnie, np.
   by na ekranie były pokazane linie łączące wszystkie elementy ze sobą, by także świeciły się te z nich, które są zasilone.
   To wyjdzie mi samo w trakcie pisania i będę traktował to jako bajer raczej niż coś do czego podążam.


Ogólny plan budowy symulatora:

1. Na początku chcę stworzyć szkieletową, logiczną część programu, na razie bez dźwięków, bez złożonych detali wizualnych,
   tu przycisk to zwykły TButton, żarówka to zwykła kontrolka ledowa itd. Sama logika działania układu. A jak to zacznie działać
   wtedy wezmę się za pisanie bardziej złożonych detali wizualnych by przycisk był przyciskiem, pewnie wiele róznych jego wersji,
   podobnie z innymi elementami, przekaźniki to będą przekaźniki, czyli zeskanowane bitmapy tych elementów, animacja pracy,
   udźwiękowienie itd.


To na razie tyle... Będę tu dopisywał to, co przyjdzie mi do głowy...
