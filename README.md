# Creator Content Management Dashboard (Rails + Tailwind)

This repository contains a take-home implementation of a web-based **Creator Content Management Dashboard** built with **Ruby on Rails** and **Tailwind CSS**. The application is server-rendered (no API-only requirement) and focuses on clean Rails conventions, a well-structured UI, and solid unit tests.

---

## Overview

The dashboard helps brands manage social media content created by influencers (“Creators”). Each piece of “Content” represents a link to a post published on a social media platform such as Instagram, TikTok, or YouTube.

**Goals**
- Follow standard Rails MVC conventions (models, controllers, views)
- Use Tailwind CSS for a clean, responsive UI (utility classes only; no custom CSS files)
- Implement model validations, strong parameters, and a small service object
- Provide unit test coverage for core logic

---

## Tech Stack

- Ruby on Rails (>= 7)
- PostgreSQL
- Tailwind CSS
- Hotwire/Turbo (optional for enhanced UX)
- RSpec or Minitest (tests)

---

## Data Model

### Creator
Represents an influencer.

**Fields**
- `name` (string, required)
- `email` (string, required, unique)

### Content
Represents a social media post submitted by a creator.

**Fields**
- `title` (string, required)
- `social_media_url` (string, required)
- `social_media_provider` (enum, required): `instagram` / `tiktok` / `youtube`

**Associations**
- `Content` belongs to `Creator`

---

## Required Features

### 1) Creators Index Page
- List all creators
- Show creator:
  - name
  - email
  - content count

### 2) Creator Detail Page
- Show creator details (name, email)
- Show a **paginated** list of the creator’s content
- Allow filtering content by `social_media_provider`

### 3) Content Form (Create & Edit)
- Provide forms to create and update a content record
- Fields:
  - title
  - social_media_url
  - social_media_provider
- Validations:
  - `title` must be present
  - `social_media_url` must be present and a valid URL format
  - `social_media_provider` must be one of the allowed values
- Display validation errors inline on the form

### 4) Service Object for Content Creation
- Extract content creation logic into a Service Object, e.g. `Contents::Create`
- The service should return a result indicating success or failure

### 5) Unit Tests
Using **RSpec or Minitest**, cover:
- model validations
- `Contents::Create` service object behavior

---

## Optional Features (If Time Allows)

### Dashboard Stats Bar
A stats bar on the dashboard homepage showing:
- total creators
- total content items
- breakdown by `social_media_provider` (e.g., Instagram: 12, TikTok: 8, YouTube: 5)

### Creators Search (No Full Page Reload Preferred)
A search bar on the creators index that filters by creator name.
- Turbo Frame or a standard form is acceptable

### Seeds
Seed the database with sample data via `db/seeds.rb`:
- at least 5 creators
- at least 20 content records

---

## Setup

### Prerequisites
- Ruby (compatible with Rails >= 7)
- PostgreSQL
- Node tooling as required by the chosen Rails/Tailwind setup

### Install
```bash
bundle install
bin/rails db:create db:migrate