#
# START of profile, echo $Me
Write-Host "In Customizations for [$($Host.Name)]"
Write-Host "On $(hostname)"
$ME = whoami
Write-Host "Logged on as $ME"

#
# Generic configurations
$FormatEnumerationLimit = 99
$PSDefaultParameterValues = @{
    '*:autosize'       = $true
    'Receive-Job:keep' = $true
    '*:Wrap'           = $true
}

#
# Set Vi-Mode, and rebind Escape key in PSReadLine for Vi-Mode.
Set-PSReadLineOption -EditMode Vi -ViModeIndicator None
#Set-PSReadLineKeyHandler -Key Ctrl+J+K -Function ViCommandMode //bug

#
# Customizations for module FZF
if ((Get-Command fzf*) -and (Get-InstalledModule -Name PSFzf)) {
    if (Get-Command fd*) {
        $env:FZF_DEFAULT_COMMAND="fd . "
        $env:FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        $env:FZF_ALT_C_COMMAND="fd -t d . "
    }

    Import-Module PSFzf
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    Set-PsFzfOption -TabExpansion 
    # replace 'ctrl+t' and 'ctrl+r' with your preferred bindings:
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    # print usage ( To view key bindings type: Get-PSReadLineKeyHandler )
    Write-Host "Press <c-t> to select provider paths."
    Write-Host "Press <c-r> to select a command history provided by PSReadline."
    Write-Host "Press <a-a> to select command arguments provided by PSReadline."
    Write-Host "Press <a-c> to change directory."
} else {
    Write-Warning 'Failed to locate fzf/PSFzf, try: Install-Module -Name PSFzf '
}


#
# useful alias
#
Function Func-Fda { fd -IH }
Set-Alias -Name fda -Value Func-Fda
Function Func-Rga { rg -uuu }
Set-Alias -Name rga -Value Func-Rga
Function Get-HelpDetailed { Get-Help $args[0] -Detailed }
Set-Alias -Name hd -Value Get-HelpDetailed
Set-Alias -Name gh -Value Get-Help
Set-Alias -Name vi -Value vim

#
# Script is done running.
Write-Host "Completed Customizations to $(hostname)."

