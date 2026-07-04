NOTES_DIR="${NOTES_DIR:?NOTES_DIR must be set}"
NOTES_REMOTE="${NOTES_REMOTE:?NOTES_REMOTE must be set}"

export GIT_SSH_COMMAND="ssh -o BatchMode=yes"

if [ ! -e "$NOTES_DIR/.git" ]; then
  if [ -e "$NOTES_DIR" ] && [ -n "$(ls -A "$NOTES_DIR" 2>/dev/null)" ]; then
    echo "notes: $NOTES_DIR exists but is not a git repo, refusing to touch it" >&2
    exit 0
  fi
  echo "notes: cloning $NOTES_REMOTE into $NOTES_DIR"
  git clone "$NOTES_REMOTE" "$NOTES_DIR"
  exit 0
fi

cd "$NOTES_DIR"

if [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

messages=(
  "checkpoint"
  "wip"
  "autosave"
  "notes go brrr"
  "just in case"
  "another one"
  "saving my brain"
  "todo: better message"
  "snapshot"
  "keep"
)
msg="${messages[$((RANDOM % ${#messages[@]}))]}"

git add -A
git commit -m "$msg"

git push || echo "notes: push failed (offline or no auth), commit kept locally" >&2
