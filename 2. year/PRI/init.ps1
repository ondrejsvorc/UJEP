$folderName = Read-Host "Enter the new project folder name"
Write-Host "Creating project: $folderName"

$dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
if (-not $dockerProcess) {
    Write-Host "Starting Docker Desktop..."
    Start-Process "C:\Program Files\Docker\Docker\frontend\Docker Desktop.exe" -WindowStyle Hidden
}

$newFolderPath = Join-Path (Get-Location) $folderName
New-Item -Path $newFolderPath -ItemType Directory -Force | Out-Null
New-Item -Path (Join-Path $newFolderPath "src") -ItemType Directory -Force | Out-Null
New-Item -Path (Join-Path $newFolderPath "public") -ItemType Directory -Force | Out-Null

$indexPhpPath = Join-Path (Join-Path $newFolderPath "src") "index.php"
"<?php echo 'Hello, World!'; ?>" | Out-File -FilePath $indexPhpPath -Encoding UTF8 -NoNewline

$dockerFilesDir = Join-Path (Get-Location) "docker-files"
Copy-Item -Path (Join-Path $dockerFilesDir "docker-compose.yaml") -Destination $newFolderPath -Force | Out-Null
Copy-Item -Path (Join-Path $dockerFilesDir "Dockerfile") -Destination $newFolderPath -Force | Out-Null

while ($true) {
    Write-Host "Waiting for Docker to start..."
    $dockerStatus = docker info 2>$null
    if ($dockerStatus -match "Containers:") { break }
    Start-Sleep -Milliseconds 500
}
Write-Host "Docker is running."

Write-Host "Opening project in VS Code..."
$vsCodePath = "C:\Users\ondre\AppData\Local\Programs\Microsoft VS Code\Code.exe"
Start-Process $vsCodePath -ArgumentList $newFolderPath -WindowStyle Hidden

Write-Host "Starting GitHub Desktop..."
Start-Process -FilePath "C:\Users\ondre\AppData\Local\GitHubDesktop\GitHubDesktop.exe"

Write-Host "Starting Docker containers..."
Push-Location $newFolderPath
docker-compose up --build -d *> $null 2>&1
Pop-Location

Write-Host "Opening web services..."
Start-Process "chrome.exe" "http://localhost:8080/"
Start-Process "chrome.exe" "http://localhost:8000/"
Write-Host "Setup complete."