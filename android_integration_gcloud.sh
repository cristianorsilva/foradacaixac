flutter clean
flutter pub get

date_time_run=$(date +"%d_%m_%Y %H:%M:%S")

patrol build android --target integration_test/tests/pix

gcloud firebase test android run \
    --type instrumentation \
    --use-orchestrator \
    --app build/app/outputs/apk/debug/app-debug.apk \
    --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
    --device-ids=crownqlteue \
    --os-version-ids=29 \
    --orientations=portrait \
    --timeout 1m \
    --results-bucket=gs://fora-da-caixa-0001.appspot.com \
    --results-dir=android/tests/"$date_time_run"

# para pegar a lista de dispositivos disponíveis: gcloud firebase test android models list
# para pegar o caminho do results-bucket, ir no firebase storage, e ver os detalhes do projeto. Copie a url criada
# para rodar teste local: patrol test --target integration_test/tests/pix --device 'sdk gphone64 arm64'