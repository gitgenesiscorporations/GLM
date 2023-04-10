/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGPms001 � Autor � George AC Gon�alves  � Data � 09/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGPms001 � Autor � George AC Gon�alves  � Data � 09/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Regra de codifica��o de produtos                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o dos campos de grupo e tipo de produto            ���
���          � ROTINA MATA010 - Cadastro de Produtos                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gGPms001()  // Regra de codifica��o de produtos

cArea    := GetArea()          
cAreaSB1 := SB1->(GetArea())

cQuery := "Select Max (SB1.B1_COD) As PRODUTO " 
cQuery += "  From " + RetSqlname("SB1") + " SB1 "
cQuery += " Where SB1.B1_FILIAL = '" + xFilial("SB1") + "' And " 
cQuery += "       SB1.B1_GRUPO  = '" + M->B1_GRUPO    + "' And " 
cQuery += "       SB1.B1_TIPO   = '" + M->B1_TIPO     + "' And " 
cQuery += "       SB1.D_E_L_E_T_ = ' '                           "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())

If TMP->(!Eof())
	_cCdProd := M->B1_GRUPO+M->B1_TIPO+StrZero(Val(SubStr(TMP->PRODUTO,7,7))+1,7)
Else                                                                 
	_cCdProd := M->B1_GRUPO+M->B1_TIPO+"0000001"
EndIf                                  

TMP->(DbCloseArea())	
                                              
SB1->(RestArea(cAreaSB1))
RestArea(cArea)

Return _cCdProd   // retorno da fun��o