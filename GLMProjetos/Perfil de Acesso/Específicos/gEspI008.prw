/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspI008 ³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspI008 ³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±³          ³ gWFGestor³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±³          ³ gWFCtrl  ³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Reenvio da Solicitação de Perfil de Acesso                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Seleção da opção reenvio de solicitação - Rotina gEspM010  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gEspI008()  // Reenvio da Solicitação de Perfil de Acesso

Public cTo              // para
Public cBody            // mensagem
Public cSubject         // título
Public cAnexo           // anexo
Public aModAnexo := {}  // array dos módulos para anexo

Public gcNumSol := ZZE->ZZE_NUMSOL  // Número da solicitação

DBSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
ZZE->(DbSetOrder(1))  // muda ordem do índice
ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // busca a linha da getdados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOpcao := "ALTERAR"
nOpcE  := 2
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
	If Alltrim(SX3->x3_campo) == "ZZF_FILIAL" .Or. Alltrim(SX3->x3_campo) == "ZZF_NUM"
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

		DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
		ZZF->(DbSetOrder(3))  // muda ordem do índice
		If ZZF->(DbSeek(xFilial("ZZF")+M->ZZE_NUMSOL))  // posiciona registro
			Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == M->ZZE_NUMSOL  // percorre o arquivo no intervalo
			    
				If ZZF->ZZF_STATG <> "1"  // se solicitação ainda não aprovada pelo gestor
					RecLock("ZZF",.F.)  // se bloquear registro
					ZZF->ZZF_DTENVG := dDataBase  // data de envio ao gestor
					ZZF->ZZF_HRENVG := TIME()     // hora de envio ao gestor					
					MsUnLock()  // libera registro bloqueado    				
                          
					cAnexo    := gWFGestor(ZZF->ZZF_GESTOR,ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF+ZZF->ZZF_NIVEL+",")  // chamada a função de montagem do workflow para aprovação dos gestores
					U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
					DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
					ZZE->(DbSetOrder(1))  // muda ordem do índice
		   			If ZZE->(DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se não existir registro de solicitação      
						RecLock("ZZE",.F.)  // se bloquear registro
						ZZE->ZZE_STATUS := "2"  // status da solicitação: 2-Aguardando Aprovação
						MsUnLock()  // libera registro bloqueado    
		 			EndIf
	            ElseIf ZZF->ZZF_STATG == "1" .And. ZZF->ZZF_STATC <> "1"  // se aprovada pelo gestor e ainda não aprovado pelo controller                                                  				
					cAnexo := gWFCtrl(ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF+ZZF->ZZF_NIVEL+",")  // chamada a função de montagem do workflow para aprovação do controller
					If U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow  
						RecLock("ZZF",.F.)  // se bloquear registro					
						ZZF->ZZF_DTENVC := dDataBase  // status do retorno da aprovação do gestor
						ZZF->ZZF_HRENVC := Time()     // status do retorno da aprovação do gestor								
						MsUnLock()  // libera registro bloqueado    						
					EndIf
				EndIf	
				ZZF->(DbSkip())  // incrementa contador de registro		
				
			EndDo

	 	EndIf	
	 	
	Else 
		RollBackSX8("ZZE","ZZE_NUMSOL")  // se não confirmou volta a numeração sequencial do arquivo de solicitação
	Endif
	
Endif

Return  // retorno da função
***************************************************************************************************************************************************
Static Function gWFCtrl(gcModPerf)  // função de montagem do workflow para aprovação do controller
//gcModPerf = Códigos do(s) módulo(s)/perfil(is)
                                                
Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo

cTo := ""  // Destinatário do envio do workflow para o gestor

/*
PSWORDER(2)  // muda ordem de índice
If PswSeek(ZZE->ZZE_IDCTRL) == .T.  // se encontrar usuário no arquivo
	aArray  := PSWRET()      // vetor dados do usuário
	DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
	ZZI->(DbSetOrder(1))  // muda ordem do índice
	If ZZI->(DbSeek(xFilial("ZZI")+aArray[1][1]))  // posiciona regsitro
		cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
	EndIf
EndIf
*/
         
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(4))  // muda ordem do índice
If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf            

If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de aprovação para inclusão de perfil de acesso para o NOVO usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
	cBody    := U_gEWF001(cSubject,.T.,"","G",gcGestor,.F.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
Else
	cSubject := "Solicitação de aprovação para alteração de perfil de acesso para o usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
	cBody    := U_gEWF004(cSubject,.T.,"","G",gcGestor,.T.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
EndIf		
///cBody    := U_gEWF001(cSubject,.F.,"","G","",.T.,.F.,.F.,gcModPerf,"2",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
                
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

aAnexo[1] := cAnexo                                            

Return aAnexo[1]  // retorno da função
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

cSubject := "Solicitação de aprovação para inclusão de perfil de acesso para o NOVO usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","G",gcGestor,.T.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                            
//  _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

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