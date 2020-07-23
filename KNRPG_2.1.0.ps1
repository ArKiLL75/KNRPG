param(
$AppName = "KN-RPG",
$ScriptName = "KNRPG.ps1",
$Version = "2.1.0"
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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

$Script:okButton = New-Object System.Windows.Forms.Button
$Script:okButton.Location = New-Object System.Drawing.Point(20,320)
$Script:okButton.Size = New-Object System.Drawing.Size(50,23)
$Script:okButton.Text = 'OK'
$Script:okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $Script:okButton
$form.Controls.Add($Script:okButton)
 
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(320,320)
$cancelButton.Size = New-Object System.Drawing.Size(50,23)
$cancelButton.Text = 'Quit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$($form).ShowDialog()
}

$(Create-BaseBox)
"Ok Ok"
