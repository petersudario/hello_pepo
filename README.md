# Meet Pepo

## Descrição

Meet Pepo é um aplicativo iOS que permite explorar uma coleção personalizada de modelos 3D relacionados aos meus gostos e interesses, como personagens de jogos, animes e objetos colecionáveis. O app oferece visualização interativa dos modelos, descrição detalhada, reprodução de sons e experiência em Realidade Aumentada (AR).

Todos e sons e modelos que usei são gratuitos e não foram feitos por mim. Todos os links seguem anexados no arquivo `links_credit.txt` na root do projeto.

Os assets disponiveis no `Assets.xcassets` e na pasta `Images` foram criados por mim no Figma e com o ChatGPT. Favor dar créditos caso usar meu ícone em `Assets.xcassets`.

## Funcionalidades

- **Pré-visualização 3D** com rotação, zoom e interação sonora via SceneKit (`ModelPreviewView`) e integração SwiftUI (`ModelPreviewRepresentable`).
- **Lista de modelos** navegável na interface SwiftUI, mostrando nome, referência e permitindo alternar entre itens.
- **Detalhamento em modal sheet**, exibindo a descrição completa de cada item (`ContentView`).
- **Visualização em AR**: detecção de imagem marker e sobreposição de botões para som, usando ARKit (`ARImageTrackingViewController`).
- **Splash screen animada** com sprites físicos simulando queda e pop de imagens, antes de acessar o conteúdo principal (`PhysicsScene`, `SplashOverlay`).
- **Arquitetura moderna** baseada em SwiftUI, ARKit, SceneKit, SpriteKit e gerenciada via Swift Package Manager (SPM).

## Requisitos

- Xcode 16 ou superior
- iOS 17.0 ou superior
- Swift 6.0
- Dispositivo com câmera (para recursos de AR)

## Instalação

1. Clone este repositório:
   ```bash
   git clone https://github.com/petersudario/meet-pepo.git
   ```
2. Abra o projeto no Xcode:
   ```bash
   cd meet-pepo
   open Meet\ Pepo.xcodeproj
   ```
3. Selecione um destino compatível (iPhone/iPad com iOS 17+) e execute.

4. Imprima uma folha com a imagem na pasta `Images`, e aponte a câmera do iPhone para a folha.

Atenção: A realidade aumentada funciona melhor em dispositivos reais.


