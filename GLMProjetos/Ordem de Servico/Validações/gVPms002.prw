/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVPms002 � Autor � George AC Gon�alves  � Data � 15/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVPms002 � Autor � George AC Gon�alves  � Data � 15/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Preenchimento autom�tico do c�digo do recurso              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inicializador padr�o do campo de c�digo do usu�rio         ���
���          � ROTINA PMSA321 - Apontamentos Modelo II                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVPms002()  // Preenchimento autom�tico do c�digo do recurso

cArea    := GetArea()          
cAreaAE8 := AE8->(GetArea())                        
cAreaAFU := AFU->(GetArea())                        

_cCdRec := ""  // c�digo do recurso

DbSelectArea("AE8")  // Seleciona arquivo de recursos
AE8->(DbSetOrder(3))  // muda ordem do �ndice
If AE8->(DbSeek(xFilial("AE8")+__cUserID))  // posiciona registro
	_cCdRec := AE8->AE8_RECURS  // c�digo do recurso
Else            
	MsgStop("Usu�rio ["+__cUserID+"-"+cUserName+"] n�o associado a tabela de c�digo de recursos","Aten��o")	
EndIf
               
AFU->(RestArea(cAreaAFU))
AE8->(RestArea(cAreaAE8))
RestArea(cArea)

Return _cCdRec  // retorno da fun��o