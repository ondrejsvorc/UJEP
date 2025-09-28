$rootPath = "C:\Users\ondre\source\repos\git\UJEP\CAS"
$outputFile = Join-Path $rootPath "merged_output_cas.r"

# Get all .r files recursively from the specified path
Get-ChildItem -Path $rootPath -Recurse -Filter *.r | Sort-Object FullName | ForEach-Object {
    if (Test-Path $_.FullName) {
        "### Start of $($_.FullName)`n" +
        (Get-Content $_.FullName -Raw) +
        "`n### End of $($_.FullName)`n"
    } else {
        "### Skipped missing file: $($_.FullName)`n"
    }
} | Set-Content -Encoding UTF8 $outputFile

Read-Host -Prompt "Merging complete. Press Enter to exit"