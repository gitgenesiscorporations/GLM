/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspT002 ³ Autor ³ George AC. Gonçalves ³ Data ³ 11/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspT002 ³ Autor ³ George AC. Gonçalves ³ Data ³ 11/01/09  ³±±
±±³          ³ gArrayXNU³ Autor ³ George AC. Gonçalves ³ Data ³ 11/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Processa atualização(INC/ALT) de perfil de acesso (Grupo)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Chamada após a confirmação do módulo/perfil-Rotina: gCADZZC³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gEspT002()  // Processa atualização (inclusão/alteração) de perfil de acesso (Grupo)

Local cPswFile  := "SIGAPSS.SPF"
Local cPswId    := ""
Local cPswName  := ""
Local cPswPwd   := ""
Local cPswDet   := ""
Local lEncrypt  := .F.
Local nPswRec
Local cIdGrupo  := "000000"      // obtenho o grupo base
Local nRet      := 0
Local aReturn   := {}
Local u1_aGrupo := {}
               
Public aGrupos := AllGroups(.T.)  // vetor de grupos

//Abro a Tabela de Senhas
SPF_CanOpen(cPswFile) 

//Procuro pelo grupo Base
nPswRec	:= SPF_Seek(cPswFile,"1G"+cIdGrupo,1) 

//Obtenho as Informacoes do grupo Base ( retornadas por referencia na variavel cPswDet)
SPF_GetFields(@cPswFile,@nPswRec,@cPswId,@cPswName,@cPswPwd,@cPswDet)

//Converto o conteudo da string cPswDet em um Array
aPswDet	:= Str2Array(@cPswDet,@lEncrypt)

// aReturn[1] => array com dados do grupo
g1_cIdGrupo       := M->ZZC_CDMOD+M->ZZC_CDPERF                                                                           // [01]-ID do grupo
g1_cNmGrupo       := M->ZZC_CDMOD+M->ZZC_CDPERF+"-"+M->ZZC_DSPERF                                                         // [02]-nome do grupo
g1_aHorario       := {"  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  "}  // [03]-Vetor com os horários para acesso
g1_dDtValid       := CToD("  /  /  ")                                                                                     // [04]-Data da validade da senha
g1_nQtdExpira     := 0                                                                                                    // [05]-Expira senha após N dias
g1_lAutAltSenha   := .T.                                                                                                  // [06]-Usuário autorizado a alterar senha
g1_nIdioma        := 1                                                                                                    // [07]-Idioma
g1_cDiretorio     := "\SPOOL\"                                                                                            // [08]-Diretório para gravação dos relatórios em disco
g1_cDriveImp      := "EPSON.DRV"                                                                                          // [09]-Drive impressora
///g1_cAcesso        := "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS                                                                                                                                                                                                                                                                                                                                                                    "  // [10]-Acessos
g1_cAcesso        := "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNNNNNNNNNNSNSNNSNNSNSSNNSSSSSSSSNNNNNSSSSNNNSSSSSSSSSSSNNNNNNSNNNSNNSSSSSSSSSNNSSS                                                                                                                                                                                                                                                                                                                                                   "  // [10]-Acessos
g1_aEmpresas      := gArrayEmp()                                                                                          // Chamada a função para para montar vetor com as empresas acessadas // [11]-Vetor com as empresas acessadas
g1_dDtUltAlt      := dDataBase                                                                                            // [12]-Data da última alteração
g1_nTipoImpr      := 2                                                                                                    // [13]-Tipo de impressão
g1_nFormato       := 1                                                                                                    // [14]-Formato
g1_nAmbiente      := 1                                                                                                    // [15]-Ambiente
g1_cOpcaoImp      := ""                                                                                                   // [16]-Opção de impreesão
g1_lAcOutDirImp   := .F.                                                                                                  // [17]-Acesso a outros diretórios de impressão 
g1_aRetAvDias     := {.F.,0,0}                                                                                            // [18]-Vetor com informações de avanço ou retrocesso de dias referente a data base
g1_V19            := DDATABASE                                                                                            // [19]-
g1_V20            := "5"                                                                                                  // [20]-Nível global dos campos

//aReturn[2] => array com dados de menus
g2_aMenus         := gArrayXNU()  // Chamada a função para para montar vetor com os menus de acesso

// posiciona registro de grupi - Chave 1G
nRet := SPF_Seek(cPswFile,"1G"+g1_cIdGrupo,1)

If nRet > 0  // se encontrar ID do usuário

     //Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
     SPF_GetFields(@cPswFile,@nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)

     //Converto o conteudo da string cPswDet em um Array
     aReturn := Str2Array(@cPswDet,@lEncrypt)

     // aReturn[1] => array com dados do usuário
     aReturn[1][2]  := g1_cNmGrupo
     aReturn[1][3]  := g1_aHorario
     aReturn[1][4]  := g1_dDtValid
     aReturn[1][5]  := g1_nQtdExpira
     aReturn[1][6]  := g1_lAutAltSenha
     aReturn[1][7]  := g1_nIdioma
     aReturn[1][8]  := g1_cDiretorio
     aReturn[1][9]  := g1_cDriveImp
     aReturn[1][10] := g1_cAcesso
     aReturn[1][11] := g1_aEmpresas
     aReturn[1][12] := g1_dDtUltAlt
     aReturn[1][13] := g1_nTipoImpr
     aReturn[1][14] := g1_nFormato
     aReturn[1][15] := g1_nAmbiente
     aReturn[1][16] := g1_cOpcaoImp
     aReturn[1][17] := g1_lAcOutDirImp
     aReturn[1][18] := g1_aRetAvDias
     aReturn[1][19] := g1_V19
     aReturn[1][20] := g1_V20

     // aReturn[2] => array com dados de menus
     aReturn[2] := g2_aMenus
     
     //Convertendo as informacoes no novo grupo para gravacao
     cPswDet := Array2Str(@aReturn,@lEncrypt)
     
     //Alterando grupo
     SPF_UPDATE(cPswFile,nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)
     
Else  // se não encontrar o ID do grupo

	Aadd(aReturn,{g1_cIdGrupo,g1_cNmGrupo,g1_aHorario,g1_dDtValid,g1_nQtdExpira,g1_lAutAltSenha,g1_nIdioma,g1_cDiretorio,g1_cDriveImp,g1_cAcesso,g1_aEmpresas,g1_dDtUltAlt,g1_nTipoImpr,g1_nFormato,g1_nAmbiente,g1_cOpcaoImp,g1_lAcOutDirImp,g1_aRetAvDias,g1_V19,g1_V20})
	Aadd(aReturn,g2_aMenus)

	//Convertendo as informacoes no novo usuario para gravacao
	cPswDet := Array2Str(@aReturn,@lEncrypt)

	//Incluindo o novo grupo                                                 
	SPF_Insert(cPswFile, "1G"+g1_cIdGrupo, cPswName, cPswPwd, cPswDet)	

EndIf

Return  // retorno da função
****************************************************************************************************************************************************

Static Function gArrayXNU() // função para para montar vetor com os menus de acesso

Declare g2_aMenus[Len(aGrupos[1][2])]

For Ln := 1 To Len(aGrupos[1][2])
	gCdMod := SubStr(aGrupos[1][2][Ln],1,2)
	If gCdMod == M->ZZC_CDMOD  // se código do módulo igual ao código do módulo/perfil
		g2_aMenus[Ln] := SubStr(aGrupos[1][2][Ln],1,2)+"5"+AllTrim(M->ZZC_XNU)  // Define vetor com os menus
	Else
		g2_aMenus[Ln] := SubStr(aGrupos[1][2][Ln],1,2)+"X"+AllTrim(SubStr(aGrupos[1][2][Ln],4,999))  // Define vetor com os menus				
	EndIf		
Next

Return g2_aMenus  // retorno da função        
****************************************************************************************************************************************************

Static Function gArrayEmp() // função para para montar vetor com as empresas acessadas

u2_aEmpresas := {}

DbSelectArea("SM0")  // seleciona arquivo de moedas
SM0->(DbSetOrder(1))  // muda ordem do índice
SM0->(DbGoTop())  // vai para o início do arquivo

Do While SM0->(!Eof())  // percorre todo o arquivo	
	Aadd(u2_aEmpresas,SM0->M0_CODIGO+SM0->M0_CODFIL)                  
	SM0->(DbSkip())  // incrementa contador de registro
EndDo

Return u2_aEmpresas  // retorno da função