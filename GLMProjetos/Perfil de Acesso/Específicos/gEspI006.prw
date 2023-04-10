/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspI006 ³ Autor ³ George AC. Gonçalves ³ Data ³ 22/05/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspI006 ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFHelpA ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFHelpE ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFCtrlC ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFGestor³ Autor ³ George AC. Gonçalves ³ Data ³ 03/06/09  ³±±
±±³          ³ gWFUser  ³ Autor ³ George AC. Gonçalves ³ Data ³ 03/06/09  ³±±
±±³          ³ gWFARede ³ Autor ³ George AC. Gonçalves ³ Data ³ 03/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Manutenção no Bloqueio de Acesso do Usuário                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Seleção da opção bloqueio de usuário - Rotina gEspM008     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "tbiconn.ch"
#Include "Ap5Mail.ch"
#include "Topconn.ch"      

User Function gEspI006()  // Manutenção no Bloqueio de Acesso de Usuário

Public cTo       // para
Public cBody     // mensagem
Public cSubject  // título
Public cAnexo    // anexo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOpcao := "INCLUIR"
nOpcE  := 3
nOpcG  := 2
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
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_STATC"  .Or. Alltrim(SX3->x3_campo) == "ZZF_OBSCON" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_TIPO"
		sx3->(DbSkip())  // incrementa contador de registro
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

aCols             := {Array(nUsado+1)}
aCols[1,nUsado+1] := .F.
For _ni := 1 To nUsado
	aCols[1,_ni] := CriaVar(aHeader[_ni,2])
Next

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
                              
	// recupera número da solicitação de acesso
	M->ZZE_NUMSOL := StrZero(Val(GetSX8NUM("ZZE","ZZE_NUMSOL"))+1,12)
	If Val(SubStr(M->ZZE_NUMSOL,1,4)) <> Val(SubStr(DToS(dDataBase),1,4))  
		M->ZZE_NUMSOL := SubStr(DToS(dDataBase),1,4)+"00000001"
	EndIf

	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executar processamento                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lRet  // se confirma gravação                                                                  
	
	    // grava arquivo de solicitação de acesso - usuário
		DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
		ZZE->(DbSetOrder(1))  // muda ordem do índice
		If ZZE->(!DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se não existir registro de solicitação      
			RecLock("ZZE",.T.)  // se bloquear registro
			ZZE->ZZE_FILIAL := xFilial("ZZE")  // código da filial
			ZZE->ZZE_NUMSOL := M->ZZE_NUMSOL   // número da solicitação
			ZZE->ZZE_DTSOL  := M->ZZE_DTSOL    // data da solicitação
			ZZE->ZZE_HRSOL  := M->ZZE_HRSOL    // hora da solicitação
			ZZE->ZZE_STATUS := "3"             // status da solicitação: 3-Encerrada
			ZZE->ZZE_TIPO   := "3"             // tipo da solicitação: 3-Bloqueio Perfil			
			ZZE->ZZE_CDSOL  := M->ZZE_CDSOL    // código do usuário solicitante
			ZZE->ZZE_IDUSUS := M->ZZE_IDUSUS   // ID do usuário solicitante			
			ZZE->ZZE_MATSOL := M->ZZE_MATSOL   // matrícula do solicitante
			ZZE->ZZE_NMSOL  := M->ZZE_NMSOL    // nome do usuário solicitante
			ZZE->ZZE_CDDEPT := M->ZZE_CDDEPT   // código do departamento do solicitante
			ZZE->ZZE_DSDEPT := M->ZZE_DSDEPT   // descrição do departamento do solicitante
			ZZE->ZZE_CDFUNC := M->ZZE_CDFUNC   // código do cargo/função do solicitante
			ZZE->ZZE_DSFUNC := M->ZZE_DSFUNC   // descrição do cargo/função do solicitante
			ZZE->ZZE_EMAILS := M->ZZE_EMAILS   // e-Mail do solicitante
			ZZE->ZZE_LOCAL  := M->ZZE_LOCAL    // localidade do solicitante
			ZZE->ZZE_TELSOL := M->ZZE_TELSOL   // telefone/ramal do solicitante
			ZZE->ZZE_CDUSU  := M->ZZE_CDUSU    // código do usuário
			ZZE->ZZE_VFUNC  := M->ZZE_VFUNC    // vinculo funcional
			ZZE->ZZE_EMPPRE := M->ZZE_EMPPRE   // empresa prestadora do serviço			
			ZZE->ZZE_MATUSU := M->ZZE_MATUSU   // matrícula do usuário
			ZZE->ZZE_NMUSU  := M->ZZE_NMUSU    // nome do usuário
			ZZE->ZZE_USUSUP := M->ZZE_USUSUP   // código de usuário do supervisor
			ZZE->ZZE_NMUSUP := M->ZZE_NMUSUP   // nome de usuário do supervisor
			ZZE->ZZE_CDDEPU := M->ZZE_CDDEPU   // código do departamento do usuário       
			ZZE->ZZE_NMDEPU := M->ZZE_NMDEPU   // descrição do departamento do usuário
			ZZE->ZZE_CDFUNU := M->ZZE_CDFUNU   // código do cargo/função do usuário
			ZZE->ZZE_DSFUNU := M->ZZE_DSFUNU   // decrição do cargo/função do usuário
			ZZE->ZZE_EMAILU := M->ZZE_EMAILU   // e-Mail do usuário
			ZZE->ZZE_LOCALU := M->ZZE_LOCALU   // localidade do usuário
			ZZE->ZZE_TELUSU := M->ZZE_TELUSU   // telefone/ramal do usuário
			ZZE->ZZE_EMP    := M->ZZE_EMP      // empresas
			ZZE->ZZE_CTRL   := M->ZZE_CTRL     // controller
			ZZE->ZZE_IDCTRL := M->ZZE_IDCTRL   // ID do controller			                    
			ZZE->ZZE_DTENC  := dDataBase       // data de encerramento da solicitação
			ZZE->ZZE_HRENC  := TIME()          // hora de encerramento da solicitação				  
			ZZE->ZZE_DTIBLQ := M->ZZE_DTIBLQ   // data de início do bloqueio
			ZZE->ZZE_DTFBLQ := M->ZZE_DTFBLQ   // data de término do bloqueio
			ZZE->ZZE_MOTBLQ := M->ZZE_MOTBLQ   // motivo do bloqueio		       
			ZZE->ZZE_IDUSU  := M->ZZE_IDUSU    // Código do usuário
			ZZE->ZZE_SOLIC  := "06"            // 01=Solicitação de perfil de acesso;02=Alteração de cargo/função;03=Transferência departamental;04=Transferência entre empresas/filias;05=Transferência entre SA´s;06=Bloqueio de usuário;07=Desligamento de usuário;08=Desbloqueio de acesso;09=Reinicialização de senha;10=Seleção de ambiente/empresa;
			MsUnLock()  // libera registro bloqueado    
			ConfirmSX8("ZZE","ZZE_NUMSOL")  // grava número da solicitação de acesso			
 		EndIf

		gGestorAnt := ""   // gestor anterior
		
	    // grava arquivo de solicitação de acesso - perfil
		DBSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
		ZZF->(DbSetOrder(1))  // muda ordem do índice
		
		For n1 := 1 To Len(aCols)  // linhas  	          
			cSeqOa := aCols[n1,Ascan(aHeader,{|x|alltrim(x[2])=="ZZF_ITEM"})]  // busca as sequencias das linhas da getdados para procura na linha abaixo
			If ZZF->(!DbSeek(xFilial("ZZF")+M->ZZE_NUMSOL+cSeqOa ))  // busca a linha da getdados
				// Se é uma linha nova inclui a linha no arquivo
				RecLock("ZZF",.T.)  // trava o arquivo e inclui uma linha em branco para a inclusao dos dados novos
				For n2 := 1 To Len(aHeader)  // Colunas
					If aCols[n1,Len(aCols[n1])] == .F.  // se linha não deletada
						FieldPut(FieldPos(aHeader[n2,2]),aCols[n1,n2])              
					EndIf
				Next 	        
				ZZF->ZZF_FILIAL := xFilial("ZZF")  // código da filial
				ZZF->ZZF_NUM    := M->ZZE_NUMSOL   // número da solicitação
				ZZF->ZZF_ITEM   := StrZero(n1,2)   // grava sequencia      
				ZZF->ZZF_TIPO   := "3"             // tipo da solicitação: 3-Bloqueio Perfil							
				MsUnlock()	        

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
				ZZH->ZZH_TIPO   := ZZE->ZZE_TIPO     // novo acesso
				MsUnLock()  // libera registro bloqueado    

				If !Empty(gGestorAnt) .And. ZZF->ZZF_GESTOR <> gGestorAnt  // se gestor atual diferente do anterior 
					gWFGestor(gGestorAnt)  // chamada a função de montagem do workflow para aprovação dos gestores
					U_gEspEWF(gGestorAnt,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
					gGestorAnt := ZZF->ZZF_GESTOR                 // iguala posição de gestores       
                EndIf                                                           
                
				gGestorAnt := ZZF->ZZF_GESTOR                 // iguala posição de gestores                

			EndIf   
		Next 

		DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
		ZZI->(DbSetOrder(1))  // muda ordem do índice
		If ZZI->(DbSeek(xFilial("ZZI")+gGestorAnt))  // posiciona regsitro
			gWFGestor(ZZI->ZZI_EMAIL)  // função de montagem do workflow para controller sobre capacitação do usuário
			U_gEspEWF(ZZI->ZZI_EMAIL,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow																				
		EndIf
		
		U_gEspP002(ZZE->ZZE_NUMSOL,"B")  // chamada a função que processa atualização de usuário/perfil							

		// Envio de WORKFLOW´s
		gWFHelpA()  // chamada a função de montagem do workflow para o helpdesk registrar abertura do chamado
		If U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a função de envio de workflow
			DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
			ZZE->(DbSetOrder(1))  // muda ordem do índice
			If ZZE->(DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se existir registro de solicitação      
				RecLock("ZZE",.F.)  // se bloquear registro
				ZZE->ZZE_DTEWFM := dDataBase  // data de envio do workflow para o helpdesk
				ZZE->ZZE_HREWFM := TIME()     // hora de envio do workflow para o helpdesk
				MsUnlock()	        				
			EndIf		
		EndIf
		
		DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
		ZZI->(DbSetOrder(4))  // muda ordem do índice
		If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
			gWFCtrlC(ZZI->ZZI_EMAIL)  // função de montagem do workflow para controller sobre capacitação do usuário
			U_gEspEWF(ZZI->ZZI_EMAIL,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow																				
		EndIf

		gWFUser()  // chamada a função de montagem do workflow para usuário informando o bloqueio
		U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow					
						
		gWFARede()  // chamada a função de montagem do workflow para Help Desk avisar a Administração de rede bloquear o REMOTE
		U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow

		gWFHelpE()  // chamada a função de montagem do workflow para o helpdesk registrar encerramento do chamado
		U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a função de envio de workflow
    
	Else 
		RollBackSX8("ZZE","ZZE_NUMSOL")  // se não confirmou volta a numeração sequencial do arquivo de solicitação
	Endif
Endif

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFHelpA()  // função de montagem do workflow para o helpdesk registrar abertura do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
cSubject := "Abertura da solicitação de bloqueio de perfil de acesso para o usuário "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFCtrlC(cTo)  // função de montagem do workflow para controller sobre capacitação do usuário
//cTo = Destinatário do envio do workflow para o gestor

cSubject := "Comunicação de bloqueio de perfil de acesso para o usuário "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFHelpE()  // função de montagem do workflow para o helpdesk registrar encerramento do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
cSubject := "Encerramento da solicitação de bloqueio de perfil de acesso para o usuário "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFARede()  // função de montagem do workflow para Help Desk avisar a Administração de rede instalaro REMOTE

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
cSubject := "Bloquear temporáriamente o acesso a rede do usuário "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função                                                                               
***************************************************************************************************************************************************

Static Function gWFUser()  // função de montagem do workflow para usuário informando o bloqueio

cTo      := ZZE->ZZE_EMAILU  // Destinatário do envio do workflow para o usuário
cSubject := "Seu acesso foi Bloqueado temporáriamente "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFGestor(cTo)  // função de montagem do workflow para gestor sobre bloqueio do usuário
//cTo = Destinatário do envio do workflow para o gestor

cSubject := "Comunicação de bloqueio de perfil de acesso para o usuário "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a função de montagem da mensagem para workflow
                                                                 
Return  // retorno da função