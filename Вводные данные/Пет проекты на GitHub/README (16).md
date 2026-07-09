# laravelShop

## Описание

Интернет-магазин (e-commerce приложение), разработанный на фреймворке Laravel (PHP). Проект включает функционал каталога товаров, корзины, оформления заказов и административную панель.

**Автор:** vanya890

## Основные возможности

- Управление товарами и категориями
- Корзина и оформление заказов
- Админ-панель
- Аутентификация пользователей
- Laravel Mix для фронтенда

## Технологии

- **Laravel** (PHP framework)
- **MySQL** / SQLite (база данных)
- **Blade** (шаблоны)
- **Bootstrap** / JavaScript
- **Composer**, **npm**

## Установка и запуск

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/vanya890/laravelShop.git
   cd laravelShop
   ```

2. Установите зависимости:
   ```bash
   composer install
   npm install
   ```

3. Настройте окружение:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. Настройте базу данных в `.env` и выполните миграции:
   ```bash
   php artisan migrate
   php artisan db:seed  # если есть сиды
   ```

5. Запустите сервер разработки:
   ```bash
   php artisan serve
   ```

6. Скомпилируйте фронтенд (опционально):
   ```bash
   npm run dev
   ```

## Структура проекта

Стандартная структура Laravel + дополнительные папки для магазина.

## Лицензия

MIT (стандарт Laravel)

© vanya890