// VM koolitus — slaidid
// Kompileerimine:  typst compile main.typ VM_koolitus.pdf
// Reaalajas eelvaade:  typst watch main.typ

#import "@preview/touying:0.6.1": *
#import themes.metropolis: *

// LAP brändivärvid (LAP_Identity_Guide)
#let lap-orange = rgb("#F09410")      // Main Orange
#let lap-orange-2 = rgb("#FFA80D")    // Secondary Orange
#let lap-dark = rgb("#1E1E1E")        // Text Color - Dark

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Virtuaalmasinad],
    author: [Rene Arumetsa],
    date: datetime.today(),
    institution: [LAP · VM koolitus],
  ),
  // LAP värvipalett: oranž aktsent, tume tekst
  config-colors(
    primary: lap-orange,
    secondary: lap-orange-2,
    tertiary: lap-dark,
    neutral-darkest: lap-dark,
  ),
)

// LAP fondid: pealkirjad Syncopate, sisu Lato
#set text(font: "Lato", size: 20pt)
#show heading: set text(font: "Syncopate", weight: "bold")

// 1. Pealkirjaslaid — Syncopate (LAP pealkirjafont) + oranž
#slide(config: config-page(margin: 2em))[
  #v(2fr)
  #text(font: "Syncopate", weight: "bold", size: 30pt, fill: lap-orange)[Virtuaalmasinad]
  #v(0.8em)
  #line(length: 100%, stroke: 1.5pt + lap-orange)
  #v(0.5em)
  #text(font: "Lato", weight: "bold", size: 15pt)[Rene Arumetsa] \
  #text(font: "Lato", size: 13pt, fill: gray)[VM koolitus · #datetime.today().display("[day].[month].[year]")]
  #v(2fr)
]

// 2. Mis on VM
== Mis on virtuaalmasin?

#v(1em)

*Virtuaalmasin (VM)* on tarkvaraline arvuti, mis töötab su päris arvuti
sees — oma OS-i, "riistvara" ja kõigega.

#v(0.6em)

- Täiesti *isoleeritud* hostist
- Läheb katki? Host jääb puutumata
- Üks arvuti võib käitada mitut VM-i korraga

#v(1em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    Miks täna: *proovi Archi ilma oma arvutit tapmata.*
  ]
]

// 3. Snapshot
== Snapshot — su päästerõngas

#v(1em)

Salvestab VM-i *täpse hetkeseisu*, mille juurde saab hiljem sekunditega tagasi.

#v(0.5em)

- Tee snapshot *enne* riskantset muudatust
- `# rm -rf` või partitsioonid sassi? → *Restore* ja oledki tagasi
- Ei pea kogu installi otsast alustama

#v(1em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    *Enne Archi installi tee snapshot* — see on su "undo" nupp.
  ]
]

// 4. DEMO vahe-slaid — oranž täisekraan
#slide(config: config-page(
  fill: lap-orange,
  margin: 2em,
  header: none,
  footer: none,
))[
  #set align(center + horizon)
  #text(font: "Syncopate", weight: "bold", size: 44pt, fill: white)[DEMO]
  #v(0.4em)
  #text(font: "Lato", size: 20pt, fill: white)[Teeme VirtualBoxis koos VM-i valmis — tee kaasa!]
]

// 5. Meelespea + üleminek
== Meelespea

#v(1em)

- VM = arvuti arvuti sees, *host on alati kaitstud*
- Eralda max *pool* hosti RAM-ist ja tuumadest
- *Snapshot enne installi* = su undo-nupp

#v(1.5em)

#align(center)[
  #text(size: 1.3em, weight: "bold", fill: lap-orange)[Nüüd läheme Archi installima →]
]
