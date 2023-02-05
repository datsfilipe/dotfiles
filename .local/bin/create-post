#!/usr/bin/env bash

# date
date=$(date +%Y-%m-%d)

# blog
postFilename="$HOME/www/personal/posts/$date/post-$date.md"
tagsFilename="$HOME/www/personal/posts/$date/tags-$date.md"

# if blogs, or personal, or www folder doesn't exist, create them
if [ ! -d "$HOME/www" ]; then
  mkdir -p "$HOME/www"
fi

if [ ! -d "$HOME/www/personal" ]; then
  mkdir -p "$HOME/www/personal"
fi

if [ ! -d "$HOME/www/personal/posts" ]; then
  mkdir -p "$HOME/www/personal/posts"
fi

if [ ! -d "$HOME/www/personal/posts/$date" ]; then
  mkdir -p "$HOME/www/personal/posts/$date"
else
  echo "Post already exists"
  exit 1
fi

cp "$HOME/www/personal/posts/post-template.md" $postFilename
echo "# [$date](./post-$date.md)" >> $tagsFilename

nvim -c "norm gg3l" \
  -c "startinsert" \
  $postFilename $tagsFilename
