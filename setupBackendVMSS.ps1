[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 

choco upgrade directx -yr --no-progress

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

$connectTestResult = Test-NetConnection -ComputerName d88bcstoracct1.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"d88bcstoracct1.file.core.windows.net`" /user:`"Azure\d88bcstoracct1`" /pass:`"0UMWfVn7HpP7FeDq7njUtg/EELN4P53+hD3ew0AhxCEvVXgIDQtgovSBRMLnU/9+4W+cbguAfY0stkqat3II/g==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\d88bcstoracct1.file.core.windows.net\ntarunrealfs" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

$zipFileName = 'Nextech UE4 PS Files - 3-9-21.zip'
$remoteStoragePath = 'Z:\' + $zipFileName
$zipFilePath = $folder + $zipFileName

Copy-Item $remoteStoragePath -Destination $folder
Expand-Archive -LiteralPath $zipFilePath -DestinationPath $folder

exit 0

Remove-Item C:\ProgramData\chocolatey -Recurse

Start-Process -NoNewWindow 'c:\Unreal\Nextech UE4 PS Files - 3-9-21\WindowsNoEditor\NexTechAR.exe' -AudioMixer -PixelStreamingIP=localhost -PixelStreamingPort=8888 -RenderOffScreen
