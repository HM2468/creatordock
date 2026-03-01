#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./bin/console_render.sh
# or:
#   DATABASE_URL=... RAILS_MASTER_KEY=... SECRET_KEY_BASE=... ./bin/console_render.sh
#
# Optional: put env vars into .env.render and keep it OUT of git.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Load local env file if present (DO NOT commit this file)
if [[ -f ".env.render" ]]; then
  set -a
  # shellcheck disable=SC1091
  source ".env.render"
  set +a
fi

: "${DATABASE_URL:?DATABASE_URL is required (Render Postgres External URL)}"

# Use production env to mimic deployed behavior
export RAILS_ENV="${RAILS_ENV:-production}"

# These two are optional, but often needed when production credentials are used.
# Uncomment the checks if your app requires them.
# : "${RAILS_MASTER_KEY:?RAILS_MASTER_KEY is required to decrypt credentials}"
# : "${SECRET_KEY_BASE:?SECRET_KEY_BASE is required}"

echo "==> Starting Rails console (RAILS_ENV=$RAILS_ENV)"
echo "==> Using DATABASE_URL host: $(python - <<'PY'
import os, urllib.parse
u = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(u.hostname or "")
PY
)"
echo "==> Note: this console targets the REMOTE database. Be careful."

exec bin/rails console
