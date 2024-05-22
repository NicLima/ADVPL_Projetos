//Bibliotecas
#Include 'Totvs.ch'
#Include 'RESTFul.ch'
#Include 'TopConn.ch'


/*API PARA CONSULTA DE CADASTRO DE PRODUTO
NICOLAS LIMA
17/05/2024
*/
WSRESTFUL zAPI02 DESCRIPTION 'WebService cadastro de protudo'
    //Atributos --Atributos vão na url
    WSDATA id           AS STRING

    //Métodos
    WSMETHOD GET DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/zAPI02/get_id?{id}'

END WSRESTFUL 

/*
MÉTODO GET ID
Busca registro via ID
@param id, Caractere, String que será pesquisada através do MsSeek
*/

WSMETHOD GET WSRECEIVE id WSSERVICE zAPI02
    Local ojResponse := JsonObject():New()
    Local cAliasWS  := 'SB1'
    Local lRet      := .T.
    
    //Se o id estiver vazio
    If Empty(::id) //Esse '::id' consulta o valor do id que vem da URL
        //SetRestFault(500, 'Falha ao consultar o registro') //Caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500)
        ojResponse['errorId']    := 'ID001'
        ojResponse['error']      := 'ID vazio'
        ojResponse['solution']   := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::id))
            //SetRestFault(500, 'Falha ao consutlar ID') //caso queira usar esse comando, você não poderá usar oturos retornos, como os abaixo
            Self:setStatus(500)
            ojResponse['errorId']    := 'ID002'
            ojResponse['error']      := 'ID não encontrado'
            ojResponse['solution']   := 'Código ID não encontrado na tabela ' + cAliasWS
        Else //Encontrou o registro
            //Define o retorno
            ojResponse['cod']    := (cAliasWS)->B1_COD
            ojResponse['desc']   := Alltrim((cAliasWS)->B1_DESC)
            ojResponse['tipo']   := (cAliasWS)->B1_TIPO
            ojResponse['um']     := (cAliasWS)->B1_UM
            ojResponse['locpad'] := (cAliasWS)->B1_LOCPAD
            ojResponse['grupo']  := (cAliasWS)->B1_GRUPO
        EndIF
    EndIF    

    //Define oo retorno
    Self:SetContentType('application/json')
    Self:SetResponse(ojResponse:toJSON())
Return lRet


