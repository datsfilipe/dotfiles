#!/bin/bash

protected_branches=(production develop stage main master)
current_branch=$(git symbolic-ref --short HEAD)
force_push=$(echo "$@" | grep -q -- "--force" && echo "yes" || echo "no")

for branch in "${protected_branches[@]}"; do
  if [[ "$current_branch" == "$branch" && "$force_push" != "yes" ]]; then
    echo "push to $branch is not allowed unless --force is added."
    exit 1
  fi
done

exit 0
