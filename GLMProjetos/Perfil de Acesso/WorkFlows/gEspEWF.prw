/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspEWF  � Autor � George AC. Gon�alves � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspEWF  � Autor � George AC. Gon�alves � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio de WorkFlow                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Fun��es de envio de workflow - Rotinas: gEspI001           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "tbiconn.ch"
#Include "Ap5Mail.ch"

User Function gEspEWF(cTo,cBody,cSubject,cAnexo)  // Fun��o de envio de workflow

// Par�metros:
// MV_RELSERV  - Servidor de email
// MV_RELACNT  - Conta de envio
// MV_RELPSW   - Senha da Conta de envio
// MV_RELFROM  - Remetente ( e-mail )
// MV_RELAUTH  - Se o servidor de e-mail precisa de autentica��o

ConOut( "*****************************" )
ConOut( "Enviando e-mail para : " + cTo )
ConOut( "*****************************" )               
	
// Conecta com o Servidor SMTP
CONNECT SMTP SERVER GetMV("MV_RELSERV") ACCOUNT GetMV("MV_RELACNT") PASSWORD GetMV("MV_RELPSW") RESULT lOk
	
If lOk
	ConOut(cSubject)    
	                                       
	// Autentica a conex�o com o servidor de e-mail (Caso seja necess�rio)
	If GetMV("MV_RELAUTH")
		MAILAUTH(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"))
	EndIf
	   
	If pCount() < 4    // Verifica se n�o foi passado o parametro de anexo      
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
	ConOut( "Erro de conex�o : " + cSmtpError )   
Endif
	
Return lOk  // retorno da fun��o              