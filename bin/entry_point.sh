#!/bin/bash

CONFIG_FILE=_config.yml

# Function to manage Gemfile.lock
manage_gemfile_lock() {
    git config --global --add safe.directory /srv/jekyll
    if command -v git &> /dev/null && [ -f Gemfile.lock ]; then
        if git ls-files --error-unmatch Gemfile.lock &> /dev/null; then
            echo "Gemfile.lock is tracked by git, keeping it intact"
            git restore Gemfile.lock 2>/dev/null || true
        else
            echo "Gemfile.lock is not tracked by git, removing it"
            rm Gemfile.lock
        fi
    fi
}

start_jekyll() {
    manage_gemfile_lock
    jekyll serve --watch --port=8080 --host=0.0.0.0 --livereload --verbose --trace --force_polling &
    jekyll_pid=$!
}

trap 'kill "$jekyll_pid" 2>/dev/null || true' EXIT INT TERM
start_jekyll

while true; do
    inotifywait -q -e modify,move,create,delete $CONFIG_FILE
    if [ $? -eq 0 ]; then
        echo "Change detected to $CONFIG_FILE, restarting Jekyll"
        kill -TERM "$jekyll_pid" 2>/dev/null || true
        wait "$jekyll_pid" 2>/dev/null || true
        start_jekyll
    fi
done
