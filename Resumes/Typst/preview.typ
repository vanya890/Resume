// Professional Typst resume preview. Data is sourced from the repository's JSON files.
#let profile = json("../../data/profile.json")
#let projects = json("../../data/projects.json").projects.filter(p => p.visibility == "public")
#let skills = json("../../data/skills.json").skills

#set document(title: "Резюме — " + profile.full_name, author: profile.full_name)
#set page(
  paper: "a4",
  margin: (left: 19mm, right: 19mm, top: 17mm, bottom: 17mm),
  numbering: "1",
  footer: context [
    #v(4pt)
    #line(length: 100%, stroke: 0.45pt + rgb("#D8DEE8"))
    #v(5pt)
    #grid(columns: (1fr, auto), align: (left, right))[
      #text(size: 7pt, fill: rgb("#788397"))[#profile.full_name · Резюме]
    ][
      #text(size: 7pt, fill: rgb("#788397"))[ #counter(page).display("1") ]
    ]
  ],
)
#set text(font: "Liberation Sans", size: 9pt, lang: "ru", fill: rgb("#202B3C"))
#set par(leading: 0.58em, spacing: 0.48em, justify: false)
#set heading(numbering: none)

#let navy = rgb("#172B4D")
#let accent = rgb("#2864A8")
#let muted = rgb("#68778D")
#let pale = rgb("#F2F5F9")
#let rule = rgb("#D9E1EB")

#let section(title) = [
  #v(0.85em)
  #grid(columns: (auto, 1fr), column-gutter: 9pt, align: horizon)[
    #text(size: 10pt, weight: "bold", fill: navy, tracking: 0.7pt)[#upper(title)]
  ][
    #v(0.58em)
    #line(length: 100%, stroke: 0.65pt + rule)
  ]
  #v(0.35em)
]

#let project-card(project) = block(
  breakable: false,
  above: 0.22em,
  below: 0.48em,
)[
  #grid(columns: (1fr, auto), align: horizon)[
    #text(size: 9.6pt, weight: "bold", fill: navy)[#project.title]
  ][
    #text(size: 7.6pt, fill: muted)[#project.period]
  ]
  #v(0.12em)
  #text(size: 8.6pt)[#project.description]
  #if "highlights" in project and project.highlights.len() > 0 [
    #v(0.12em)
    #for item in project.highlights [
      #grid(columns: (8pt, 1fr), column-gutter: 3pt, align: top)[
        #text(fill: accent)[•]
      ][
        #text(size: 8.1pt, fill: rgb("#39485C"))[#item]
      ]
    ]
  ]
  #v(0.12em)
  #grid(columns: (auto, 1fr), column-gutter: 5pt, align: top)[
    #text(size: 7.4pt, weight: "bold", fill: muted)[СТЕК]
  ][
    #text(size: 7.4pt, fill: muted)[#project.stack.join(" · ")]
  ]
  #if project.links.len() > 0 [
    #v(0.08em)
    #for item in project.links [
      #link(item.url)[#text(size: 7.5pt, weight: "medium", fill: accent)[#item.label]]
      #h(0.7em)
    ]
  ]
  #v(0.18em)
  #line(length: 100%, stroke: 0.35pt + rule)
]

#align(left)[
  #text(size: 23pt, weight: "bold", fill: navy, tracking: -0.5pt)[#profile.full_name]
  #v(0.18em)
  #text(size: 10.5pt, weight: "medium", fill: accent)[#profile.headline]
  #v(0.55em)
  #grid(columns: (1fr, 1fr), column-gutter: 8pt, row-gutter: 4pt)[
    #text(size: 8pt, fill: muted)[#profile.location]
  ][
    #link("mailto:" + profile.contacts.email)[#text(size: 8pt, fill: accent)[#profile.contacts.email]]
  ][
    #link(profile.contacts.github)[#text(size: 8pt, fill: accent)[github.com/vanya890]]
  ][
    #link(profile.contacts.telegram)[#text(size: 8pt, fill: accent)[Telegram]]
  ]
]
#v(0.55em)
#line(length: 100%, stroke: 1.5pt + accent)

#section("Профессиональный профиль")
Разработчик программного обеспечения, работающий на пересечении прикладной разработки, AI-интеграций и киберфизических систем. Практический опыт подтверждён проектами в робототехническом моделировании, разработке приложений и автоматизации.

#section("Ключевые навыки")
#grid(
  columns: 2,
  column-gutter: 12pt,
  row-gutter: 5pt,
  ..skills.map(skill => [
    #grid(columns: (8pt, 1fr), column-gutter: 4pt, align: top)[
      #text(fill: accent)[•]
    ][
      #text(size: 8.4pt, fill: rgb("#2D3B50"))[#skill.name]
    ]
  ]),
)

#section("Избранные проекты")
#for project in projects [
  #project-card(project)
]

#section("Образование")
#for item in profile.education [
  #block(breakable: false, above: 0.16em, below: 0.42em)[
    #grid(columns: (1fr, auto), align: horizon)[
      #text(size: 9pt, weight: "bold", fill: navy)[#item.institution]
    ][
      #text(size: 7.7pt, fill: muted)[#item.period]
    ]
    #v(0.12em)
    #text(size: 8.4pt)[#item.program · #item.specialization]
    #v(0.08em)
    #text(size: 8pt, fill: muted)[#item.result]
  ]
]

#v(0.35em)
#align(center)[
  #text(size: 7pt, fill: muted)[Тестовая версия оформления. Уровни навыков не указаны до подтверждения.]
]
