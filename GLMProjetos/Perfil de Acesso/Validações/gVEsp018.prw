/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp018 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp018 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Descri��o do Departamento do Usu�rio Solicitante     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo desc. dept. usu�rio sol.-Rotina gEspI002���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp018()  // Exibe Descri��o do Departamento do Usu�rio Solicitante

gcDsDepSol := ""  // Retorna a Descri��o do departamento do usu�rio solicitante

/*
If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	DbSelectArea("SQB")  // seleciona arquivo de departamentos
	SQB->(DbSetOrder(1))  // muda ordem do �ndice
	If SQB->(DbSeek(xFilial("SQB")+M->ZZE_CDDEPT))  // posiciona registro
		gcDsDepSol := SQB->QB_DESCRIC  // descri��o do departamento
	EndIf
EndIf
*/

/*
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	gcDsDepSol := Replicate("*",30)  // Retorna a Descri��o do departamento do usu�rio solicitante

	DbSelectArea("CTT")  // seleciona arquivo de departamentos
	CTT->(DbSetOrder(1))  // muda ordem do �ndice
	If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPT))  // posiciona registro
		gcDsDepSol := CTT->CTT_DESC01  // descri��o do departamento
	EndIf
///EndIf
*/

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcDsDepSol := Replicate("*",30)  // Retorna a descri��o do departamento do usu�rio solicitante

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
				gcDsDepSol := ZZE->ZZE_DSDEPT  // c�digo do departamento solicitante
			EndIf

			TMP->(DbCloseArea())	

			If Empty(gcDsDepSol)  // se descri��o do departamento vazio			
				DbSelectArea("CTT")  // seleciona arquivo de departamentos
				CTT->(DbSetOrder(1))  // muda ordem do �ndice
				If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPT))  // posiciona registro
					gcDsDepSol := CTT->CTT_DESC01  // descri��o do departamento
				EndIf
			EndIf
			
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
			gcDsDepSol := ZZE->ZZE_DSDEPT  // descri��o do departamento do usu�rio solicitante
		EndIf

		TMP->(DbCloseArea())	
		
		If Empty(gcDsDepSol)  // se descri��o do departamento vazio			
			DbSelectArea("CTT")  // seleciona arquivo de departamentos
			CTT->(DbSetOrder(1))  // muda ordem do �ndice
			If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPT))  // posiciona registro
				gcDsDepSol := CTT->CTT_DESC01  // descri��o do departamento
			EndIf
		EndIf		
		
	EndIf

Else

	DbSelectArea("CTT")  // seleciona arquivo de departamentos
	CTT->(DbSetOrder(1))  // muda ordem do �ndice
	If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPT))  // posiciona registro
		gcDsDepSol := CTT->CTT_DESC01  // descri��o do departamento
	EndIf
		
EndIf

If Empty(gcDsDepSol)  // se descri��o do departamento vazio
	gcDsDepSol := Replicate("*",30)  // Retorna a descri��o do departamento do usu�rio solicitante
EndIf

Return gcDsDepSol  // retorno da fun��o