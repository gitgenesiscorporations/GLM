/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspEWF  ³ Autor ³ George AC. Gonçalves ³ Data ³ 07/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspEWF  ³ Autor ³ George AC. Gonçalves ³ Data ³ 07/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Envio de WorkFlow                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Funções de envio de workflow - Rotinas: gEspI001           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "tbiconn.ch"
#Include "Ap5Mail.ch"

User Function gEspEWF(cTo,cBody,cSubject,cAnexo)  // Função de envio de workflow

// Parâmetros:
// MV_RELSERV  - Servidor de email
// MV_RELACNT  - Conta de envio
// MV_RELPSW   - Senha da Conta de envio
// MV_RELFROM  - Remetente ( e-mail )
// MV_RELAUTH  - Se o servidor de e-mail precisa de autenticação

ConOut( "*****************************" )
ConOut( "Enviando e-mail para : " + cTo )
ConOut( "*****************************" )               
	
// Conecta com o Servidor SMTP
CONNECT SMTP SERVER GetMV("MV_RELSERV") ACCOUNT GetMV("MV_RELACNT") PASSWORD GetMV("MV_RELPSW") RESULT lOk
	
If lOk
	ConOut(cSubject)    
	                                       
	// Autentica a conexão com o servidor de e-mail (Caso seja necessário)
	If GetMV("MV_RELAUTH")
		MAILAUTH(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"))
	EndIf
	   
	If pCount() < 4    // Verifica se não foi passado o parametro de anexo      
		// Envia o e-mail
		SEND MAIL From GetMV('MV_RELFROM') TO cTo SUBJECT cSubject BODY cBody RESULT lOk   
	Else // caso tenha sida passado o parametro de anexo
		// Envia o e-mail
		SEND MAIL From GetMV('MV_RELFROM') TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAnexo RESULT lOk   
	EndIf	             
	
	If lOk   
		ConOut( 'Para:  '+ cTo )
		ConOut( 'Com sucesso' )
	Else  
		Get MAIL ERROR cSmtpError
		ConOut( "Erro de envio : " + cSmtpError )
	Endif    
	
	// Desconecta do Servidor   
	DISCONNECT SMTP SERVER    
	
Else
	Get MAIL ERROR cSmtpError
	ConOut( "Erro de conexão : " + cSmtpError )   
Endif
	
Return lOk  // retorno da função              