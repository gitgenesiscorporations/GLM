/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGPms002 � Autor � George AC Gon�alves  � Data � 17/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGPms002 � Autor � George AC Gon�alves  � Data � 17/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Preenchimento do campo de n�mero da ordem de servi�o       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do campo de projetos                             ���
���          � ROTINA PMSA321 - Apontamentos Modelo II                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gGPms002()  // Preenchimento do campo de n�mero da ordem de servi�o

cArea    := GetArea()          
cAreaAFU := AFU->(GetArea())
              
If ALTERA == .T.            
	If N > 1
		_cNumOS := aCols[N-1,Ascan(aHeader,{|x|AllTrim(x[2])=="AFU_DOCUME"})]	
	EndIf
EndIf
                                              
AFU->(RestArea(cAreaAFU))
RestArea(cArea)

Return _cNumOS   // retorno da fun��o