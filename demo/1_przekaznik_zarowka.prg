program E1003-001 #nazwa

var                                      # definicje elementów
  # OBWÓD 1
  1 przycisk   1   : 1,2                 # nr_elementu nazwa ilość_sekcji:nr_pinów
  2 przekaźnik 1,2 : 1,2, 3,4,5, 6,7,8   # nr_elementu nazwa
  3 żarówka    1   : 1,2
  # OBWÓD 2
  4 przycisk   1   : 1,2
  5 przekaźnik 1,2 : 1,2, 3,4,5, 6,7,8
  6 żarówka    1   : 1,2

const # lista elementów, które mają być wyświetlona na formie
  1,10,10   # przycisk - by można było wpływać na symulację; X,Y - w którym miejscu na formie umieścić przycisk
  3,50,10   # żarówka - by można było obserwować aktualny stan symulacji
  4,10,100
  6,50,100

begin
  # linia nr 0 zawsze jest zasilająca (+)!
  # PIN 0 zawsze jest masą (-)!
  # nazwa | nr_linii | nr_pinu_na_który_się_wpinamy
  # SEKCJE ZAWSZE ODDZIELANE SĄ PUSTĄ LINIĄ

  # SEKCJA ZASILANIA CEWKI - PRZYCISK WŁĄCZA ZASILANIE
  0,f, 1,1     # 0 - urządzenie specjalne, f - faza (plus/minus), 1 - przycisk, 1 - pierwszy pin tego przycisku
  1,2, 2,1     # 1 - przycisk, 2 - drugi pin tego przycisku, 2 - przekaźnik, 1 - cewka
  2,2, 0,m     # 2 - przekaźnik, 2 - cewka, 0 - urządzenie specjalne, m - masa (minus/plus)

  # SEKCJA ZASILANIA ŻARÓWKI - WŁĄCZANY JEDNĄ Z SEKCJI PRZEKAŹNIKA
  0,f, 2,4
  2,5, 3,1
  3,2, 0,m

  # OBWÓD 2 (DWA ZDARZENIA W JEDNEJ SEKCJI - BRAK LINII PUSTEJ)
  0,f, 4,1
  4,2, 5,1
  5,2, 0,m     # poszło do masy, ale to nie koniec sekcji, teraz kolej na modyfikację!
  0,f, 5,4
  5,5, 4,1
end
