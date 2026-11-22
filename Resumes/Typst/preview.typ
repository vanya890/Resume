// Тестовый документ Typst, использующий централизованные данные репозитория.
#let profile = json("../../data/profile.json")
#let projects = json("../../data/projects.json").projects.filter(p => p.visibility == "public")
#let skills = json("../../data/skills.json").skills

#set document(title: "Резюме — " + profile.full_name, author: profile.full_name, lang: "ru")
#set page(paper: "a4", margin: (x: 17mm, y: 15mm), numbering: "1")
#set text(font: "Liberation Sans", size: 8.7pt, lang: "ru", fill: rgb("#202938"))
#set par(leading: 0.48em, justify: true)
#set heading(numbering: none)
#let accent = rgb("#2457A6")
#let muted = rgb("#64748B")
#let section(title) = [
  #v(0.55em)
  #text(size: 11pt, weight: "bold", fill: accent)[#title]
  #v(0.2em)
  #line(length: 100%, stroke: 0.7pt + accent)
  #v(0.3em)
]
#align(center)[
  #text(size: 19pt, weight: "bold", fill: rgb("#14233B"))[#profile.full_name]
  #v(0.2em)
  #text(size: 9.5pt, weight: "medium")[#profile.headline]
  #v(0.25em)
  #text(size: 8pt, fill: muted)[#profile.location]
  #v(0.15em)
  #link("mailto:" + profile.contacts.email)[#profile.contacts.email]
  #h(0.7em) · #link(profile.contacts.github)[GitHub]
  #h(0.7em) · #link(profile.contacts.telegram)[Telegram]
]
#section("ПРОФИЛЬ")
Разработчик программного обеспечения, работающий на пересечении прикладной разработки, AI-интеграций и киберфизических систем. Практический опыт отражён в проектах по робототехническому моделированию, разработке приложений и автоматизации.
#section("ТЕХНОЛОГИИ И НАВЫКИ")
#grid(columns: 3, gutter: 0.3em, ..skills.map(skill => box(fill: rgb("#F1F5F9"), radius: 3pt, inset: 4pt)[#text(size: 7.8pt)[#skill.name]]))
#section("ИЗБРАННЫЕ ПРОЕКТЫ")
#for project in projects [
  #block(above: 0.25em, below: 0.35em)[
    #text(size: 9.5pt, weight: "bold")[#project.title]
    #h(1fr)
    #text(size: 7.5pt, fill: muted)[#project.period]
    #v(0.1em)
    #project.description
    #if "highlights" in project and project.highlights.len() > 0 [
      #v(0.1em)
      #for item in project.highlights [
        #list(item)
      ]
    ]
    #text(size: 7.5pt, fill: muted)[Стек: #project.stack.join(", ")]
    #linebreak()
    #for item in project.links [
      #link(item.url)[#item.label] #h(0.5em)
    ]
  ]
]
#section("ОБРАЗОВАНИЕ")
#for item in profile.education [
  #block(above: 0.2em, below: 0.3em)[
    #text(size: 9pt, weight: "bold")[#item.institution]
    #h(1fr)
    #text(size: 7.5pt, fill: muted)[#item.period]
    #linebreak()
    #item.program · #item.specialization
    #linebreak()
    #text(size: 8pt)[#item.result]
  ]
]
#v(0.4em)
#align(center)[#text(size: 7pt, fill: muted)[Тестовая версия. Уровни навыков намеренно не указаны до подтверждения.] ]
