/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp023 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp023 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Telefone/Ramal do Usu�rio Solicitante                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo tel. usu�rio solic. - Rotina gEspI002   ���
���                                                   - Rotina gEspI013   ���    
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp023()  // Exibe telefone/ramal do Usu�rio Solicitante

///gcTelSol := ""  // Retorna o telefone/ramal do usu�rio solicitante
gcTelSol := Replicate("*",20)  // Retorna o telefone/ramal do usu�rio solicitante

///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
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
				gcTelSol := ZZE->ZZE_TELUSU  // telefone/ramal do solicitante
			EndIf

			TMP->(DbCloseArea())	
		EndIf	
		
    Else
		cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
		cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "				
		cQuery += "       Where ZZE.ZZE_FILIAL = ' '                    And "
		cQuery += "             ZZE.ZZE_CDSOL  = '" + M->ZZE_CDSOL + "' And "    
		cQuery += "			    ZZE.D_E_L_E_T_ = ' '                        "

		TCQUERY cQuery Alias TMP NEW                                      

		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
			gcTelSol := ZZE->ZZE_TELSOL  // telefone/ramal do usu�rio solicitante
		EndIf

		TMP->(DbCloseArea())	
	EndIf	
///EndIf

Return gcTelSol  // retorno da fun��o