/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp011 � Autor � George AC Gon�alves  � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp011 � Autor � George AC Gon�alves  � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe ID do Controller da Empresa                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Habilita��o do campo controller - Rotina gEspI001          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp011()  // Exibe ID do Controller da Empresa

gIDControl := "" 

cQuery := "    SELECT ZZI.ZZI_IDUSUA AS ID_USER "
cQuery += "      FROM " + RetSqlname("ZZI") + " ZZI "
cQuery += "     WHERE ZZI.ZZI_FILIAL = '" + xFilial("ZZI") + "' And " 
cQuery += "           ZZI.ZZI_TIPO  <> '1'                      And "    
cQuery += "           ZZI.D_E_L_E_T_ = ' '                          "
                                
TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())  // vai para o in�cio do arquivo

Do While TMP->(!Eof())  // percorre todo o arquivo
	gIDControl := TMP->ID_USER  // ID do usu�rio
	TMP->(DbSkip())  // incrementa contador de registro
EndDo

TMP->(DbCloseArea())  // fecha arquivo tempor�rio

Return gIDControl  // retorno da fun��o