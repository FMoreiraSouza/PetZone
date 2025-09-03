# PetZone App

![Swift](https://img.shields.io/badge/Swift-5.7-orange?logo=swift)
![UIKit](https://img.shields.io/badge/UIKit-iOS-blue)

---

## 📃 Descrição

O **PetZone App** é um aplicativo iOS desenvolvido em **Swift** com **UIKit** para oferecer uma experiência de compras online voltada para produtos de pet shop. Ele utiliza o **ParseSwift** para integração com o backend Back4App, permitindo gerenciamento de produtos, carrinho de compras, autenticação de usuários e pagamentos. 

O projeto segue uma arquitetura modular com serviços bem definidos, separando responsabilidades entre interface de usuário, lógica de negócios e integração com o backend. A aplicação é responsiva, adaptando-se a diferentes tamanhos de tela de dispositivos iOS, e inclui animações visuais para melhorar a experiência do usuário.

---

## 💻 Tecnologias Utilizadas

- **Swift** → Linguagem de programação para desenvolvimento iOS.
- **UIKit** → Framework para construção de interfaces de usuário.
- **ParseSwift** → SDK para integração com o backend Back4App.
- **SpriteKit** → Framework para animações 2D, usado na animação do carrinho.
- **CoreData** → Persistência local de dados.
- **URLSession** → Comunicação com APIs para carregamento de imagens.
- **NSCache** → Cache de imagens para otimização de desempenho.

---

## 🛎️ Funcionalidades

### 🔹 Autenticação
- **Login**: Validação de email e senha com integração ao Back4App.
- **Registro**: Cadastro de novos usuários com validação de nome, email e senha.
- **Recuperação de Senha**: Envio de email para redefinição de senha.
- **Logout**: Finalização segura da sessão do usuário.

### 🔹 Catálogo de Produtos
- Lista de produtos com:
  - Nome
  - Preço
  - Imagem
  - Indicador de estoque ("ESGOTADO" para produtos sem estoque).
- Detalhes do produto exibidos em um alerta, incluindo:
  - Código
  - Descrição
  - Quantidade
  - Categoria
  - Validade

### 🔹 Carrinho de Compras
- Adição de produtos ao carrinho com validação de estoque.
- Exibição de itens no carrinho com nome, preço e quantidade.
- Cálculo automático do total do carrinho.
- Animação de adição ao carrinho usando **SpriteKit**.

### 🔹 Pagamento
- Suporte a dois métodos de pagamento:
  - **Pix**: Geração de código de pagamento copiado para a área de transferência.
  - **Cartão de Crédito**: Formulário para inserção de dados do cartão (número, nome, validade e CVV).
- Confirmação de pagamento com alertas e atualização de estoque no backend.
- Limpeza do carrinho após conclusão do pagamento.

### 🔹 Menu Lateral
- Exibe o nome do usuário logado.
- Opções para:
  - Acessar a tela "Sobre".
  - Realizar logout.

### 🔹 Gerenciamento de Estados
- **Loading**: Indicadores de carregamento para operações assíncronas.
- **Success**: Exibição de dados carregados com sucesso.
- **Error**: Tratamento de erros com mensagens amigáveis ao usuário.
- **Toast Messages**: Notificações visuais para ações como envio de email de recuperação.

### 🔹 Navegação
- Navegação fluida com `UINavigationController`.
- Transições animadas entre telas (Welcome, Login, Register, Home, Cart, Payment, About).
- Menu lateral animado com sombra e toque para fechar.

---

## 📱 Responsividade

- Interface adaptada para diferentes tamanhos de tela usando **Auto Layout** e **Safe Area Layout Guides**.
- Componentes visuais (botões, imagens, textos) ajustados dinamicamente com `NSLayoutConstraint`.
- Suporte a modo claro e escuro do iOS.

---

## ▶️ Como Rodar o Projeto

### Pré-requisitos
- **Xcode** (versão 14.0 ou superior).
- **Dispositivo iOS** ou simulador (iOS 15.0 ou superior).
- Conta no **Back4App** com as chaves de API configuradas.

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/seu-user/petzone-app.git
cd petzone-app

# 2. Instale as dependências
pod install

# 3. Configure as chaves do Back4App
# Edite o arquivo APIClient.swift com suas chaves de applicationId e clientKey.

# 4. Abra o projeto no Xcode
open PetZoneApp.xcworkspace

# 5. Compile e execute o app
# Selecione um dispositivo/simulador e clique em "Run" no Xcode.

# Configuração do Back4App

## Criar uma Conta no Back4App
1. Acesse o site do [Back4App](https://www.back4app.com/) e crie uma conta.
2. Faça login no painel do Back4App.

## Configurar as Classes no Painel do Back4App
1. No painel, crie as seguintes classes:
   - **Product**: Para armazenar informações dos produtos.
   - **Cart**: Para gerenciar os itens no carrinho de compras.
   - **User**: Para gerenciar os dados dos usuários.
2. Configure os campos necessários para cada classe, como nome, preço, ID do usuário, etc.

## Adicionar Chaves no APIClient.swift
1. No painel do Back4App, localize as chaves `applicationId` e `clientKey` na seção de configurações do aplicativo.
2. Abra o arquivo `APIClient.swift` no projeto.
3. Adicione as chaves ao código, como no exemplo abaixo:

```swift
struct APIClient {
    static let applicationId = "INSIRA_SEU_APPLICATION_ID"
    static let clientKey = "INSIRA_SEU_CLIENT_KEY"
}

## Demonstração
(Adicione aqui um GIF ou screenshot do app, se disponível)

📝 **Notas Adicionais**

- O projeto utiliza **CoreData** para persistência local, garantindo robustez no gerenciamento de dados offline.
- A classe `ImageCache` otimiza o carregamento de imagens, reduzindo o uso de rede.
- Animações com **SpriteKit** adicionam um toque visual ao processo de adição ao carrinho.
- O código segue boas práticas de **Swift**, com injeção de dependências e separação de responsabilidades.
