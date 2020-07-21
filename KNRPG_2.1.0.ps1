param(
$AppName = "KN-GameStation",
$Version = "1.0.1",
$repositoryroot = "https://github.com",
$repositoryfolder = "ArKiLL75/KNGameStation",
$WavBannerPath = "269595.wav",
$PictureBannerPath = 'Dwarfmini.png',
#$Script:CountDown = 5,
$GooGleDNS = "8.8.8.8"
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Test-UpdateServerConnexion
{
If($(Invoke-WebRequest -Uri $($repositoryroot + "/" + $repositoryfolder) -UseBasicParsing -ErrorAction SilentlyContinue)){Return "OK"}
Else{Return "KO"}
}
Function Test-InternetConnexion
{
If(Test-Connection $GoogleDNS -ErrorAction SilentlyContinue -Count 1){Return "OK ($(Get-PublicIP))"} #
Else{Return "KO"}
}
Function Test-NetWorkConnexion
{
if($NetworkLocal = Get-NetIPConfiguration | ?{$_.NetAdapter.Status -ne "Disconnected"} -ErrorAction SilentlyContinue){Return "OK ($($NetworkLocal.IPv4Address.IPAddress))"}
Else{Return "KO"}
}

Function Get-PublicIP
{
(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
}

Function Start-ProgressBar
{
    While ($i -le 100) {
        $progress.Value = $i
        Start-Sleep -m 1
        $i
        $i += 1
        }
}

Function Check-Connections
{
#Sleep 1
$labelNetWork.Text = "Network  : $(Test-NetWorkConnexion)"
$form.Controls.Add($labelNetWork)

$labelWeb.Text = "Internet : $(Test-InternetConnexion)"
$form.Controls.Add($labelWeb)

$labelServer.Text = "Server   : $(Test-UpdateServerConnexion)"
$form.Controls.Add($labelServer)

If($labelServer.Text -match "OK")
{
$labelUpdate.Text = Check-Update
$form.Controls.Add($labelUpdate)

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(20,120)
$progress.Size = New-Object System.Drawing.Size(280,20)
$progress.Maximum = 100
$progress.Minimum = 0
$i = 0
$form.Controls.Add($progress)

$updateButton = New-Object System.Windows.Forms.Button
$updateButton.Location = New-Object System.Drawing.Point(20,65)
$updateButton.Size = New-Object System.Drawing.Size(50,23)
$updateButton.Text = 'Update'
$updateButton.Add_Click(
       {
    Start-ProgressBar
       })
$form.AcceptButton = $updateButton
$form.Controls.Add($updateButton)
}
$TimerCheckUpdate.Stop()
$TimerCheckUpdate.Dispose() 
}

Function Check-Update
{
$r = $(Invoke-WebRequest -Uri $($repositoryroot + "/" + $repositoryfolder) -UseBasicParsing -ErrorAction SilentlyContinue).Links |?{$_.title -match ".ps1"}
If(($r.Title.split("_")[1]).Replace(".ps1","") -gt $Version)
{
$BoxTextVersion = $("Version "+ $($r.Title.split("_")[1]).Replace('.ps1','')) + " available."
}
Else{$BoxTextVersion = "No Update available."}
$BoxTextVersion
}

Function Create-BaseBox
{
param(
$BoxText = "base"
)
$form = New-Object System.Windows.Forms.Form
$form.MaximizeBox = $False
$form.MinimizeBox = $False
$form.Text = $AppName
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(20,320)
$okButton.Size = New-Object System.Drawing.Size(50,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)
 
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(320,320)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$form
}

Function Add-UpdateBox
{
param
(
$form
)
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(20,20)
$label1.Size = New-Object System.Drawing.Size(280,20)
$label1.Text = "Checking Connection ..."
$form.Controls.Add($label1)

$labelNetWork = New-Object System.Windows.Forms.Label
$labelNetWork.Location = New-Object System.Drawing.Point(20,40)
$labelNetWork.Size = New-Object System.Drawing.Size(280,20)


$labelWeb = New-Object System.Windows.Forms.Label
$labelWeb.Location = New-Object System.Drawing.Point(20,60)
$labelWeb.Size = New-Object System.Drawing.Size(280,20)


$labelServer = New-Object System.Windows.Forms.Label
$labelServer.Location = New-Object System.Drawing.Point(20,80)
$labelServer.Size = New-Object System.Drawing.Size(280,20)

$labelUpdate = New-Object System.Windows.Forms.Label
$labelUpdate.Location = New-Object System.Drawing.Point(20,100)
$labelUpdate.Size = New-Object System.Drawing.Size(280,20)


$TimerCheckUpdate = New-Object System.Windows.Forms.Timer
$TimerCheckUpdate.Interval = 1000
#$Script:CountDownCheckUpdate = 1
$TimerCheckUpdate.Add_Tick({Check-Connections})
$TimerCheckUpdate.Start()

$($form).ShowDialog()
}
Add-UpdateBox $(Create-BaseBox)
