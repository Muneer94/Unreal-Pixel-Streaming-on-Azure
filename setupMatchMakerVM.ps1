[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 

choco upgrade filezilla -yr --no-progress
choco upgrade git -yr --no-progress
choco upgrade nodejs -yr --no-progress
choco upgrade vcredist-all -yr --no-progress
choco upgrade directx -yr --no-progress

New-Alias -Name git -Value "$Env:ProgramFiles\Git\bin\git.exe" -Force

$folder = "c:\Unreal\"

if (-not (Test-Path -LiteralPath $folder)) {
    New-Item -ItemType Directory -Force -Path $folder
}
else {
    #rename the existing folder if exists
    $endtag = 'unreal-' + (get-date).ToString('MMddyyhhmmss')
    Rename-Item -Path $folder  -NewName $endtag -Force
    New-Item -ItemType Directory -Force -Path $folder
}

$zipFileName = 'Nextech UE4 PS Files - 3-9-21.zip'
$remoteStoragePath = 'Z:\' + $zipFileName
$zipFilePath = $folder + $zipFileName

Copy-Item $remoteStoragePath -Destination $folder
Expand-Archive -LiteralPath $zipFilePath -DestinationPath $folder

exit 0
