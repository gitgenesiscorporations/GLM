/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspA002 � Autor � George AC. Gon�alves � Data � 08/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspA002 � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFSolRec� Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gVerItem � Autor � George AC. Gon�alves � Data � 08/01/09  ���
���          � gWFHelpD � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFGestR � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFARede � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFUser  � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFSolApr� Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFAteERP� Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFGestC � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFCtrlC � Autor � George AC. Gon�alves � Data � 26/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Aprova��o da Solicita��o de Perfil de Acesso - Controller  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Sele��o da op��o aprova��o controller - Rotina gEspM003    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gEspA002()  // Aprova��o da Solicita��o de Perfil de Acesso - Controller

Public cTo              // para
Public cBody            // mensagem
Public cSubject         // t�tulo
Public cAnexo           // anexo
Public aModAnexo := {}  // array dos m�dulos para anexo

Public gcNumSol := ZZF->ZZF_NUM  // N�mero da solicita��o

DBSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // busca a linha da getdados

//��������������������������������������������������������������Ŀ
//� Opcoes de acesso para a Modelo 3                             �
//����������������������������������������������������������������
cOpcao := "ALTERAR"
nOpcE  := 2
nOpcG  := 3
N      := 1

//��������������������������������������������������������������Ŀ
//� Cria variaveis M->????? da Enchoice                          �
//����������������������������������������������������������������
RegToMemory("ZZE",(cOpcao=="INCLUIR"))

//��������������������������������������������������������������Ŀ
//� Cria aHeader e aCols da GetDados                             �
//����������������������������������������������������������������
nUsado  := 0
aHeader := {}

DbSelectArea("SX3")  // Seleciona arquivo de dicion�rio de dados
SX3->(DbSeek("ZZF"))  // Posiciona registro - arquivo ZZF
Do While SX3->(!Eof()) .And. SX3->x3_arquivo == "ZZF"  // percorre registro enquanto o arquivo for o ZZF
	If Alltrim(SX3->x3_campo) == "ZZF_FILIAL" .Or. Alltrim(SX3->x3_campo) == "ZZF_NUM"    .Or.;
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVG" .Or.;		          
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETG" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_STATG"  .Or. Alltrim(SX3->x3_campo) == "ZZF_OBSGES" .Or.;		   	   
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETC"
		SX3->(DbSkip())  // incrementa contador de registro
		Loop  // pega pr�ximo registro
	EndIf	
	If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel  // se campo em uso e o n�vel do usu�rio permite visualiza��o
    	nUsado := nUsado+1
        Aadd(aHeader, {AllTrim(SX3->x3_titulo),;
                       SX3->x3_campo,;
                       SX3->x3_picture,;
	                   SX3->x3_tamanho,;
	                   SX3->x3_decimal,;
	                   "AllwaysTrue()",;
    	               SX3->x3_usado,;
    	               SX3->x3_tipo,;
    	               SX3->x3_arquivo,;
    	               SX3->x3_context})
	EndIf
	    SX3->(DbSkip())  // incrementa contador de regsitro    
EndDo

aCols := {}
DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do �ndice
If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
	Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
		AADD(aCols,Array(nUsado+1))
		For _ni := 1 To nUsado
			aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
		Next 
		aCols[Len(aCols),nUsado+1]:=.F.
		ZZF->(DbSkip())  // incrementa contador de registro		
	EndDo   
EndIf

If Len(aCols) > 0
	//��������������������������������������������������������������Ŀ
	//� Executa a Modelo 3                                           �
	//����������������������������������������������������������������
	cTitulo        := cCadastro
	cAliasEnchoice := "ZZE"
	cAliasGetD     := "ZZF"
	cLinOk         := "AllwaysTrue()"
	cTudOk         := "AllwaysTrue()"
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"ZZE_NUMSOL"}

	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	//��������������������������������������������������������������Ŀ
	//� Executar processamento                                       �
	//����������������������������������������������������������������
	If _lRet  // se confirma grava��o                                                                  

		lAdmRede := .F.  // flag de envio para ADM Rede	
		lEnvWFA  := .F.  // flag de envio de workflow�s de aprova��es
		lEnvWFR  := .F.  // flag de envio de workflow�s de recusas		

		For n1 := 1 To Len(aCols)  // linhas  	          
			DBSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
			ZZF->(DbSetOrder(1))  // muda ordem do �ndice
			cSeqOa := aCols[n1,Ascan(aHeader,{|x|alltrim(x[2])=="ZZF_ITEM"})]  // busca as sequencias das linhas da getdados para procura na linha abaixo
			If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+cSeqOa))  // busca a linha da getdados
				RecLock("ZZF",.F.)  // trava o arquivo e inclui uma linha em branco para a inclusao dos dados novos
				ZZF->ZZF_STATC  := aCols[n1][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_STATC'})]   // status do retorno da aprova��o do controller
				ZZF->ZZF_OBSCON := aCols[n1][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_OBSCON'})]  // observa��o do retorno da aprova��o do controller
				ZZF->ZZF_DTRETC := dDataBase                                                   // data do retorno da aprova��o do controller
				ZZF->ZZF_HRRETC := Time()                                                      // hora do retorno da aprova��o do controller
				MsUnlock()	        

				If ZZF->ZZF_STATC == "1"  // aprovada

					U_gEspP001(ZZE->ZZE_NUMSOL,.F.)  // chamada a fun��o que processa atualiza��o de usu�rio/perfil							

					ZZF->(DbClearFilter()) // Limpa o filtro 	

					DBSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
					ZZF->(DbSetOrder(1))  // muda ordem do �ndice
					ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+cSeqOa))  // busca a linha da getdados

///					ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   		
					ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")'))   					

					DbSelectArea("ZZH")  // seleciona arquivo de log de movimenta��o de perfil
					RecLock("ZZH",.T.)  // se bloquear registro
					ZZH->ZZH_FILIAL := xFilial("ZZE")    // c�digo da filial
					ZZH->ZZH_NUMSOL := ZZE->ZZE_NUMSOL   // n�mero da solicita��o
					ZZH->ZZH_DTMOV  := dDataBase         // data da movimenta��o
					ZZH->ZZH_CDSOL  := ZZE->ZZE_CDSOL    // c�digo do usu�rio solicitante
					ZZH->ZZH_NMSOL  := ZZE->ZZE_NMSOL    // nome do usu�rio solicitante
					ZZH->ZZH_CDUSU  := ZZE->ZZE_CDUSU    // c�digo do usu�rio
					ZZH->ZZH_NMUSU  := ZZE->ZZE_NMUSU    // nome do usu�rio
					ZZH->ZZH_EMP    := ZZE->ZZE_EMP      // empresas
					ZZH->ZZH_ITEM   := cSeqOa            // sequencial da solicita��o
					ZZH->ZZH_CDMOD  := ZZF->ZZF_CDMOD    // c�digo do m�dulo
					ZZH->ZZH_DSMOD  := ZZF->ZZF_DSMOD    // descri��o do m�dulo
					ZZH->ZZH_CDGEST := ZZF->ZZF_GESTOR   // c�digo do usu�rio do gestor
					ZZH->ZZH_NMGEST := ZZF->ZZF_NMGEST   // nome do gestor
					ZZH->ZZH_CDPERF := ZZF->ZZF_CDPERF   // c�digo do perfil
					ZZH->ZZH_DSPERF := ZZF->ZZF_DSPERF   // descri��o do perfil
					ZZH->ZZH_CDCTRL := ZZF->ZZF_IDCTRL   // c�digo do usu�rio do controller
					ZZH->ZZH_DTRETG := ZZF->ZZF_DTRETG   // data do retorno da aprova��o do gestor
					ZZH->ZZH_DTRETC := dDataBase         // data do retorno da aprova��o do controller
					ZZH->ZZH_TIPO   := ZZE->ZZE_TIPO     // novo acesso
					ZZH->ZZH_SOLIC  := ZZE->ZZE_SOLIC    // refer�ncia da solicita��o
					MsUnLock()  // libera registro bloqueado    
              
					If lEnvWFA == .F.  // se workflow�s de aprova��es ainda n�o enviado

						cAnexo := gWFUser()  // chamada a fun��o de montagem do workflow para usu�rio informando usu�rio, perfil e matriz de capacita��o
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow					

						cAnexo := gWFSolApr()  // fun��o de montagem do workflow para solicitante informando usu�rio, perfil e matriz de capacita��o					
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow										

						cAnexo := gWFAteERP()  // fun��o de montagem do workflow para Atendimento ERP informando usu�rio, perfil e matriz de capacita��o
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow															

						DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
						ZZI->(DbSetOrder(1))  // muda ordem do �ndice
						If ZZI->(DbSeek(xFilial("ZZI")+ZZF->ZZF_GESTOR))  // posiciona regsitro
							If ZZI->ZZI_CAPAC == "S"  // se envia workflow de capacita��o do usu�rio
								cAnexo := gWFGestC(ZZI->ZZI_EMAIL)  // fun��o de montagem do workflow para gestor sobre capacita��o do usu�rio
								U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow																				
							EndIf	
						EndIf
						
						DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
						ZZI->(DbSetOrder(4))  // muda ordem do �ndice
						If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
							If ZZI->ZZI_CAPAC == "S"  // se envia workflow de capacita��o do usu�rio
								cAnexo := gWFCtrlC(ZZI->ZZI_EMAIL)  // fun��o de montagem do workflow para controller sobre capacita��o do usu�rio
								U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow																				
							EndIf							
						EndIf

						If lAdmRede == .F.  // flag de envio para ADM Rede	                      
							gWFARede()  // chamada a fun��o de montagem do workflow para Help Desk avisar a Administra��o de rede instalaro REMOTE
							U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
							
							lAdmRede := .T.  // flag de envio para ADM Rede													
						EndIf	
						
					EndIf	

					lEnvWFA := .T.  // flag de envio de workflow�s de aprova��es
					
				Else	  
					If lEnvWFR == .F.  // se workflow�s de recusas ainda n�o enviado				                                                                                  
						gWFSolRec()  // chamada a fun��o de montagem do workflow para solicitante sobre recusa do controller
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
							
						gWFGestR()  // chamada a fun��o de montagem do workflow para gestor sobre recusa do controller
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
					EndIf	
					
					lEnvWFR := .T.  // flag de envio de workflow�s de recusas
					
				EndIf						

			EndIf   
			
		Next 

		gVerItem()  // chamada a fun��o de verifica��o de itens para encerramento da solicita��o
             
	Endif
Endif

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFSolRec()  // fun��o de montagem do workflow para solicitante sobre recusa do gestor
     
cTo := ZZE->ZZE_EMAILS  // Destinat�rio do envio do workflow para o solicitante
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Recusa na aprova��o para inclus�o de perfil de acesso para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                            
	cSubject := "Recusa na aprova��o para altera��o de perfil de acesso para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.F.,ZZF->ZZF_STATG,"C","",.F.,.F.,.F.,"","5",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                            
Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gVerItem()  // chamada a fun��o de verifica��o de itens para encerramento da solicita��o

cArea    := GetArea()
cAreaZZF := ZZF->(GetArea())

gnCont := 0  // contador de item

ZZF->(DbClearFilter()) // Limpa o filtro 

cQuery := "    SELECT Count(*) AS QTD_ITEM "
cQuery += "      FROM " + RetSqlname("ZZF") + " ZZF "
cQuery += "     WHERE ZZF.ZZF_FILIAL = '" + xFilial("ZZF")  + "' And " 
cQuery += "           ZZF.ZZF_NUM    = '" + ZZE->ZZE_NUMSOL + "' And " 
cQuery += "           ZZF.D_E_L_E_T_ = ' '                           "
                                
TCQUERY cQuery Alias TMP NEW                                      

DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do �ndice
If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
	Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
		If !Empty(ZZF->ZZF_STATC) .Or. ZZF->ZZF_STATG == "2"  // recusada ou aprovada
			gnCont := gnCont + 1  // contador de item		
		EndIf	
		ZZF->(DbSkip())  // incrementa contador de regsitro
	EndDo
EndIf

If TMP->QTD_ITEM == gnCont  // se todos os itens recusados pelos gestores
	gWFHelpD()  // chamada a fun��o de montagem do workflow para o helpdesk registrar encerramento do chamado	
	If U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a fun��o de envio de workflow
		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(DbSeek(xFilial("ZZE")+ZZE->ZZE_NUMSOL))  // se existir registro de solicita��o      
			RecLock("ZZE",.F.)  // se bloquear registro
			ZZE->ZZE_STATUS := "3"        // status da solicita��o: 3-Encerrada
			ZZE->ZZE_DTENC  := dDataBase  // data de encerramento da solicita��o
			ZZE->ZZE_HRENC  := TIME()     // hora de encerramento da solicita��o
			MsUnlock()	        				
		EndIf			
	EndIf
EndIf

TMP->(DbCloseArea())	

///ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   
ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")'))   

ZZF->(RestArea(cAreaZZF))
RestArea(cArea)

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFHelpD()  // fun��o de montagem do workflow para o helpdesk registrar encerramento do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Encerramento da solicita��o de inclus�o de perfil de acesso para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                                  
	cSubject := "Encerramento da solicita��o de altera��o de perfil de acesso para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.F.,.F.,"","6",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFGestR()  // fun��o de montagem do workflow para gestor sobre recusa do controller
     
cTo := ""  // Destinat�rio do envio do workflow para o gestor
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(1))  // muda ordem do �ndice
If ZZI->(DbSeek(xFilial("ZZI")+ZZF->ZZF_GESTOR))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf
                                           
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Recusa na aprova��o para inclus�o de perfil de acesso para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                            
	cSubject := "Recusa na aprova��o para altera��o de perfil de acesso para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.F.,ZZF->ZZF_STATG,"C","",.F.,.F.,.F.,"","5",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                            
Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFARede()  // fun��o de montagem do workflow para Help Desk avisar a Administra��o de rede instalaro REMOTE

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
cSubject := "Instala��o do REMOTE na m�quina do NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF002(cSubject)  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFUser()  // fun��o de montagem do workflow para usu�rio informando usu�rio, perfil e matriz de capacita��o

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo

cTo      := ZZE->ZZE_EMAILU  // Destinat�rio do envio do workflow para o usu�rio
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Solicita��o de perfil de acesso aprovada para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicita��o de altera��o de perfil de acesso aprovada para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,If(ZZE->ZZE_TIPO=="1",.T.,.F.),"","3",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow

// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFSolApr()  // fun��o de montagem do workflow para solicitante informando usu�rio, perfil e matriz de capacita��o

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo

cTo      := ZZE->ZZE_EMAILS  // Destinat�rio do envio do workflow para o solicitante
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Solicita��o de perfil de acesso aprovada para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                               
	cSubject := "Solicita��o de altera��o de perfil de acesso aprovada para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                                                                 
// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFAteERP()  // fun��o de montagem do workflow para Atendimento ERP informando usu�rio, perfil e matriz de capacita��o

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo

cTo      := GetMV('END_ATERP')  // Destinat�rio do envio do workflow para o Atendimento ERP
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Solicita��o de perfil de acesso aprovada para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicita��o de altera��o de perfil de acesso aprovada para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                                                                 
// ; _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFGestC(cTo)  // fun��o de montagem do workflow para gestor sobre capacita��o do usu�rio
//cTo = Destinat�rio do envio do workflow para o gestor

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo     
                                           
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Solicita��o de perfil de acesso aprovada para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicita��o de altera��o de perfil de acesso aprovada para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                                                                 
// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFCtrlC(cTo)  // fun��o de montagem do workflow para controller sobre capacita��o do usu�rio
//cTo = Destinat�rio do envio do workflow para o gestor

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo
                                           
If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Solicita��o de perfil de acesso aprovada para o NOVO usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                               
	cSubject := "Solicita��o de altera��o de perfil de acesso aprovada para o usu�rio: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                                                                 
// _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da fun��o