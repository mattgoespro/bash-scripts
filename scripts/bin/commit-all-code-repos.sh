#!/bin/bash

# read -r -a repositories <(find . -mindepth 1 -name ".git" -type d -print0)
# echo $repositories

function has_unstaged_changes() {
	if git diff --quiet; then
		return 1
	else
		return 0
	fi
}

function has_staged_changes() {
	if git diff --cached --quiet; then
		return 1
	else
		return 0
	fi
}

while IFS= read -r -d '' repo_git_dir; do
	repo_dir="$(dirname "$repo_git_dir")"
	repo_name="$(basename "$repo_dir")"
	echo "Committing git repository '$repo_name' ..."

	cd "$repo_dir" || {
		echo "[error] $repo_name: failed to enter directory -> $repo_dir"
		exit 1 >>/dev/null
	}

	git add .
	git commit -m "backup"

	if ! git push --force; then
		echo "[error] $repo_name: failed to force-push changes"
		exit 1 >>/dev/null
	fi
done < <(find "$HOME/Desktop" -mindepth 1 -path "**/Code/**/.git" -not -path "**/Code/3rd Party/**/.git" -type d -print0)

echo -e "\nAll repositories pushed successfully."
exit 0 >>/dev/null
