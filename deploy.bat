@echo off

mkdir deploy

copy _res\connect.wav deploy
copy _res\disconnect.wav deploy
if exist _res\net_properties.dll (
  copy _res\net_properties.dll deploy
) else (
  echo "net_properties.dll must be added by hand for now, exiting."
  goto :exit
)
copy Win32\Release\ip_notification.exe deploy
copy README.md deploy
copy CHANGELOG.md deploy
copy LICENSE deploy

cd deploy
upx ip_notification.exe

7za a release-bin.zip *

:exit
pause
