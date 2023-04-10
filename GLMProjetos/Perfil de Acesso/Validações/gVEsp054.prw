/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp054 � Autor � George AC Gon�alves  � Data � 16/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp054 � Autor � George AC Gon�alves  � Data � 16/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Empresa Pestadadora de Servi�o                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo empresa prestadora - Rotina gEspI013    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp054()  // Exibe empresa prestadora do servi�o

gcEmpPrest := ""  // Retorna a empresa prestadora servi�o

If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambiente

	PSWORDER(2)  // muda ordem de �ndice
	If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()

		cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
		cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "					
		cQuery += "       Where ZZE.ZZE_FILIAL = ' '                    And "
		cQuery += "             ZZE.ZZE_CDUSU  = '" + aArray[1][1] + "' And "    
		cQuery += "			    ZZE.D_E_L_E_T_ = ' '                        "

		TCQUERY cQuery Alias TMP NEW                                      

		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
			gcEmpPrest := ZZE->ZZE_EMPPRE  // empresa prestadora do servi�o
		EndIf

		TMP->(DbCloseArea())	
	EndIf
		
EndIf

Return gcEmpPrest  // retorno da fun��o