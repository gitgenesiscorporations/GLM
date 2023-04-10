/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp059 � Autor � George AC Gon�alves  � Data � 02/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp059 � Autor � George AC Gon�alves  � Data � 02/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra matr�cula pelo respons�vel do centro de custo       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo matr�cula do usu�rio - Rotina gEspI001  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp059()  // Filtra matr�cula pelo respons�vel do centro de custo

lRet := .F.  // flag de retorno falso
                               
DbSelectArea("CTT")  // seleciona arquivo de centro de custo
CTT->(DbSetOrder(1))  // muda ordem do �ndice
If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))  // posiciona registro
	If AllTrim(Upper(CTT->CTT_IDRESP)) == AllTrim(Upper(SubStr(cUsuario,7,15)))  // se o solicitante responsavel pelo CC
		lRet := .T.  // flag de retorno verdadeiro
	EndIf
EndIf

Return lRet  // retorno da fun��o                              