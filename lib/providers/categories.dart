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
    }
  };
}
