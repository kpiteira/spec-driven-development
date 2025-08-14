# Validator Agent Discovery Protocol

## MANDATORY: Pre-Validation Discovery Phase

### Step 1: Implementation Manifest Discovery
```bash
# REQUIRED: Read implementation manifest first
if [[ -f ".task_bundles/$TASK_ID/implementation_manifest.json" ]]; then
    echo "✅ Implementation manifest found"
    # Parse manifest to understand what was actually implemented
else
    echo "❌ CRITICAL: Implementation manifest missing"
    echo "Cannot proceed with validation without knowing what was implemented"
    exit 1
fi
```

### Step 2: Git Status Discovery  
```bash
# REQUIRED: Discover actual file changes
git status --porcelain > ".task_bundles/$TASK_ID/git_status.txt"
git diff --name-only HEAD > ".task_bundles/$TASK_ID/modified_files.txt"

# Verify manifest matches reality
if [[ $(wc -l < ".task_bundles/$TASK_ID/modified_files.txt") -eq 0 ]]; then
    echo "❌ CRITICAL: No files actually modified despite implementation claim"
    exit 1
fi
```

### Step 3: File Existence Validation
```bash
# REQUIRED: Validate each file in manifest actually exists and is modified
while IFS= read -r file_path; do
    if [[ ! -f "$file_path" ]]; then
        echo "❌ CRITICAL: Manifest claims file $file_path modified but file doesn't exist"
        exit 1
    fi
    
    if ! git diff --name-only HEAD | grep -q "^$file_path$"; then
        echo "❌ CRITICAL: Manifest claims file $file_path modified but git shows no changes"
        exit 1
    fi
    
    echo "✅ Verified: $file_path exists and has changes"
done < ".task_bundles/$TASK_ID/modified_files.txt"
```

### Step 4: Test Discovery
```bash
# REQUIRED: Discover and validate test files
find . -name "*$TASK_ID*" -name "*.sh" -path "*/test*" > ".task_bundles/$TASK_ID/discovered_tests.txt"

# Verify tests exist if claimed in manifest
if jq -r '.tests_created[].path' ".task_bundles/$TASK_ID/implementation_manifest.json" | while read test_path; do
    if [[ ! -f "$test_path" ]]; then
        echo "❌ CRITICAL: Manifest claims test $test_path created but file doesn't exist"
        exit 1
    fi
done; then
    echo "✅ All claimed tests exist"
fi
```

## ONLY AFTER DISCOVERY: Proceed with Validation

- Discovery phase must complete successfully before any validation begins
- All discovered files must match implementation manifest
- Any mismatch is a CRITICAL ERROR requiring investigation