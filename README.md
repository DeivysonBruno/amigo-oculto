
# Configurações

- O app foi desenvolvido usando a versão Flutter (Channel stable, 1.22.3, on Microsoft Windows [versão 10.0.18363.1198], locale pt-BR).

- Para executar o Applicativo intale o arquivo app-release.apk que esta junto aos arquivos entregues.

- Testado apenas em Android

- Será necessario usar o comando "flutter pub get" no terminal na pasta do projeto para instalar as dependencias do projeto, ou usar o botão pub get dentro do arquivo
pubspec.yaml

- O código fonte foi enviado  compactado caso queira gerar um novo apk basta usar o comando
"flutter build apk" na pasta do projeto.

- o codigo fonte também pode ser clonado do git: https://github.com/DeivysonBruno/amigo-oculto,
caso pegue o código do github deverá adicionar no arquivo
amigo-oculto/lib/src/shared/constants.dart
o email e senha para envio dos emails via smtp nas variáveis :

Email e senha enviados por email no arquivo readme
Este email foi criado exclusivamente para esse fim.

# Desenvolvimento

- Todos as premissas solicitadas encontram-se implementadas na applicação, como escalonei o teste com meu tempo de trabalho estive mais focado nas funcionalidades, logo o layout é mais simples, porem busquei fazer todos os tratamentos de inserção de dados.

- Na tela de adição de participantes ao digitar o cep do participante, caso haja internet app faz uma busca no viacep e preenche os campos do endereço.

- Em caso do moderador participar do sorteio, quando o incluir como participante o switch moderador deve ser ativado

- O sorteio só é liberado caso haja mais de 4 participantes.

- O app e dividido da seguinte forma : menu onde pode escolher a tela a qual deseja ver, Tela de criar um novo sorteio, tela com histórico , e tela com os sorteios pendentes.

- A tela de envio pendente permite o envio dos emails que não foram enviados, caso o moderador veja a necessidade de reeviar os dados do sorteio ele pode o fazer na tela de histórico.



