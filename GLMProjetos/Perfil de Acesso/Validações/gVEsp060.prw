/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp060 � Autor � George AC Gon�alves  � Data � 02/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp060 � Autor � George AC Gon�alves  � Data � 02/12/09  ���
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

User Function gVEsp060()  // Filtra matr�cula pelo respons�vel do centro de custo

lRet := .T.  // flag de retorno verdadeiro

If M->ZZE_MATSOL == M->ZZE_MATUSU  // se matr�cula do solicitante igual ao do usu�rio
	lRet := .F.  // flag de retorno falso
	MsgStop("Matr�cula do usu�rio n�o pode ser a mesma que o solicitante","Aten��o")	
EndIf
                                                                        
DbSelectArea("SRA")  // seleciona arquivo de funcion�rios
SRA->(DbSetOrder(1))  // muda ordem do �ndice
If SRA->(!DbSeek(xFilial("SRA")+M->ZZE_MATUSU))  // posiciona registro
	lRet := .F.  // flag de retorno falso
	MsgStop("Matr�cula do usu�rio n�o cadastrada no arquivo de funcion�rio do m�dulo de folha de pagamento","Aten��o")	 
Else
	If !Empty(SRA->RA_SITFOLH)  // se situa��o n�o for normal
		lRet := .F.  // flag de retorno falso
		MsgStop("Funcion�rio n�o esta com a situa��o normalizada no m�dulo de folha de pagamento","Aten��o")	 	
	EndIf
EndIf

DbSelectArea("CTT")  // seleciona arquivo de centro de custo
CTT->(DbSetOrder(1))  // muda ordem do �ndice
If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))  // posiciona registro
	If AllTrim(Upper(CTT->CTT_IDRESP)) <> AllTrim(Upper(SubStr(cUsuario,7,15)))  // se o solicitante responsavel pelo CC
		lRet := .F.  // flag de retorno falso
		MsgStop("Funcion�rio n�o pertence ao centro de custo sob responsabilidade do solicitante","Aten��o")		
	EndIf
EndIf
                                       
Return lRet  // retorno da fun��o