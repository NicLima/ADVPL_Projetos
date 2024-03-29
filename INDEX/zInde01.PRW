//Bibliotecas
#Include 'Totvs.ch'
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Defines
#Define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              ZINDE01
Autor....:              Nicolas C Lima Santos 
Data.....:              08/02/24
Descricao / Objetivo:   Criar um ind�ce para um tabela customizada "a quente", sem utilizar o configurador. 
Doc. Origem:            
Solicitante:            
Uso......:              
Obs......:              https://terminaldeinformacao.com/2015/10/05/criando-tabelas-campos-e-indices-a-quente-no-protheus/          
=====================================================================================
*/

User Function zINDE01()
    Local aArea         := GetArea()
    Local aAreaX2       := SX2->(GetArea()) //SX2 - Tabela de manuten��o dos arquivos
    Local aAreaIX       := SIX->(GetArea()) //SIX - Tabela de ind�ce dos arquivos
    Local cAliasTab     := "ZK0"            //ZK0 - Tabela customizada criada para este estudo
    Local aSIX          := {}
    Local lTemAltera    := .F.
    Local cMsgAux       := ""
    Local nAtual        := 0

    Begin Sequence
        //Setando os ind�ces
        SX2->(dbSetORder(2)) //X2_CHAVE
        SIX->(dbSetOrder(1)) //INDICE+ORDEM

        AADD(aSIX, {"ZK0", "1", "ZK0_FILIAL+ZK0_GAPNUM", "Numero GAP", "S", "GAPNUM", "S"})
        /*/
        SIX: -> SIX - �ndices dos Arquivos (SX2).
            [nLinha][01] - �ndice
            [nLinha][02] - Ordem
            [nLinha][03] - Chave
            [nLinha][04] - Descri��o
            [nLinha][05] - Propriedade
            [nLinha][06] - NickName
            [nLinha][07] - Mostr.Pesq
        /*/
        //Percorrendo os �ndices
            For nAtual := 1 To Len(aSIX)
                //Se n�o conseguir posicionar, quer dizer que n�o existe o �ndice, logo ser� criado
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
            
            //Se tiver altera��es em campo e/ou �ndices
            If lTemAltera
                //Bloqueia altera��es no Dicion�rio
                __SetX31Mode(.F.)
                
                //Se a tabela tiver aberta nessa se��o, fecha
                If Select(cAliasTab) > 0
                    (cAliasTab)->(DbCloseArea())
                EndIf
            
                //Atualiza o Dicion�rio
                X31UpdTable(cAliasTab)
                
                //Se houve Erro na Rotina
                If __GetX31Error()
                    cMsgAux := "Houveram erros na atualiza��o da tabela " + cAliasTab + ":" + CRLF
                    cMsgAux += __GetX31Trace()
                    Aviso('Aten��o', cMsgAux, {'OK'}, 03)
                EndIf                                                         
                
                //Abrindo a tabela para criar dados no sql
                DbSelectArea(cAliasTab)
                
                //Desbloqueando altera��es no dicion�rio
                __SetX31Mode(.T.)
            endif

    End Sequence    
     
    RestArea(aAreaIX)
    RestArea(aAreaX2)
    RestArea(aArea) 

Return Nil

