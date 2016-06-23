# 管理者権限で開いたPowerShellにて, 以下を手動で実行する
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
