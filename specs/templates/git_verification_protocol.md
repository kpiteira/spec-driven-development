# Git Operation Verification Protocol

## MANDATORY: Verified Git Operations Only

### Pre-Commit Verification
```bash
# REQUIRED: Stage files from implementation manifest only
while IFS= read -r file_path; do
    if [[ -f "$file_path" ]] && git diff --name-only HEAD | grep -q "^$file_path$"; then
        git add "$file_path"
        echo "✅ Staged: $file_path"
    else
        echo "❌ CRITICAL: Cannot stage $file_path - file missing or unchanged"
        exit 1
    fi
done < ".task_bundles/$TASK_ID/modified_files.txt"

# REQUIRED: Verify staging was successful
staged_files=$(git diff --cached --name-only | wc -l)
expected_files=$(wc -l < ".task_bundles/$TASK_ID/modified_files.txt")

if [[ $staged_files -ne $expected_files ]]; then
    echo "❌ CRITICAL: Staging failed - staged $staged_files but expected $expected_files"
    git reset  # Unstage everything
    exit 1
fi
```

### Commit Operation with Verification
```bash
# REQUIRED: Get commit SHA before attempting commit
pre_commit_sha=$(git rev-parse HEAD)

# REQUIRED: Commit with verification
if git commit -m "$commit_message"; then
    # REQUIRED: Verify commit was actually created
    post_commit_sha=$(git rev-parse HEAD)
    
    if [[ "$pre_commit_sha" == "$post_commit_sha" ]]; then
        echo "❌ CRITICAL: Commit command succeeded but no new commit created"
        exit 1
    fi
    
    # REQUIRED: Verify commit contains expected files
    committed_files=$(git show --name-only "$post_commit_sha" | tail -n +2)
    
    while IFS= read -r expected_file; do
        if ! echo "$committed_files" | grep -q "^$expected_file$"; then
            echo "❌ CRITICAL: Expected file $expected_file not in commit"
            exit 1
        fi
    done < ".task_bundles/$TASK_ID/modified_files.txt"
    
    echo "✅ Commit successful: $post_commit_sha"
    echo "$post_commit_sha" > ".task_bundles/$TASK_ID/verified_commit_sha.txt"
    
else
    echo "❌ CRITICAL: Git commit command failed"
    git status
    exit 1
fi
```

### Post-Commit Verification
```bash
# REQUIRED: Final verification of commit integrity
final_sha=$(git rev-parse HEAD)
verified_sha=$(cat ".task_bundles/$TASK_ID/verified_commit_sha.txt")

if [[ "$final_sha" != "$verified_sha" ]]; then
    echo "❌ CRITICAL: Commit SHA mismatch after verification"
    exit 1
fi

# REQUIRED: Update bundle status with verified information only
jq --arg sha "$final_sha" \
   --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")" \
   '.git_commit_sha = $sha | .validation_completed_at = $timestamp | .status = "completed"' \
   ".task_bundles/$TASK_ID/bundle_status.yaml.tmp" > ".task_bundles/$TASK_ID/bundle_status.yaml"
```

## Failure Recovery
```bash
# If any verification fails:
git reset --soft HEAD~1  # Undo commit if it was created
git reset                # Unstage files
echo "validation_failed" > ".task_bundles/$TASK_ID/validation_status.txt"
# Preserve bundle for debugging
```