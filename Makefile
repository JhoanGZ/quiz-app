.PHONY: build up down logs shell db-create db-migrate db-seed setup

new:
	docker run --rm -v .:/app -w /app ruby:3.3.6-slim bash -c "\
		apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm git curl && \
		npm install -g yarn && \
		gem install rails && \
		rails new . --database=postgresql --css=tailwind --skip-test"

build:
	docker compose build

up:
	docker compose up

down:
	docker compose down

logs:
	docker compose logs -f

shell:
	docker compose run --rm web bash

db-create:
	docker compose run --rm web rails db:create

db-migrate:
	docker compose run --rm web rails db:migrate

db-seed:
	docker compose run --rm web rails db:seed

setup: build db-create db-migrate db-seed
