/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SigaEST  ³ Autor ³ George AC Gonçalves  ³ Data ³ 30/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ SigaEST  ³ Autor ³ George AC Gonçalves  ³ Data ³ 30/06/09  ³±±
±±³          ³ gWFGestor³ Autor ³ George AC. Gonçalves ³ Data ³ 30/06/09  ³±±
±±³          ³ gWFCtrl  ³ Autor ³ George AC. Gonçalves ³ Data ³ 30/06/09  ³±±
±±³          ³ gWFAutit ³ Autor ³ George AC. Gonçalves ³ Data ³ 30/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Identifica 1o. acesso do usuário ao módulo de ESTOQUE/CUSTO³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Inicialização do projeto                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function SigaEST()  // Identifica 1o. acesso do usuário ao módulo de ESTOQUE/CUSTO

cArea := GetArea()          
cAreaZZK := ZZK->(GetArea())
cAreaZZI := ZZI->(GetArea())
cAreaZZJ := ZZJ->(GetArea())
cAreaSX6 := SX6->(GetArea())

Public cTo       // para
Public cBody     // mensagem
Public cSubject  // título
Public cAnexo    // anexo 
Public aModAnexo := {}  // array dos módulos para anexo

gcCdMod := "04"  // Código do módulo de estoque/custo

DbSelectArea("ZZJ")  // seleciona arquivo de departamento/módulo
ZZJ->(DbSetOrder(2))  // muda ordem do índice
If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona regsitro
	If ZZJ->ZZJ_MODCRI == "S"  // se módulo critico

		DbSelectArea("ZZK")  // seleciona arquivo de 1o. acesso aos módulos criticos
		ZZK->(DbSetOrder(2))  // muda ordem do índice
		If ZZK->(DbSeek(xFilial("ZZK")+SubStr(cUsuario,7,15)+gcCdMod))  // posiciona ponteiro
			If ZZK->ZZK_1ACESS <> "S"  // se 1o. acesso do usuário ao módulo
				RecLock("ZZK",.F.)  // se bloquear registro
				ZZK->ZZK_1ACESS := "S"        // 1o. acesso do usuário ao módulo
				ZZK->ZZK_DT1ACE := dDataBase  // data do 1o. acesso do usuário ao módulo
				ZZK->ZZK_HR1ACE := TIME()     // hora do 1o. acesso do usuário ao módulo				
				MsUnLock()  // libera registro bloqueadO

				cAnexo := gWFGestor(gcCdMod,ZZK->ZZK_IDUSU,ZZK->ZZK_NMUSU,ZZK->ZZK_DT1ACE,ZZK->ZZK_HR1ACE)  // chamada a função de montagem do workflow para gestores
				U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
		
				cAnexo := gWFCtrl(gcCdMod,ZZK->ZZK_IDUSU,ZZK->ZZK_NMUSU,ZZK->ZZK_DT1ACE,ZZK->ZZK_HR1ACE)  // chamada a função de montagem do workflow para controllers
				U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
		
				cAnexo := gWFAudit(gcCdMod,ZZK->ZZK_IDUSU,ZZK->ZZK_NMUSU,ZZK->ZZK_DT1ACE,ZZK->ZZK_HR1ACE)  // chamada a função de montagem do workflow para auditoria interna
				U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow				
											
			EndIf	
		EndIf		
		
	EndIf
EndIf

// verifica a existência do parâmetro MV_MNTUSA e cria caso não exista
If !GetMv("MV_MNTUSA",.T.)  // se não existir o parâmetrp
	DbSelectArea("SX6")  // seleciona arquivo
	SX6->(DbSetorder(1))  // muda ordem do índice
	If SX6->(!DbSeek(xFilial("SX6")+"MV_MNTUSA"))  // se não existir parâmetro
		RecLock("SX6",.T.)
		SX6->X6_VAR     := "MV_MNTUSA"
		SX6->X6_TIPO    := "C"
		SX6->X6_CONTEUD := "NSS"
		SX6->X6_CONTSPA := "NSS"
		SX6->X6_CONTENG := "NSS"
		SX6->X6_DESCRIC := "Determina a integracao do MNT com o PCP,COMPRAS e"
		SX6->X6_DESC1   := "ESTOQUE"
		SX6->X6_DSCSPA  := "Determina la integracion del MNT con PCP, COMPRAS"
		SX6->X6_DSCSPA1 := "y STOCK"
		SX6->X6_DSCENG  := "Determine the MNT integration with PCP,"
		SX6->X6_DSCENG1 := "PURCHASES and INVENTORY."
		SX6->X6_PROPRI  := "S"
		SX6->X6_PYME    := "N"
		MsUnLock()
	EndIf
Endif

SX6->(RestArea(cAreaSX6))
ZZJ->(RestArea(cAreaZZJ))
ZZI->(RestArea(cAreaZZI))
ZZK->(RestArea(cAreaZZK))
RestArea(cArea)
			
Return  // Retorno da Função 
***************************************************************************************************************************************************

Static Function gWFGestor(gcCdMod,gcIDUsu,gcNmUsu,gdDt1Acess,gcHr1Acess)  // função de montagem do workflow para gestores
//gcCdMod = Código do módulo             
//gcIDUsu    = ID do usuário
//gcNmUsu    = Nome do usuário                                            
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo    := {}                                                                       // array dos módulos para anexo             
aDescModulos := RetModName(.T.)                                                          // array com os dados dos módulos
cDescMod     := AllTrim(aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3])  // recupera descrição do módulo		
		
DbSelectArea("ZZJ")  // seleciona arquivo de departamento/módulo
ZZJ->(DbSetOrder(2))  // muda ordem do índice
If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona regsitro
     
	cTo := ""  // Destinatário do envio do workflow para o gestor
	DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
	ZZI->(DbSetOrder(1))  // muda ordem do índice
	If ZZI->(DbSeek(xFilial("ZZI")+ZZJ->ZZJ_GESTOR))  // posiciona regsitro
		cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
	EndIf
                                                     
	cSubject := "1o. acesso ao módulo de "+cDescMod+" pelo usuário "+AllTrim(gcNmUsu)+"."  // Assunto da mensagem
	cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
	cBody    := U_gEWF005(cSubject,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // chamada a função de montagem da mensagem para workflow	

// ;	_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

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
                            
EndIf

Return aAnexo[1]  // retorno da função
***************************************************************************************************************************************************

Static Function gWFCtrl(gcCdMod,gcIDUsu,gcNmUsu,gdDt1Acess,gcHr1Acess)  // função de montagem do workflow para controllers
//gcCdMod = Código do módulo             
//gcIDUsu    = ID do usuário
//gcNmUsu    = Nome do usuário                                            
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo    := {}                                                                       // array dos módulos para anexo                          
aDescModulos := RetModName(.T.)                                                          // array com os dados dos módulos
cDescMod     := AllTrim(aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3])  // recupera descrição do módulo		

gcCtrl := U_gVEsp011()  // Recupera ID do Controller da Empresa
     
cTo := ""  // Destinatário do envio do workflow para o gestor
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(4))  // muda ordem do índice
If ZZI->(DbSeek(xFilial("ZZI")+gcCtrl))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf
                                                     
cSubject := "1o. acesso ao módulo de "+cDescMod+" pelo usuário "+AllTrim(gcNmUsu)+"."  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF005(cSubject,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // chamada a função de montagem da mensagem para workflow	

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

Static Function gWFAudit(gcCdMod,gcIDUsu,gcNmUsu,gdDt1Acess,gcHr1Acess)  // função de montagem do workflow para auditoria interna
//gcCdMod = Código do módulo             
//gcIDUsu    = ID do usuário
//gcNmUsu    = Nome do usuário                                            
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo    := {}                                                                       // array dos módulos para anexo                                       
aDescModulos := RetModName(.T.)                                                          // array com os dados dos módulos
cDescMod     := AllTrim(aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3])  // recupera descrição do módulo		
		
cTo      := GetMV('MV_EAUDINT')  // Destinatário do envio do workflow para o helpdesk                                                     
cSubject := "1o. acesso ao módulo de "+cDescMod+" pelo usuário "+AllTrim(gcNmUsu)+"."  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF005(cSubject,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // chamada a função de montagem da mensagem para workflow	

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