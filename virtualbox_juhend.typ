// VirtualBoxi juhend — A4 õppematerjal
// Kompileerimine:  typst compile virtualbox_juhend.typ
// Eelvaade:        typst watch virtualbox_juhend.typ

// LAP brändivärvid (LAP_Identity_Guide)
#let lap-orange = rgb("#F09410")      // Main Orange
#let lap-orange-2 = rgb("#FFA80D")    // Secondary Orange
#let lap-dark = rgb("#1E1E1E")        // Text Color - Dark

#set document(title: "VirtualBoxi juhend", author: "Rene Arumetsa")
#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.2cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: gray)
      VirtualBoxi juhend #h(1fr) LAP · VM koolitus
      #line(length: 100%, stroke: 0.5pt + lap-orange)
    ]
  },
)
// LAP fondid: pealkirjad Syncopate, sisu Lato
#set text(font: "Lato", size: 11pt, lang: "et", fill: lap-dark)
#set par(justify: true, leading: 0.7em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  set text(font: "Syncopate", weight: "bold", size: 14pt, fill: lap-orange)
  v(0.6em)
  it
  v(0.3em)
}
#show heading.where(level: 2): it => {
  set text(font: "Syncopate", weight: "bold", size: 10pt, fill: lap-dark)
  v(0.4em)
  it
  v(0.2em)
}

// Abifunktsioonid --------------------------------------------------

#let nipp(body) = block(
  fill: rgb("#eafaf1"),
  inset: 10pt,
  radius: 6pt,
  width: 100%,
  stroke: (left: 3pt + rgb("#27ae60")),
)[#text(weight: "bold")[💡 Nipp:] #body]

#let hoiatus(body) = block(
  fill: rgb("#fdedec"),
  inset: 10pt,
  radius: 6pt,
  width: 100%,
  stroke: (left: 3pt + rgb("#e74c3c")),
)[#text(weight: "bold")[⚠️ Tähelepanu:] #body]

#let klahv(k) = box(
  fill: luma(240),
  inset: (x: 5pt, y: 2pt),
  radius: 3pt,
  stroke: 0.5pt + luma(180),
)[#text(font: "Liberation Mono", size: 9pt)[#k]]

// Tiitel -----------------------------------------------------------

#align(center)[
  #v(2cm)
  #text(font: "Syncopate", size: 24pt, weight: "bold", fill: lap-orange)[VirtualBoxi juhend]
  #v(0.5em)
  #text(size: 14pt, fill: gray)[Virtuaalmasina loomine ja haldamine samm-sammult]
  #v(1cm)
  #text(size: 11pt)[LAP · VM koolitus · #datetime.today().display("[day].[month].[year]")]
]

#v(2cm)

#outline(title: [Sisukord], indent: 1em, depth: 2)

#pagebreak()

// Sisu -------------------------------------------------------------

= Mis on VirtualBox?

Oracle *VirtualBox* on tasuta ja avatud lähtekoodiga virtualiseerimistarkvara. See
võimaldab käitada ühe arvuti sees teist "virtuaalset" arvutit — koos oma
operatsioonisüsteemiga. Nii saad näiteks Windowsi all proovida Linuxit, ilma et
peaksid oma põhisüsteemi muutma.

VirtualBox on *tüüp 2 hüperviisor*: see töötab tavalise operatsioonisüsteemi peal
(Windows, macOS või Linux) ja sobib suurepäraselt õppimiseks, testimiseks ja
katsetamiseks.

== Mõisted

/ Host (peremees): füüsiline arvuti, kus VirtualBox töötab.
/ Guest (külaline): virtuaalmasina sees olev operatsioonisüsteem.
/ ISO: operatsioonisüsteemi paigaldusketta tõmmisfail.
/ Snapshot: virtuaalmasina salvestatud hetkeseis.

= Paigaldamine

== Allalaadimine

+ Ava brauseris #link("https://www.virtualbox.org")[virtualbox.org]
+ Vajuta *Downloads*
+ Vali oma host-süsteemile sobiv pakett (Windows, macOS, Linux)
+ Laadi alla ka *Extension Pack* (lisab USB 2.0/3.0 ja muu toe)

== Linuxil (NixOS)

NixOS-il lisa `configuration.nix` faili:

```nix
virtualisation.virtualbox.host.enable = true;
users.extraGroups.vboxusers.members = [ "sinu-kasutajanimi" ];
```

Seejärel käivita `sudo nixos-rebuild switch` ja logi uuesti sisse.

#nipp[Teistel Linuxi distrodel paigalda pakett `virtualbox` oma paketihalduriga
(nt `sudo apt install virtualbox`) ja lisa end `vboxusers` gruppi.]

= Virtuaalmasina loomine

== Uue VM-i loomine

+ Ava VirtualBox ja vajuta *New* (Uus)
+ Anna masinale *nimi* (nt "Ubuntu-test")
+ Vali *ISO Image* — osuta allalaetud paigaldusfailile
+ Vali *Type* ja *Version* (nt Linux / Ubuntu 64-bit)
+ Märgista *Skip Unattended Installation*, kui soovid ise paigaldada

== Ressursside eraldamine

Järgmisel sammul määra riistvara:

#table(
  columns: (1fr, auto, auto),
  inset: 8pt,
  align: (left, center, center),
  table.header([*Ressurss*], [*Miinimum*], [*Soovitatav*]),
  [Mälu (RAM)], [2 GB], [4 GB],
  [Protsessorituumad], [1], [2],
  [Virtuaalketas], [20 GB], [40 GB],
)

#hoiatus[Ära anna virtuaalmasinale üle *poole* oma hosti ressurssidest, muidu
muutub põhiarvuti aeglaseks. 8 GB RAM-iga arvutis anna VM-ile maksimaalselt 4 GB.]

== Virtuaalketas

Vali *Create a Virtual Hard Disk Now*. Soovitused:

- Vorming: *VDI* (VirtualBoxi oma vorming)
- Tüüp: *Dynamically allocated* — ketas kasvab vastavalt vajadusele ega võta
  kohe kogu ruumi

= Operatsioonisüsteemi paigaldamine

+ Vali loodud VM ja vajuta *Start* (Käivita)
+ VM käivitub ISO-failist, nagu päris arvuti paigaldusplaadilt
+ Järgi OS-i paigaldusjuhiseid (keel, ketta partitsioneerimine, kasutaja)
+ Pärast paigaldust eemalda ISO: *Devices → Optical Drives → Remove disk*
+ Taaskäivita virtuaalmasin

#nipp[Hiire "püüdmisest" vabanemiseks vajuta *host-klahvi* — vaikimisi parempoolne
#klahv[Ctrl] (Windows/Linux) või #klahv[⌘ vasak] (macOS).]

= Külalislisandid (Guest Additions)

*Guest Additions* on draiverite ja tööriistade pakett, mis parandab
virtuaalmasina kasutuskogemust märgatavalt:

- Sujuvam ja suurem ekraanilahutus (automaatne akna suurusega kohandumine)
- Jagatud lõikelaud (copy-paste hosti ja külalise vahel)
- Jagatud kaustad
- Parem hiire integratsioon

Paigaldamiseks vali töötavas VM-is menüüst *Devices → Insert Guest Additions
CD Image* ja käivita paigaldaja külalis-OS-is.

= Snapshot'id

Snapshot salvestab virtuaalmasina täpse hetkeseisu, mille juurde saab hiljem
tagasi pöörduda. See on *katsetamiseks* hindamatu väärtusega.

== Snapshot'i tegemine

+ Vali VM ja ava *Snapshots* vaade (paremas ülanurgas)
+ Vajuta *Take* ja anna snapshotile selge nimi (nt "puhas paigaldus")

== Taastamine

+ Vali soovitud snapshot nimekirjast
+ Vajuta *Restore*
+ VM pöördub tagasi salvestatud seisu — kõik hilisemad muudatused kaovad

#hoiatus[Snapshot *ei ole varundus*! See hoitakse samas kettafailis. Tähtsaid
andmeid varunda eraldi kettale või pilve.]

= Jagatud kaustad

Failide vahetamiseks hosti ja külalise vahel:

+ VM-i seaded → *Shared Folders*
+ Lisa kaust hosti arvutist (nt `/home/renkar/jagatud`)
+ Märgista *Auto-mount* ja *Make Permanent*
+ Taaskäivita VM — kaust ilmub külalis-OS-i

#nipp[Linuxi külalises peab kasutaja kuuluma `vboxsf` gruppi, et jagatud kaustu
lugeda: `sudo usermod -aG vboxsf $USER`.]

= Võrgurežiimid

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left, left),
  table.header([*Režiim*], [*Kirjeldus*]),
  [NAT _(vaikimisi)_], [VM pääseb internetti, host ei näe VM-i otse. Sobib enamuseks.],
  [Bridged], [VM käitub võrgus eraldi arvutina ja saab oma IP ruuterist.],
  [Host-only], [Ainult host ↔ VM suhtlus, internetti ei pääse.],
  [Internal], [Ainult VM-ide omavaheline privaatvõrk.],
)

= Levinud probleemid

/ VM ei käivitu, viga virtualiseerimise kohta: Luba *VT-x / AMD-V*
  arvuti BIOS/UEFI seadetes.

/ Ainult 32-bitised valikud: Virtualiseerimine on BIOS-is välja lülitatud,
  luba see sealt.

/ Ekraan jääb väikeseks: Paigalda *Guest Additions* (vt ptk 5).

/ Aeglane töö: Vähenda eraldatud RAM-i või tuumade arvu, sulge host-arvutis
  muud rakendused.

= Klaviatuuri kiirklahvid

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left, left),
  table.header([*Klahvid*], [*Tegevus*]),
  [#klahv[Host] + #klahv[F]], [Täisekraani režiim],
  [#klahv[Host] + #klahv[Home]], [Menüü avamine täisekraanil],
  [#klahv[Host] + #klahv[Del]], [Saada Ctrl+Alt+Del külalisele],
  [#klahv[Host] + #klahv[R]], [Taaskäivita VM],
  [#klahv[Host]], [Vabasta hiir/klaviatuur],
)

#v(1fr)

#align(center)[
  #line(length: 40%, stroke: 0.5pt + gray)
  #v(0.5em)
  #text(size: 9pt, fill: gray)[Head virtualiseerimist! 🖥️]
]
