### Developer Experience em projetos Ruby on Rails

Este repositório contém um exemplo prático das soluções aplicadas no meu Trabalho de Conclusão de Curso (TCC) do MBA em Engenharia de Software pela USP/Esalq, cujo tema é: "Avaliação do impacto de ferramentas de apoio na Developer Experience em projetos Ruby on Rails".

#### 📝 Sobre o TCC

O objetivo do trabalho foi analisar como ferramentas de apoio podem melhorar a Developer Experience (DX) em projetos Ruby on Rails. A pesquisa partiu da hipótese de que a ausência de ambientes padronizados e de suporte adequado compromete tanto a produtividade quanto o bem-estar dos desenvolvedores.

Para isso, foram implementadas três soluções principais em projetos reais dentro de uma empresa de tecnologia:

- **Ruby LSP (Language Server Protocol)**: fornece funcionalidades como autocomplete, navegação no código, linting, hover com documentação e renomeação de símbolos diretamente no editor.
- **Ruby Spec Runner**: permite rodar testes Rspec de forma integrada ao editor (VSCode ou Cursor), tornando o ciclo de feedback mais rápido e acessível.
- **Dev Containers (via Docker + VSCode/Cursor)**: padroniza o ambiente de desenvolvimento, garantindo que todos os desenvolvedores trabalhem com a mesma versão de Ruby, gems e dependências, além de acelerar o onboarding.

Após a adoção dessas ferramentas, foi aplicado um questionário com o time de desenvolvimento para mensurar os impactos percebidos em termos de produtividade, fluidez no desenvolvimento, facilidade no onboarding e satisfação com o ambiente de trabalho.

Os resultados mostraram que a introdução dessas ferramentas teve impacto positivo e relevante na melhoria da Developer Experience, alinhando-se às melhores práticas apontadas na literatura de engenharia de software.

#### 🗂️ O que há neste repositório?

Este repositório simula um exemplo prático de como essas ferramentas foram configuradas no ambiente real. Os arquivos e scripts presentes aqui não são o projeto de produção da empresa, mas refletem a estrutura, os conceitos e as práticas aplicadas.

Arquivos e pastas principais:

`devcontainer.json`

Arquivo de configuração do **Dev Container**, responsável por definir o ambiente de desenvolvimento containerizado.

🔍 O que ele faz:

- Cria um ambiente padronizado para desenvolvimento em Ruby on Rails utilizando Docker.
- Garante que todos os desenvolvedores utilizem as mesmas versões de Ruby, gems e dependências.
- Configura o VSCode automaticamente com extensões essenciais:
  - **Shopify.ruby-lsp** → Language Server para Ruby.
  - **Fooo.ruby-spec-runner** → Execução de testes RSpec integrada ao editor.
  - **GitLens** → Ferramenta para enriquecer a navegação e histórico Git.
- Define comandos de teste (`bundle exec rspec --color`) e diretórios (`./spec`).
- Expõe a porta 3000 (padrão do Rails).
- Realiza a configuração automática de GPG, SSH e Git dentro do container, incluindo suporte para commits assinados.

🧠 Detalhes importantes do `devcontainer.json`:

- Faz bind dos seus arquivos locais de configuração (`.ssh`, `.gnupg`, `.gitconfig`) para dentro do container, permitindo que o ambiente conte com suas credenciais e configurações pessoais.
- Inclui um comando `postCreateCommand` robusto que:
  - Instala dependências adicionais no container.
  - Configura SSH.
  - Copia e ajusta permissões de chaves GPG.
  - Habilita commit assinado automaticamente no Git dentro do container.

`setup-gpg.sh`

Script auxiliar que complementa a configuração do GPG no container.

🔍 O que ele faz:

- Ajusta as permissões da pasta `.gnupg` e de suas chaves, garantindo que o GPG funcione corretamente.
- Configura o agente do GPG (`gpg-agent`) para utilizar o **pinentry-curses**, que permite interação no terminal para desbloqueio das chaves.
- Define um cache de senha extremamente longo (10 anos), evitando que você precise digitar sua senha GPG repetidamente no container.
- Exporta a variável `GPG_TTY`, necessária para que o GPG funcione corretamente no terminal.
- Recarrega o agente GPG para aplicar todas as configurações.

🚀 Resultado: Permite que você assine commits (`git commit -S`), tags e outras operações seguras diretamente no ambiente do Dev Container, exatamente como faria na sua máquina local.

`Gemfile` (exemplo)

Arquivo que demonstra as dependências Ruby necessárias para rodar um projeto típico Rails, incluindo gems para desenvolvimento, teste e suporte à DX proposta.

#### 🚀 Objetivo deste repositório

Este repositório tem caráter educacional e demonstrativo. Seu objetivo é mostrar como a adoção de ferramentas como Dev Containers, Ruby LSP e Ruby Spec Runner pode transformar o ambiente de desenvolvimento de projetos Ruby on Rails, promovendo:

- Redução no tempo de setup;
- Maior fluidez na execução de testes;
- Facilidade na navegação e manutenção do código;
- Ambiente mais padronizado entre desenvolvedores;
- Melhoria na satisfação e produtividade da equipe.

📚 Referências

Este trabalho foi desenvolvido como parte do TCC para o MBA em Engenharia de Software pela USP/Esalq em 2025.

Se quiser entender mais sobre os fundamentos teóricos que embasam este trabalho, recomendo a leitura das seguintes referências, que também foram utilizadas no TCC:

- Forsgren, N., Humble, J., & Kim, G. (2018). Accelerate: The Science of Lean Software and DevOps. IT Revolution.
- Greiler, M., Storey, M., & Noda, A. (2022). An Actionable Framework for Understanding and Improving Developer Experience. IEEE Transactions on Software Engineering.
- Razzaq, A. et al. (2024). A Systematic Literature Review on the Influence of Enhanced Developer Experience on Developers' Productivity. ACM Computing Surveys.

✨ Contato

Caso tenha interesse em discutir sobre Developer Experience, Ruby on Rails, ou queira saber mais sobre este trabalho, me encontre no [LinkedIn](https://www.linkedin.com/in/giovannasm/) ou envie um email para: giovannasm@gmail.com
