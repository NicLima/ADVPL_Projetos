# ADVPL_Projetos
Vers�o Protheus: 12.1.2210

Consulta Espec�fica
   * **zAPI01.prw**: Integra��o com API Rest Users padr�o do Protheus para consultar dados de determinado usu�rio e posterirmente realizar o bloqueio deste usu�rio. 

**Oberva��es sobre o fonte:**

1. O m�todo GET serve para consultar os dados do usu�rio, uma vez que o Nome e o e-mail s�o obrigat�rios na passagem do body no m�todo PUT.

2. O m�todo PUT serve para alterar o usu�rio, o Nome e o e-mail s�o obrigat�rio, caso o usu�rio j� tenha e-mail cadastrado, esse ser� mantido, caso n�o tenha ser� passado '@', por�m na pr�tica o campo de e-mail fica em branco.

   2.1 o par�metro que indica que o usu�rio deve ser bloqueado � ' "active":false' '

3. As informa��es de 'cUrl', 'cEndPt' e 'cCodUsr' devem ser atualizados conforme as informa��es desejadas.
