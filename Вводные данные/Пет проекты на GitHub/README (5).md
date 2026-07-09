# Minecraft Server Project

Полностью контейнеризованный Minecraft-сервер на базе **Purpur 1.21** + лендинг-сайт в Docker.

## Стек технологий

| Слой | Технология |
|------|-----------|
| Сервер | Purpur 1.21 (itzg/minecraft-server) |
| Сайт | React + TypeScript + Vite |
| Веб-сервер | Nginx |
| Status API | Node.js (minecraft-server-util) |
| Инфраструктура | Docker + Docker Compose |

## Сервисы

| Сервис | Порт | Описание |
|--------|------|----------|
| `minecraft` | `25565` | Игровой сервер |
| `website` | `80` | Лендинг-сайт |
| `status-api` | `3001` | Internal API статуса |
| SquareMap | `8081` | Веб-карта мира |

## Быстрый старт

```bash
# Запустить все сервисы
docker-compose up -d

# Пересобрать сайт после изменений
docker-compose build website && docker-compose up -d website
```

## Настройка IP сервера

Открой `website/src/App.tsx` и замени первые две константы:

```ts
const SERVER_IP = 'play.myserver.net';    // ← твой домен или IP
const MAP_URL   = 'http://IP:8081';       // ← адрес SquareMap
```

Затем пересобери сайт: `docker-compose build website && docker-compose up -d website`

## Структура проекта

```
MinecraftServer/
├── docker-compose.yml      # Все сервисы
├── data/                   # Данные Minecraft-сервера (не в git)
│   └── plugins/            # JAR-файлы плагинов
├── website/                # Лендинг (React + TS + Vite)
│   ├── src/
│   │   ├── components/     # Модульные компоненты
│   │   ├── hooks/          # useServerStatus.ts
│   │   └── App.tsx         # Конфиг + сборка страницы
│   ├── nginx.conf          # SPA-роутинг + /api/status прокси
│   └── Dockerfile          # Multi-stage: Node → Nginx
├── status-api/             # Сервис статуса MC-сервера
│   ├── server.js           # HTTP-сервер + minecraft-server-util
│   └── Dockerfile
├── README.md
├── CHANGELOG.md
└── PROJECT_KNOWLEDGE.md    # AI-дружественная документация
```

## Плагины

| Плагин | Версия | Функция |
|--------|--------|---------|
| AuthMeReloaded | 5.6.0 | Авторизация в offline-mode |
| SkinsRestorer | 15.11.0 | Скины для пиратских лаунчеров |
| SquareMap | latest | Веб-карта |
| GriefPrevention | latest | Защита территорий |
| ViaVersion | latest | Поддержка старых клиентов |
| ViaBackwards | latest | Обратная совместимость |
| EssentialsX | 2.21.0 | Базовые команды |
| LuckPerms | 5.5.17 | Управление правами |
| Vault | latest | API для плагинов экономики |
| WorldEdit | 7.3.10-beta | Редактирование мира |
| WorldGuard | 7.0.12 | Защита регионов |
| MiniMOTD | 2.2.2 | Анимированное MOTD |
| spark | latest | Профилировщик производительности |

---

## 🚀 Лаунчер клиента (Windows .exe)

**Используйте готовый лаунчер для подключения к серверу:**

### 📥 Скачать
Готовый файл: [`launcher/release/МойСервер 1.0.0.exe`](launcher/release/МойСервер%201.0.0.exe) (75 MB, portable – не требует установки)

### 🔨 Пересборка (если нужно)
```powershell
cd launcher
.\build.ps1
```

**Требования для сборки:**
- Node.js 20+
- npm 9+
- Временно отключить антивирус (иначе блокирует electron-файлы)

**Результат сборки:** `launcher/release/МойСервер 1.0.0.exe`

### 🌟 Особенности лаунчера
- ✅ **Автоматическая загрузка Minecraft** (оффлайн-режим, пиратские лаунчеры)
- ✅ **Авто-установка Java 21** (portable JRE ~55 MB)
- ✅ **Корректная поддержка пиратских аккаунтов** (AuthMe + SkinsRestorer)
- ✅ **Синхронизация модов** с сервера (клиентские моды)
- ✅ **Параллельная загрузка** ассетов (5-10× быстрее)
- ✅ **Автоматические фоллбэки** (CDN → прокси)
- ✅ **Возобновление прерванных загрузок**
- ✅ **Детальное логирование** в `logs/launcher.log`
