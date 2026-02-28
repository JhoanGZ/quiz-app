# Quiz App

Quiz application built with Ruby on Rails 8 featuring role-based access control, image uploads, and a JSON API.

## Stack

- **Ruby on Rails 8.1** — Web framework
- **PostgreSQL 16** — Database
- **Devise** — Authentication
- **Pundit** — Authorization (role-based policies)
- **Tailwind CSS** — Styling
- **Hotwire / Turbo + Stimulus** — Frontend interactivity
- **Active Storage** — Image uploads (S3 in production)
- **Docker + Docker Compose** — Containerized development

## Features

### Admin
- Create and manage quizzes (draft/published)
- Add questions with 4 options (one correct)
- Upload images to quizzes and questions (max 2MB, JPEG/PNG/WEBP)
- Attach external video URLs (YouTube/Vimeo)
- Publish quizzes when ready

### Player
- Browse published quizzes
- Take a quiz and submit answers
- View score and detailed results
- Cannot retake a completed quiz

### Rules
- Draft quizzes are not accessible to players
- Completed attempts cannot be modified
- Each player can only attempt a quiz once

## Getting Started

### Prerequisites

- Docker Desktop
- Docker Compose

### Setup

```bash
# Clone the repository
git clone https://github.com/JhoanGZ/quiz-app.git
cd quiz-app

# Build and start containers
make build
make up

# Create database and run migrations
make db-create
make db-migrate

# Load sample data
make db-seed
```

The app will be available at `http://localhost:3000`

### Seed Users

| Role   | Email             | Password    |
|--------|-------------------|-------------|
| Admin  | admin@quiz.com    | password123 |
| Player | player@quiz.com   | password123 |

## Makefile Commands

| Command          | Description                    |
|------------------|--------------------------------|
| `make build`     | Build Docker images            |
| `make up`        | Start all containers           |
| `make down`      | Stop all containers            |
| `make logs`      | View container logs            |
| `make shell`     | Open bash in web container     |
| `make console`   | Open Rails console             |
| `make db-create` | Create the database            |
| `make db-migrate`| Run pending migrations         |
| `make db-seed`   | Seed the database              |
| `make setup`     | Full setup (build + db + seed) |

## API Endpoints

Base URL: `/api/v1`

Authentication via header: `X-User-Email: user@example.com`

### Quizzes

```
GET /api/v1/quizzes        — List quizzes (filtered by role)
GET /api/v1/quizzes/:id    — Show quiz with questions and options
```

### Attempts

```
POST /api/v1/attempts      — Submit quiz answers
GET  /api/v1/attempts/:id  — View attempt result
```

### Example: Submit a quiz attempt

**Endpoint:** `POST /api/v1/attempts`

**Headers:**
- `X-User-Email: player@quiz.com`
- `Content-Type: application/json`

**Body:**
```json
{
  "quiz_id": 1,
  "answers": [
    {"question_id": 1, "option_id": 2},
    {"question_id": 2, "option_id": 7},
    {"question_id": 3, "option_id": 11}
  ]
}
```

**Response:**
```json
{
  "id": 1,
  "quiz": "Capitales del Mundo",
  "score": 100,
  "passing_score": 70,
  "passed": true,
  "total_questions": 3,
  "correct_answers": 3
}
```

## Data Model

```
User (Devise + roles)
 ├── has_many :quizzes (as admin)
 └── has_many :attempts (as player)

Quiz
 ├── has_many :questions
 ├── has_many :attempts
 └── has_one_attached :image

Question
 ├── has_many :options
 ├── has_many :answers
 └── has_one_attached :image

Option
 └── belongs_to :question

Attempt
 ├── belongs_to :user
 ├── belongs_to :quiz
 └── has_many :answers

Answer
 ├── belongs_to :attempt
 ├── belongs_to :question
 └── belongs_to :option
```

## Architecture Decisions

- **Pundit over CanCanCan** — Cleaner, one policy per model, pure Ruby, easier to test and maintain.
- **Integer enum for roles** — `player: 0, admin: 1` with Rails enum. Simple, no extra gems needed.
- **Active Storage for images** — Native Rails solution. Local storage in development, S3-ready for production.
- **Video as URL** — External hosting (YouTube/Vimeo) instead of uploading video files. Cost-effective and scalable.
- **Header-based API auth** — Simple authentication for API consumption. JWT could be added for production.
- **dependent: :destroy** — Cascade deletion for data consistency. Soft delete (via `discard` gem) recommended for production.

## Design Notes

- Added a passing score to quizzes — a quiz without knowing if you passed felt incomplete.
- Questions currently belong to one quiz. Could be made reusable with a join table in the future.
- Used hard delete for simplicity. In production I'd use soft delete (`discard` gem) to keep data history.
- API auth is header-based for easy testing. JWT would be the next step for production.
- Videos are external URLs (YouTube/Vimeo) — no need to store heavy files when platforms already handle streaming.
