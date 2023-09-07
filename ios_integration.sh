flutter clean
flutter pub get

output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="16.4"

patrol build ios --target integration_test/tests/login --release

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
popd

# patrol test --target integration_test/tests/login --release --device 'iPhone de Cristiano'
# para pegar os dispositivos locais: patrol devices