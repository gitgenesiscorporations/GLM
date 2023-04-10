/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp017 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp017 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe C�digo do Departamento do Usu�rio Solicitante        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo c�d. depto. usu�rio sol.-Rotina gEspI002���
���                                                       -Rotina gEspI013���    
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp017()  // Exibe C�digo do Departamento do Usu�rio Solicitante

gcCdDepSol := ""  // Retorna o C�digo do departamento do usu�rio solicitante

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcCdDepSol := Replicate("*",2)  // Retorna o C�digo do departamento do usu�rio solicitante

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
				gcCdDepSol := ZZE->ZZE_CDDEPU  // c�digo do departamento solicitante
			EndIf

			TMP->(DbCloseArea())	

			If Empty(gcCdDepSol)  // se c�digo do departamento vazio			
			    gcCdDepSol := Ret_CD_CC()  // fun��o que retorna o c�digo do centro de custo			
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
			gcCdDepSol := ZZE->ZZE_CDDEPT  // c�digo do departamento do usu�rio solicitante
		EndIf

		TMP->(DbCloseArea())	

		If Empty(gcCdDepSol)  // se c�digo do departamento vazio			
		    gcCdDepSol := Ret_CD_CC()  // fun��o que retorna o c�digo do centro de custo			
		EndIf
		
	EndIf

Else
    gcCdDepSol := Ret_CD_CC()  // fun��o que retorna o c�digo do centro de custo
EndIf
                    
If Empty(gcCdDepSol)  // se c�digo do departamento vazio
	gcCdDepSol := Replicate("*",2)  // Retorna o c�digo do departamento do usu�rio solicitante
EndIf
                    
Return gcCdDepSol  // retorno da fun��o
****************************************************************************************************************************************************

Static Function Ret_CD_CC()  // fun��o que retorna o c�digo do centro de custo

cQuery  := ""                             
cEmpAnt := ""
                         
DbSelectArea("SM0")  // seleciona arquivo de empresas          
SM0->(DbSetOrder(1))  // mujda ordem do �ndice
SM0->(DbGoTop())  // posiciona no primeiro registro
Do While !SM0->(Eof())  // percorre todo o arquivo      

	If cEmpAnt == SM0->M0_CODIGO  // se mesma empresa
		SM0->(DbSkip())  // incrementa contador de registro		
		Loop  // pega pr�ximo registro
	EndIf
	
	cQuery += "Select SRA.RA_CC As CC "
	cQuery += "  FROM SRA" + SM0->M0_CODIGO + "0 SRA "					
	cQuery += " Where SRA.RA_IDUSU   = '" + SubStr(cUsuario,7,15) + "' And "    
	cQuery += "       SRA.RA_SITFOLH = ' '                             And "      						
	cQuery += "       SRA.D_E_L_E_T_ = ' '                                 "
	     
	cEmpAnt := SM0->M0_CODIGO  // pega empresa

	SM0->(DbSkip())  // incrementa contador de registro
	
	If !SM0->(Eof())
		cQuery += "Union                                                       "	
	EndIf                    

EndDo
cQuery += "Order By SRA.RA_CC "

TCQUERY cQuery Alias TMP NEW                                      

_cCC := TMP->CC  // Centro de custo
	
TMP->(DbCloseArea())			
                                                                       
Return _cCC  // retorno da fun��o