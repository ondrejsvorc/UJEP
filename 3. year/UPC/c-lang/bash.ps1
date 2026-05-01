$ContainerName = "upc-dev-container"

Write-Host "$ContainerName ..."
docker exec -it $ContainerName /bin/bash
Write-Host "... $ContainerName"