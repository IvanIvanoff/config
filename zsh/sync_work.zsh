################# GIT SYNC FUNCTION

sync_work() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Error: Not in a git repository"
        return 1
    fi

    # Get current branch name
    current_branch=$(git branch --show-current)

    # Check if we're on main or master branch
    if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
        echo "❌ Error: Cannot sync work on main/master branch"
        echo "Please switch to a feature branch first:"
        echo "  git checkout -b feature/your-branch-name"
        return 1
    fi

    echo "🔄 Syncing work on branch: $current_branch"

    # Check if there are any changes to commit
    if git diff --quiet && git diff --cached --quiet; then
        echo "ℹ️  No changes to commit"
    else
        # Add all files and commit
        echo "📝 Adding and committing changes..."
        git add .
        git commit -m "synced ongoing work"

        if [ $? -ne 0 ]; then
            echo "❌ Failed to commit changes"
            return 1
        fi
    fi

    # Push the branch
    echo "⬆️  Pushing to origin..."
    git push -u origin "$current_branch"

    if [ $? -ne 0 ]; then
        echo "❌ Failed to push to origin"
        return 1
    fi

    # Check if GitHub CLI is installed
    if ! command -v gh &> /dev/null; then
        echo "⚠️  GitHub CLI not installed. Cannot create PR automatically."
        echo "Install with: brew install gh (macOS) or visit: https://cli.github.com/"
        echo "✅ Branch synced successfully!"
        return 0
    fi

    # Check if there's already a PR for this branch
    echo "🔍 Checking for existing PR..."
    existing_pr=$(gh pr list --head "$current_branch" --json number --jq '.[0].number' 2>/dev/null)

    if [ -n "$existing_pr" ] && [ "$existing_pr" != "null" ]; then
        echo "ℹ️  PR #$existing_pr already exists for this branch"
        echo "🔗 View PR: $(gh pr view $existing_pr --json url --jq '.url')"
    else
        # Create a new PR
        echo "🚀 Creating new PR..."

        # Get the default branch (main or master)
        default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

        # Create PR with a basic template
        pr_title="Work in progress: $current_branch"
        pr_body="## Summary
This PR contains ongoing work from the $current_branch branch.

**Status:** 🚧 Work in Progress

## Changes
- Synced ongoing development work
- Auto-created by sync_work function

---
*This PR was automatically created. Please update the title and description as needed.*"

        pr_url=$(gh pr create --title "$pr_title" --body "$pr_body" --base "$default_branch" --head "$current_branch" --draft 2>/dev/null)

        if [ $? -eq 0 ]; then
            echo "✅ Draft PR created: $pr_url"
        else
            echo "⚠️  Could not create PR automatically. You may need to:"
            echo "   - Authenticate with GitHub CLI: gh auth login"
            echo "   - Or create the PR manually on GitHub"
        fi
    fi

    echo "✅ Sync completed successfully!"
    echo "📊 Summary:"
    echo "   Branch: $current_branch"
    echo "   Status: Pushed to origin"
    if [ -n "$existing_pr" ] && [ "$existing_pr" != "null" ]; then
        echo "   PR: #$existing_pr (existing)"
    elif [ -n "$pr_url" ]; then
        echo "   PR: Created (draft)"
    fi
}
################# END GIT SYNC FUNCTION
