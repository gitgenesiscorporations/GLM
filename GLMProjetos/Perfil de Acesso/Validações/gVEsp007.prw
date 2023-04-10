/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp007 � Autor � George AC Gon�alves  � Data � 19/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp007 � Autor � George AC Gon�alves  � Data � 19/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida c�digo do m�dulo                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do m�dulo - Rotina gEspI001            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp007()  // Valida c�digo do m�dulo

lRet := .T.  // departamento/m�dulo n�o cadastrado

gcCdDepto := aCols[N,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="ZZF_CDDEPT"})]  // recupera campo de c�digo do departamento

DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
ZZJ->(DbSetOrder(1))  // muda ordem do �ndice
If ZZJ->(!DbSeek(xFilial("ZZJ")+gcCdDepto+M->ZZF_CDMOD))  // posiciona registro
	lRet := .F.  // departamento/m�dulo j� cadastrado
	MsgStop("M�dulo n�o cadastrado para o departamento selecionado.","Aten��o")	
EndIf

Return lRet   // retorno da fun��o