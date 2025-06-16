# 📄 Documentação dos Arquivos `devcontainer.json` e `setup-gpg.sh`

---

## 🐳 **Explicação completa do arquivo `devcontainer.json`**

O arquivo `devcontainer.json` é responsável por definir todo o ambiente de desenvolvimento containerizado dentro do VSCode (ou qualquer editor compatível com Dev Containers).

---

### 🔍 **Passo a passo detalhado**

### 1. **Identificação do container**

```json
{
  "name": "Capim Dash Backend",
```

- **`name`** → Define o nome que o container vai ter no VSCode.  
➝ Neste caso, `"Capim Dash Backend"`.

---

### 2. **Orquestração com Docker Compose**

```json
"dockerComposeFile": "../docker-compose.yml",
"service": "app",
```

- **`dockerComposeFile`** → Indica o arquivo `docker-compose.yml` que será usado para subir o container.  
➝ Está localizado na pasta acima (`../docker-compose.yml`).

- **`service`** → Define qual serviço dentro do Docker Compose será usado como base para o Dev Container.  
➝ No exemplo, `"app"`.

---

### 3. **Localização do código no container**

```json
"workspaceFolder": "/app",
```

- **`workspaceFolder`** → Define que o diretório de trabalho dentro do container será `/app`.

---

### 4. **Customizações do VSCode**

```json
"customizations": {
  "vscode": {
    "settings": { ... },
    "extensions": [ ... ]
  }
},
```

#### 🔧 **Settings do VSCode**

```json
"settings": {
  "terminal.integrated.defaultProfile.linux": "bash",
  "rubyTestExplorer.testFramework": "rspec",
  "rubyTestExplorer.rspecCommand": "bundle exec rspec --color",
  "rubyTestExplorer.rspecDirectory": "./spec",
  "ruby-spec-runner.rspecFormat": "Documentation"
}
```

- Define que:
  - Terminal padrão será **Bash**.
  - O framework de testes usado será **RSpec**.
  - Comando para rodar testes: `bundle exec rspec --color`.
  - Diretório dos testes: `./spec`.
  - Saída dos testes no formato **Documentation**, que é mais legível.

#### 🔌 **Extensões instaladas automaticamente no VSCode**

```json
"extensions": [
  "Shopify.ruby-lsp",
  "rebornix.Ruby",
  "castwide.solargraph",
  "Fooo.ruby-spec-runner",
  "eamodio.gitlens"
]
```

- **Shopify.ruby-lsp** → LSP oficial do Ruby (autocomplete, navegação, linting, etc.).
- **rebornix.Ruby** → Suporte básico ao Ruby no VSCode.
- **castwide.solargraph** → Outro servidor LSP para Ruby (alternativo/auxiliar).
- **Fooo.ruby-spec-runner** → Integração de testes RSpec no VSCode.
- **eamodio.gitlens** → Melhora a visualização do Git (blame, histórico, etc.).

---

### 5. **Comando pós-criação (`postCreateCommand`)**

```json
"postCreateCommand": "apt-get update && apt-get install -y openssh-client pinentry-curses && bundle install && ..."
```

Executa uma série de comandos no container após ele ser criado:

- Instala dependências como:
  - `openssh-client` → Necessário para Git via SSH.
  - `pinentry-curses` → Interface de senha do GPG no terminal.
- Executa `bundle install` → Instala gems.
- Copia:
  - Suas chaves SSH (`~/.ssh`) para dentro do container.
  - Suas chaves GPG (`~/.gnupg`) e configuração Git (`~/.gitconfig`).
- Ajusta permissões de segurança dessas pastas.
- Configura o GPG para funcionar dentro do container:
  - Cache de senha muito longo.
- Executa o script `setup-gpg.sh` para garantir a configuração final do GPG.

> ⚠️ **Importante:** Esse processo **não ativa automaticamente a assinatura de commits.** É necessário que você já tenha sua chave GPG criada e configurada no Git com `commit.gpgsign true`.

---

### 6. **Portas expostas**

```json
"forwardPorts": [3000],
```

- Exposição da porta `3000`, que é a porta padrão de aplicações Rails (`rails s`).

---

### 7. **Volumes e montagens (`mounts`)**

```json
"mounts": [
  "source=${localEnv:HOME}/.netrc,target=/root/.netrc,type=bind",
  "source=${env:HOME}/.ssh,target=/home/vscode/host-ssh,type=bind,consistency=cached,readonly",
  "source=${env:HOME}/.gnupg,target=/home/vscode/host-gnupg,type=bind,consistency=cached,readonly",
  "source=${env:HOME}/.gitconfig,target=/home/vscode/host-gitconfig,type=bind,consistency=cached,readonly"
]
```

- Faz bind dos seus arquivos locais para dentro do container:
  - `.netrc` → Credenciais para serviços HTTP (ex.: GitHub, Heroku).
  - `.ssh` → Chaves SSH para autenticação Git.
  - `.gnupg` → Chaves GPG (para commits assinados).
  - `.gitconfig` → Suas configurações pessoais do Git.

---

### 8. **Variáveis de ambiente**

```json
"containerEnv": {
  "GPG_TTY": "/dev/console",
  "DISPLAY": ":0"
}
```

- **`GPG_TTY`** → Necessário para que o GPG funcione corretamente no terminal.
- **`DISPLAY`** → Usado para exportação de interface gráfica, embora neste contexto não seja essencial.

---

## ✅ **Resumo funcional do `devcontainer.json`**

- 🔧 Cria um ambiente padronizado para desenvolvimento Ruby on Rails.
- 🔐 Prepara o ambiente para uso de SSH, GPG e Git dentro do container.
- 🚀 Inclui suporte completo para:
  - Testes integrados no editor.
  - Navegação no código.
  - Suporte a commits assinados (desde que você já tenha sua chave GPG e configuração Git).

---

## 🔐 **Explicação completa do arquivo `setup-gpg.sh`**

O script `setup-gpg.sh` serve para configurar o **GPG** dentro do Dev Container, garantindo que você consiga:

- Assinar commits (`git commit -S`).
- Assinar tags.
- Usar GPG para outras operações seguras dentro do container.

---

### 🔍 **Passo a passo detalhado**

### 🔸 **Corrige permissões da pasta `.gnupg`**

```bash
chmod 700 ~/.gnupg
chmod 600 ~/.gnupg/*
```

- A pasta `.gnupg` precisa ter permissão **700** (acesso total apenas para o usuário).
- Os arquivos dentro dela precisam ter permissão **600** (leitura/escrita apenas para o dono).

---

### 🔸 **Ativa o uso do agente GPG**

```bash
echo 'use-agent' > ~/.gnupg/gpg.conf
```

- Habilita o uso do **gpg-agent**, que gerencia o cache das senhas e a interação com as chaves.

---

### 🔸 **Define o pinentry para terminal (modo texto)**

```bash
echo 'pinentry-program /usr/bin/pinentry-curses' > ~/.gnupg/gpg-agent.conf
```

- Usa o **pinentry-curses**, uma interface de senha que funciona dentro do terminal (modo texto).

---

### 🔸 **Configura cache de senha para não expirar (10 anos)**

```bash
echo 'default-cache-ttl 315360000' >> ~/.gnupg/gpg-agent.conf
echo 'max-cache-ttl 315360000' >> ~/.gnupg/gpg-agent.conf
```

- Define o tempo padrão e máximo do cache para **10 anos em segundos**, evitando ter que digitar a senha GPG repetidamente.

---

### 🔸 **Informa o terminal ao GPG**

```bash
export GPG_TTY=$(tty)
```

- Informa ao GPG qual terminal deve ser usado para solicitar senhas.

---

### 🔸 **Recarrega o agente GPG**

```bash
gpg-connect-agent reloadagent /bye
```

- Recarrega as configurações do `gpg-agent` para aplicar imediatamente as mudanças feitas.

---

## ✅ **Resumo funcional do `setup-gpg.sh`**

- 🔧 Prepara corretamente o ambiente GPG no container.
- 🔒 Garante segurança nas permissões.
- 🚀 Evita ter que digitar a senha GPG repetidamente.
- 🔗 Permite fazer commits assinados, assinar tags e realizar outras operações que dependem do GPG de forma transparente dentro do container.
