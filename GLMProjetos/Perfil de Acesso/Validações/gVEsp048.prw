/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp048 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp048 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Descri��o do Departamento do Usu�rio                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo desc. depto. do usu�rio -Rotina gEspI002���
���                                                       -Rotina gEspI013���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp048()  // Exibe Descri��o do Departamento do Usu�rio

gcDsDepUsu := ""  // Retorna a Descri��o do departamento do usu�rio

/*
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	gcDsDepSol := Replicate("*",30)  // Retorna a Descri��o do departamento do usu�rio

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambiente
		DbSelectArea("SQB")  // seleciona arquivo de departamentos
		SQB->(DbSetOrder(1))  // muda ordem do �ndice
		If SQB->(DbSeek(xFilial("SQB")+M->ZZE_CDDEPU))  // posiciona registro
			gcDsDepSol := SQB->QB_DESCRIC  // descri��o do departamento
		EndIf                         
	Else
		gcDsDepSol := M->ZZE_DSDEPT
	EndIf
		
///EndIf
*/

/*    
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	gcDsDepUsu := Replicate("*",30)  // Retorna a Descri��o do departamento do usu�rio

	DbSelectArea("CTT")  // seleciona arquivo de departamentos
	CTT->(DbSetOrder(1))  // muda ordem do �ndice
	If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
		gcDsDepUsu := CTT->CTT_DESC01  // descri��o do departamento
	EndIf
///EndIf
*/

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcDsDepUsu := Replicate("*",30)  // Retorna a descri��o do cargo/fun��o do usu�rio solicitante

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
				gcDsDepUsu := ZZE->ZZE_NMDEPU  // descri��o do cargo/fun��o solicitante
			EndIf

			TMP->(DbCloseArea())	
			
			If Empty(gcDsDepUsu)  // se descri��o do departamento vazio			
				DbSelectArea("CTT")  // seleciona arquivo de departamentos
				CTT->(DbSetOrder(1))  // muda ordem do �ndice
				If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
					gcDsDepUsu := CTT->CTT_DESC01  // descri��o do departamento
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
			gcDsDepUsu := ZZE->ZZE_NMDEPU  // descri��o do cargo/fun��o do usu�rio solicitante
		EndIf

		TMP->(DbCloseArea())	
		
		If Empty(gcDsDepUsu)  // se descri��o do departamento vazio			
			DbSelectArea("CTT")  // seleciona arquivo de departamentos
			CTT->(DbSetOrder(1))  // muda ordem do �ndice
			If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
				gcDsDepUsu := CTT->CTT_DESC01  // descri��o do departamento
			EndIf
		EndIf
					
	EndIf	

Else

	DbSelectArea("CTT")  // seleciona arquivo de departamentos
	CTT->(DbSetOrder(1))  // muda ordem do �ndice
	If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
		gcDsDepUsu := CTT->CTT_DESC01  // descri��o do departamento
	EndIf

EndIf

If Empty(gcDsDepUsu)  // se descri��o do departamento vazio
	gcDsDepUsu := Replicate("*",30)  // Retorna a descri��o do departamento do usu�rio
EndIf

Return gcDsDepUsu  // retorno da fun��o