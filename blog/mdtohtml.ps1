# Set working directory to the script's location
Set-Location -Path $PSScriptRoot

# Prompt for title
$title = Read-Host "Enter blog post title"
$date = Get-Date -Format "yyyy-MM-dd"
$slug = $title.ToLower() -replace '[^a-z0-9\s-]', '' -replace '\s+', '-' -replace '-+', '-'

# Paths (all relative to /blog/)
$mdPath = "posts/$date-$slug.md"
$htmlPath = "posts/$date-$slug.html"
$templatePath = "template/template.html"
$jsonPath = "posts.json"
$baseMd = "template/template.md"

# Create Markdown file from template if missing
if (-not (Test-Path $mdPath)) {
    Copy-Item $baseMd $mdPath
    Write-Host "Created $mdPath from template"
}

# Generate HTML
pandoc $mdPath --template=$templatePath --metadata=title="$title" --metadata=date="$date" -o $htmlPath
Write-Host "Converted to $htmlPath"

# Update posts.json
$json = Get-Content $jsonPath | ConvertFrom-Json
$newPost = [PSCustomObject]@{
    title    = $title
    date     = $date
    filename = "posts/$date-$slug.html"
}
$json = ,$newPost + $json
$json | ConvertTo-Json -Depth 3 | Set-Content $jsonPath -Encoding utf8
Write-Host "Updated posts.json"
