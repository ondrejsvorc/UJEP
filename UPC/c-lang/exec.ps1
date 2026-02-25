param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $Arguments
)

[string] $ContainerName = "upc-dev-container"
[string] $WorkingDirectory = "/src/01-hello"

docker exec -w $WorkingDirectory $ContainerName @Arguments