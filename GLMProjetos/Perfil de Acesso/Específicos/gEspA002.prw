/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspA002 ³ Autor ³ George AC. Gonçalves ³ Data ³ 08/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspA002 ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFSolRec³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gVerItem ³ Autor ³ George AC. Gonçalves ³ Data ³ 08/01/09  ³±±
±±³          ³ gWFHelpD ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFGestR ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFARede ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFUser  ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFSolApr³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFAteERP³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFGestC ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFCtrlC ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Aprovação da Solicitação de Perfil de Acesso - Controller  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Seleção da opção aprovação controller - Rotina gEspM003    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gEspA002()  // Aprovação da Solicitação de Perfil de Acesso - Controller

Public cTo              // para
Public cBody            // mensagem
Public cSubject         // título
Public cAnexo           // anexo
Public aModAnexo := {}  // array dos módulos para anexo

Public gcNumSol := ZZF->ZZF_NUM  // Número da solicitação

DBSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
ZZE->(DbSetOrder(1))  // muda ordem do índice
ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // busca a linha da getdados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOpcao := "ALTERAR"
nOpcE  := 2
nOpcG  := 3
N      := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("ZZE",(cOpcao=="INCLUIR"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado  := 0
aHeader := {}

DbSelectArea("SX3")  // Seleciona arquivo de dicionário de dados
SX3->(DbSeek("ZZF"))  // Posiciona registro - arquivo ZZF
Do While SX3->(!Eof()) .And. SX3->x3_arquivo == "ZZF"  // percorre registro enquanto o arquivo for o ZZF
	If Alltrim(SX3->x3_campo) == "ZZF_FILIAL" .Or. Alltrim(SX3->x3_campo) == "ZZF_NUM"    .Or.;
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVG" .Or.;		          
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETG" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_STATG"  .Or. Alltrim(SX3->x3_campo) == "ZZF_OBSGES" .Or.;		   	   
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETC"
		SX3->(DbSkip())  // incrementa contador de registro
		Loop  // pega próximo registro
	EndIf	
	If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel  // se campo em uso e o nível do usuário permite visualização
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
DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do índice
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo        := cCadastro
	cAliasEnchoice := "ZZE"
	cAliasGetD     := "ZZF"
	cLinOk         := "AllwaysTrue()"
	cTudOk         := "AllwaysTrue()"
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"ZZE_NUMSOL"}

	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executar processamento                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lRet  // se confirma gravação                                                                  

		lAdmRede := .F.  // flag de envio para ADM Rede	
		lEnvWFA  := .F.  // flag de envio de workflow´s de aprovações
		lEnvWFR  := .F.  // flag de envio de workflow´s de recusas		

		For n1 := 1 To Len(aCols)  // linhas  	          
			DBSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
			ZZF->(DbSetOrder(1))  // muda ordem do índice
			cSeqOa := aCols[n1,Ascan(aHeader,{|x|alltrim(x[2])=="ZZF_ITEM"})]  // busca as sequencias das linhas da getdados para procura na linha abaixo
			If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+cSeqOa))  // busca a linha da getdados
				RecLock("ZZF",.F.)  // trava o arquivo e inclui uma linha em branco para a inclusao dos dados novos
				ZZF->ZZF_STATC  := aCols[n1][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_STATC'})]   // status do retorno da aprovação do controller
				ZZF->ZZF_OBSCON := aCols[n1][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_OBSCON'})]  // observação do retorno da aprovação do controller
				ZZF->ZZF_DTRETC := dDataBase                                                   // data do retorno da aprovação do controller
				ZZF->ZZF_HRRETC := Time()                                                      // hora do retorno da aprovação do controller
				MsUnlock()	        

				If ZZF->ZZF_STATC == "1"  // aprovada

					U_gEspP001(ZZE->ZZE_NUMSOL,.F.)  // chamada a função que processa atualização de usuário/perfil							

					ZZF->(DbClearFilter()) // Limpa o filtro 	

					DBSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
					ZZF->(DbSetOrder(1))  // muda ordem do índice
					ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+cSeqOa))  // busca a linha da getdados

///					ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   		
					ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")'))   					

					DbSelectArea("ZZH")  // seleciona arquivo de log de movimentação de perfil
					RecLock("ZZH",.T.)  // se bloquear registro
					ZZH->ZZH_FILIAL := xFilial("ZZE")    // código da filial
					ZZH->ZZH_NUMSOL := ZZE->ZZE_NUMSOL   // número da solicitação
					ZZH->ZZH_DTMOV  := dDataBase         // data da movimentação
					ZZH->ZZH_CDSOL  := ZZE->ZZE_CDSOL    // código do usuário solicitante
					ZZH->ZZH_NMSOL  := ZZE->ZZE_NMSOL    // nome do usuário solicitante
					ZZH->ZZH_CDUSU  := ZZE->ZZE_CDUSU    // código do usuário
					ZZH->ZZH_NMUSU  := ZZE->ZZE_NMUSU    // nome do usuário
					ZZH->ZZH_EMP    := ZZE->ZZE_EMP      // empresas
					ZZH->ZZH_ITEM   := cSeqOa            // sequencial da solicitação
					ZZH->ZZH_CDMOD  := ZZF->ZZF_CDMOD    // código do módulo
					ZZH->ZZH_DSMOD  := ZZF->ZZF_DSMOD    // descrição do módulo
					ZZH->ZZH_CDGEST := ZZF->ZZF_GESTOR   // código do usuário do gestor
					ZZH->ZZH_NMGEST := ZZF->ZZF_NMGEST   // nome do gestor
					ZZH->ZZH_CDPERF := ZZF->ZZF_CDPERF   // código do perfil
					ZZH->ZZH_DSPERF := ZZF->ZZF_DSPERF   // descrição do perfil
					ZZH->ZZH_CDCTRL := ZZF->ZZF_IDCTRL   // código do usuário do controller
					ZZH->ZZH_DTRETG := ZZF->ZZF_DTRETG   // data do retorno da aprovação do gestor
					ZZH->ZZH_DTRETC := dDataBase         // data do retorno da aprovação do controller
					ZZH->ZZH_TIPO   := ZZE->ZZE_TIPO     // novo acesso
					ZZH->ZZH_SOLIC  := ZZE->ZZE_SOLIC    // referência da solicitação
					MsUnLock()  // libera registro bloqueado    
              
					If lEnvWFA == .F.  // se workflow´s de aprovações ainda não enviado

						cAnexo := gWFUser()  // chamada a função de montagem do workflow para usuário informando usuário, perfil e matriz de capacitação
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow					

						cAnexo := gWFSolApr()  // função de montagem do workflow para solicitante informando usuário, perfil e matriz de capacitação					
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow										

						cAnexo := gWFAteERP()  // função de montagem do workflow para Atendimento ERP informando usuário, perfil e matriz de capacitação
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow															

						DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
						ZZI->(DbSetOrder(1))  // muda ordem do índice
						If ZZI->(DbSeek(xFilial("ZZI")+ZZF->ZZF_GESTOR))  // posiciona regsitro
							If ZZI->ZZI_CAPAC == "S"  // se envia workflow de capacitação do usuário
								cAnexo := gWFGestC(ZZI->ZZI_EMAIL)  // função de montagem do workflow para gestor sobre capacitação do usuário
								U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow																				
							EndIf	
						EndIf
						
						DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
						ZZI->(DbSetOrder(4))  // muda ordem do índice
						If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
							If ZZI->ZZI_CAPAC == "S"  // se envia workflow de capacitação do usuário
								cAnexo := gWFCtrlC(ZZI->ZZI_EMAIL)  // função de montagem do workflow para controller sobre capacitação do usuário
								U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow																				
							EndIf							
						EndIf

						If lAdmRede == .F.  // flag de envio para ADM Rede	                      
							gWFARede()  // chamada a função de montagem do workflow para Help Desk avisar a Administração de rede instalaro REMOTE
							U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
							
							lAdmRede := .T.  // flag de envio para ADM Rede													
						EndIf	
						
					EndIf	

					lEnvWFA := .T.  // flag de envio de workflow´s de aprovações
					
				Else	  
					If lEnvWFR == .F.  // se workflow´s de recusas ainda não enviado				                                                                                  
						gWFSolRec()  // chamada a função de montagem do workflow para solicitante sobre recusa do controller
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
							
						gWFGestR()  // chamada a função de montagem do workflow para gestor sobre recusa do controller
						U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
					EndIf	
					
					lEnvWFR := .T.  // flag de envio de workflow´s de recusas
					
				EndIf						

			EndIf   
			
		Next 

		gVerItem()  // chamada a função de verificação de itens para encerramento da solicitação
             
	Endif
Endif

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFSolRec()  // função de montagem do workflow para solicitante sobre recusa do gestor
     
cTo := ZZE->ZZE_EMAILS  // Destinatário do envio do workflow para o solicitante
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Recusa na aprovação para inclusão de perfil de acesso para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                            
	cSubject := "Recusa na aprovação para alteração de perfil de acesso para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.F.,ZZF->ZZF_STATG,"C","",.F.,.F.,.F.,"","5",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                            
Return  // retorno da função
***************************************************************************************************************************************************

Static Function gVerItem()  // chamada a função de verificação de itens para encerramento da solicitação

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

DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do índice
If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
	Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
		If !Empty(ZZF->ZZF_STATC) .Or. ZZF->ZZF_STATG == "2"  // recusada ou aprovada
			gnCont := gnCont + 1  // contador de item		
		EndIf	
		ZZF->(DbSkip())  // incrementa contador de regsitro
	EndDo
EndIf

If TMP->QTD_ITEM == gnCont  // se todos os itens recusados pelos gestores
	gWFHelpD()  // chamada a função de montagem do workflow para o helpdesk registrar encerramento do chamado	
	If U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a função de envio de workflow
		DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
		ZZE->(DbSetOrder(1))  // muda ordem do índice
		If ZZE->(DbSeek(xFilial("ZZE")+ZZE->ZZE_NUMSOL))  // se existir registro de solicitação      
			RecLock("ZZE",.F.)  // se bloquear registro
			ZZE->ZZE_STATUS := "3"        // status da solicitação: 3-Encerrada
			ZZE->ZZE_DTENC  := dDataBase  // data de encerramento da solicitação
			ZZE->ZZE_HRENC  := TIME()     // hora de encerramento da solicitação
			MsUnlock()	        				
		EndIf			
	EndIf
EndIf

TMP->(DbCloseArea())	

///ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   
ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3")'))   

ZZF->(RestArea(cAreaZZF))
RestArea(cArea)

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFHelpD()  // função de montagem do workflow para o helpdesk registrar encerramento do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Encerramento da solicitação de inclusão de perfil de acesso para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                                  
	cSubject := "Encerramento da solicitação de alteração de perfil de acesso para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.F.,.F.,"","6",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFGestR()  // função de montagem do workflow para gestor sobre recusa do controller
     
cTo := ""  // Destinatário do envio do workflow para o gestor
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(1))  // muda ordem do índice
If ZZI->(DbSeek(xFilial("ZZI")+ZZF->ZZF_GESTOR))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf
                                           
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Recusa na aprovação para inclusão de perfil de acesso para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                            
	cSubject := "Recusa na aprovação para alteração de perfil de acesso para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.F.,ZZF->ZZF_STATG,"C","",.F.,.F.,.F.,"","5",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                            
Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFARede()  // função de montagem do workflow para Help Desk avisar a Administração de rede instalaro REMOTE

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
cSubject := "Instalação do REMOTE na máquina do NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF002(cSubject)  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFUser()  // função de montagem do workflow para usuário informando usuário, perfil e matriz de capacitação

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo

cTo      := ZZE->ZZE_EMAILU  // Destinatário do envio do workflow para o usuário
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de perfil de acesso aprovada para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicitação de alteração de perfil de acesso aprovada para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,If(ZZE->ZZE_TIPO=="1",.T.,.F.),"","3",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow

// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se módulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da função
***************************************************************************************************************************************************

Static Function gWFSolApr()  // função de montagem do workflow para solicitante informando usuário, perfil e matriz de capacitação

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo

cTo      := ZZE->ZZE_EMAILS  // Destinatário do envio do workflow para o solicitante
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de perfil de acesso aprovada para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                               
	cSubject := "Solicitação de alteração de perfil de acesso aprovada para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                                                                 
// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se módulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da função
***************************************************************************************************************************************************

Static Function gWFAteERP()  // função de montagem do workflow para Atendimento ERP informando usuário, perfil e matriz de capacitação

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo

cTo      := GetMV('END_ATERP')  // Destinatário do envio do workflow para o Atendimento ERP
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de perfil de acesso aprovada para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicitação de alteração de perfil de acesso aprovada para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                                                                 
// ; _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se módulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da função
***************************************************************************************************************************************************

Static Function gWFGestC(cTo)  // função de montagem do workflow para gestor sobre capacitação do usuário
//cTo = Destinatário do envio do workflow para o gestor

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo     
                                           
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de perfil de acesso aprovada para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicitação de alteração de perfil de acesso aprovada para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                                                                 
// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se módulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da função
***************************************************************************************************************************************************

Static Function gWFCtrlC(cTo)  // função de montagem do workflow para controller sobre capacitação do usuário
//cTo = Destinatário do envio do workflow para o gestor

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo
                                           
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de perfil de acesso aprovada para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                               
	cSubject := "Solicitação de alteração de perfil de acesso aprovada para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.F.,"","3",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                                                                 
// _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se módulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

///aAnexo[1] := SubStr(cAnexo,1,Len(cAnexo)-1)                      
aAnexo[1] := cAnexo

Return aAnexo[1]  // retorno da função