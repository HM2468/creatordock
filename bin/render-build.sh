#!/usr/bin/env bash
set -o errexit

echo "==> Configuring bundler path"
bundle config set --local path vendor/bundle
bundle config set --local without 'development test'

echo "==> Installing gems"
bundle install --jobs 4 --retry 3

echo "==> Precompiling assets"
bin/rails assets:precompile

echo "==> Cleaning assets"
bin/rails assets:clean

echo "==> Create database"
bin/rails db:create

echo "==> Migrating database"
bin/rails db:migrate

bin/rails db:seed