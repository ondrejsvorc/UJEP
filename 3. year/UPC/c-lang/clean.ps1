[string] $RootPath = Get-Location

Get-ChildItem -Path $RootPath -Directory | ForEach-Object {
    Push-Location $_.FullName
    try {
        make clean
    }
    finally {
        Pop-Location
    }
}