/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp005 � Autor � George AC Gon�alves  � Data � 11/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp005 � Autor � George AC Gon�alves  � Data � 11/12/08  ���
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

User Function gGEsp005()  // Seleciona arquivo de menu�s (.XNU)

_cPatch := "SERVIDOR"+AllTrim(GetMv("PATCH_MENU"))+"\"+M->ZZC_CDMOD+"\"                                         // patch dos diret�rios de menus                                    
cArqXnu := cGetFile("Arquivos de Menus (*.XNU) | *.XNU |",OemToAnsi("Selecionando Arquivos..."),0,_cPatch,.T.)  // seleciona arquivos de menu�s

Return cArqXnu  // retorno da fun��o