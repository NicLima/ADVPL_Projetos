# ADVPL_Projetos
Versão Protheus: 12.1.2210

Consulta Específica
   * **zAPI01.prw**: Integração com API Rest Users padrão do Protheus para consultar dados de determinado usuário e posterirmente realizar o bloqueio deste usuário. 

**Obervações sobre o fonte:**

1. O método GET serve para consultar os dados do usuário, uma vez que o Nome e o e-mail são obrigatórios na passagem do body no método PUT.

2. O método PUT serve para alterar o usuário, o Nome e o e-mail são obrigatório, caso o usuário já tenha e-mail cadastrado, esse será mantido, caso não tenha será passado '@', porém na prática o campo de e-mail fica em branco.

   2.1 o parâmetro que indica que o usuário deve ser bloqueado é ' "active":false' '

3. As informações de 'cUrl', 'cEndPt' e 'cCodUsr' devem ser atualizados conforme as informações desejadas.
