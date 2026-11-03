// Prezentacja na podstawie Research Model Canvas (RMC.pdf)
// Renderowanie: typst compile prezentacja.typ

#let title = [Adaptacyjne sterowanie sygnalizacją świetlną]
#let subtitle = [Research Model Canvas]

#let accent = rgb("#1f5f8b")
#let accent-light = rgb("#e8f1f8")
#let muted = rgb("#5b6770")

#set document(title: "Adaptacyjne sterowanie sygnalizacją świetlną")
#set text(lang: "pl", font: ("Noto Sans", "DejaVu Sans"), size: 20pt, fill: rgb("#1b1f23"))
#set par(leading: 0.6em)
#set list(indent: 0.4em, spacing: 1em, marker: text(fill: accent)[●])
#set enum(indent: 0.4em, spacing: 0.75em)
#show strong: set text(fill: accent)

#set page(
  paper: "presentation-16-9",
  margin: (x: 1.6cm, top: 2.6cm, bottom: 1.4cm),
  header: none,
  footer: context {
    set text(size: 11pt, fill: muted)
    if counter(page).get().first() > 1 [
      #title
      #h(1fr)
      #counter(page).display() / #counter(page).final().first()
    ]
  },
)

// Slajd z tytułem w pasku u góry. `num` to numer pola na kanwie RMC.
#let slide(heading, num: none, body) = {
  pagebreak(weak: true)
  place(top + left, dx: -1.6cm, dy: -2.6cm, block(
    width: 100% + 3.2cm,
    height: 1.9cm,
    fill: accent,
    inset: (x: 1.6cm),
    align(horizon, {
      set text(fill: white, size: 26pt, weight: "bold")
      heading
      if num != none {
        h(1fr)
        text(size: 14pt, weight: "regular", fill: white.transparentize(30%))[pole RMC (#num)]
      }
    }),
  ))
  body
}

// Wyróżniona ramka
#let callout(body) = block(
  width: 100%,
  fill: accent-light,
  stroke: (left: 4pt + accent),
  inset: (x: 16pt, y: 14pt),
  radius: (right: 4pt),
  body,
)

// Kafelek z nagłówkiem
#let card(heading, body, height: auto) = block(
  width: 100%,
  height: height,
  fill: accent-light,
  inset: 14pt,
  radius: 6pt,
  {
    text(weight: "bold", fill: accent)[#heading]
    v(0.3em)
    set text(size: 19pt)
    body
  },
)

// ---------------------------------------------------------------------------
// Slajd tytułowy
// ---------------------------------------------------------------------------
#page(margin: 0pt, footer: none, {
  block(width: 100%, height: 100%, fill: accent, inset: 2.4cm, {
    set text(fill: white)
    v(1fr)
    text(size: 16pt, fill: white.transparentize(25%), upper(subtitle))
    v(0.4em)
    text(size: 40pt, weight: "bold", title)
    v(0.6em)
    line(length: 6cm, stroke: 2pt + white)
    v(0.6em)
    text(size: 20pt)[Transfer metod MARL z siatek regularnych na realną sieć Wrocławia]
    v(1fr)
    text(size: 18pt, weight: "bold")[Dominik Czech, Michał Jankowski, Mateusz Wechman]
  })
})

// ---------------------------------------------------------------------------
#slide([Problem badawczy i kontekst], num: 1)[
  - *Problem:* literatura o adaptacyjnym sterowaniu sygnalizacją opiera się głównie na symulacjach syntetycznych, regularnych siatkach.
  - *Czego dziś nie da się zrobić:* brak otwartego, skalibrowanego środowiska symulacyjnego Wrocławia.
  - *Dowody problemu:* według przeglądu SOTA brak produkcyjnych wdrożeń RL w sterowaniu sygnalizacją.
]

#slide([Pytanie badawcze], num: 1)[
  #v(1fr)
  #callout[
    #set text(size: 24pt)
    Czy założenia topologiczne metod MARL zaprojektowanych dla siatek regularnych
    przenoszą się na *nieregularną sieć Wrocławia* i jakim *kosztem interpretowalności*
    osiąga się koordynację sieciową?
  ]
  #v(0.5em)
  #align(right, text(size: 15pt, fill: muted)[(sformułowanie robocze)])
  #v(1fr)
]

#slide([Rozwiązanie], num: 4)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
    [
      *Cele*
      + Zbudować skalibrowane środowisko symulacyjne sieci Wrocławia.
      + Zbadać MARL z informacją topologiczną i komunikacją między skrzyżowaniami na tle baseline'ów.
      + Ocenić interpretowalność i audytowalność wyników.
    ],
    [
      *Odpowiedź na problem*

      Eksperyment transferu metod z siatek regularnych na realną sieć z priorytetem tramwajowym.

      #v(0.4em)
      *Nowość*
      - falsyfikowalna teza o transferze,
      - połączenie koordynacji sieciowej i interpretowalności,
      - uczciwe baseline'y.
    ],
  )
]

#slide([Cele i metody], num: 5)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.8cm,
    row-gutter: 0.9cm,
    align: (center + horizon, horizon),
    text(size: 30pt, weight: "bold", fill: accent)[O1],
    [Zakończyć przegląd SOTA, zdefiniować zakres i sformułowanie problemu \
      #text(size: 16pt, fill: muted)[koniec fazy 1: grudzień 2026]],
    text(size: 30pt, weight: "bold", fill: accent)[O2],
    [Skalibrowana sieć SUMO z popytem z MATSim, zwalidowana względem danych GPS i natężeń],
    text(size: 30pt, weight: "bold", fill: accent)[O3],
    [Porównanie co najmniej jednego podejścia MARL z baseline'ami na wspólnym scenariuszu i metrykach],
  )
  #v(1fr)
  #callout[
    *Metody:* SUMO, MATSim; metody nie-RL jako porównanie (fuzzy, GPLight, agenci LLM).
  ]
]

#slide([Unikalna wartość i przewaga konkurencyjna], num: [13, 9])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8cm,
    card[Unikalna wartość proponowanych badań][
      - Pierwsze otwarte, skalibrowane środowisko symulacyjne Wrocławia.
      - Falsyfikowalny test, czy metody MARL z regularnych siatek działają na realnej, nieregularnej sieci z priorytetem tramwajowym, wraz z oceną kosztu interpretowalności.
    ],
    card[Przewaga konkurencyjna][
      - *Uczciwe baseline'y:* sterownik adaptacyjny w stylu GERTRUDE, nie tylko fixed-time.
      - *Dostęp do lokalnego kontekstu:* kontakt z ZDiUM i znajomość charakterystyki miasta.
    ],
  )
]

#slide([Użytkownicy i beneficjenci], num: 2)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.6cm,
    card[Bezpośredni][
      Społeczność badawcza TSC/ITS.
    ],
    card[Potencjalni][
      ZDiUM Wrocław (zarządca sieci i systemu GERTRUDE), dostawcy ITS, miasta europejskie i planiści transportu.
    ],
    card[Pośredni][
      Kierowcy, pasażerowie komunikacji miejskiej, piesi -- jeśli system zostanie wdrożony.
    ],
  )
  #v(0.6em)
  #callout[
    *Popyt i feedback:* popyt po stronie operatorów nie jest jeszcze zweryfikowany.
  ]
]

#slide([Współpracownicy, partnerzy i zasoby], num: 8)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.6cm,
    card[Współpracownicy][
      - promotor,
      - koło naukowe,
      - ZDiUM,
      - kontakty w Europie -- jako konsultanci, nie partnerzy.
    ],
    card[Dane][
      - KBR 2018 i 2024,
      - mobilne dane OD,
      - prędkości GPS,
      - OSM,
      - natężenia ZDiUM.
    ],
    card[Sprzęt][
      Moc obliczeniowa GPU do treningu MARL.
    ],
  )
]

#slide([Wyniki badań], num: 6)[
  - *Publikacja naukowa* -- czasopismo czy konferencja: otwarte.
  - *Kod:* pipeline MATSim → SUMO, raporty z badań MARL.
  - *Skalibrowany scenariusz SUMO dla Wrocławia* (w zakresie dozwolonym licencjami danych).
  - *Udostępnianie i archiwizacja:* GitHub;
]

#slide([Działania na rzecz rezultatów], num: 7)[
  - *Świadomość:* prezentacje (AI Forum 2026), kontakt z ZDiUM.
  - *Uptake:* udokumentowana i otwarta struktura repozytorium i pipeline'u, żeby inne zespoły mogły odtworzyć środowisko.
  - *Dowody wpływu:* cytowania, odpowiedzi i rozmowy z kontaktami, użycie repozytorium.
]

#slide([Wyniki i wpływ], num: 3)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8cm,
    card[Krótkoterminowe][
      - Publikacja naukowa.
      - Skalibrowane środowisko symulacyjne i pipeline MATSim → SUMO.
    ],
    card[Długoterminowe][
      - Baza do współpracy z ZDiUM i partnerami europejskimi.
      - Narzędzie do oceny polityk sterowania w symulacji przed jakimkolwiek wdrożeniem.
    ],
  )
  #v(0.6em)
  #set text(size: 17pt)
  - *Rodzaje wpływu:* akademicki, technologiczny, edukacyjny (główne); społeczny/środowiskowy tylko pośrednio i niezweryfikowany.
  - *Co użytkownicy zrobią inaczej:* ocenią metody sterowania na wiarygodnym modelu własnej sieci, z jawnie opisanymi ograniczeniami.
]

#slide([Ryzyka i łagodzenie], num: 12)[
  #set text(size: 17pt)
  #table(
    columns: (0.6fr, 1.2fr, 1.4fr),
    inset: 10pt,
    stroke: none,
    fill: (_, y) => if y == 0 { accent } else if calc.even(y) { accent-light },
    table.header(
      text(fill: white, weight: "bold")[Ryzyko],
      text(fill: white, weight: "bold")[Opis],
      text(fill: white, weight: "bold")[Łagodzenie],
    ),
    [*Kalibracja*],
    [Sieć SUMO nie zejdzie do akceptowalnego błędu względem GPS i natężeń (O2).],
    [Wcześniej ustalić kryteria walidacji (np. GEH, błąd prędkości) i zawęzić scenariusz do korytarza lub podsieci.],
    [*Czas i zakres*],
    [Projekt jest ambitny przy zasobach koła naukowego.],
    [Podział na etapy z minimum.],
    [*Współpraca*],
    [ZDiUM może nie odpowiedzieć lub nie udostępnić danych.],
    [Projekt opiera się na danych otwartych (OSM, KBR). Dane ZDiUM są wartością dodaną, nie warunkiem koniecznym.],
  )
]

#slide([Etyka i odpowiedzialne badania (RRI)], num: 4)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8cm,
    card[Etyka][
      - Dane mobilne OD i ankiety KBR -- agregacja, zgodność z RODO.
      - Brak ingerencji w realny ruch -- wyłącznie symulacja.
    ],
    card[RRI][
      - Audytowalność.
      - Otwartość tam, gdzie licencje pozwalają.
      - Brak obietnic wdrożeniowych.
    ],
  )
]

#slide([Koszty i finansowanie], num: [10, 11])[
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8cm,
    card[Wydatki na badania][
      - GPU do treningu (własne lub uczelniane) -- kwota do ustalenia.
      - Czas pracy zespołu: w ramach studiów i działalności koła, bez wynagrodzeń.
    ],
    card[Strumienie finansowania][
      - *Obecnie:* finansowanie własne, uczelniane.
      - *Potencjalnie:* fundusze koła naukowego.
    ],
  )
]

#slide([Podsumowanie])[
  #v(1fr)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.6cm,
    card[Co?][
      Otwarte, skalibrowane środowisko SUMO/MATSim dla Wrocławia.
    ],
    card[Po co?][
      Falsyfikowalny test transferu MARL z siatek regularnych na realną sieć z priorytetem tramwajowym.
    ],
    card[Jak?][
      Porównanie z uczciwymi baseline'ami (GERTRUDE-like, fuzzy, GPLight, LLM) i ocena interpretowalności.
    ],
  )
  #v(1fr)
  #align(center, text(size: 28pt, weight: "bold", fill: accent)[Dziękuję za uwagę])
  #v(1fr)
]
