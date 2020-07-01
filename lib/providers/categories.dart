class Categories {
  final workData = {
    "Elektryk": {
      "Instalacje elektryczne": {
        "Jaka usługa Cię interesuje?": {
          "multi": true,
          "options": [
            "naprawa instalacji elektrycznej",
            "montaż instalacji elektrycznej",
            "przegląd / pomiar instalacji elektrycznej",
            "zaprojektowanie instalacji elektrycznej",
          ],
        },
        "Gdzie usługa ma być wykonana?": {
          "multi": false,
          "options": [
            "dom",
            "mieszkanie",
            "lokal użytkowy / usługowy",
            "kamienica",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Ilu pomieszczeń dotyczy usługa?": {
          "multi": false,
          "options": [
            "1",
            "2",
            "3",
            "4 i więcej",
          ],
        },
      },
      "Pogotowie elektryczne": {
        "Co się dzieje?": {
          "multi": true,
          "options": [
            "awaria urządzenia / sprzętu domowego",
            "gniazdko / włącznik jest uszkodzone",
            "nie ma prądu w gniazdku",
            "wybija bezpieczniki / korki",
            "inne - opiszę w ostatnim kroku",
          ],
        },
      },
      "Pomiary elektryczne": {
        "Jaka usługa Cię interesuje?": {
          "multi": true,
          "options": [
            "pomiar okresowy instalacji elektrycznej",
            "przegląd techniczny instalacji elektrycznej",
          ],
        },
        "Gdzie usługa ma być wykonana?": {
          "multi": false,
          "options": [
            "dom",
            "mieszkanie",
            "lokal użytkowy / usługowy",
            "kamienica",
          ],
        },
      },
      "Podłączanie sprzętu AGD": {
        "Jaki sprzęt chcesz podłączyć?": {
          "multi": true,
          "options": [
            "lodówkę",
            "płytę indukcyjną / ceramiczną",
            "piekarnik elektryczny",
            "pralkę / zmywarkę",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Jaki rodzaj sprzętu chcesz podłączyć?": {
          "multi": false,
          "options": [
            "pod zabudowę",
            "wolnostojący",
          ],
        },
      },
      "Audyt energetyczny": {
        "Jakiej nieruchomości dotyczy usługa?": {
          "multi": false,
          "options": [
            "dom",
            "mieszkanie",
            "lokal użytkowy / usługowy",
            "kamienica",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Jaka jest kubatura (pojemność) nieruchomości?": {
          "multi": false,
          "options": [
            "mniej niż 250 m³",
            "250 - 500 m³",
            "powyżej 500 m³",
            "nie wiem, potrzebuję pomocy wykonawcy",
          ],
        },
      },
      "Montaż instalacji odgromowej": {
        "Jaki rodzaj budynku chcesz zabezpieczyć?": {
          "multi": false,
          "options": [
            "dom",
            "budynek przemysłowy",
            "budynek użytkowy",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Jaki dach ma budynek?": {
          "multi": false,
          "options": [
            "czterospadowy",
            "dwuspadowy",
            "nieregularny",
            "płaski",
            "inny - ustalę szczegóły z wykonawcą",
          ],
        },
        "Ile metrów wysokości ma budynek, który chcesz zabezpieczyć?": {
          "multi": false,
          "options": [
            "mniej niż 30 m",
            "więcej niż 30 m",
          ],
        },
      },
      "Pozostałe usługi elektryczne": {
        "Jaka usługa Cię interesuje?": {
          "multi": true,
          "options": [
            "montaż bramy elektrycznej",
            "montaż domofonu / monitoringu",
            "montaż oświetlenia",
            "montaż / wymiana włącznika / gniazdka",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Gdzie usługa ma być wykonana?": {
          "multi": false,
          "options": [
            "dom",
            "kamienica",
            "lokal użytkowy / usługowy",
            "mieszkanie",
            "inne - opiszę w ostatnim kroku",
          ],
        },
      },
    },
    "Hydraulik": {
      "Instalacje wodne": {
        "Jakiej usługi potrzebujesz?": {
          "multi": true,
          "options": [
            "montaż",
            "naprawa",
            "przegląd",
            "wymiana",
          ],
        },
        "Czego dotyczy usługa?": {
          "multi": false,
          "options": [
            "całej instalacji",
            "armatury wodnej (sanitarnej)",
            "rur",
            "wodomierzy",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Ilu pomieszczeń dotyczy usługa?": {
          "multi": false,
          "options": [
            "1",
            "2",
            "3",
            "4 i więcej",
          ],
        },
      },
      "Montaż kabiny prysznicowej": {
        "Jakiego rodzaju kabinę chcesz zamontować?": {
          "multi": false,
          "options": [
            "zwykła (natryskowa)",
            "wielofunkcyjna (np. z hydromasażem)",
          ],
        },
      },
      "Pogotowie hydrauliczne": {
        "Co się dzieje?": {
          "multi": true,
          "options": [
            "uszkodzony kran / bateria",
            "pęknięty zlew / wanna / WC",
            "pęknięta / zapchana rura",
            "zepsuta spłuczka",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Gdzie usługa ma być wykonana?": {
          "multi": false,
          "options": [
            "dom",
            "mieszkanie",
            "lokal użytkowy / usługowy",
            "kamienica",
          ],
        },
      },
      "Biały montaż": {
        "Jaki sprzęt chcesz zamontować?": {
          "multi": true,
          "options": [
            "brodzik / kabina prysznicowa",
            "umywalka / zlew",
            "wanna",
            "WC",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Jakie dodatkowe usługi Cię interesują?": {
          "multi": false,
          "options": [
            "nie potrzebuję dodatkowych usług",
            "montaż baterii",
            "układanie płytek ceramicznych",
            "inne - opiszę w ostatnim kroku"
          ],
        },
      },
    },
    "Ogród": {
      "Układanie kostki": {
        "Gdzie chcesz położyć kostkę?": {
          "multi": true,
          "options": [
            "chodnik",
            "podjazd",
            "altana",
            "parking",
            "opaska wokół domu",
            "inne - ustalę szczegóły z wykonawcą",
          ],
        },
        "Ile m² kostki chcesz ułożyć?": {
          "multi": false,
          "options": [
            "do 10 m²",
            "10 - 50 m²",
            "51 - 100 m²",
            "101 - 150 m²",
            "powyżej 150 m²",
            "ilość",
          ],
        },
        "Czy zapewniasz materiały?": {
          "multi": false,
          "options": [
            "Tak, zapewniam",
            "Nie, zapewniam",
          ],
        },
      },
      "Przycinanie drzew": {
        "Jaki typ drzewa chcesz przyciąć?": {
          "multi": true,
          "options": [
            "iglaste",
            "liściaste",
          ],
        },
        "ile drzew chcesz przyciąć? ": {
          "multi": false,
          "options": [
            "1",
            "2-4",
            "4-10",
            "Inna ilość",
          ],
        },
      },
      "Koszenie trawy": {
        "Obszar koszenia?": {
          "multi": false,
          "options": [
            "mniej niż 10 m²",
            "10 - 50 m²",
            "51 - 100 m²",
            "powyżej 150 m²",
          ],
        },
        "Jaki sprzęt do koszenia posiadasz?": {
          "multi": true,
          "options": [
            "nie zapewniam sprzętu",
            "kosiarka spalinowa",
            "kosiarka elektryczna",
            "podkaszarka",
            "inny - opiszę w ostatnim kroku",
          ],
        },
      },
    },
    "Montaż i naprawa": {
      "Montaż i naprawa okien": {
        "Co chcesz zrobić?": {
          "multi": true,
          "options": [
            "Montaż drzwi wewnętrznych",
            "Montaż drzwi zewnętrznych",
            "Naprawa okien",
            "Regulacja drzwi",
            "Regulacja okien",
            "Uszczelnianie okien",
            "Wymiana okien",
          ],
        },
        "Jakiego rodzaju okien/drzwi dotyczy usługa": {
          "multi": true,
          "options": [
            "ścienne (zwykłe okno)",
            "balkonowe",
            "dachowe",
            "przesuwne",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Z jakiego materiału są wykonane okna?": {
          "multi": false,
          "options": [
            "aluminium",
            "drewno",
            "PCV",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Ilość okien ulegającym naprawie": {
          "multi": false,
          "options": ["1", "1-3", "3-5", "więcej()"],
        },
      },
      "Naprawa sprzętu AGD": {
        "Jaki sprzęt chcesz naprawić ?": {
          "multi": true,
          "options": [
            "lodówkę",
            "piekarnik elektryczny",
            "płytę indukcyjną / ceramiczną",
            "pralkę / zmywarkę",
            "inne – pole własne ",
          ],
        },
        "Jakie są problemy ze sprzętem?": {
          "multi": true,
          "options": [
            "hałasuje",
            "nie włącza się",
            "przegrzewa się",
            "wolniej pracuje",
            "inne - opiszę w ostatnim kroku",
          ],
        },
      },
      "Podłączanie sprzętu AGD": {
        "Jaki sprzęt chcesz podłączyć?": {
          "multi": true,
          "options": [
            "lodówkę",
            "piekarnik elektryczny",
            "płytę indukcyjną / ceramiczną",
            "Regulacja drzwi",
            "pralkę / zmywarkę",
            "inne – pole własne",
          ],
        },
        "Typ sprzętu": {
          "multi": false,
          "options": [
            "wolnostojący",
            "pod zabudowę ",
          ],
        },
      },
    },
    "Sprzątanie": {
      "Mycie okien": {
        "Gdzie chcesz umyć okna?": {
          "multi": true,
          "options": [
            "dom jednorodzinny",
            "dom wielorodzinny",
            "mieszkanie",
            "lokal użytkowy / usługowy",
            "kamienica",
            "inne - opiszę w ostatnim kroku"
          ],
        },
        "Jakie okna chcesz umyć": {
          "multi": true,
          "options": [
            "zwykłe okna",
            "okna balkonowe",
            "okna dachowe",
            "witryny",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "Ile okien chcesz umyć?": {
          "multi": false,
          "options": [
            "1",
            "1-3",
            "3-5",
            "więcej()",
          ],
        },
      },
      "Sprzątanie mieszkań": {
        "Jaka jest powierzchnia mieszkania?": {
          "multi": true,
          "options": [
            "mniej niż 30 m²",
            "30 - 50 m²",
            "51 - 70 m²",
            "71 - 90 m²",
            "powyżej 90 m²",
            "inne - opiszę w ostatnim kroku"
          ],
        },
        "jakie pomieszczenia są do posprzątania": {
          "multi": false,
          "options": [
            "pokój",
            "łazienka",
            "kuchnia",
            "piwnica / komórka lokatorska",
            "inne - opiszę w ostatnim kroku",
          ],
        },
      },
      "Dezynfekcja": {
        "Jakiej nieruchomości dotyczy usługa": {
          "multi": true,
          "options": [
            "dom",
            "mieszkanie",
            "mieszkanie",
            "lokal użytkowy / usługowy",
            "kamienica",
            "inne - opiszę w ostatnim kroku"
          ],
        },
        "Jakiej usługi poszukujesz?": {
          "multi": true,
          "options": [
            "odkomarzanie",
            "zwalczanie karaluchów",
            "zwalczanie much",
            "zwalczanie os / szerszeni",
            "zwalczanie pluskiew / obrzeżków / kleszczy",
            "inne - opiszę w ostatnim kroku",
          ],
        },
        "jaka powierzchnia wymaga dezynsekcji": {
          "multi": false,
          "options": [
            "mniej niż 30 m²",
            "30 - 50 m²",
            "51 - 70 m²",
            "71 - 90 m²",
            "więcej",
          ],
        },
      },
    }
  };
}
