/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp009 � Autor � George AC Gon�alves  � Data � 19/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp009 � Autor � George AC Gon�alves  � Data � 19/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida c�digo do perfil                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do perfil - Rotina gEspI001            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp009()  // Valida c�digo do perfil

lRet := .T.  // departamento/m�dulo n�o cadastrado

gcCdMod  := aCols[N,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="ZZF_CDMOD"})]   // recupera campo de c�digo do m�dulo

DbSelectArea("ZZC")  // seleciona arquivo de m�dulo/perfil
ZZC->(DbSetOrder(1))  // muda ordem do �ndice
If ZZC->(!DbSeek(xFilial("ZZC")+gcCdMod+M->ZZF_CDPERF))  // posiciona registro
	lRet := .F.  // departamento/m�dulo j� cadastrado
	MsgStop("Perfil n�o cadastrado para o departamento/m�dulo selecionado.","Aten��o")	
EndIf

Return lRet   // retorno da fun��o