#!/bin/bash

# read -r -a repositories <(find . -mindepth 1 -name ".git" -type d -print0)
# echo $repositories

while IFS= read -r -d '' repo_git_dir; do
	repo_dir="$(dirname "$repo_git_dir")"
	repo_name="$(basename "$repo_dir")"
	echo "Committing git repository '$repo_name'"

	cd "$repo_dir" || {
		echo "error: unable to navigate to repository '${repo_dir}'"
		exit 1 >>/dev/null
	}

	if ! git add .; then
		echo "error: unable to stage files for commit"
		exit 1 >>/dev/null
	fi

	if ! git commit -m "backup"; then
		echo "error: unable to commit staged files"
	fi

	if ! git push --force; then
		echo "error: failed to push changes"
		exit 1 >>/dev/null
	fi
done < <(find ~+ -mindepth 1 -name ".git" -type d -print0)
