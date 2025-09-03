<img src="Media/Logo.png" alt="PetZone Logo" width="300"/>

# PetZone

![Swift](https://img.shields.io/badge/Swift-5.7-orange?logo=swift)
![UIKit](https://img.shields.io/badge/UIKit-iOS15.0-blue)

---

## 📃 Descrição

O **PetZone** é um aplicativo iOS desenvolvido em **Swift** com **UIKit** para compras online de produtos de pet shop. Utiliza o **ParseSwift** para integração com o backend **Back4App**, gerenciando produtos, carro de compras, autenticação e pagamentos.

O projeto segue a arquitetura **MVC (Model-View-Controller)**, com **Model** para lógica de negócios, **View** para interface, e **Controllers** para interação entre views e modelos, usando protocolos para modularidade.

A interface é intuitiva, com navegação fluida, animações e responsividade para diferentes telas.

---

## 💻 Tecnologias Utilizadas

- **Swift** → Linguagem de programação para desenvolvimento iOS.
- **UIKit** → Framework para construção de interfaces de usuário (suporte a iOS 15.0+). [Saiba mais sobre UIKit](https://developer.apple.com/documentation/uikit).
- **ParseSwift** → SDK para integração com o backend Back4App. [Saiba mais sobre ParseSwift](https://github.com/parse-community/Parse-Swift).
- **SpriteKit** → Framework para animações 2D, usado na animação do carro de compras.
- **CoreData** → Persistência local de dados.
- **URLSession** → Comunicação com APIs para carregamento de imagens.
- **NSCache** → Cache de imagens para otimização de desempenho.

---

## 🛎️ Funcionalidades

### 🔹 Autenticação
- Login com validação de email e senha via Back4App.
- Registro de novos usuários com validação de nome, email e senha.
- Recuperação de senha via e-mail.
- Logout seguro.

### 🔹 Catálogo de Produtos
- Visualização de produtos com:
  - Nome
  - Preço
  - Imagem
  - Indicador de estoque ("Esgotado" para produtos sem estoque).
- Detalhes do produto em alertas, incluindo:
  - Código
  - Descrição
  - Quantidade
  - Categoria
  - Validade

### 🔹 Carro de Compras
- Adição de produtos com validação de estoque.
- Exibição de itens com nome, preço e quantidade.
- Cálculo automático do total do carro de compras.
- Animação de adição ao carro de compras com **SpriteKit**.

### 🔹 Pagamento
- Métodos de pagamento:
  - **Pix**: Geração de código de pagamento copiado para a área de transferência.
  - **Cartão de Crédito**: Formulário para dados do cartão (número, nome, validade, CVV).
- Confirmação de pagamento com alertas e atualização de estoque.
- Limpeza do carro de compras após pagamento.

### 🔹 Menu Lateral
- Exibe o nome do usuário logado.
- Opções para acessar a tela "Sobre" e realizar logout.

### 🔹 Gerenciamento de Estados
- **Loading**: Indicadores de carregamento para operações assíncronas.
- **Success**: Exibição de dados carregados.
- **Error**: Tratamento de erros com mensagens amigáveis.
- **Toast Messages**: Notificações visuais para ações como envio de email.

### 🔹 Navegação
- Navegação fluida com `UINavigationController`.
- Transições animadas entre telas (Welcome, Login, Register, Home, Cart, Payment, About).
- Menu lateral animado com sombra e toque para fechar.

---

## 📱 Responsividade

- Interface adaptada com **Auto Layout** e **Safe Area Layout Guides**.
- Componentes visuais (botões, imagens, textos) ajustados dinamicamente com `NSLayoutConstraint`.
- Suporte a modo claro e escuro do iOS.

---

## ▶️ Como Rodar o Projeto

### Pré-requisitos
- **Xcode** (versão 14.0 ou superior).
- **Dispositivo iOS** ou simulador (iOS 15.0 ou superior).
- Conta no [Back4App](https://www.back4app.com/) configurada com chaves de API.

### Clone o repositório

- git clone https://github.com/seu-user/seu-projeto-app.git

### Abra o projeto no Xcode

- Abra o Xcode.
- Selecione File > Open e escolha o arquivo .xcodeproj ou .xcworkspace na pasta do projeto.
- Aguarde o Xcode processar os arquivos e indexar o projeto.

### Configure o Back4App

- Acesse o Back4App Dashboard.
- Crie um novo aplicativo ou selecione um existente.
- Copie as chaves Application ID e Client Key do Back4App.
- No Xcode, abra o arquivo de configuração (geralmente AppDelegate.swift ou Configuration.swift) e adicione as chaves:
swiftimport Parse

  ```bash
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      let configuration = ParseClientConfiguration {
          $0.applicationId = "SUA_APPLICATION_ID"
          $0.clientKey = "SUA_CLIENT_KEY"
          $0.server = "https://parseapi.back4app.com"
      }
      Parse.initialize(with: configuration)
      return true
  }
- Habilite os serviços necessários no Back4App Dashboard (ex.: Database, Cloud Code, ou outros, conforme o projeto).

### Instale as dependências

#### Se o projeto usar CocoaPods:
- Certifique-se de ter o CocoaPods instalado (sudo gem install cocoapods).
- Na pasta do projeto, execute:
- bashpod install
- Abra o arquivo .xcworkspace gerado pelo CocoaPods no Xcode.

#### Se o projeto usar Swift Package Manager:
- No Xcode, vá em File > Add Packages e adicione as URLs dos pacotes necessários (ex.: ParseSwift).
- Aguarde o Xcode resolver e baixar as dependências.

### Simulador

- No Xcode, selecione um simulador no menu superior (ex.: iPhone 14 Pro com iOS 16 ou superior).
- Clique no botão Run (ícone de play) ou pressione Cmd + R para iniciar o simulador.

### Dispositivo físico

#### Via cabo USB

- Conecte o dispositivo iOS ao Mac via cabo USB.
- Habilite o Modo Desenvolvedor no dispositivo (Configurações > Privacidade e Segurança > Modo Desenvolvedor).
- No Xcode, selecione o dispositivo físico no menu superior.
- Se necessário, assine o aplicativo com sua Apple Developer Account:

  - Vá em Xcode > Settings > Accounts e adicione sua conta.
  - Em Signing & Capabilities, selecione sua equipe de desenvolvimento.

#### Via Wi-Fi

- Certifique-se de que o dispositivo e o Mac estão na mesma rede Wi-Fi.
- No Xcode, vá em Window > Devices and Simulators.
- Selecione o dispositivo conectado via USB e marque a opção Connect via Network.
- Desconecte o cabo USB; o dispositivo permanecerá disponível para deploy sem fio.

### Rode o app

- Selecione o simulador ou dispositivo físico no menu superior do Xcode.
- Clique em Run (ícone de play) ou pressione Cmd + R ou alternativamente, no terminal, use:
  ```bash
    xcodebuild -workspace seu-projeto-app.xcworkspace -scheme SeuProjeto -destination 'platform=iOS Simulator,name=iPhone 14 Pro' build

---

## 🎥 Apresentação do Aplicativo

Confira a apresentação do aplicativo:  

- [Apresentação](https://youtu.be/xgrYM1RJArE)
