/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp043 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp043 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe localiza��o do usu�rio                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo localiza��o do usu�rio - Rotina gEspI013���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp043()  // Exibe localiza��o do usu�rio

///gcLocal := ""  // Retorna a localiza��o do usu�rio
gcLocal := M->ZZE_LOCAL  // Retorna a localiza��o do usu�rio

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	gcLocal := Replicate("*",20)  // Retorna a localiza��o do usu�rio
EndIf	

If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambiente
	cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
	cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "				
	cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And "
	cQuery += "             ZZE.ZZE_CDUSU  = '" + M->ZZE_CDUSU   + "' And "    
	cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

	TCQUERY cQuery Alias TMP NEW                                      

	DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
	ZZE->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
		gcLocal := ZZE->ZZE_LOCALU  // localiza��o do usu�rio
	EndIf

	TMP->(DbCloseArea())	
EndIf

Return gcLocal  // retorno da fun��o