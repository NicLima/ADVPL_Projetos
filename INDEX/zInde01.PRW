//Bibliotecas
#Include 'Totvs.ch'
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Defines
#Define CRLF chr(13) + chr(10)
//Constantes usadas na criação dos campos
#Define _X3_USADO         "€€€€€€€€€€€€€€ "
#Define _X3_USFILIAL     "€€€€€€€€€€€€€€€"
#Define _X3_RESERV         "þA"
#Define _X3_OBRIGA         "€"
#Define _X3_NAO_OBRIGA     ""

//Variáveis estáticas
//Static cTitulo := "Chamados"
//Static cAliasMVC := "ZK0"

/*
=====================================================================================
Programa.:              ZMOD02
Autor....:              Nicolas C Lima Santos 
Data.....:              08/02/24
Descricao / Objetivo:   
Doc. Origem:            
Solicitante:            
Uso......:              
Obs......:              https://terminaldeinformacao.com/2015/10/05/criando-tabelas-campos-e-indices-a-quente-no-protheus/          
=====================================================================================
*/
/*/
SIX: -> SIX - Índices dos Arquivos (SX2).
        [nLinha][01] - Índice
        [nLinha][02] - Ordem
        [nLinha][03] - Chave
        [nLinha][04] - Descrição
        [nLinha][05] - Propriedade
        [nLinha][06] - NickName
        [nLinha][07] - Mostr.Pesq
/*/

User Function zMOD02()
    Local aArea := GetArea()
    Local aAreaX2 := SX2->(GetArea())
    Local aAreaIX := SIX->(GetArea())
    Local cAliasTab := "ZK0"
    Local aSIX := {}

    Local lTabCriada    := .F.
    Local lTemAltera    := .F.

    Local cMsgAux       := ""
    Local nAtual        := 0
    Local cOrdemAux     := ""

    Begin Sequence
    
        //Setando os indíces
        SX2->(dbSetORder(2)) //X2_CHAVE
        SIX->(dbSetOrder(1)) //INDICE+ORDEM

        //Selectionar tabela
        //DbSelectArea(cAliasTab)
        //DbGoTop()

        //If cAliasTab > 0 
        //    MsgInfo("Tabela encontrada", "Atenção")
        //Else
        //    MsgInfo("Tabela NÃO encontrada", "Atenção")
        //    Break
        //EndIf

        AADD(aSIX, {"ZK0", "1", "ZK0_FILIAL+ZK0_GAPNUM", "Numero GAP", "S", "GAPNUM", "S"})
        /*/
        SIX: -> SIX - Índices dos Arquivos (SX2).
            [nLinha][01] - Índice
            [nLinha][02] - Ordem
            [nLinha][03] - Chave
            [nLinha][04] - Descrição
            [nLinha][05] - Propriedade
            [nLinha][06] - NickName
            [nLinha][07] - Mostr.Pesq
        /*/

        //Percorrendo os índices
            For nAtual := 1 To Len(aSIX)
                //Se não conseguir posicionar, quer dizer que não existe o índice, logo será criado
                If ! SIX->(DbSeek(aSIX[nAtual][1] + aSIX[nAtual][2]))
                    RecLock("SIX", .T.)
                        SIX->INDICE    :=    aSIX[nAtual][1]
                        SIX->ORDEM     :=    aSIX[nAtual][2]
                        SIX->CHAVE     :=    aSIX[nAtual][3]
                        SIX->DESCRICAO :=    aSIX[nAtual][4]
                        SIX->DESCSPA   :=    aSIX[nAtual][4]
                        SIX->DESCENG   :=    aSIX[nAtual][4]
                        SIX->PROPRI    :=    aSIX[nAtual][5]
                        SIX->F3        :=    ""
                        SIX->NICKNAME  :=    aSIX[nAtual][6]
                        SIX->SHOWPESQ  :=    aSIX[nAtual][7]
                    SIX->(MsUnlock())
                    lTemAltera := .T.
                EndIf
            Next
            
            //Se tiver alterações em campo e/ou índices
            If lTemAltera
                //Bloqueia alterações no Dicionário
                __SetX31Mode(.F.)
                
                //Se a tabela tiver aberta nessa seção, fecha
                If Select(cAliasTab) > 0
                    (cAliasTab)->(DbCloseArea())
                EndIf
            
                //Atualiza o Dicionário
                X31UpdTable(cAliasTab)
                
                //Se houve Erro na Rotina
                If __GetX31Error()
                    cMsgAux := "Houveram erros na atualização da tabela "+cTabAux+":"+Chr(13)+Chr(10)
                    cMsgAux += __GetX31Trace()
                    Aviso('Atenção', cMsgAux, {'OK'}, 03)
                EndIf                                                         
                
                //Abrindo a tabela para criar dados no sql
                DbSelectArea(cAliasTab)
                
                //Desbloqueando alterações no dicionário
                __SetX31Mode(.T.)
            endif

    End Sequence    
     
    RestArea(aAreaIX)
    //RestArea(aAreaX3)
    RestArea(aAreaX2)
    RestArea(aArea) 

    RestArea(aArea)

Return Nil

