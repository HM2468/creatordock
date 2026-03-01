# Creatordock

A server-rendered **Creator Content Management Dashboard** built with Ruby on Rails 8. Brands use it to manage social media content produced by influencers ("Creators"), tracking posts published on Instagram, TikTok, and YouTube.

---

## Tech Stack

| Layer | Choice |
|---|---|
| Language | Ruby 4.0.0 |
| Framework | Rails 8.1 |
| Database | PostgreSQL |
| Asset pipeline | Propshaft |
| CSS | Tailwind CSS 4 (`tailwindcss-rails`) |
| Templates | HAML (`haml-rails`) |
| Frontend JS | Importmap + Hotwire (Turbo + Stimulus) |
| Pagination | Kaminari |
| Background jobs | SolidQueue |
| Caching | SolidCache |
| WebSockets | SolidCable |
| Testing | RSpec + Faker |
| Env management | dotenv-rails (development/test only) |

---

## Design Decisions

### Server-rendered with Hotwire
The app is fully server-rendered (no JSON API). Turbo Frames are used for partial page updates — the creators index search bar updates the list without a full page reload while keeping the rest of the layout stable. Navigation between pages uses standard Turbo Drive.

### Counter cache on Creator
`creators.contents_count` uses ActiveRecord's `counter_cache: true` on the `Content` model. This avoids a `COUNT(*)` query every time a creator row is displayed. Because bulk inserts (e.g. the dev seed task) bypass callbacks, `Creator.reset_counters` is called explicitly after any bulk operation.

### LIKE wildcard sanitisation
The creator name search uses `sanitize_sql_like` to escape `%` and `_` before interpolating into the `ILIKE` pattern. The query itself already uses a parameterised placeholder (`?`) to prevent SQL injection; `sanitize_sql_like` closes the remaining gap of unintended wildcard matching.

### Shared pagination partial
A single `app/views/shared/_pagination.html.haml` partial handles pagination across all views. It accepts a `collection` (any Kaminari-paginated scope) and an optional `options` hash of extra query params (e.g. `provider`, `search`) that are merged into every page link, preserving active filters across pages.

### Fixed-height scrollable content areas
Both the creators index table and the creator show content list use a fixed `60vh` scrollable container with the pagination bar pinned to the bottom of the viewport (`position: fixed`). This keeps navigation controls always accessible regardless of how many records are on the page.

### Enum storage
`social_media_provider` is stored as an integer column mapped via `enum`. This keeps the column compact and lets Rails handle the string–integer translation, while still allowing `ILIKE` filtering by provider name at the controller level.

---

## Data Model

```
Creator
  name        string  (required)
  email       string  (required, unique, case-insensitive)
  contents_count  integer (counter cache)

Content
  creator_id          bigint  FK → creators
  title               string  (required)
  social_media_url    string  (required, valid HTTP URL)
  social_media_provider  integer enum: instagram(0) tiktok(1) youtube(2)
```

---

## Setup

### It has already been deployed on Render for demo purposes

creatordock demo: https://creatordock.onrender.com

> Note: This demo is hosted on Render’s free tier. Free instances may sleep when idle, so the first request after a period of inactivity can take a bit longer while the service wakes up.

### Prerequisites

- Ruby 4.0.0 (use `rbenv` or `rvm`)
- PostgreSQL running locally
- Bundler

### 1. Clone and install dependencies

```bash
git clone <repo-url>
cd creatordock
bundle install
```

### 2. Configure environment variables

Copy the example below into a `.env` file at the project root:

```bash
RAILS_MAX_THREADS=5
PGHOST=127.0.0.1
PGPORT=5432
PGUSER=postgres
PGPASSWORD=postgres
```

### 3. Create and migrate the database

```bash
bin/rails db:create db:migrate
bin/rails db:seed
```

### 4. Run the development server

Two processes are required — the Rails server and the Tailwind CSS watcher:

```bash
bin/dev
```

This runs both processes defined in `Procfile.dev`:

```
web: bin/rails server
css: bin/rails tailwindcss:watch
```

The app will be available at `http://localhost:3000`.

---

## Running Tests

```bash
bundle exec rspec
```

---

## Development Utilities

### Seed 100 fake content records for a creator

Useful for testing pagination. Only runs in `development` or `test`.

```bash
bundle exec rake "dev:seed_contents[CREATOR_ID]"

# Example:
bundle exec rake "dev:seed_contents[1]"
```

> **Note:** This uses `insert_all!` for performance and calls `Creator.reset_counters` afterwards to keep `contents_count` accurate.

---

## Built with Claude

This project was primarily built by **Claude Code** — Anthropic's AI-powered CLI for software engineering tasks — running the **Claude Opus 4.6** model.

I first scaffolded the project and established the core structure (Rails app setup, key gems, database setup, baseline layouts and routing). From that foundation, Claude Code implemented the remaining features and refinements based on the take-home brief, while I guided, reviewed, and iterated interactively via the terminal. Specific tasks included:

- **Feature implementation and refinements** — Creators index and detail pages, Content create/edit forms with inline validation errors, the `Contents::Create` service object, the dashboard stats bar, Turbo Frame-powered creator search, and database seeds.
- **Debugging a Turbo Frame "Content missing" error** on the creators index page — the "View" link was scoped inside a `turbo_frame_tag`, causing Turbo to look for a matching frame in the show page response. Fixed by adding `data: { turbo_frame: "_top" }` to break out of the frame and perform a full page navigation.
- **Writing a development rake task** (`dev:seed_contents`) to bulk-insert 100 fake `Content` records for a given creator ID using Faker, with `insert_all!` for performance and `Creator.reset_counters` to reconcile the counter cache afterwards.
- **Improving the ILIKE search query** on the creators index by adding `sanitize_sql_like` to escape `%` and `_` wildcard characters in user input, preventing unintended wildcard matching.
- **Adding pagination** to the creators index page — wiring up Kaminari in the controller and rendering the shared pagination partial with the `search` param preserved across pages.
- **UI layout improvements** — fixed-height scrollable content areas (`60vh`) with a sticky table header, and a pagination bar pinned to the bottom of the viewport on both the index and show pages.
- **Linking the dashboard stats card** for Total Creators to the creators index page with a hover effect.
- **Writing this README** — documenting the tech stack, design decisions, data model, and setup instructions.
