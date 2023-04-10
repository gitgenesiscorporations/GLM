/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � PMDELAFU  � Autor � George AC Gon�alves � Data � 16/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � PMDELAFU  � Autor � George AC Gon�alves � Data � 16/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Complemento � exclus�o dos apontamentos modelo II          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Ponto de entrada na rotina PMSA321                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function PMDELAFU()  // Complemento � exclus�o dos apontamentos modelo II

cArea    := GetArea()          
cAreaAFU := AFU->(GetArea())
cAreaSZ0 := SZ0->(GetArea())

DbSelectArea("SZ0")  // seleciona arquivo de cabe�alho da ordem de servi�o
SZ0->(DbSetOrder(1))  // muda ordem do �ndice
If SZ0->(DbSeek(xFilial("SZ0")+AFU->AFU_DOCUME))  // posiciona registro   
	RecLock("SZ0",.F.)  // se bloquear registro                                              
	SZ0->(DbDelete())  // exclui registro
	MsUnLock()  // libera registro bloqueado                                                 
EndIf

SZ0->(RestArea(cAreaSZ0))
AFU->(RestArea(cAreaAFU))
RestArea(cArea)

Return  // retorno da fun��o