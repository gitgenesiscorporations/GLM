/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (TMK) - M�dulo de Call Center                              ���
�������������������������������������������������������������������������Ŀ��
���Programa  � TMK260OK   � Autor � George AC Gon�alves � Data � 13/06/14 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � TMK260OK   � Autor � George AC Gon�alves � Data � 13/06/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza hist�rico de atendimento                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de call center                         ���
��������������������������������������������������������������������������ٱ�
���Partida   � Ponto de entrada na rotina TMKA260                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function TMK260OK()  // Atualiza hist�rico de atendimento

lRet := .T.  // retotno verdadeiro
                                  
If ALTERA
	DbSelectArea("SUS")  // seleciona arquivo de prospec��o
	SUS->(DbSetOrder(1))  // muda ordem do �ndice
	If SUS->(DbSeek(xFilial("SUS")+M->US_COD+M->US_LOJA))  // posiciona registro
		RecLock("SUS",.F.)  // se bloquear registro
		MSMM(,TamSX3("US_HISTMK")[1],,M->US_HISTMK,1,,,"SUS","US_CODHIST")                                	
		MsUnLock()  // libera registro bloqueado          		
	Endif
EndIf	

Return lRet  // retorno da fun��o