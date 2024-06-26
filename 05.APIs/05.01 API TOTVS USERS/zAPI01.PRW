//Bibliotecas
#Include "TOTVS.ch"
#Include "Protheus.ch"

/*
=====================================================================================
Programa.:              zAPI01.PRW
Autor....:              Nicolas C Lima Santos 
Data.....:              26/04/24
Descricao / Objetivo:   Integra��o com API Rest Users padr�o do Protheus para consultar dados de determinado
                        usu�rio e posterirmente realizar o bloqueio deste usu�rio.
Doc. Origem:            
Solicitante:            
Uso......:              
Obs......:              https://github.com/jerfweb/API-REST-PROTHEUS/blob/master/API%20PADRAO/API%20USER/fAlterarUsuario.prw
Obs......:              https://api.totvs.com.br/
Obs......:              https://api.totvs.com.br/apidetails/User_v1_000.json
Obs......:              O m�todo DELETE desta API � o ideal para bloquear os usu�rios, por�m
                        ele tamb�m limpa os acessos e grupos, por isso n�o foi utilizado.          
=====================================================================================
*/
User Function  ZAPI01()

    Local oRestClient   := Nil
    Local cUrl		    := "/'rest_endereco'/users/"  //Deve-ser atualizar com o endere�o do REST 
    Local aHeadStr		:= {"Content-Type: application/json"}
    Local cEndPt      := "http://172.28.35.142:34286" //IP + PORTA do servi�o do protheus
    Local oObjJson		:= Nil
    Local cStrResul		:= ""
    Local cCodUsr       := "001256" //C�digo do usu�rios a ser bloqueado.
    Local cEmail        := ""
    Local cDispName     := "" 
    Local lAtivUsr      := ""
    Local lContinua     := .F.

    Begin Sequence
      
      If Empty(Alltrim(cCodUsr))
        Break
      EndIf
      
      //Endere�o do EndPoint REST
      oRestClient := FWRest():New(AllTrim(cEndPt)) 

      // chamada de classe REST com retorno de dados do usu�rio - Verbo GET
      oRestClient:setPath(cUrl+cCodUsr)
      
      //Consulta - Verbo GET, para obter informa��es do usu�rio.
      If oRestClient:Get(aHeadStr)
        //Deserealiza o Json
        If !FWJsonDeserialize(oRestClient:GetResult(),@oObjJson)
            MsgStop("Ocorreu erro no processamento do Json.")
            Break
        ElseIf AttIsMemberOf(oObjJson,"errorCode")
            MsgStop("errorCode: " + DecodeUTF8(oObjJson:errorCode) + " - errorMessage: " + DecodeUTF8(oObjJson:errorMessage))
            Break
        Else
            //Recebe Dados do Json
            cStrResul := oRestClient:GetResult()
            Conout("Dados da opera��o: " + cStrResul)
            lContinua := .T.
        EndIf

        //Grava informa��s para o m�todo PUT para bloquear o usu�rio.
        cEmail    := oObjJson:EMAILS[1]:VALUE
        cDispName := oObjJson:DISPLAYNAME
        lAtivUsr  := oObjJson:ACTIVE //Se for false o usu�rio j� est� bloqueado.
      
        //Se conseguiu obter os dados de usu�rios, procede para bloqueio.
        If lContinua
          If Empty(AllTrim(cCodUsr)) .and. Empty(AllTrim(cDispName))
            Break
          EndIf

          If Empty(lAtivUsr) .or. lAtivUsr == .F.
            Break
          EndIf

          If Empty(AllTrim(cEmail)) //Passar o e-mail � obrigat�rio.
            cEmail := "@" 
          EndIf
        
          //BODY - estrutura basica para update de usu�rio, mais informa��o ler documenta��o.
          cJSon := ' { '
          cJSon += '    "userName":"' + cDispName + '", '
          cJSon += '    "emails":[ '
          cJSon += '       { '
          cJSon += '          "value":"' + cEmail + '", '
          cJSon += '          "primary":true '
          cJSon += '       } '
          cJSon += '    ], '
          cJSon += '    "active":false'
          cJSon += ' } '

          //Bloqueio do usu�rio - Verbo PUT.
          If oRestClient:Put(aHeadStr, cJSon)
            If !FWJsonDeserialize(oRestClient:GetResult(),@oObjJson)
              MsgStop("Ocorreu erro no processamento do Json.")
              Break
            ElseIf AttIsMemberOf(oObjJson,"errorCode")
              MsgStop("errorCode: " + DecodeUTF8(oObjJson:errorCode) + " - errorMessage: " + DecodeUTF8(oObjJson:errorMessage))
              Break
            Else
              cStrResul := oRestClient:GetResult()
              Conout("Dados da opera��o: " + cStrResul)
            EndIf
          EndIf

        EndIf

      Else
        cStrResul := oRestClient:GetLastError()
        Conout("Dados da opera��o: " + cStrResul)
      EndIf

    End Sequence
    
Return
