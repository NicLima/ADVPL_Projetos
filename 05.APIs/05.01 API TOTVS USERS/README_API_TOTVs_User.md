# ADVPL_Projetos
Versão Protheus: 12.1.2210

API TOTVS USER
   * **zAPI01.prw**: Integracao com API Rest Users padrao do Protheus para consultar dados de determinado usuario e posterirmente realizar o bloqueio deste usuario. 

**Obervacoes sobre o fonte:**

1. O metodo GET serve para consultar os dados do usuario, uma vez que o Nome e o e-mail sao obrigatorios na passagem do body no metodo PUT.

2. O metodo PUT serve para alterar o usuario, o Nome e o e-mail sao obrigatorios, caso o usuario ja tenha e-mail cadastrado, esse sera mantido, caso nao tenha serao passado '@', porem na pratica o campo de e-mail fica em branco.

   2.1 o parametro que indica que o usuario deve ser bloqueado e ' "active":false' '.

3. As informacoes de 'cUrl', 'cEndPt' e 'cCodUsr' devem ser atualizados conforme as informacoes desejadas.
