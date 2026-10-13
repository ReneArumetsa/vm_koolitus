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
    subtitle: [Sissejuhatus virtualiseerimisse ja praktiline töö],
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

// Pealkirjaslaid — custom, Syncopate (LAP pealkirjafont) + oranž
#slide(config: config-page(margin: 2em))[
  #v(2fr)
  #text(font: "Syncopate", weight: "bold", size: 30pt, fill: lap-orange)[Virtuaalmasinad]
  #v(0.5em)
  #text(font: "Lato", size: 18pt, fill: lap-dark)[Sissejuhatus virtualiseerimisse ja praktiline töö]
  #v(0.8em)
  #line(length: 100%, stroke: 1.5pt + lap-orange)
  #v(0.5em)
  #text(font: "Lato", weight: "bold", size: 15pt)[Rene Arumetsa] \
  #text(font: "Lato", size: 13pt, fill: gray)[LAP · VM koolitus · #datetime.today().display("[day].[month].[year]")]
  #v(2fr)
]

// Sisukord
#slide[
  = Sisukord
  #outline(title: none, indent: 1em, depth: 1)
]

== Enne alustamist

Et praktika sujuks, vajad:

- Sülearvutit *administraatoriõigustega*
- Vähemalt *30 GB vaba* kettaruumi
- Ette alla laetud: *VirtualBox* + *Ubuntu ISO*
- *VT-x / AMD-V* lubatud arvuti BIOS/UEFI-s

#v(0.8em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    Pole jõudnud? Küsi *USB-pulka* — installerid on kaasas.
  ]
]

== Tänane kava

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left, left),
  stroke: none,
  table.hline(stroke: 0.5pt + gray),
  [#text(fill: lap-orange)[*0–15 min*]], [Mis on VM, miks, hüperviisorid],
  [#text(fill: lap-orange)[*15–25 min*]], [Tööriistad ja VirtualBoxi paigaldus],
  [#text(fill: lap-orange)[*25–55 min*]], [DEMO: loome Ubuntu VM-i koos],
  [#text(fill: lap-orange)[*55–75 min*]], [Snapshot, Guest Additions, võrk],
  [#text(fill: lap-orange)[*75–90 min*]], [Küsimused ja iseseisev katsetamine],
  table.hline(stroke: 0.5pt + gray),
)

= Mis on virtualiseerimine?

== Virtuaalmasin lühidalt

#v(1em)

*Virtuaalmasin (VM)* on tarkvaraline arvuti, mis töötab teise, füüsilise arvuti sees.

#v(0.5em)

- Omaette operatsioonisüsteem (külalis-OS)
- Oma "riistvara": protsessor, mälu, kettad, võrgukaart
- Isoleeritud peremeesarvutist (host)

#v(0.5em)

Üks füüsiline masin võib korraga käitada *mitut* virtuaalmasinat.

== Miks virtualiseerida?

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Eelised*
    - Ressursside parem ärakasutus
    - Isoleeritus ja turvalisus
    - Hetktõmmised (snapshots)
    - Lihtne varundus ja taastamine
    - Katsetamine ilma riskita
  ],
  [
    *Kasutusalad*
    - Serverite konsolideerimine
    - Arenduse ja testimise keskkonnad
    - Vana tarkvara käitamine
    - Koolitus ja õpe
    - Pilveteenused (AWS, Azure)
  ],
)

== Hüperviisor

Tarkvarakiht, mis loob ja haldab virtuaalmasinaid.

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Tüüp 1 — "bare metal"*

    _(riistvaratasandi)_

    Töötab otse riistvara peal.
    - VMware ESXi
    - Microsoft Hyper-V
    - KVM / Proxmox

    Serverites, kiire ja tõhus.
  ],
  [
    *Tüüp 2 — "hosted"*

    _(tarkvaratasandi)_

    Töötab tavalise OS-i peal.
    - VirtualBox
    - VMware Workstation / Player

    Lauaarvutis, lihtne alustada.
  ],
)

== Tüüp 1 vs tüüp 2 — ülesehitus

#let kih(body, fill: luma(225), tekst: lap-dark) = rect(
  width: 100%, inset: 8pt, radius: 4pt, fill: fill, stroke: none,
)[#align(center)[#text(size: 0.9em, fill: tekst)[#body]]]

#let vmrida = grid(
  columns: (1fr, 1fr), gutter: 5pt,
  ..("VM", "VM").map(t => rect(
    fill: lap-orange.lighten(65%), inset: 8pt, radius: 4pt, stroke: none, width: 100%,
  )[#align(center)[#text(size: 0.9em)[*#t*]]]))

#v(0.5em)

#grid(
  columns: (1fr, 1fr),
  gutter: 2.5em,
  align: top,
  [
    #align(center)[#text(fill: lap-orange, weight: "bold")[Tüüp 1 — bare metal]]
    #v(0.5em)
    #stack(
      spacing: 6pt,
      vmrida,
      kih([Hüperviisor], fill: lap-orange),
      kih([Füüsiline riistvara], fill: lap-dark, tekst: white),
    )
    #v(0.4em)
    #align(center)[#text(size: 0.8em, fill: gray)[Hüperviisor otse raua peal]]
  ],
  [
    #align(center)[#text(fill: lap-orange, weight: "bold")[Tüüp 2 — hosted]]
    #v(0.5em)
    #stack(
      spacing: 6pt,
      vmrida,
      kih([Hüperviisor — VirtualBox], fill: lap-orange),
      kih([Host OS], fill: luma(225)),
      kih([Füüsiline riistvara], fill: lap-dark, tekst: white),
    )
    #v(0.4em)
    #align(center)[#text(size: 0.8em, fill: gray)[Lisakiht: host OS]]
  ],
)

#v(0.6em)

#align(center)[#text(size: 0.9em)[Põhierinevus: *tüüp 2-l on host OS vahekihina*, tüüp 1-l mitte.]]

== Tüüp 1 lähemalt

Töötab *otse riistvara peal* — host-operatsioonisüsteemi vahelt pole.

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Eelised*
    - Maksimaalne jõudlus — pole OS-i "vahekihti"
    - Tugevam isoleeritus ja turvalisus
    - Suur tihedus — palju VM-e ühel serveril
    - Töötab 24/7, kaughallatav
  ],
  [
    *Näited*
    - VMware ESXi
    - Microsoft Hyper-V
    - KVM / Proxmox VE
    - Xen

    #v(0.3em)
    Kus: *andmekeskused, serverid, pilv* (AWS, Azure).
  ],
)

#v(0.6em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    Pilveteenuste virtuaalmasinad töötavad just tüüp 1 hüperviisoritel.
  ]
]

== Tüüp 2 lähemalt

Töötab *tavalise OS-i peal* — lihtsalt üks rakendus su arvutis.

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Eelised*
    - Lihtne paigaldada ja kasutada
    - Töötab tavalisel laua-/sülearvutil
    - Graafiline, sõbralik liides
    - Ei vaja eraldi serverit
  ],
  [
    *Näited*
    - VirtualBox
    - VMware Workstation / Player
    - Parallels (macOS)
    - QEMU (graafilise liidesega)

    #v(0.3em)
    Kus: *lauaarvutid, arendus, test, õpe*.
  ],
)

#v(0.6em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    Meie tänane VirtualBox on just tüüp 2 — sobib ideaalselt alustamiseks.
  ]
]

== VM vs konteiner

Sage segadus — mõlemad isoleerivad, aga erinevalt.

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Virtuaalmasin*
    - Oma *täielik* operatsioonisüsteem
    - Raskem (GB-d), käivitub minutites
    - Tugev isoleeritus
    - Erinevad OS-id samal hostil
  ],
  [
    *Konteiner*
    - Jagab hosti OS-i *tuuma*
    - Kerge (MB-d), käivitub sekunditega
    - Õhem isoleeritus
    - Üks rakendus + selle sõltuvused
    - Tööriistad: Docker, Podman, LXC …
  ],
)

#v(0.8em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    *VM* = terve arvuti · *Konteiner* = pakitud rakendus
  ]
]

= Tööriistad

== Levinumad lahendused

#table(
  columns: (auto, 1fr, auto, auto),
  inset: 8pt,
  align: (left, left, center, center),
  table.header([*Tööriist*], [*Platvorm*], [*Tüüp*], [*Hind*]),
  [VirtualBox], [Win / macOS / Linux], [2], [Tasuta],
  [VMware Workstation], [Win / Linux], [2], [Tasuta\*],
  [KVM / QEMU], [Linux], [1], [Tasuta],
  [Hyper-V], [Windows], [1], [Windowsiga],
  [Proxmox VE], [Server], [1], [Tasuta],
)

#v(0.5em)

#text(size: 0.8em)[\* VMware Workstation on nüüd isiklikuks kasutuseks tasuta.]

== Soovitus alustajale

#v(1em)

*VirtualBox* — kõige lihtsam alguspunkt:

- Tasuta ja avatud lähtekoodiga
- Töötab igal platvormil (Windows, macOS, Linux)
- Graafiline, selge kasutajaliides
- Suur kogukond ja palju juhendeid

#v(1em)

Linuxis tõsisemaks tööks → *KVM* (nt virt-manager või Proxmox).

= Praktika

== Virtuaalmasina loomine — sammud

+ *Laadi alla* OS-i paigaldusfail (ISO)
+ *Loo uus VM* ja anna sellele nimi
+ *Eralda ressursid:* mälu (RAM) ja protsessorituumad
+ *Loo virtuaalketas* (nt 40 GB)
+ *Ühenda ISO* virtuaalse CD-seadmega
+ *Käivita* VM ja paigalda OS nagu päris arvutis
+ Paigalda *külalislisandid* (Guest Additions)

== Ressursside soovitused

#table(
  columns: (1fr, auto, auto, auto),
  inset: 8pt,
  align: (left, center, center, center),
  table.header([*Külalis-OS*], [*RAM*], [*Tuumad*], [*Ketas*]),
  [Linux (server, CLI)], [2 GB], [2], [20 GB],
  [Linux (töölaud)], [4 GB], [2], [40 GB],
  [Windows 10 / 11], [4–8 GB], [2–4], [60 GB],
)

#v(1em)

#align(center)[
  #text(fill: red.darken(10%))[*Reegel:* ära anna VM-ile üle poole hosti ressurssidest.]
]

== Snapshot'id — hetktõmmised

#v(1em)

Salvestab VM-i *täpse hetkeseisu*, mille juurde saab hiljem tagasi pöörduda.

#v(0.5em)

- Tee snapshot *enne* riskantset muudatust
- Midagi läks katki? → taasta snapshot sekunditega
- Suurepärane *katsetamiseks* ja koolituseks

#v(1em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    Snapshot ≠ varundus. Hoia tähtsaid andmeid eraldi!
  ]
]

== Võrgurežiimid (VirtualBox)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *NAT* _(vaikimisi)_
    - VM pääseb internetti
    - Host ei näe VM-i otse
  ],
  [
    *Bridged*
    - VM kui eraldi arvuti võrgus
    - Saab oma IP ruuterist
  ],
  [
    *Host-only*
    - Ainult host ↔ VM suhtlus
    - Internetti ei pääse
  ],
  [
    *Internal*
    - Ainult VM-ide omavaheline võrk
  ],
)

= VirtualBox praktikas

== VirtualBoxi paigaldamine

#v(1em)

+ Ava #text(fill: lap-orange)[virtualbox.org] → *Downloads*
+ Laadi alla oma süsteemile sobiv pakett
+ Laadi alla ka *Extension Pack* (USB, lisatugi)
+ Paigalda ja käivita

#v(1em)

#align(center)[
  #box(fill: lap-orange.lighten(80%), inset: 10pt, radius: 6pt)[
    Tasuta · Windows / macOS / Linux · lihtne alustada
  ]
]

// DEMO vahe-slaid — LAP oranž täisekraan
#slide(config: config-page(
  fill: lap-orange,
  margin: 2em,
  header: none,
  footer: none,
))[
  #set align(center + horizon)
  #text(font: "Syncopate", weight: "bold", size: 44pt, fill: white)[DEMO]
  #v(0.4em)
  #text(font: "Lato", size: 20pt, fill: white)[Loome nüüd koos Ubuntu virtuaalmasina — tee kaasa!]
]

== VM-i loomine 4 sammuga

#grid(
  columns: (auto, 1fr),
  gutter: 1em,
  row-gutter: 1.2em,
  text(size: 1.4em, weight: "bold", fill: lap-orange)[1], [*New* → anna masinale nimi ja osuta ISO-failile],
  text(size: 1.4em, weight: "bold", fill: lap-orange)[2], [Eralda *RAM* ja *tuumad* (nt 4 GB, 2 tuuma)],
  text(size: 1.4em, weight: "bold", fill: lap-orange)[3], [Loo *virtuaalketas* (VDI, dünaamiline, 40 GB)],
  text(size: 1.4em, weight: "bold", fill: lap-orange)[4], [*Start* → paigalda OS nagu päris arvutis],
)

== Pärast paigaldust

#v(1em)

*Guest Additions* — paigalda kohe!
- Sujuvam ekraan ja automaatne akna suurus
- Jagatud lõikelaud ja kaustad
- Menüü: _Devices → Insert Guest Additions CD Image_

#v(0.8em)

*Snapshot* — enne katsetamist
- _Snapshots → Take_ → nimeta "puhas paigaldus"
- Midagi läks katki? → _Restore_ ja oledki tagasi

== Kiire spikker

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left, left),
  table.header([*Olukord*], [*Lahendus*]),
  [Hiir "kinni" VM-is], [Vajuta parem _Ctrl_ (host-klahv)],
  [Ekraan liiga väike], [Paigalda Guest Additions],
  [Ei käivitu / 32-bit], [Luba _VT-x / AMD-V_ BIOS-is],
  [Internet ei tööta], [Kontrolli võrgurežiimi (NAT)],
)

= Kokkuvõte

== Peamised mõtted

#v(1em)

- Virtuaalmasin = tarkvaraline arvuti arvuti sees
- Hüperviisor loob ja haldab VM-e (tüüp 1 vs tüüp 2)
- *VirtualBox* on parim alguspunkt
- Eralda ressursse mõistlikult — mitte üle poole hostist
- *Snapshot'id* teevad katsetamise ohutuks

#v(1.5em)

#align(center)[
  #text(size: 1.3em, weight: "bold")[Küsimused?]
]
