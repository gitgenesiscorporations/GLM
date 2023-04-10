/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspT004 ³ Autor ³ George AC. Gonçalves ³ Data ³ 23/05/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspT004 ³ Autor ³ George AC. Gonçalves ³ Data ³ 23/05/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Processa atualização de usuário/perfil                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Chamada após a confirmação do bloqueio - Rotina: gEspP002  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gEspT004(gcOpc)  // Processa atualização de usuário/perfil
// gcOpc    = identifica opção para gravação
//            "B" = Bloqueio de usuário
//            "S" = Reinicia senha   
//            "D" = Desbloqueio de usuário 

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

Public aUsers := AllUsers(.T.)   // vetor de usuários             
Public u1_cSenha
Public u1_cCdUser

//Abro a Tabela de Senhas
SPF_CanOpen(cPswFile) 

//Procuro pelo usuario Base
nPswRec	:= SPF_Seek(cPswFile,"1U"+cUsrId,1) 

//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
SPF_GetFields(@cPswFile,@nPswRec,@cPswId,@cPswName,@cPswPwd,@cPswDet)

//Converto o conteudo da string cPswDet em um Array
aPswDet	:= Str2Array(@cPswDet,@lEncrypt)

// aReturn[1] => array com dados do usuário
u1_cUsrId         := ZZE->ZZE_CDUSU  // ID so usuário    
u1_lAutAltSenha   := .T.             // Usuário autorizado a alterar senha
u1_lAltSenhaLogon := .T.             // Altera senha no próximo logon

If gcOpc == "B"  // se opção de bloqueio     
	u1_lUsuBloqueio := .T.             // Usuário bloqueado
ElseIf gcOpc == "D"  // se opção de bloqueio     	       
	u1_lUsuBloqueio := .F.             // Usuário desbloqueado
EndIf	

//Decriptando a senha antiga para obter o tamanho valido para a senha
cOldPsw	  := PswEncript(u1_cUsrId,1)
//Encriptando a senha para o novo usuario
cNewPsw	  := PswEncript(Padr(u1_cUsrId,Len(cOldPsw)),0)
//Atribuindo a nova senha ao novo usuario
u1_cSenha := cNewPsw

// posiciona registro de usuário - Chave 1U
nRet := SPF_Seek(cPswFile,"1U"+u1_cUsrId,1)

If nRet > 0  // se encontrar ID do usuário

     //Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
     SPF_GetFields(@cPswFile,@nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)

     //Converto o conteudo da string cPswDet em um Array
     aReturn := Str2Array(@cPswDet,@lEncrypt)

	 // aReturn[1] => array com dados do usuário 
	 u1_cCdUser := aReturn[1][2]  // código do usuário
	 
	 Do Case
	 	Case gcOpc == "B" .Or. gcOpc == "D"  // se opção de bloqueio ou desbloqueio    
			aReturn[1][17] := u1_lUsuBloqueio                          

			//Convertendo as informacoes no novo usuario para gravacao
			cPswDet := Array2Str(@aReturn,@lEncrypt)
     
			//Alterando usuario     
///			SPF_UPDATE(cPswFile,nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)     
///			SPF_UPDATE(cPswFile,nRet,"1U"+u1_cUsrId,Upper("1U"+u1_cCdUser),"1U"+u1_cSenha,cPswDet)     
			SPF_UPDATE(cPswFile,nRet,"1U"+u1_cUsrId,Upper("1U"+u1_cCdUser),"1U"+aReturn[1][3],cPswDet)     			
			
	 	Case gcOpc == "S"  // se opção de reiniciar senha
			aReturn[1][3]  := u1_cSenha
			aReturn[1][8]  := u1_lAutAltSenha
			aReturn[1][9]  := u1_lAltSenhaLogon			
			
			//Convertendo as informacoes no novo usuario para gravação
			cPswDet := Array2Str(@aReturn,@lEncrypt)
     
			//Alterando usuario     
///			SPF_UPDATE(cPswFile,nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)                              
			SPF_UPDATE(cPswFile,nRet,"1U"+u1_cUsrId,Upper("1U"+u1_cCdUser),"1U"+u1_cSenha,cPswDet)     
			
	 EndCase

EndIf

Return  // retorno da função