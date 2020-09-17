@echo off

mkdir deploy

copy _res\connect.wav deploy
copy _res\disconnect.wav deploy
copy _res\net_properties.dll deploy
copy Win32\Release\ip_notification.exe deploy
copy README.md deploy

cd deploy
upx ip_notification.exe

7za a release-bin.zip *.*

pause
