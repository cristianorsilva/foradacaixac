flutter clean
flutter pub get

output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="17.2"

date_time_run=$(date +"%d_%m_%Y_%H:%M:%S")

patrol build ios --target integration_test/tests/pix --release

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
popd


gcloud firebase test ios run --test "build/ios_integ/Build/Products/ios_tests.zip" \
  --device model=iphone13pro,version=15.7,locale=en_US,orientation=portrait \
  --xcode-version=15.0 \
  --timeout 4m \
  --results-bucket=gs://fora-da-caixa-0001.appspot.com \
  --results-dir=ios/tests/"$date_time_run"


# para pegar a lista de dispositivos disponíveis: gcloud firebase test ios models list
# para pegar o caminho do results-bucket, ir no firebase storage, e ver os detalhes do projeto. Copie a url criada
# para pegar os dispositivos locais: patrol devices
