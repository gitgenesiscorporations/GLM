/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspI013 ³ Autor ³ George AC. Gonçalves ³ Data ³ 15/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspI013 ³ Autor ³ George AC. Gonçalves ³ Data ³ 15/06/09  ³±±
±±³          ³ gWFHelpD ³ Autor ³ George AC. Gonçalves ³ Data ³ 03/06/09  ³±±
±±³          ³ gWFGestor³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Manutenção na Seleção de Ambientes/Empresas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Seleção da opção seleção de amebientes - Rotina gEspM015   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "tbiconn.ch"
#Include "Ap5Mail.ch"
#include "Topconn.ch"      

User Function gEspI013()  // Manutenção na Seleção de Ambientes/Empresas

Public cTo              // para
Public cBody            // mensagem
Public cSubject         // título
Public cAnexo           // anexo
Public aModAnexo := {}  // array dos módulos para anexo

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

aCols := MontaAcols(aCols)  // monta acols

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
			ZZE->ZZE_STATUS := "1"             // status da solicitação: 1-Em aberto
			ZZE->ZZE_TIPO   := "2"             // tipo da solicitação: 2-Alteração Perfil			
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
			ZZE->ZZE_UHOMO  := M->ZZE_UHOMO    // Identifica usuário homônimo			
			ZZE->ZZE_IDUSU  := M->ZZE_IDUSU    // Código do usuário
			ZZE->ZZE_PERAVR := M->ZZE_PERAVR   // Permite avançar ou retroceder dias para lançamento
			ZZE->ZZE_AVANCO := M->ZZE_AVANCO   // Número de dias a avançar para lançamento
			ZZE->ZZE_RETROC := M->ZZE_RETROC   // Número de dias a retroceder para lançamento						
			ZZE->ZZE_SOLIC  := "10"            // 01=Solicitação de perfil de acesso;02=Alteração de cargo/função;03=Transferência departamental;04=Transferência entre empresas/filias;05=Transferência entre SA´s;06=Bloqueio de usuário;07=Desligamento de usuário;08=Desbloqueio de acesso;09=Reinicialização de senha;10=Seleção de ambiente/empresa;
			MsUnLock()  // libera registro bloqueado    
			ConfirmSX8("ZZE","ZZE_NUMSOL")  // grava número da solicitação de acesso			
 		EndIf

	    // grava arquivo de solicitação de acesso - perfil
		DBSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
		ZZF->(DbSetOrder(1))  // muda ordem do índice
		
		For n1 := 1 To Len(aCols)  // linhas  	          
			If aCols[n1,Len(aCols[n1])] == .T.  // se linha não deletada		
				Loop  // pega próximo item
			EndIf
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
				ZZF->ZZF_TIPO   := "2"             // tipo da solicitação: 2-Alteração Perfil							
				MsUnlock()	        
			EndIf   
		Next 

		// Envio de WORKFLOW´s
		gWFHelpD()  // chamada a função de montagem do workflow para o helpdesk registrar abertura do chamado
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
                     
		gGestorAnt := ""   // gestor anterior
		gcModPerf  := ""  // código do módulo/perfil					
		DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
		ZZF->(DbSetOrder(3))  // muda ordem do índice
		If ZZF->(DbSeek(xFilial("ZZF")+M->ZZE_NUMSOL))  // posiciona registro
			Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == M->ZZE_NUMSOL  // percorre o arquivo no intervalo
			
				RecLock("ZZF",.F.)  // se bloquear registro
				ZZF->ZZF_DTENVG := dDataBase  // data de envio ao gestor
				ZZF->ZZF_HRENVG := TIME()     // hora de envio ao gestor					
				MsUnLock()  // libera registro bloqueado    				
                          
				If !Empty(gGestorAnt) .And. ZZF->ZZF_GESTOR <> gGestorAnt  // se gestor atual diferente do anterior 
					cAnexo    := gWFGestor(gGestorAnt,gcModPerf)  // chamada a função de montagem do workflow para aprovação dos gestores
					gcModPerf := ""
					U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
					DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
					ZZE->(DbSetOrder(1))  // muda ordem do índice
		   			If ZZE->(DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se não existir registro de solicitação      
						RecLock("ZZE",.F.)  // se bloquear registro
						ZZE->ZZE_STATUS := "2"  // status da solicitação: 2-Aguardando Aprovação
						MsUnLock()  // libera registro bloqueado    
			 		EndIf
					gGestorAnt := ZZF->ZZF_GESTOR                 // iguala posição de gestores       
                EndIf                                                           
                
				gGestorAnt := ZZF->ZZF_GESTOR                 // iguala posição de gestores                
				gcModPerf  := gcModPerf+ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF+ZZF->ZZF_NIVEL+","  // código do módulo/perfil
				ZZF->(DbSkip())  // incrementa contador de registro		
				
			EndDo
			
			cAnexo    := gWFGestor(gGestorAnt,gcModPerf)  // chamada a função de montagem do workflow para aprovação dos gestores
			gcModPerf := ""
			U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
			DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
			ZZE->(DbSetOrder(1))  // muda ordem do índice
			If ZZE->(DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se não existir registro de solicitação      
				RecLock("ZZE",.F.)  // se bloquear registro
				ZZE->ZZE_STATUS := "2"  // status da solicitação: 2-Aguardando Aprovação
				MsUnLock()  // libera registro bloqueado    
	 		EndIf
			
	 	EndIf	

	Else 
		RollBackSX8("ZZE","ZZE_NUMSOL")  // se não confirmou volta a numeração sequencial do arquivo de solicitação	 	
	Endif
Endif

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFHelpD()  // função de montagem do workflow para o helpdesk registrar abertura do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
cSubject := "Abertura da solicitação de seleção de ambiente/empresa para o usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF004(cSubject,.T.,"","","",.F.,.F.,.F.,"","1",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFGestor(gcGestor,gcModPerf)  // função de montagem do workflow para aprovação dos gestores
//gcGestor  = Código do gestor               
//gcModPerf = Códigos do(s) módulo(s)/perfil(is)

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo
     
cTo := ""  // Destinatário do envio do workflow para o gestor
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(1))  // muda ordem do índice
If ZZI->(DbSeek(xFilial("ZZI")+gcGestor))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf

cSubject := "Solicitação de aprovação para seleção de ambiente/empresa para o usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF004(cSubject,.T.,"","G",gcGestor,.T.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                            
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

aAnexo[1] := cAnexo                                            

Return aAnexo[1]  // retorno da função
***************************************************************************************************************************************************

Static Function MontaAcols(aCols)  // função de montagem do acols

PSWORDER(1)  // muda ordem de índice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usuário no arquivo
	aArray := PSWRET()
Else	              
	aArray := {}
EndIf	

vLinha := AClone(aCols[N])
	
For gLn := 1 To Len(aArray[1][10])
	gcCdMod  := SubStr(aArray[1][10][gLn],1,2)  // código do módulo
	gcCdPerf := SubStr(aArray[1][10][gLn],3,2)  // código do perfil

	gcCdDepto := ""  // código do departamento
	gcDsDepto := ""  // descrição do departamento
	gcDsMod   := ""  // descrição do módulo
	gcCdGest  := ""  // Código do gestor do módulo
	gcNmGest  := ""  // Nome do gestor do módulo  
	gcIDGest  := ""  // ID do gestor do módulo				
	DbSelectArea("ZZJ")  // seleciona arquivo de departamento/módulo
	ZZJ->(DbSetOrder(2))  // muda ordem do índice
	If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona ponteiro
		gcCdDepto := ZZJ->ZZJ_CDDEP   // código do departamento
		gcDsDepto := ZZJ->ZZJ_DSDEP   // descrição do departamento			
		gcDsMod   := ZZJ->ZZJ_DSMOD   // descrição do módulo			
		gcCdGest  := ZZJ->ZZJ_GESTOR  // Código do gestor do módulo
		gcNmGest  := ZZJ->ZZJ_NMGEST  // Nome do gestor do módulo					
		
		PSWORDER(1)  // muda ordem de índice
		If PswSeek(gcCdGest) == .T.  // se encontrar usuário no arquivo
			aArrGest := PSWRET()
			gcIDGest := aArrGest[1][2] // Retorna o ID do usuário
		EndIf
	EndIf

	gcDsPerf := ""  // descrição do perfil
	gcPConf  := ""  // perfil conflitante?
	DbSelectArea("ZZC")  // seleciona arquivo de módulo/perfil
	ZZC->(DbSetOrder(1))  // muda ordem do índice
	If ZZC->(DbSeek(xFilial("ZZC")+gcCdMod+gcCdPerf))  // posiciona ponteiro
		gcDsPerf := ZZC->ZZC_DSPERF  // descrição do perfil
		gcPConf  := ZZC->ZZC_PCRIT   // perfil conflitante?
	EndIf		
		
	gcIDCtrl := M->ZZE_IDCTRL  // ID do Controller
                                                                   
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_ITEM"   })] := StrZero(Len(aCols),2)
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDDEPT" })] := gcCdDepto
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_DSDEPT" })] := gcDsDepto
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDMOD"  })] := gcCdMod
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_DSMOD"  })] := gcDsMod
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_GESTOR" })] := gcCdGest
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_NMGEST" })] := gcNmGest
	ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_IDGEST" })] := gcIDGest
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDPERF" })] := gcCdPerf
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_DSPERF" })] := gcDsPerf		
	aCols[N][Ascan(aHeader,{|x|x[2]="ZZF_PCRIT"  })] := gcPConf
	ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_IDCTRL" })] := gcIDCtrl

	If Len(aCols) < Len(aArray[1][10])
		Aadd(aCols,AClone(vLinha))      
		N := Len(aCols)
	EndIf		

Next       

N := 1

GetdRefresh()

Return aCols  // retorno da função