/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � EBX Investimentos Ltda                                     ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gCADZZCa � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gCADZZCa � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Seleciona arquivo de menu�s (.XNU)                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do departamento - Rotina gCADZZJ       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gCADZZCa()  // Seleciona arquivo de menu�s (.XNU)

Local lRet    := .T.                                                           // retorno de arquivo selecionado
Local _cPatch := "SERVIDOR"+AllTrim(GetMv("PATCH_MENU"))+"\"+M->ZZC_CDMOD+"\"  // patch dos diret�rios de menus                                    

Public cArqXnu := M->ZZC_XNU                                                   // arquivo de menu

If AllTrim(cArqXnu) == "*"  // se n�o informado arquivo
	cArqXnu := cGetFile("Arquivos de Menus (*.XNU) | *.XNU |",OemToAnsi("Selecionando Arquivos..."),0,_cPatch,.T.)

	If Empty(cArqXnu)  // se arquivo n�o selecionado                         
		lRet := .F.  // retorno de arquivo selecionado	
		MsgStop("Arquivo de menu n�o selecionado","Aten��o")			
	EndIf
EndIf	

If lRet == .T. .And. !File(cArqXnu)  // se n�o existe o arquivo informado
	lRet := .F.  // retorno de arquivo selecionado		
	MsgStop("Arquivo de menu n�o existe no diret�rio","Aten��o")			
EndIf

Return lRet   // retorno da fun��o