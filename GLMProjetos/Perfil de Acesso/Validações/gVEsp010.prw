/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp010 � Autor � George AC Gon�alves  � Data � 05/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp010 � Autor � George AC Gon�alves  � Data � 06/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Controller da Empresa                                ���
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

User Function gVEsp010()  // Exibe Controller da Empresa

cNmControl := ""

cQuery := "    SELECT ZZI.ZZI_NMUSU AS NM_CONTROLLER "
cQuery += "      FROM " + RetSqlname("ZZI") + " ZZI "
cQuery += "     WHERE ZZI.ZZI_FILIAL = '" + xFilial("ZZI") + "' And " 
cQuery += "           ZZI.ZZI_TIPO  <> '1'                      And "    
cQuery += "           ZZI.D_E_L_E_T_ = ' '                          "
                                
TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())  // vai para o in�cio do arquivo

Do While TMP->(!Eof())  // percorre todo o arquivo
	cNmControl := TMP->NM_CONTROLLER  // nome do controller
	TMP->(DbSkip())  // incrementa contador de registro
EndDo

TMP->(DbCloseArea())  // fecha arquivo tempor�rio

Return cNmControl  // retorno da fun��o