/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspT001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 08/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspT001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 09/01/09  ³±±
±±³          ³ gArrayEmp³ Autor ³ George AC. Gonçalves ³ Data ³ 08/01/09  ³±±
±±³          ³ gArrayXNU³ Autor ³ George AC. Gonçalves ³ Data ³ 09/01/09  ³±±
±±³          ³ gChkUser ³ Autor ³ George AC. Gonçalves ³ Data ³ 08/01/09  ³±±
±±³          ³ gArrayGru³ Autor ³ George AC. Gonçalves ³ Data ³ 09/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Processa atualização de usuário/perfil                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Chamada após a confirmação do controller - Rotina: gEspP001³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gEspT001()  // Processa atualização de usuário/perfil

Local cPswFile  := "SIGAPSS.SPF"
Local cPswId    := ""
Local cPswName  := ""
Local cPswPwd   := ""
Local cPswDet   := ""
Local cOldPsw
Local cNewPsw
Local lEncrypt  := .F.
Local nPswRec
Local cUsrId    := "000000"      // obtenho o usuario base
Local nRet      := 0
Local aReturn   := {}
Local u1_aGrupo := {}
Local cStatus   := ""
               
Public aUsers  := AllUsers(.T.)   // vetor de usuários
Public aGrupos := AllGroups(.T.)  // vetor de grupos

//Abro a Tabela de Senhas
SPF_CanOpen(cPswFile) 

//Procuro pelo usuario Base
nPswRec	:= SPF_Seek(cPswFile,"1U"+cUsrId,1) 

//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
SPF_GetFields(@cPswFile,@nPswRec,@cPswId,@cPswName,@cPswPwd,@cPswDet)

//Converto o conteudo da string cPswDet em um Array
aPswDet	:= Str2Array(@cPswDet,@lEncrypt)

// aReturn[1] => array com dados do usuário
u1_cUsrId         := gChkUser("ID",ZZE->ZZE_NMUSU)         // chamada a função que recupera o ID do usuário
u1_cCdUser        := gChkUser(u1_cUsrId,ZZE->ZZE_NMUSU)    // chamada a função que recupera o código do usuário
u1_cNomeC         := ZZE->ZZE_NMUSU                        // Nome completo do usuário
u1_aSenha         := {}                                    // Vetor com número das últimas senhas
u1_dDtValid       := CToD("  /  /  ")                      // Data da validade da senha
u1_nQtdExpira     := 0                                     // Expira senha após N dias
u1_lAutAltSenha   := .F.                                   // Usuário autorizado a alterar senha
u1_lAltSenhaLogon := .T.                                   // Altera senha no próximo logon

DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do índice
If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
	Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
		If ZZF->ZZF_STATC == "1"  // perfil aprovado
			aGrupo := gArrayGru()  // Chamada a função para para montar vetor com os grupos/perfis de acesso
			Aadd(u1_aGrupo,aGrupo)  // array com os grupos/perfis de acesso			
		EndIf
		ZZF->(DbSkip())  // incrementa contador de registro
	EndDo
EndIf			

u1_cIdSuper       := ZZE->ZZE_USUSUP                       // ID do superior do usuário
u1_cDepart        := ZZE->ZZE_NMDEPU                       // Departamento do usuário
u1_cCargo         := ZZE->ZZE_DSFUNU                       // Cargo do usuário
u1_cEmail         := ZZE->ZZE_EMAILU                       // e-Mail do usuário
u1_nAcessoSim     := 1                                     // Número de acessos simultâneos do usuário
u1_dDtUltAlt      := dDataBase                             // Data da última alteração
u1_lUsuBloqueio   := .F.                                   // Usuário bloqueado
u1_nDigAno        := 2                                     // Número de dígitos para o ano
u1_lListner       := .F.                                   // Listner de ligações
u1_cRamal         := AllTrim(ZZE->ZZE_TELUSU)              // Telefone do usuário
u1_cRamal         := SubStr(u1_cRamal,Len(u1_cRamal)-4,4)  // Ramal do usuário
u1_V21            := ""                                    //
u1_V22            := "0000"                                //
u1_aRetAvDias     := {.F.,0,0}                             // Vetor com informações de avanço ou retrocesso de dias referente a data base
u1_V24            := CToD("  /  /  ")                      //
u1_V25            := ""                                    //

//Decriptando a senha antiga para obter o tamanho valido para a senha
cOldPsw	  := PswEncript(u1_cUsrId,1)
//Encriptando a senha para o novo usuario
cNewPsw	  := PswEncript(Padr(u1_cUsrId,Len(cOldPsw)),0)
//Atribuindo a nova senha ao novo usuario
u1_cSenha := cNewPsw

// aReturn[2] => array com dados de acesso
u2_aHorario       := {"  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  "}  // Vetor com os horários para acesso
u2_nIdioma        := 1                                                                                                    // Idioma
u2_cDiretorio     := "C:\TEMP"                                                                                            // Diretório para gravação dos relatórios em disco
u2_cDriveImp      := "EPSON.DRV"                                                                                          // Drive impressora
u2_cAcesso        := "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS                                                                                                                                                                                                                                                                                                                                                                    "  // Acessos
u2_aEmpresas      := gArrayEmp()                                                                                          // Chamada a função para para montar vetor com as empresas acessadas
u2_cPontoEnt      := ""                                                                                                   // Ponto de entrada
u2_nTipoImpr      := 1                                                                                                    // Tipo de impressão
u2_nFormato       := 1                                                                                                    // Formato
u2_nAmbiente      := 2                                                                                                    // Ambiente
u2_lPrioridade    := .F.  ///If(Len(u1_aGrupo)>0,.T.,.F.)                                                                 // Prioridade para configuração do grupo/perfil
u2_cOpcaoImp      := ""                                                                                                   // Opção de impreesão
u2_lAcOutDirImp   := .F.                                                                                                  // Acesso a outros diretórios de impressão

// aReturn[3] => array com dados de menus
u3_aMenus         := gArrayXNU()  // Chamada a função para para montar vetor com os menus de acesso

// aReturn[4] => array com dados de ???
u4_V1             := .F.  // 
u4_V2             := ""   // 
u4_V3             := ""   // 
u4_V4             := 1    // 

// posiciona registro de usuário - Chave 1U
nRet := SPF_Seek(cPswFile,"1U"+u1_cUsrId,1)

If nRet > 0  // se encontrar ID do usuário

     //Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
     SPF_GetFields(@cPswFile,@nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)

     //Converto o conteudo da string cPswDet em um Array
     aReturn := Str2Array(@cPswDet,@lEncrypt)
     
     // aReturn[1] => array com dados do usuário
     aReturn[1][4]  := u1_cNomeC
     aReturn[1][5]  := u1_aSenha
     aReturn[1][6]  := u1_dDtValid
     aReturn[1][7]  := u1_nQtdExpira
     aReturn[1][8]  := u1_lAutAltSenha
     aReturn[1][9]  := u1_lAltSenhaLogon
     aReturn[1][10] := u1_aGrupo
     aReturn[1][11] := u1_cIdSuper
     aReturn[1][12] := u1_cDepart     
     aReturn[1][13] := u1_cCargo                                                       
     aReturn[1][14] := u1_cEmail
     aReturn[1][15] := u1_nAcessoSim
     aReturn[1][16] := u1_dDtUltAlt
     aReturn[1][17] := u1_lUsuBloqueio
     aReturn[1][18] := u1_nDigAno
     aReturn[1][19] := u1_lListner
     aReturn[1][20] := u1_cRamal
     aReturn[1][21] := u1_V21
     aReturn[1][22] := u1_V22
     aReturn[1][23] := u1_aRetAvDias
     aReturn[1][24] := u1_V24
     aReturn[1][25] := u1_V25

     // aReturn[2] => array com dados de acesso
     aReturn[2][1]  := u2_aHorario
     aReturn[2][2]  := u2_nIdioma
     aReturn[2][3]  := u2_cDiretorio
     aReturn[2][4]  := u2_cDriveImp
     aReturn[2][5]  := u2_cAcesso
     aReturn[2][6]  := u2_aEmpresas
     aReturn[2][7]  := u2_cPontoEnt
     aReturn[2][8]  := u2_nTipoImpr
     aReturn[2][9]  := u2_nFormato
     aReturn[2][10] := u2_nAmbiente
     aReturn[2][11] := u2_lPrioridade
     aReturn[2][12] := u2_cOpcaoImp
     aReturn[2][13] := u2_lAcOutDirImp

     // aReturn[3] => array com dados de menus
     aReturn[3] := u3_aMenus    
     
     // aReturn[4] => array com dados de ???
     aReturn[4][1]  := u4_V1
     aReturn[4][2]  := u4_V2
     aReturn[4][3]  := u4_V3
     aReturn[4][4]  := u4_V4

     //Convertendo as informacoes no novo usuario para gravacao
     cPswDet := Array2Str(@aReturn,@lEncrypt)
     
     //Alterando usuario     
     SPF_UPDATE(cPswFile,nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)
     
Else  // se não encontrar o ID do uauário

     Aadd(aReturn,{u1_cUsrId,u1_cCdUser,u1_cSenha,u1_cNomeC,u1_aSenha,u1_dDtValid,u1_nQtdExpira,u1_lAutAltSenha,u1_lAltSenhaLogon,u1_aGrupo,u1_cIdSuper,u1_cDepart,u1_cCargo,u1_cEmail,u1_nAcessoSim,u1_dDtUltAlt,u1_lUsuBloqueio,u1_nDigAno,u1_lListner,u1_cRamal,u1_V21,u1_V22,u1_aRetAvDias,u1_V24,u1_V25})
     Aadd(aReturn,{u2_aHorario,u2_nIdioma,u2_cDiretorio,u2_cDriveImp,u2_cAcesso,u2_aEmpresas,u2_cPontoEnt,u2_nTipoImpr,u2_nFormato,u2_nAmbiente,u2_lPrioridade,u2_cOpcaoImp,u2_lAcOutDirImp})
     Aadd(aReturn,u3_aMenus)
     Aadd(aReturn,{u4_V1,u4_V2,u4_V3,u4_V4})

     //Convertendo as informacoes no novo usuario para gravacao
     cPswDet := Array2Str(@aReturn,@lEncrypt)

     //Incluindo o novo usuario
     SPF_Insert(cPswFile, "1U"+u1_cUsrId, Upper("1U"+u1_cCdUser), "1U"+u1_cSenha, cPswDet)

EndIf

MsgStop("Usuário: "+u1_cCdUser+"     |     Senha:"+PswEncript(u1_cSenha,1),"Atenção")

Return  // retorno da função
****************************************************************************************************************************************************

Static Function gArrayEmp() // função para para montar vetor com as empresas acessadas

u2_aEmpresas := {}
gCdEmpresas  := AllTrim(ZZE->ZZE_EMP)

For nG := 1 To Len(gCdEmpresas)            
	If Len(gCdEmpresas) > 0
		nPosF := At(",",gCdEmpresas) 
		If nPosF > 0
			gCdEmpFil := SubStr(gCdEmpresas,1,4)  // código da empresa/filial
		Else
			gCdEmpFil := SubStr(gCdEmpresas,Len(gCdEmpresas)-4,4)  // código da empresa/filial
			gCdEmpresas	:= ""
		EndIf	
		gCdEmpresas	:= SubStr(gCdEmpresas,nPosF+1,Len(gCdEmpresas))	
	Else
		Exit
	EndIf			
	Aadd(u2_aEmpresas,gCdEmpFil)
Next

Return u2_aEmpresas  // retorno da função
****************************************************************************************************************************************************

Static Function gChkUser(g_cID,g_cCDUSER)  // função que recupera o ID e o código do usuário
//g_cID     = "ID"          -> para retornar o ID do usuário
//g_cID     = ID do usuário -> para retornar o código do usuário 
//g_cCDUSER = Nome do usuário

If g_cID == "ID"  // se retorna o ID do usuário
	g_cUser := StrZero(Val(aUsers[Len(aUsers)][1][1])+1,6)  // ID do usuário
	For lN := 1 To Len(aUsers)  // percorre arquivo de usuários
		If Upper(AllTrim(aUsers[lN][1][4])) == Upper(AllTrim(ZZE->ZZE_NMUSU))  // verifica existência do usuário
			g_cUser := aUsers[lN][1][1]  // ID do usuário             
			Exit  // aborta loop
		EndIf
	Next
Else  // se retorna o código do usuário
	PSWORDER(1)  // muda ordem de índice
	If PswSeek(g_cID) == .T.  // se encontrar usuário no arquivo
		aArray  := PSWRET()      // vetor dados do usuário
		g_cUser := aArray[1][2]  // Retorna o código do usuário
	Else
		g_1Nome := SubStr(g_cCDUSER,1,At(" ",g_cCDUSER)-1)  // primeiro nome
		For Ln := Len(g_cCDUSER) To 1 Step -1
			If SubStr(g_cCDUSER,Ln,1) == " " .Or. Empty(SubStr(g_cCDUSER,Ln,1))
				g_2Nome := SubStr(g_cCDUSER,Ln+1,Len(g_cCDUSER))
				Exit
			EndIf
		Next
		g_cCDUSER := SubStr(g_1Nome+"."+g_2Nome,1,15)

		PSWORDER(2)  // muda ordem de índice
		nCont := 0  // contador de nomes
		Do While .T.  // loop enquanto verdadeiro
			If PswSeek(g_cCDUSER) == .F.  // se não encontrar usuário no arquivo
				Exit  // aborta loop
			Else	            
				nCont := nCont + 1  // contador de nomes				
				If nCont > 9  // se considerar 2 digitos                            
					g_cCDUSER := AllTrim(SubStr(g_cCDUSER,1,14))+StrZero(nCont,1)					
				Else
					g_cCDUSER := AllTrim(SubStr(g_cCDUSER,1,13))+StrZero(nCont,2)
				EndIf	
			EndIf		
		EndDo
	EndIf
EndIf

Return g_cUser  // retorno da função     
****************************************************************************************************************************************************

Static Function gArrayXNU() // função para para montar vetor com os menus de acesso

Declare u3_aMenus[Len(aUsers[1][3])]

For Ln := 1 To Len(aUsers[1][3])
	gCdMod := SubStr(aUsers[1][3][Ln],1,2)
	DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
	ZZF->(DbSetOrder(2))  // muda ordem do índice
	If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+gCdMod))  // posiciona registro
		Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL .And. ZZF->ZZF_CDMOD == gCdMod  // percorre o arquivo no intervalo
			If ZZF->ZZF_STATC == "1"  // aprovada
				DbSelectArea("ZZC")  // seleciona arquivo de módulo/perfil
				ZZC->(DbSetOrder(1))  // muda ordem do índice
				If ZZC->(DbSeek(xFilial("ZZC")+ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF))  // posiciona registro
					u3_aMenus[Ln] := SubStr(aUsers[1][3][Ln],1,2)+"5"+AllTrim(ZZC->ZZC_XNU)  // Define vetor com os menus
				Else 
					u3_aMenus[Ln] := SubStr(aUsers[1][3][Ln],1,2)+"X"+AllTrim(SubStr(aUsers[1][3][Ln],4,999))  // Define vetor com os menus					
				EndIf	
			Else
				u3_aMenus[Ln] := SubStr(aUsers[1][3][Ln],1,2)+"X"+AllTrim(SubStr(aUsers[1][3][Ln],4,999))  // Define vetor com os menus				
			EndIf		
			ZZF->(DbSkip())  // incrementa contador de registro
		EndDo			
	Else
		u3_aMenus[Ln] := SubStr(aUsers[1][3][Ln],1,2)+"X"+AllTrim(SubStr(aUsers[1][3][Ln],4,999))  // Define vetor com os menus	
	EndIf						
Next

Return u3_aMenus  // retorno da função        
****************************************************************************************************************************************************

Static Function gArrayGru()  // função para para montar vetor com os grupos/perfis de acesso

Local aRGrupo := {}

// aRGrupo[1] => array com dados do grupo
g1_cIdGrupo       := ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF                                                                       // [01]-ID do grupo
g1_cNmGrupo       := ZZF->ZZF_DSPERF                                                                                      // [02]-nome do grupo
g1_aHorario       := {"  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  "}  // [03]-Vetor com os horários para acesso
g1_dDtValid       := CToD("  /  /  ")                                                                                     // [04]-Data da validade da senha
g1_nQtdExpira     := 0                                                                                                    // [05]-Expira senha após N dias
g1_lAutAltSenha   := .F.                                                                                                  // [06]-Usuário autorizado a alterar senha
g1_nIdioma        := 1                                                                                                    // [07]-Idioma
g1_cDiretorio     := "C:\TEMP"                                                                                            // [08]-Diretório para gravação dos relatórios em disco
g1_cDriveImp      := "EPSON.DRV"                                                                                          // [09]-Drive impressora
g1_cAcesso        := "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS                                                                                                                                                                                                                                                                                                                                                                    "  // [10]-Acessos
g1_aEmpresas      := gArrayEmp()                                                                                          // [11]-Chamada a função para para montar vetor com as empresas acessadas
g1_dDtUltAlt      := dDataBase                                                                                            // [12]-Data da última alteração
g1_nTipoImpr      := 1                                                                                                    // [13]-Tipo de impressão
g1_nFormato       := 1                                                                                                    // [14]-Formato
g1_nAmbiente      := 2                                                                                                    // [15]-Ambiente
g1_cOpcaoImp      := ""                                                                                                   // [16]-Opção de impreesão
g1_lAcOutDirImp   := .F.                                                                                                  // [17]-Acesso a outros diretórios de impressão 
g1_aRetAvDias     := {.F.,0,0}                                                                                            // [18]-Vetor com informações de avanço ou retrocesso de dias referente a data base
g1_V19            := CToD("  /  /  ")                                                                                     // [19]-
g1_V20            := ""                                                                                                   // [20]-

//aRGrupo[2] => array com dados de menus
g2_aMenus         := gArrayXNU()  // Chamada a função para para montar vetor com os menus de acesso

Aadd(aRGrupo,{g1_cIdGrupo,g1_cNmGrupo,g1_aHorario,g1_dDtValid,g1_nQtdExpira,g1_lAutAltSenha,g1_nIdioma,g1_cDiretorio,g1_cDriveImp,g1_cAcessog1_aEmpresas,g1_dDtUltAlt,g1_nTipoImpr,g1_nFormato,g1_nAmbiente,g1_cOpcaoImp,g1_lAcOutDirImp,g1_aRetAvDias,g1_V19,g1_V20})
Aadd(aRGrupo,g2_aMenus)

Return aRGrupo  // retorno da função    






/////Atribuindo o vinculo funcional ao novo usuario
///APSWDET_USER_STAFF			:= cEmpAnt+cFilAnt+APSWDET_USER_ID
