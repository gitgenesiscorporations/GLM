/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspT004 � Autor � George AC. Gon�alves � Data � 23/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspT004 � Autor � George AC. Gon�alves � Data � 23/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa atualiza��o de usu�rio/perfil                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada ap�s a confirma��o do bloqueio - Rotina: gEspP002  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspT004(gcOpc)  // Processa atualiza��o de usu�rio/perfil
// gcOpc    = identifica op��o para grava��o
//            "B" = Bloqueio de usu�rio
//            "S" = Reinicia senha   
//            "D" = Desbloqueio de usu�rio 

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

Public aUsers := AllUsers(.T.)   // vetor de usu�rios             
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

// aReturn[1] => array com dados do usu�rio
u1_cUsrId         := ZZE->ZZE_CDUSU  // ID so usu�rio    
u1_lAutAltSenha   := .T.             // Usu�rio autorizado a alterar senha
u1_lAltSenhaLogon := .T.             // Altera senha no pr�ximo logon

If gcOpc == "B"  // se op��o de bloqueio     
	u1_lUsuBloqueio := .T.             // Usu�rio bloqueado
ElseIf gcOpc == "D"  // se op��o de bloqueio     	       
	u1_lUsuBloqueio := .F.             // Usu�rio desbloqueado
EndIf	

//Decriptando a senha antiga para obter o tamanho valido para a senha
cOldPsw	  := PswEncript(u1_cUsrId,1)
//Encriptando a senha para o novo usuario
cNewPsw	  := PswEncript(Padr(u1_cUsrId,Len(cOldPsw)),0)
//Atribuindo a nova senha ao novo usuario
u1_cSenha := cNewPsw

// posiciona registro de usu�rio - Chave 1U
nRet := SPF_Seek(cPswFile,"1U"+u1_cUsrId,1)

If nRet > 0  // se encontrar ID do usu�rio

     //Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
     SPF_GetFields(@cPswFile,@nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)

     //Converto o conteudo da string cPswDet em um Array
     aReturn := Str2Array(@cPswDet,@lEncrypt)

	 // aReturn[1] => array com dados do usu�rio 
	 u1_cCdUser := aReturn[1][2]  // c�digo do usu�rio
	 
	 Do Case
	 	Case gcOpc == "B" .Or. gcOpc == "D"  // se op��o de bloqueio ou desbloqueio    
			aReturn[1][17] := u1_lUsuBloqueio                          

			//Convertendo as informacoes no novo usuario para gravacao
			cPswDet := Array2Str(@aReturn,@lEncrypt)
     
			//Alterando usuario     
///			SPF_UPDATE(cPswFile,nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)     
///			SPF_UPDATE(cPswFile,nRet,"1U"+u1_cUsrId,Upper("1U"+u1_cCdUser),"1U"+u1_cSenha,cPswDet)     
			SPF_UPDATE(cPswFile,nRet,"1U"+u1_cUsrId,Upper("1U"+u1_cCdUser),"1U"+aReturn[1][3],cPswDet)     			
			
	 	Case gcOpc == "S"  // se op��o de reiniciar senha
			aReturn[1][3]  := u1_cSenha
			aReturn[1][8]  := u1_lAutAltSenha
			aReturn[1][9]  := u1_lAltSenhaLogon			
			
			//Convertendo as informacoes no novo usuario para grava��o
			cPswDet := Array2Str(@aReturn,@lEncrypt)
     
			//Alterando usuario     
///			SPF_UPDATE(cPswFile,nRet,@cPswId,@cPswName,@cPswPwd,@cPswDet)                              
			SPF_UPDATE(cPswFile,nRet,"1U"+u1_cUsrId,Upper("1U"+u1_cCdUser),"1U"+u1_cSenha,cPswDet)     
			
	 EndCase

EndIf

Return  // retorno da fun��o