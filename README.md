# Резюме и портфолио — Кузык Иван Романович

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-live-3157d5?style=for-the-badge&logo=github)](https://vanya890.github.io/Resume/)
[![Build and deploy](https://github.com/vanya890/Resume/actions/workflows/pages.yml/badge.svg)](https://github.com/vanya890/Resume/actions/workflows/pages.yml)

**Разработчик программного обеспечения · AI-интеграции · киберфизические системы**

Москва · [vanya.kuzyk1@gmail.com](mailto:vanya.kuzyk1@gmail.com) · [Telegram @CODY890](https://t.me/CODY890) · [GitHub](https://github.com/vanya890)

## Онлайн-портфолио

**[Открыть сайт резюме](https://vanya890.github.io/Resume/)**

Сайт содержит краткий профиль, компетенции, избранные публичные проекты, образование и шесть вариантов резюме PDF.

## Варианты PDF-резюме

PDF собираются из исходников XeLaTeX автоматически при запуске GitHub Actions. Актуальные опубликованные файлы доступны на GitHub Pages:

| Направление | PDF |
|---|---|
| Универсальное | [Resume_Universal.pdf](https://vanya890.github.io/Resume/Resumes/Universal/Resume_Universal.pdf) |
| AI / ML | [Resume_AI_ML.pdf](https://vanya890.github.io/Resume/Resumes/AI_ML/Resume_AI_ML.pdf) |
| Инженерное | [Resume_Engineer.pdf](https://vanya890.github.io/Resume/Resumes/Engineer/Resume_Engineer.pdf) |
| Робототехника | [Resume_Robotics.pdf](https://vanya890.github.io/Resume/Resumes/Robotics/Resume_Robotics.pdf) |
| Веб-разработка | [Resume_Web.pdf](https://vanya890.github.io/Resume/Resumes/Web/Resume_Web.pdf) |
| Аналитика данных | [Resume_Data.pdf](https://vanya890.github.io/Resume/Resumes/Data/Resume_Data.pdf) |

## Структура проекта

```text
.
├── .github/workflows/pages.yml  # CI, сборка PDF и деплой GitHub Pages
├── data/projects.json           # единый реестр проектов для сайта
├── index.html                   # адаптивный сайт-портфолио
├── MasterData/                  # рабочая база навыков
├── Resumes/
│   ├── Common/                  # общие персональные данные и образование
│   ├── AI_ML/
│   ├── Data/
│   ├── Engineer/
│   ├── Robotics/
│   ├── Universal/
│   └── Web/
└── scripts/
    ├── build-resumes.sh         # сборка всех PDF
    └── validate_site.py         # проверка ссылок и структуры сайта
```

## Локальная сборка

Требуются XeLaTeX, пакет Polyglossia, расширения TeX Live и шрифты Liberation Serif/Sans/Mono.

На Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y latexmk texlive-xetex texlive-lang-cyrillic texlive-latex-extra fonts-liberation
./scripts/build-resumes.sh
python3 scripts/validate_site.py site
```

Сценарий собирает шесть PDF из исходников в `Resumes/*/*.tex`, размещает их в каталоге `site/` и запускает проверку внутренних ссылок и артефактов.

## GitHub Actions

Workflow [Build resumes and deploy GitHub Pages](.github/workflows/pages.yml):

- запускается при push в `main`, pull request и вручную через `workflow_dispatch`;
- собирает все варианты PDF с помощью XeLaTeX;
- проверяет внутренние ссылки, якоря и наличие PDF;
- публикует статический сайт через GitHub Pages.

Для первого использования в **Settings → Pages → Build and deployment → Source** должен быть выбран **GitHub Actions**.

## Образование

- **Московский политехнический университет**, 09.03.01 «Информатика и вычислительная техника», специализация «Киберфизические системы», 2022–2026. Средний балл 5.0; ВКР по разработке образовательного 3D-симулятора робототехники защищена на «отлично».
- **ГБПОУ «Образовательный комплекс „Юго-Запад“»**, 09.02.07 «Информационные системы и программирование», квалификация «Специалист по информационным системам», 2018–2022. Диплом с отличием.

## Приватность

Оригиналы дипломов, выписки из личного кабинета и старые версии резюме не хранятся в текущей публичной версии репозитория. Для подтверждения образования работодатель может запросить документы напрямую. Старые Git-коммиты могут сохранять прежние версии удалённых файлов; полная очистка истории требует отдельной процедуры переписывания Git history.
