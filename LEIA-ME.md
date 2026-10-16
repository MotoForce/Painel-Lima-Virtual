# Painel Lima Virtual — Versão 2.1

**Endereço pretendido:** https://painel.limavirtual.online

O projeto contém uma página mestra responsiva que direciona visitantes a páginas HTML já publicadas. Não importa, hospeda nem executa automaticamente os códigos HTML dentro de cada cartão.

## Acesso por token (versão 2.1)
- Ao abrir o endereço, a interface solicita um token. A palavra definida para esta versão é **inteligente** (letras minúsculas).
- A autorização é lembrada **somente na aba atual** via `sessionStorage`. Ao clicar em **Sair**, o painel volta para a tela de acesso. Ao fechar a aba, normalmente será necessário digitar o token novamente (alguns navegadores podem restaurar sessões).
- O valor do token não fica gravado em texto puro no HTML: a comparação utiliza um resumo SHA-256 com a API Web Crypto. **Isso não equivale a controle de acesso seguro**, porque o JavaScript, o resumo e `apps.json` continuam visíveis ao público; a sessão no navegador também pode ser modificada. Não coloque conteúdos confidenciais nesse portal.
- **O token apenas bloqueia a interface inicial.** Para proteger de verdade o portal e os aplicativos de destino, use autenticação no servidor/edge (por exemplo, Cloudflare Access, autenticação na hospedagem ou outra solução de controle de acesso).
- Necessário HTTPS (ou localhost) para validação com Web Crypto. Não é garantido funcionamento por `file://`.

## Arquivos
- `index.html`: portal responsivo e editor local.
- `apps.json`: lista pública de links, nomes, categorias, ícones e palavras-chave.
- `assets/logo.svg`: logomarca vetorial e ícone de aba.
- `manifest.webmanifest`: metadados para instalação como atalho/app web, quando suportada pelo navegador.
- `sw.js`: disponibiliza a interface básica offline após primeiro acesso HTTPS. **Os sites externos não ficam disponíveis offline.**
- `TESTES.md`: roteiro de QA e limitações.

## Publicação
1. Abra o pacote e publique **o conteúdo da pasta** no diretório raiz do serviço que atenderá `painel.limavirtual.online`, mantendo a mesma estrutura de arquivos.
2. No seu serviço de DNS, configure `painel` conforme a instrução do provedor de hospedagem (ex.: CNAME apontando para o endereço informado pela plataforma). Não há apontamento DNS pré-configurado neste projeto.
3. Habilite e valide certificado HTTPS no subdomínio.
4. Acesse `https://painel.limavirtual.online/` e confirme se `apps.json` carrega. Faça uma atualização forçada após a publicação.
5. Publique cada sistema HTML em um endereço HTTPS válido, independente, e cadastre esse endereço no painel.

### Editar aplicativos
Clique em **Gerenciar atalhos**, adicione/edite/exclua e reorganize os aplicativos, depois clique em **Exportar apps.json**. **Envie esse arquivo para o servidor substituindo o `apps.json` anterior**. Editar na tela não altera a hospedagem.

### Estrutura do apps.json
```json
[
  {
    "id": "meu-sistema",
    "name": "Meu Sistema",
    "url": "https://exemplo.com/sistema/",
    "icon": "📚",
    "category": "Educação",
    "description": "Conteúdos de aprendizagem",
    "tags": ["aulas", "estudo", "curso"],
    "featured": true
  }
]
```
O link `exemplo.com` acima é **ilustrativo**, não um aplicativo instalado. O JSON entregue vem com **um único link real informado anteriormente**: a página principal `limavirtual.online`. Substitua ou amplie.

### Recursos e restrições
- Pesquisa local sem acentos, com pontuação por correspondência em nome, categoria, descrição e tags. **Não é IA generativa nem utiliza API de IA**.
- Favoritos e acessos recentes ficam salvos **apenas neste navegador**, por `localStorage`, sem rastrear usuários em um servidor.
- Editor é **local e acessível a quem entra na interface**, sem autenticação administrativa independente. Não serve como área administrativa protegida.
- Não cadastre URLs privadas, segredos ou dados pessoais no `apps.json`: o arquivo fica publicamente acessível.
- Somente links HTTPS são aceitos. A segurança de autenticação de cada sistema de destino precisa ser implementada no próprio sistema.
- Sem bibliotecas externas, banco de dados, Node.js ou Python em produção.
- O portal funciona em navegadores atuais; navegadores antigos como os do Windows 7 podem apresentar limitações (CSS moderno, JavaScript, service worker).

## Hospedagem
É compatível com hospedagem de arquivos estáticos (Cloudflare Pages, GitHub Pages com domínio personalizado ou hospedagem convencional). É necessário configurar DNS e domínio personalizado seguindo a plataforma escolhida. Não foi feito deploy nem alterado DNS.

© Nailson Rodrigues de Lima


## Correcao 2.1.1 - rodape
O nome Painel Lima Virtual no rodape nao e mais um link. SW atualizado para invalidar cache antigo.
