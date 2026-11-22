// Typst data-pipeline spike. Not a production resume.
#let profile = json("../../data/profile.json")
#set document(title: "Resume data pipeline pilot", author: profile.full_name, lang: "ru")
#set page(paper: "a4", margin: (x: 22mm, y: 20mm))
#set text(font: "Liberation Serif", size: 10pt, lang: "ru")
#set par(leading: 0.65em, justify: true)
#align(center)[
  #text(size: 20pt, weight: "bold")[#profile.full_name]
  #linebreak()
  #profile.headline
  #linebreak()
  #profile.contacts.email
]
= Образование
#for item in profile.education [
  *#item.institution*
  #linebreak()
  #item.program — #item.specialization
  #linebreak()
  #item.period
  #linebreak()
  #item.result
  #v(0.6em)
]
#text(size: 8pt, fill: gray)[Пилотный документ. Не использовать как готовое резюме.]
