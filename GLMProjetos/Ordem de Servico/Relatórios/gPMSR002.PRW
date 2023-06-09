/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gPMSR002  � Autor � George AC. Gon�alves � Data � 28/04/14 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gPMSR002     � Autor � George Gon�alves  � Data � 28/04/14 ���
���          � gResumo      � Autor � George Gon�alves  � Data � 28/04/14 ���
���          � gImpCabecalho� Autor � George Gon�alves  � Data � 28/04/14 ���
���          � gImpRodape   � Autor � George Gon�alves  � Data � 28/04/14 ���
���          � ValidPerg    � Autor � George Gon�alves  � Data � 28/04/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o do Fechamento Mensal - Cliente                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu - Rotina gPMSR002                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "Topconn.ch"      
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "AP5MAIL.CH"
#include "PROTHEUS.CH"
#include "FONT.CH"

User Function gPMSR002()  // Emiss�o do Fechamento Mensal - Cliente

cPerg := Padr("GLM001",10)

//+---------------------------------------------------------------------+
//� Verifica as perguntas selecionadas                                  �
//+---------------------------------------------------------------------+
ValidPerg()  // chamada a fun��o de valida��o de grupo de perguntas

//+---------------------------------------------------------------------+
//� Variaveis utilizadas para parametros                                �
//� mv_par01  // C�digo do Cliente                                      �
//� mv_par02  // Loja do Cliente                                        �
//� mv_par03  // M�s/Ano Fechamento                                     �
//+---------------------------------------------------------------------+ 
If !Pergunte(cPerg,.T.)
	Return  // Retorno da fun��o
EndIf

Processa({||gResumo()})  // chamada a fun��o de impress�o do fechamento mensal

Return  // retorno da fun��o      
****************************************************************************************************************************************************

Static Function gResumo()  // Fun��o de impress�o do fechamento mensal

Private li   := 9999
Private nPag := 1 

Private oFont01N 
Private oFont02N 

Define FONT oFont1 NAME "Times New Roman" BOLD

oFont01N := TFont():New("Times New Roman",12,12,,.T.,,,,.T.,.F.)
oFont02N := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)

oPrint := TMSPrinter():New("Emiss�o do Fechamento Mensal - Cliente")

oPrint:SetPortrait() 

ProcRegua(1)
                                                           
aDsMes    := {"Janeiro","Fevereiro","Mar�o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
_cTTHoras := ""
_cTTABO   := ""
_cTTFAT   := ""

DbSelectArea("SM0")  // seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // muda ordem do �ndice
If SM0->(DbSeek(cEmpAnt+cFilAnt))  // posiciona registro
	_cCidade := SM0->M0_CIDCOB  // nome do cliente
EndIf

DbSelectArea("SA1")  // seleciona arquivo de clientes
SA1->(DbSetOrder(1))  // muda ordem do �ndice
If SA1->(DbSeek(xFilial("SA1")+mv_par01+mv_par02))  // posiciona registro
	_cNmCliente := SA1->A1_NOME   // nome do cliente
	_ceMailCli  := SA1->A1_EMAIL  // e-mail do cliente	
	_cCidCli    := SA1->A1_MUN    // munic�pio do cliente	
	_cEstCli    := SA1->A1_EST    // estado do cliente			
EndIf
          
// Select da pesquisa do fechamento
cQuery := "Select SZ0.Z0_NUMOS  As NUMOS , " 
cQuery += "       SZ0.Z0_DTEMIS As DTEMIS, " 
cQuery += "       SZ0.Z0_HRTOT  As HRTOT , " 
cQuery += "       SZ0.Z0_HRABO  As HRABO , " 
cQuery += "       SZ0.Z0_HRFAT  As HRFAT , " 
cQuery += "       SZ0.Z0_RESPPR As RESPPR  " 
cQuery += "  From " + RetSqlname("SZ0") + " SZ0 "
cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                            + " ' And " 
cQuery += "       SZ0.Z0_CLIENTE   = '" + mv_par01                                  + " ' And " 
cQuery += "       SZ0.Z0_LOJA      = '" + mv_par02                                  + " ' And " 
cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(mv_par03,4,4)+SubStr(mv_par03,1,2) + "%' And " 
cQuery += "       SZ0.Z0_APROV     = 'S'                                                  And " 
cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                      "
cQuery += "Order By SZ0.Z0_DTEMIS, SZ0.Z0_NUMOS "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())

Do While TMP->(!Eof())  // percorre o arquivo no intervalo
	_cNumOS     := TMP->NUMOS   // n�mero da OS
	_cDtEmis    := TMP->DTEMIS  // data de emiss�o/apontamento da OS
	_cHoraTotal := TMP->HRTOT   // total de horas do atendimento             
	_cHoraABO   := TMP->HRABO   // total de horas abonadas
	_cHoraFAT   := TMP->HRFAT   // total de horas faturadas
	_cRespProj  := TMP->RESPPR  // nome do respons�vel pelo projeto no cliente		

	// valida cancelamento pelo operador
	If LASTKEY() == 286 .Or. LASTKEY() == 27             
		Exit 
	EndIf

	If li > 2800  // se quebra de p�gina
		If nPag > 1  // se n�o for impress�o da 1a p�gina
			gImpRodape()  // chamada a fun��o de impress�o do rodap�
		Endif
		
		gImpCabecalho()  // chamada a fun��o de impress�o do cabe�alho			
	EndIf   

	oPrint:Say(li,0200,DToC(SToD(_cDtEmis)),oFont02N)
	oPrint:Say(li,0650,"GLM OS " + SubStr(_cNumOS,1,4)+"-"+SubStr(_cNumOS,5,6),oFont02N)
	oPrint:Say(li,1190,_cHoraABO,oFont02N)
	oPrint:Say(li,1590,_cHoraFAT,oFont02N)
	oPrint:Say(li,1990,_cHoraTotal,oFont02N)			
                 
	_cTTABO   := SomaHoras(_cTTABO,_cHoraABO)      // somat�rio das horas abonadas
	_cTTFAT   := SomaHoras(_cTTFAT,_cHoraFAT)      // somat�rio das horas faturadas
	_cTTHoras := SomaHoras(_cTTHoras,_cHoraTotal)  // somat�rio das horas		

	li := li + 50  // incrementa contador de linhas         						                                                                   
			
	TMP->(DbSkip())  // incrementa contador de registros
    	  	
EndDo                                                         

If !Empty(_cTTHoras)
	_cTTABO   := AllTrim(StrTran(StrZero(_cTTABO,5,2),".",":"))    // total das horas abonadas
	_cTTFAT   := AllTrim(StrTran(StrZero(_cTTFAT,5,2),".",":"))    // total das horas faturadas
	_cTTHoras := AllTrim(StrTran(StrZero(_cTTHoras,5,2),".",":"))  // total das horas
                 
	oPrint:Line(li,0100,li,2325)			

	li := li + 30  // incrementa contador de linhas         						                                                                   
	
	oPrint:Say(li,1180,_cTTABO,oFont01N)
	oPrint:Say(li,1580,_cTTFAT,oFont01N)
	oPrint:Say(li,1980,_cTTHoras,oFont01N)			
EndIf

TMP->(DbCloseArea())	

gImpRodape()  // chamada a fun��o de impress�o do rodap�
oPrint:Preview()	
	
Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do �ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","C�digo do Cliente"     ,"C�digo do Cliente"     ,"C�digo do Cliente"     ,"mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	Aadd(aRegs,{cPerg,"02","Loja do Cliente"       ,"Loja do Cliente"       ,"Loja do Cliente"       ,"mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})	
	Aadd(aRegs,{cPerg,"03","M�s/Ano Fechamento"    ,"M�s/Ano Fechamento"    ,"M�s/Ano Fechamento"    ,"mv_ch3","C",07,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","",""})			

   For i := 1 To Len(aRegs)
      RecLock("SX1",.T.)
      For j := 1 To FCount()
         If j <= Len(aRegs[i])
            FieldPut(j,aRegs[i,j])              
         EndIf
      Next
      MsUnlock()
   Next
	
EndIf

Return  // Retorno da fun��o
***************************************************************************************************************************************************

Static Function gImpCabecalho()  // Impress�o do cabe�alho

oPrint:StartPage()

oPrint:SayBitmap(0000,0100,"LogoGLMCabec.Bmp",2235,0600)		

If nPag == 1  // se n�o for impress�o da 1a p�gina

	oPrint:Say(0600,0300,AllTrim(_cCidade) + ", " + SubStr(DToS(dDataBase),7,2) + " de " + aDsMes[Val(SubStr(DToS(dDataBase),5,2))] + " de " + SubStr(DToS(dDataBase),1,4) + ".",oFont01N)

	oPrint:Say(0700,0300,"�",oFont01N)

	oPrint:Say(0750,0300,AllTrim(_cNmCliente),oFont01N)

	oPrint:Say(0800,0300,AllTrim(_cCidCli) + " / " +  AllTrim(_cEstCli),oFont01N)

	oPrint:Say(0900,0300,"Aten��o: Sr(a). " + AllTrim(_cRespProj),oFont01N)

	oPrint:Say(0950,0597,Lower(AllTrim(_ceMailcli)),oFont01N)

	oPrint:Say(1050,0300,"Refer�ncia: Resumo do Faturamento - " + aDsMes[Val(SubStr(mv_par03,1,2))] + SubStr(mv_par03,3,5),oFont01N)
	
	oPrint:Say(1150,0300,"Prezado(a) Sr(a) " + AllTrim(_cRespProj) + ",",oFont01N)

	oPrint:Say(1250,0450,"Segue resumo do faturamento referente aos servi�os executados no m�s de",oFont01N)

	If SubStr(mv_par03,1,2)	<> "12"		
		oPrint:Say(1300,0300,aDsMes[Val(SubStr(mv_par03,1,2))] + SubStr(mv_par03,3,5) + ". Estaremos emitindo a Nota Fiscal Servi�o no dia " + "01/" + StrZero(Val(SubStr(mv_par03,1,2))+1,2) + "/" + SubStr(mv_par03,4,5) + " com",oFont01N)	
		oPrint:Say(1350,0300,"vencimento para o dia " + "05/" + StrZero(Val(SubStr(mv_par03,1,2))+1,2) + "/" + SubStr(mv_par03,4,5) + ".",oFont01N)	
	Else
		oPrint:Say(1300,0300,aDsMes[Val(SubStr(mv_par03,1,2))] + SubStr(mv_par03,3,5) + ". Estaremos emitindo a Nota Fiscal Servi�o no dia " + "01/01/" + StrZero(Val(SubStr(mv_par03,4,5))+1,4)+ " com",oFont01N)
		oPrint:Say(1350,0300,"vencimento para o dia " + "05/01/" + StrZero(Val(SubStr(mv_par03,4,5))+1,4) + ".",oFont01N)	
	EndIf			

	oPrint:Say(1450,0450,"Agradecemos antecipadamente a confian�a depositada colocando-nos a inteira",oFont01N)

	oPrint:Say(1500,0300,"disposi��o para eventuais esclarecimentos.",oFont01N)
	
	oPrint:Say(1650,0200,"QUADRO DEMONSTRATIVO DE HORAS:",oFont01N)
	
	oPrint:Line(1700,0100,1700,2325)			

	oPrint:Say(1720,0200,"DATA",oFont02N)
	oPrint:Say(1720,0650,"OS�s",oFont02N)	
	oPrint:Say(1720,1175,"HORAS ABONADAS",oFont02N)
	oPrint:Say(1720,1575,"HORAS FATURADAS",oFont02N)
	oPrint:Say(1720,1975,"TOTAL HORAS",oFont02N)									

	oPrint:Line(1780,0100,1780,2325)			

	li := 1810
		
Else	
	oPrint:Say(0600,0200,"QUADRO DEMONSTRATIVO DE HORAS:",oFont01N)

	oPrint:Line(0600,0100,0600,2325)			

	oPrint:Say(0620,0200,"DATA",oFont02N)
	oPrint:Say(0620,0650,"OS�s",oFont02N)	
	oPrint:Say(0620,1175,"HORAS ABONADAS",oFont02N)
	oPrint:Say(0620,1575,"HORAS FATURADAS",oFont02N)
	oPrint:Say(0620,1975,"TOTAL HORAS",oFont02N)									

	oPrint:Line(0780,0100,0780,2325)			

	li := 780
	
EndIf					

nPag++  // incrementa contador de p�ginas

Return  // Retorno da fun��o
***************************************************************************************************************************************************

Static Function gImpRodape()  // Impress�o do rodap�

Do Case
	Case cFilAnt == "01"  // GLM Inform�tica
		oPrint:SayBitmap(2900,0100,"LogoGLMInfoRod.Bmp",2235,0370)			
	Case cFilAnt == "02"  // GLM Empreendimentos
		oPrint:SayBitmap(2900,0100,"LogoGLMEmprRod.Bmp",2235,0370)		
	Case cFilAnt == "03"  // GLM Consulting
EndCase                     

oPrint:EndPage()

Return  // Retorno da fun��o