# foradacaixac

Projeto com Patrol Testing

Fora da Caixa é um app desenvolvido para auxiliar no treinamento de Analistas de testes;
O app simula um aplicativo bancário com algumas funcionalidades 'implementadas';
Os dados são salvos localmente numa base de dados, e toda vez que o app é removido a base é removida também;
Projeto roda em Android e iOS;


## Comandos para verificar versões

    detalhes gerais: flutter doctor -v
    verificar versão do flutter: flutter --version
    local de instalação do flutter: where flutter 
    verificar versão do dart: dart --version
    local de instalação do dart: where dart

## Getting Started

    Users para logar:
        CPF: 929.035.400-39
        CPF: 050.209.090-17
        CPF: 971.147.000-40

    Users para transferir pix: 
        Os mesmos acima. 
        Dica 1: cadastre chaves pix para os usuários e use elas;
        Dica 2: os CPFs em si já estão cadastrados como chave pix por default;
    
    Senha para logar com os users: 
        172839
    Token válido para cadastrar chave pix: 
        123456 (qualquer outro é considerado inválido)    
    Pin válido: 
        1234

## O que esse app faz?

    App simula um aplicativo financeiro, com as seguintes funcionalidades:
        Login:
            Valida usuários válidos e inválidos e informa ao usuário;
            Durante o primeiro login solicita ao usuário permissão de Localização;
        Transferência pix:
            Processo completo de transferência com debito em conta;
            Agendamento de transferência pix;
            Comprovante de transferência pix;
        Cadastro de alguns tipos de chaves pix:
            Algumas chaves podem ser cadastradas, outra não;
        Histórico de transferências e recebimentos:
            Ao tocar no saldo do usuário é possível visualizar o histórico;
        Diversos bugs e pontos de melhorias:
            Este é um app de treinamento para QAs, nada melhor que alguns bugs para cadastrar :)


## Para gerar apk de debug

    flutter build apk --debug

## Para rodar o projeto em modo release (útil quando rodar em device físico iOS)

    flutter run --release

## Patrol Testing (configurações úteis para rodar a automação)
    
    Fontes abaixo mostram as configurações necessárias
        https://pub.dev/packages/patrol
        https://patrol.leancode.co/
        https://pub.dev/documentation/patrol/latest/
    Para obter o package_name (android):
        Acesse android/app/build.gradle;
        O item applicationId é o package_name para utilizar
            c.foradacaixa.foradacaixac
    Para obter o bundle_id (ios):
        Abra o 'Runner.xcworkspace' do diretório ios no Xcode;
        Acesse a tab Build Settings e procure por Product Bundle Identifier
            c.foradacaixa.foradacaixac
    Para saber o patrol_client instalado:
        patrol --version
    Se patrol_client não está instalado:
        dart pub global activate patrol_cli

    Antes de tudo, é preciso criar os diretórios 'integration_test
        Em 'test_driver' criar o arquivo integration_test.dart
        Em 'integration_test' criar o diretório 'screens'
            No diretório 'screens' haverão arquivos estilo 'page_object' (todos com sufixo _screen)
        Em 'integration_test criar o diretório 'tests'
            No diretório 'tests' haverão arquivos de testes propriamente ditos
    
    Dentro do diretório integration_test/tests é preciso organizar os testes por 'Features':
        Login: contém os testes de login (1 teste por arquivo .dart)
        Pix: contém os testes de pix (1 teste por arquivo .dart)

## Configurando a integração com Android
    
    Seguindo a sessão 'Integrate with native side' do https://patrol.leancode.co/getting-started
        Criado em android/app/src/androidTest/java/c/foradacaixa/foradacaixac o arquivo 'MainActivityTest.java'
        Atualizado android/app/build.gradle
        Atualizado pubspec.yaml com a seção do patrol
        
## Executando os testes localmente
    
    Para rodar os testes da feature Login:
        patrol test --target integration_test/tests/login/
    Para rodar os testes da feature Pix:
        patrol test --target integration_test/tests/pix/
    Para visualizar o resultado dos testes:
        Acessar menu Run > Import tests from file
        Abrir o arquivo 'test-result.pb' do caminho build/app/outputs/androidTest-results/connected
    Outra opção para visualizar os resultados:
        build/app/reports/androidTests/connected/index.html
    
## Firebase Testlab (Configuração Android)
    
    Arquivos .sh criados com o auxílio de:
        https://github.com/leancodepl/patrol/blob/master/packages/patrol/example/run_android_testlab
        https://patrol.leancode.co/ci/firebase-test-lab
    Comando para criar os apks com o ponto de entrada (entry points) dos testes desejados:
        Testes da Feature Login:
            patrol build android --target integration_test/tests/login
        Testes da Feature Pix:
            patrol build android --target integration_test/tests/pix

## Firebase TestLab (Subindo os apks para testar Android)

    Acesse e logue em https://console.firebase.google.com/ com uma conta google.
    Adicione um novo projeto e acesso o item de menu Test Lab e clique no botão 'Executar um teste'
    Selecione a opção 'Instrumentação' Suba os 2 apks nos locais correspondentes
    Selecione o device desejado e confirme
    Inicie o teste e aguarde o resultado

## Integrando Testlab e Google Cloud (Para testar Android)

    Acesse e faça cadastro em https://cloud.google.com/
    Acesse Console e em seguida Cloud Storage
    É preciso configurar o gcloud CLI na máquina, para isso acesse https://cloud.google.com/sdk/docs/install
    Abaixo alguns comandos úteis:
        Para visualizar a versão instalada: gcloud -v
        Para visualizar todos os devices android disponíveis no gcloud: gcloud firebase test android models list 
    É preciso estar com o gcloud CLI corretamente configurado na máquina para poder prosseguir
    Para utilizar o Firebase Test Lab e o Cloud Storage integrados, utilize o arquivo android_integration_gcloud.sh
    Antes de executar o arquivo, é preciso configurá-lo para apontar para seu bucket, além de informar o device desejado
    O comando para executar no terminal é ./android_integration_gcloud.sh
    Em caso de erro de permissão de arquivo .sh, basta executar o comando abaixo antes para dar permissão:
            chmod +x android_integration_gcloud.sh
    Se nenhum erro ocorrer:
        apks serão gerados e subidos automaticamente no firebase test lab
        os testes desse apk serão executados
        o resultado da execução do teste será visível no bucket informado no arquivo bem como no terminal

## Configurando a Integração com o iOS

    Seguindo a sessão 'Integrate with native side' do https://patrol.leancode.co/getting-started/native
        Abrir o ios/Runner.xcworkspace no Xcode
        No Xcode, através do caminhho File > New > Target...
            Selecionar a opção UI Testing Bundle
            Trocar o Product Name para RunnerUITests
            Certificar-se que Target to be Tested está setado para Runner
            Certificar-se que a Language está setado para Objective-C
            Clique em Finish
        RunnerUITest.m e RunnerUITestsLaunchTests.m serão criados
        Excluir através do Xcode o arquivo RunnerUITestsLaunchTests.m
        Certifique-se que o iOS Deployment Target possui a mesma versão para RunnerUITests e Runner (setar ambos para 13.0)
        Atualizar o conteúdo de RunnerUITests.m conforme solicitado na página
        Atualizar o ios/Podfile conforme solicitado na página
        No Android studio:
            Criar o arquivo integration_test/example_test.dart
            Executar o comando no terminal: flutter build ios --config-only integration_test/example_test.dart
            Abrir um terminal no caminho ios e executar: pod install --repo-update
        De volta ao Xcode, abrir Runner.xcworkspace:
            Certifique-se que as configurações de Build estão corretas (sessão Configurations)
            Adicionar novos 'Run Script Phase' no RunnerUITests target na sessão Build Phases:
                xcode_backend build
                xcode_backend embed_and_thin
            Adicione os códigos requeridos nessas duas novas Build Phases
        Desabilite a 'execução paralela' conforme mostrado no video da página
    Para testar as configurações, selecione um simulador iOS e execute no terminal o comando abaixo:
        patrol test -t integration_test/tests/login/successful_login_test.dart
        (ou algum outro arquivo de teste)


## Firebase TestLab (Configurações iOS - requer plataforma macOS)

    Arquivos .sh criados com o auxílio de:
        https://github.com/leancodepl/patrol/blob/master/packages/patrol/example/run_android_testlab
        https://patrol.leancode.co/ci/firebase-test-lab

### OBSERVAÇÃO
        Para execução em dispositivo físico iOS pode haver problemas de signing. 
        Apenas conecte o device fisico, selecione, e execute um clean no projeto, o quanto for necessário

## Firebase TestLab (Subindo o .zip para testar iOS)

    Acesse e logue em https://console.firebase.google.com/ com uma conta google.
    Adicione um novo projeto e acesso o item de menu Test Lab e clique no botão 'Executar um teste'
    Selecione a opção 'XCTest' Suba o .zip e selecione a versão do Xcode correspondente (deve ser a mesma instalada no mac)
    Selecione o device desejado e confirme
    Inicie o teste e aguarde o resultado 

## Integrando Testlab e Google Cloud (Para testar iOS)

    TestLab possui somente devices físicos, então o foco será mostrar as configurações de .sh para device físico
    Executar o comando ./ios_integration_gcloud.sh
    Em caso de erro de permissão de arquivo .sh, basta executar o comando abaixo antes para dar permissão:
            chmod +x ios_integration_gcloud.sh
    Se nenhum erro ocorrer:
        .zip será gerado e subido automaticamente no firebase test lab
        os testes desse .zip serão executados
        o resultado da execução do teste será visível no bucket informado no arquivo bem como no terminal



## Dica para modificar ícones dos apps
    https://medium.com/flutter-community/change-flutter-app-launcher-icon-59c31bcd7554