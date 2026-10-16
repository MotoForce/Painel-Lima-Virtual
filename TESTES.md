# QA — Painel Lima Virtual 2.1

## Verificações recomendadas na hospedagem
- [ ] Carregar `index.html` em HTTPS com `apps.json` acessível (sem 404).
- [ ] Confirmar logomarca, responsividade 320px/390px/768px/desktop e ausência de barra horizontal.
- [ ] Abrir um link publicado em nova aba, sem liberar acesso privilegiado à aba original.
- [ ] Testar busca com e sem acentos, múltiplas palavras e termo inexistente.
- [ ] Filtrar por categoria, acessar Favoritos, Recentes e Sugestões.
- [ ] Adicionar, editar, reordenar e excluir atalhos na prévia; exportar `apps.json` e reimportar.
- [ ] Verificar erros para URL HTTP, URL inválida, JSON fora do padrão e IDs duplicados.
- [ ] Recarregar a página: prévia local volta à lista publicada; favoritos/Recentes continuam no navegador.
- [ ] No modo offline após carregar a página HTTPS, confirmar interface e informar que sistemas externos requerem conexão.
- [ ] Navegar por teclado; Ctrl+K leva ao campo de pesquisa; foco visível; Esc fecha configurações.
- [ ] Confirmar domínio, DNS e certificado HTTPS no ambiente de produção.

## Limites de segurança e operação
- O gerenciador **não tem autenticação** e exporta arquivos; não publica automaticamente.
- Favoritos e histórico são locais ao navegador; backup exportado não importa automaticamente neste release.
- Navegadores com `file://` geralmente não permitem carregar `apps.json`; o portal usa um item inicial nesse cenário.
- Navegadores antigos podem não suportar todos os recursos modernos.
- A disponibilidade dos aplicativos apontados não é verificada automaticamente.
- A PWA pode ser instalável dependendo do navegador/ambiente; SVG pode não satisfazer todos os requisitos de ícone em todas as plataformas.


## Casos de verificação do token (v2.1)
- Acessar em HTTPS numa aba nova: somente a tela do token deve aparecer.
- Digitar token errado: a tela não deve liberar o painel e deve exibir mensagem.
- Digitar `inteligente`: o painel deve abrir, preservar cartões e recursos da v2.0.
- Atualizar a página na mesma aba: a sessão deve normalmente permanecer ativa.
- Clicar em **Sair**: ocultar painel e voltar à tela do token.
- Após sair, atualizar: continuar bloqueado.
- Fechar a aba, abrir uma nova: exigir token novamente, salvo se navegador restaurar a sessão anterior.
- Tentar acessar `/apps.json` diretamente: arquivo permanece público; este teste confirma a limitação de segurança do bloqueio estático.
- Abrir em HTTP remoto / arquivo local: Web Crypto pode não funcionar, deve exibir aviso, sem liberar o painel.
