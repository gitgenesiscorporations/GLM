/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp062 � Autor � George AC Gon�alves  � Data � 04/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp062 � Autor � George AC Gon�alves  � Data � 04/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe dias a avan�ar para lan�amento                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo dias a avan�ar - Rotina gEspM015        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp062()  // Exibe n�mero de dias a avan�ar para lan�amento

gnAvanco := GetMv("MV_DIASAVA")  // Retorna n�mero de dias a avan�ar para lan�amento

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambiente

		PSWORDER(2)  // muda ordem de �ndice
		If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
			aArray := PSWRET()
		
			cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
			cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "						
			cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And "
			cQuery += "             ZZE.ZZE_CDUSU  = '" + aArray[1][1]   + "' And "    
			cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

			TCQUERY cQuery Alias TMP NEW                                      

			DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
			ZZE->(DbSetOrder(1))  // muda ordem do �ndice
			If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
				gnAvanco := ZZE->ZZE_AVANCO  // n�mero de dias as avan�ar
			EndIf

			TMP->(DbCloseArea())	
		EndIf	
		
    Else
		cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
		cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "					
		cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And "
		cQuery += "             ZZE.ZZE_CDSOL  = '" + M->ZZE_CDSOL   + "' And "    
		cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

		TCQUERY cQuery Alias TMP NEW                                      

		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
			gnAvanco := ZZE->ZZE_AVANCO  // n�mero de dias as avan�ar
		EndIf

		TMP->(DbCloseArea())	
  EndIf	

EndIf

Return gnAvanco  // retorno da fun��o