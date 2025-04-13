#!/usr/bin/env bash

restricted_branches=("main" "master" "production" "prod" "stag" "stage" "develop" "dev")

is_restricted_branch() {
  local branch=$1
  for restricted in "${restricted_branches[@]}"; do
    if [[ "$branch" == "$restricted" ]]; then
      return 0
    fi
  done
  return 1
}

if [[ "$BYPASS_HOOKS" == "true" ]]; then
  exit 0
fi

while read local_ref local_commit remote_ref remote_commit; do
  branch_name=$(basename "$local_ref")

  if is_restricted_branch "$branch_name"; then
    echo "pushing to '$branch_name' is not allowed unless you pass BYPASS_HOOKS=true"
    exit 1
  fi
done

exit 0
