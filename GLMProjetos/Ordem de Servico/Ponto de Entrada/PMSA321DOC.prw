/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � PMSA321DOC� Autor � George AC Gon�alves � Data � 15/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � PMSA321DOC� Autor � George AC Gon�alves � Data � 15/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Regra de numera��o da ordem de servi�o                     ���
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

User Function PMSA321DOC()  // Regra de numera��o da ordem de servi�o

cArea    := GetArea()          
cAreaAFU := AFU->(GetArea())

Public _cNumOS

cQuery := "Select Max (AFU.AFU_DOCUME) As NUMOS " 
cQuery += "  From " + RetSqlname("AFU") + " AFU "
cQuery += " Where AFU.AFU_FILIAL = '" + xFilial("AFU") + "' And " 
cQuery += "       AFU.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())

If TMP->(!Eof())
	_cNumOS := SubStr(TMP->NUMOS,1,4)+StrZero(Val(SubStr(TMP->NUMOS,5,6))+1,6)
	If SubStr(Dtos(dDataBase),1,4) <> SubStr(TMP->NUMOS,1,4)
		_cNumOS := SubStr(Dtos(dDataBase),1,4)+"000001"
	EndIf	
Else                                                                 
	_cNumOS := SubStr(Dtos(dDataBase),1,4)+"000001"
EndIf                                  

TMP->(DbCloseArea())	
                                              
AFU->(RestArea(cAreaAFU))
RestArea(cArea)

Return _cNumOS  // retorno da fun��o