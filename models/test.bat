
rem para ativar o web-server fazer:
rem chromedriver --port=4444

rem flutter driver --driver=test_driver/integration_test.dart  --target=integration_test/tabpreco_por_cliente_test.dart -d web-server

:loop
rem call flutter pub upgrade
cls
call flutter test
CHOICE /C SN /N /T 30 /D S /M "hummmm"
goto :loop