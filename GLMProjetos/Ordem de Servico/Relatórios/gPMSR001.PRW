/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gPMSR001  � Autor � George AC. Gon�alves � Data � 16/04/14 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gPMSR001     � Autor � George Gon�alves  � Data � 16/04/14 ���
���          � gImpOS       � Autor � George Gon�alves  � Data � 16/04/14 ���
���          � gImpCabecalho� Autor � George Gon�alves  � Data � 16/04/14 ���
���          � gImpRodape   � Autor � George Gon�alves  � Data � 16/04/14 ���
���          � ValidPerg    � Autor � George Gon�alves  � Data � 16/04/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Ordem de Servi�o                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu - Rotina gPMSR001                         ���
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
            
User Function GPMSR001()  // Emiss�o da ordem de servi�o

cPerg := Padr("GLMOS",10)

//+---------------------------------------------------------------------+
//� Verifica as perguntas selecionadas                                  �
//+---------------------------------------------------------------------+
ValidPerg()  // chamada a fun��o de valida��o de grupo de perguntas

//+---------------------------------------------------------------------+
//� Variaveis utilizadas para parametros                                �
//� mv_par01  // N�mero da Ordem de Servi�o	                            �
//+---------------------------------------------------------------------+ 
If !Pergunte(cPerg,.T.)
	Return  // Retorno da fun��o
EndIf

Processa({||gImpOS()})  // chamada a fun��o de impress�o da ordem de servi�o

Return  // Retorno da fun��o
***************************************************************************************************************************************************

Static Function gImpOS()  // Fun��o de impress�o da ordem de servi�o
                   
Private li   := 9999
Private nPag := 1 

Private oFont01N 
Private oFont02N 
Private oFont03  
Private oFont04  
Private oFont04N 

Define FONT oFont1 NAME "Times New Roman" BOLD

oFont01N := TFont():New("Times New Roman",12,12,,.T.,,,,.T.,.F.)
oFont02N := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
oFont03  := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
oFont04  := TFont():New("Times New Roman",09,09,,.F.,,,,.T.,.F.)
oFont04N := TFont():New("Times New Roman",09,09,,.T.,,,,.T.,.F.)

oPrint := TMSPrinter():New("Emiss�o da Ordem de Servi�o")

oPrint:SetPortrait() 

ProcRegua(1)

DbSelectArea("SZ0")  // seleciona arquivo de cabe�alho da ordem de servi�o
SZ0->(DbSetOrder(1))  // muda ordem do �ndice
If SZ0->(!DbSeek(xFilial("SZ0")+mv_par01))  // posiciona registro
	MsgAlert("Ordem de Servi�o selecionada n�o encontrada")
	Return  // retorno da fun��o
EndIf

_cTranslado := SZ0->Z0_TRANS    // se cobra translado do cliente
_cAlmoco    := SZ0->Z0_DESCALM  // se desconta intervalo de almo�o do cliente
_cDtEmis    := SZ0->Z0_DTEMIS   // data de emiss�o/apontamento da OS
_cRespProj  := SZ0->Z0_RESPPR   // nome do respons�vel pelo projeto no cliente
_cHoraIni   := SZ0->Z0_HRINI    // hora inicial do atendimento
_cHoraAlm   := SZ0->Z0_HRALM    // hora de intervalo de almo�o
_cHoraTrans := SZ0->Z0_HRTRANS  // hora de translado
_cHoraFim   := SZ0->Z0_HRFIM    // hora de t�rmino do atendimento
_cHoraTotal := SZ0->Z0_HRTOT    // total de horas do atendimento             
_cHoraAbo   := SZ0->Z0_HRABO    // total de horas abonadas
_cHoraFat   := SZ0->Z0_HRFAT    // total de horas faturadas
_cCdTecnico := SZ0->Z0_CDREC    // c�digo do t�cnico
_cCtrlVers  := SZ0->Z0_CTRRVS   // controle de vers�o

_cDsProjeto := ""  // descri��o do projeto
DbSelectArea("AF8")  // seleciona arquivo de projetos
AF8->(DbSetOrder(1))  // muda ordem do �ndice
If AF8->(DbSeek(xFilial("AF8")+SZ0->Z0_PROJETO))  // posiciona registro
	_cDsProjeto := AF8->AF8_DESCRI  // descri��o do projeto         	
	DbSelectArea("SA1")  // seleciona arquivo de clientes
	SA1->(DbSetOrder(1))  // muda ordem do �ndice
	If SA1->(DbSeek(xFilial("SA1")+AF8->AF8_CLIENT+AF8->AF8_LOJA))  // posiciona registro
		_cNmCliente := SA1->A1_NOME  // nome do cliente
	EndIf	
EndIf

DbSelectArea("AE8")  // seleciona arquivo de recursos
AE8->(DbSetOrder(1))  // muda ordem do �ndice
If AE8->(DbSeek(xFilial("AE8")+_cCdTecnico))  // posiciona registro
	_cNmTecnico := AE8->AE8_DESCRI  // nome do t�cnico
EndIf

DbSelectArea("AFU")  // seleciona arquivo de apontamentos
AFU->(DbSetOrder(7))  // muda ordem do �ndice
If AFU->(DbSeek(xFilial("AFU")+_cCtrlVers+mv_par01))  // posiciona registro
	Do While AFU->(!Eof()) .And. AFU->AFU_DOCUME == mv_par01  // percorre o arquivo no intervalo

		// valida cancelamento pelo operador
		If LASTKEY() == 286 .Or. LASTKEY() == 27             
			Exit 
		EndIf

		_cHrIniTaref := AFU->AFU_HORAI                       // hora inicial da tarefa
		_cHrFimTaref := AFU->AFU_HORAF                       // hora do t�rmino da tarefa
		_cCdMemo     := AFU->AFU_CODMEM                      // c�digo do memo
		_cServExec   := MSMM(_cCdMemo,TamSx3("AFU_OBS")[1])  // servi�o executado		

		_cHrTotTaref := AFU->AFU_HQUANT                      // total de horas da tarefa
		If At(".",AllTrim(Str(_cHrTotTaref))) > 0 
			_cHrTotTaref := AllTrim(StrTran(StrZero(Val(AllTrim(Str((Val(SubStr(AllTrim(Str(_cHrTotTaref)),1,At(".",AllTrim(Str(_cHrTotTaref)))-1)))))+"."+AllTrim(Str(((Val(SubStr(AllTrim(Str(_cHrTotTaref)),At(".",AllTrim(Str(_cHrTotTaref)))+1,99))*60)/100)))),5,2),".",":"))
		Else
			_cHrTotTaref := AllTrim(StrTran(StrZero(_cHrTotTaref,5,2),".",":"))
		EndIf

		DbSelectArea("AN4")  // seleciona arquivo de tipo de tarefa
		AN4->(DbSetOrder(1))  // muda ordem do �ndice
		If AN4->(DbSeek(xFilial("AN4")+AFU->AFU_TPTARE))  // posiciona registro
			_cAtivReal := AN4->AN4_DESCRI  // descri��o do tipo de atividade realizada
		EndIf				

		DbSelectArea("SB1")  // seleciona arquivo de produtos
		SB1->(DbSetOrder(1))  // muda ordem do �ndice
		If SB1->(DbSeek(xFilial("SB1")+AFU->AFU_COD))  // posiciona registro
			_cTpServ := SB1->B1_DESC  // descri��o do tipo de servi�o
		EndIf				

		DbSelectArea("AF9")  // seleciona arquivo de tarefas do projeto
		AF9->(DbSetOrder(1))  // muda ordem do �ndice
		If AF9->(DbSeek(xFilial("AF9")+AFU->AFU_PROJET+AFU->AFU_REVISA+AFU->AFU_TAREFA))  // posiciona registro
			_cDsTarefa := AF9->AF9_DESCRI  // descri��o da tarefa do projeto
		EndIf				

		If li > 2400  // se quebra de p�gina
			If nPag > 1  // se n�o for impress�o da 1a p�gina
				gImpRodape()  // chamada a fun��o de impress�o do rodap�
			Endif
			
			gImpCabecalho()  // chamada a fun��o de impress�o do cabe�alho			
		EndIf   

		li := li + 100  // incrementa contador de linhas         						                                                                   
		oPrint:Line(li,0070,li,2325)			                                                                                                           
		li := li + 10  // incrementa contador de linhas         						                                                                   		
		oPrint:Line(li,0070,li,2325)			

		li := li + 30  // incrementa contador de linhas         						                                                                   
		oPrint:Say(li,0420,"ATIVIDADE REALIZADA",oFont02N)
		oPrint:Say(li,1616,"TIPO DE SERVI�O",oFont02N)

		li := li + 65  // incrementa contador de linhas         						                                                                   
		oPrint:Say(li+5,0085,_cAtivReal,oFont03)
		oPrint:Say(li+5,1228,_cTpServ,oFont03)

		oPrint:Box(li-15,0070,li+60,1182)			                             
		oPrint:Box(li-15,1213,li+60,2325)			                             			
		li := li + 60  // incrementa contador de linhas         						                                                                   

		li := li + 30  // incrementa contador de linhas         						                                                                   
		oPrint:Say(li,0550,"TAREFA",oFont02N)
		oPrint:Say(li,1271,"HORA INICIAL",oFont02N)
		oPrint:Say(li,1626,"HORA T�RMINO",oFont02N)
		oPrint:Say(li,2016,"TOTAL HORAS",oFont02N)									

		li := li + 65  // incrementa contador de linhas         						                                                                   			
		oPrint:Say(li+5,0085,_cDsTarefa,oFont03)
		oPrint:Say(li+5,1352,_cHrIniTaref,oFont03)
		oPrint:Say(li+5,1738,_cHrFimTaref,oFont03)		
		oPrint:Say(li+5,2115,_cHrTotTaref,oFont03)									
            
		oPrint:Box(li-15,0070,li+60,1182)			                             
		oPrint:Box(li-15,1213,li+60,1563)			                             			
		oPrint:Box(li-15,1594,li+60,1944)			                             			
		oPrint:Box(li-15,1975,li+60,2325)			                             
		li := li + 60  // incrementa contador de linhas         						                                                                   

		li := li + 30  // incrementa contador de linhas         						                                                                   
		oPrint:Say(li,0975,"SERVI�OS EXECUTADOS",oFont02N)

		li := li + 50  // incrementa contador de linhas         						                                                                   			                                               
  		oPrint:Line(li,0070,li,2325)			

		li := li - 20  // incrementa contador de linhas         						                                                                   			                                               
		For _Ln := 1 To MlCount(_cServExec)		                   
			li := li + 50  // incrementa contador de linhas        

				If li > 2400  // se quebra de p�gina                    
					gImpRodape()  // chamada a fun��o de impress�o do rodap�
					gImpCabecalho()  // chamada a fun��o de impress�o do cabe�alho			
				EndIf   
									 						                                                                   					
			oPrint:Say(li,0085,AllTrim(MemoLine(_cServExec,155,_Ln)),oFont04)
		Next

		li := li - 150  // incrementa contador de linhas         						                                                                   			                                               
		AFU->(DbSkip())  // incrementa contador de registros
    	  	
	EndDo                                                         

	gImpRodape()  // chamada a fun��o de impress�o do rodap�
	oPrint:Preview()	
	
EndIf	

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gImpCabecalho()  // Impress�o do cabe�alho

oPrint:StartPage()

oPrint:SayBitmap(0000,-0070,"LogoGlm.Bmp",0600,0400)
			      
Do Case
	Case cFilAnt == "01"  // GLM Inform�tica
		oPrint:SayBitmap(0000,0500,"LogoGlmInfo.Bmp",1850,0370)			
	Case cFilAnt == "02"  // GLM Empreendimentos
		oPrint:SayBitmap(0000,0500,"LogoGlmEmpr.Bmp",1850,0370)		
	Case cFilAnt == "03"  // GLM Consulting
EndCase
			
oPrint:Say(0370,1340,"ORDEM DE SERVI�O N�   GLM OS " + SubStr(mv_par01,1,4)+"-"+SubStr(mv_par01,5,6),oFont01N)

oPrint:Box(0360,1852,0430,2325)			                             

oPrint:Line(0450,0070,0450,2325)			
oPrint:Line(0460,0070,0460,2325)			

oPrint:Say(0490,0543,"PROJETO",oFont02N)
oPrint:Say(0490,1280,"TRANSLADO",oFont02N)
oPrint:Say(0490,1694,"ALMO�O",oFont02N)
oPrint:Say(0490,2015,"DATA EMISS�O",oFont02N)									
			
oPrint:Say(0560,0085,SubStr(_cDsProjeto,1,67),oFont03)
oPrint:Say(0560,1360,IIf(_cTranslado=="S","SIM","N�O"),oFont03)
oPrint:Say(0560,1755,IIf(_cAlmoco=="S","SIM","N�O"),oFont03)
oPrint:Say(0560,2075,DToC(_cDtEmis),oFont03)									
            
oPrint:Box(0540,0070,0610,1182)			                             
oPrint:Box(0540,1213,0610,1563)			                             			
oPrint:Box(0540,1594,0610,1944)			                             			
oPrint:Box(0540,1975,0610,2325)			                             
			
oPrint:Say(0640,0551,"CLIENTE",oFont02N)
oPrint:Say(0640,1630,"RESPONS�VEL",oFont02N)
			
oPrint:Say(0710,0085,_cNmCliente,oFont03)
oPrint:Say(0710,1228,_cRespProj,oFont03)

oPrint:Box(0690,0070,0760,1182)			                             
oPrint:Box(0690,1213,0760,2325)			                             			

If nPag == 1  // se n�o for impress�o da 1a p�gina
	oPrint:Say(0790,0120,"HORA INICIAL",oFont02N)
	oPrint:Say(0790,0489,"HORA ALMO�O",oFont02N)			
	oPrint:Say(0790,0835,"HORA TRANSLADO",oFont02N)
	oPrint:Say(0790,1250,"HORA T�RMINO",oFont02N)
	oPrint:Say(0790,1595,"HORAS ABONADAS",oFont02N)									
	oPrint:Say(0790,1972,"HORAS FATURADAS",oFont02N)												
                                
	oPrint:Say(0860,0209,_cHoraIni,oFont03)
	oPrint:Say(0860,0594,_cHoraAlm,oFont03)			
	oPrint:Say(0860,0975,_cHoraTrans,oFont03)
	oPrint:Say(0860,1357,_cHoraFim,oFont03)                                    
	oPrint:Say(0860,1732,_cHoraAbo,oFont03)												
	oPrint:Say(0860,2119,_cHoraFat,oFont03)									

	oPrint:Box(0840,0070,0910,0420)			                             
	oPrint:Box(0840,0451,0910,0801)			                             			
	oPrint:Box(0840,0832,0910,1182)			                             						
	oPrint:Box(0840,1213,0910,1563)			                             			
	oPrint:Box(0840,1594,0910,1944)			                             			
	oPrint:Box(0840,1975,0910,2325)			                             

	li := 840
		
Else	
	li := 690
	
EndIf					

nPag++  // incrementa contador de p�ginas

Return  // Retorno da fun��o
***************************************************************************************************************************************************

Static Function gImpRodape()  // Impress�o do rodap�
           
li := 2500
oPrint:Line(li,0070,li,2325)			
li := li + 10  // incrementa contador de linhas         						                                                                   			                                               		
oPrint:Line(li,0070,li,2325)			

li := li + 30  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0650,"T�CNICO",oFont02N)
oPrint:Say(li,1678,"ASSINATURA CLIENTE",oFont02N)

li := li + 65  // incrementa contador de linhas         						                                                                   
oPrint:Say(li+5,0085,SubStr(_cCdTecnico,10,6)+"-"+_cNmTecnico,oFont03)

oPrint:Box(li-15,0070,li+60,1388)			                             
oPrint:Box(li-15,0750,li+60,1388)			                             
oPrint:Box(li-15,1419,li+60,2325)			                             			
li := li + 60  // incrementa contador de linhas         						                                                                   
	
li := li + 30  // incrementa contador de linhas         						                                                                   			                                               		
oPrint:Line(li,0070,li,2325)			
li := li + 10  // incrementa contador de linhas         						                                                                   			                                               		
oPrint:Line(li,0070,li,2325)			

li := li + 30  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"Este documento tem a finalidade de:",oFont04N)
li := li + 50  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"   - Acompanhar o desenvolvimento/implanta��o e suporte do analista e/ou projeto;",oFont04N)
li := li + 50  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"   - Relatar os servi�os realizados pelo analista e/ou coordenador;",oFont04N)
li := li + 50  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"   - Ve�culo de comunica��o entre os Clientes X GLM Inform�tica;",oFont04N)
li := li + 50  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"   - Autoriza��o para faturamento dos servi�os prestados e realizados;",oFont04N)

li := li + 65  // incrementa contador de linhas         						                                                                   			                                               		
oPrint:Line(li,0070,li,2325)			
li := li + 10  // incrementa contador de linhas         						                                                                   			                                               		
oPrint:Line(li,0070,li,2325)			

li := li + 30  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"Alertamos que caso o cliente n�o se pronuncie, concordando ou n�o com o exposto, no prazo de 48 horas da data de emiss�o desta ordem de servi�o,",oFont04N)
li := li + 50  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"seja via telefone, e-mail ou fax, perder� o direito de reclama��o.",oFont04N)
li := li + 65  // incrementa contador de linhas         						                                                                   
oPrint:Say(li,0085,"1a. via: GLM Inform�tica - 2a. via: Cliente",oFont04N)

oPrint:EndPage()

Return  // Retorno da fun��o
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do �ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","N�mero da OS"          ,"N�mero da OS"          ,"N�mero da OS"          ,"mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZ0","","","","",""})

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