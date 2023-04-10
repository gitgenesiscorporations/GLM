/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp005 � Autor � George AC Gon�alves  � Data � 11/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp005 � Autor � George AC Gon�alves  � Data � 11/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida��o do arquivo de menu�s (.XNU)                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do arquivo de menu - Rotina gCADZZC              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp005()  // Valida��o do arquivo de menu�s (.XNU)

lRet    := .T.                                                       // retorno de arquivo selecionado
_cPatch := Upper(AllTrim(GetMv("PATCH_MENU"))+"\"+M->ZZC_CDMOD+"\")  // patch dos diret�rios de menus                                    

If !Empty(M->ZZC_XNU)  // se informado o arquivo de menu
	If !File(M->ZZC_XNU)  // se n�o existe o arquivo informado
		lRet := .F.  // retorno de arquivo selecionado		
		MsgStop("Arquivo de menu n�o existe no diret�rio","Aten��o")			
	EndIf

	If lRet == .T. .And. !(_cPatch $ AllTrim(Upper(M->ZZC_XNU)))  // se arquivo selecionado esta de acordo com os par�metros de patch de menu�s
		lRet := .F.  // retorno de arquivo selecionado		
		MsgStop("M�dulo e Arquivo selecionado n�o est�o em conformidade com o par�metro dos arquivos de menus. Padr�o: [ SERVIDOR"+_cPatch+" ]","Aten��o")			
	EndIf
EndIf

Return lRet  // retorno da fun��o