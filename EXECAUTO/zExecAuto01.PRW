#include "Protheus.ch"
#include "Totvs.ch"
#include "Topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "FWMBROWSE.ch"
#include "FWMVCDEF.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              zExecAuto01
Autor....:              Nicolas C Lima Santos 
Data.....:              19/01/24
Descricao / Objetivo:   Criar um execauto para a função MATA261 - tranferência múltipla. 
Doc. Origem:            
Solicitante:            
Uso......:              
Obs......:               
=====================================================================================
*/

User Function zTeste()//zExecAuto01()
    
    Local _aArea        := GetArea()
    Local _aAuto  		:= {}
    Local _aItens  		:= {}
	Local _nOpcAuto     := 3   //Inclusao
	Local _cDocumento	:= ""
    Local _nPos         := 0
    Local _cMens        := ""

	//Variáveis de controle do ExecAuto
	Private lMSHelpAuto     := .T.
	Private lAutoErrNoFile  := .T.
	Private lMsErroAuto     := .F.

	//Implementado pois em alguns casos não esta conseguindo localizar numeração	
	For _nPos := 1 To 10
		_cDocumento  := Criavar("D3_DOC")
		_cDocumento	:= IIf(Empty(_cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),_cDocumento)
		If !Empty(_cDocumento)
			Exit
		Endif 
	Next

    If Empty(_cDocumento)
		_cMens := "Não foi possivel montar numeração SD3, para gerar movimentação." //Para implementar em alguma mensagem de erro.
        
        FWAlertInfo(_cMens,"Atenção.")

		Disarmtransaction()
	Else
        _cDocumento := A261RetINV(_cDocumento)
    EndIf

    FWAlertInfo("Início do ExecAuto MATA261","Título FWAlertInfo.")

    Begin Transaction

        //dDataBase é uma variável pública com a data atual.
        Aadd(_aAuto,{_cDocumento , dDataBase})    //Cabecalho
        
        //Itens
        Aadd(_aItens,{"D3_COD"      ,"R-20414SG001           ",Nil})
        Aadd(_aItens,{"D3_DESCRI"   ,"BUCHA DA BARRA ESTABILIZADORA (N)"   ,Nil})
        Aadd(_aItens,{"D3_UM"       ,"PC"    ,Nil})
        Aadd(_aItens,{"D3_LOCAL"    ,"11 "    ,Nil})
        Aadd(_aItens,{"D3_LOCALIZ"  ,"11 "    ,Nil})
        Aadd(_aItens,{"D3_COD"      ,"R-20414SG001           " ,Nil})
        Aadd(_aItens,{"D3_DESCRI"   ,"BUCHA DA BARRA ESTABILIZADORA (N)" ,Nil})
        Aadd(_aItens,{"D3_UM"       ,"PC"    ,Nil})
        Aadd(_aItens,{"D3_LOCAL"    ,"61"    ,Nil})
        Aadd(_aItens,{"D3_LOCALIZ"  ,"61"    ,Nil})
        Aadd(_aItens,{"D3_NUMSERI"  ,""      ,Nil})
        Aadd(_aItens,{"D3_LOTECTL"  ,""      ,Nil})
        Aadd(_aItens,{"D3_NUMLOTE"  ,""      ,Nil})
        Aadd(_aItens,{"D3_DTVALID"  ," / / " ,Nil})
        Aadd(_aItens,{"D3_POTENCI"  ,0       ,Nil})
        Aadd(_aItens,{"D3_QUANT"    ,3       ,Nil})
        Aadd(_aItens,{"D3_QTSEGUM"  ,0       ,Nil})
        Aadd(_aItens,{"D3_ESTORNO"  ,"N"     ,Nil})
        Aadd(_aItens,{"D3_SEQCALC"  ,""      ,Nil})
        Aadd(_aItens,{"D3_LOTECTL"  ,"                              "  ,Nil})
        Aadd(_aItens,{"D3_DTVALID"  ," / / " ,Nil})
        Aadd(_aItens,{"D3_ITEMGRD"  ,""      ,Nil})
        Aadd(_aItens,{"D3_GRUPO"    ,"0520"  ,Nil})
        Aadd(_aItens,{"D3_OBS"      ,"Reserva ref. orcamento 01032664" ,Nil})

        Aadd(_aAuto, aClone(_aItens))    //Preenche array para execauto

        MSExecAuto({|x,y| mata261(x,y)}, _aAuto, _nOpcAuto)

        If lMsErroAuto
            //Pegando log do ExecAuto
            MostraErro() //Mostra Log em tela
            
            Disarmtransaction()
        EndIf
    
    End Transaction

    FWAlertWarning("Fim do ExecAuto MATA261", "Título FWAlertWarning.")
    
    RestArea(_aArea)
Return

//Teste de alteração.
