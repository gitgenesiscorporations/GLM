/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp004 � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp004 � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida exist�ncia de m�dulo/perfil cr�tico                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do m�dulo de origem - Rotina gCADZZD   ���
���          � Digita��o do c�digo do perfil de origem - Rotina gCADZZD   ���
���          � Digita��o do c�digo do m�dulo cr�tico   - Rotina gCADZZD   ���
���          � Digita��o do c�digo do perfil cr�tico   - Rotina gCADZZD   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp004()  // Valida exist�ncia de m�dulo/perfil cr�tico

lRet := .T.  // m�dulo/perfil existente

DbSelectArea("ZZD")  // seleciona arquivo de m�dulo/perfil cr�tico
ZZD->(DbSetOrder(1))  // muda ordem do �ndice
If ZZD->(DbSeek(xFilial("ZZD")+M->ZZD_CDMODO+M->ZZD_CDPERO+M->ZZD_CDMODC+M->ZZD_CDPERC))  // posiciona registro
	lRet := .F.  // m�dulo/perfil cr�tico j� cadastrado
	MsgStop("M�dulo/Perfil cr�tico j� cadastrado","Aten��o")	
EndIf	

Return lRet   // retorno da fun��o