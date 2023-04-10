/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp064 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp064 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recupera Matr�cula do Usu�rio                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo matr�cula do usu�rio - Rotina gEspI002  ���    
���                                                    - Rotina gEspI013  ���    
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp064()  // Recupera Matr�cula do Usu�rio
                                                  
gcMatUsu := ""  // Matr�cula do Usu�rio

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
				gcMatUsu := ZZE->ZZE_MATUSU  // matr�cula do usu�rio
			EndIf

			TMP->(DbCloseArea())	
		EndIf	
		
		If Empty(gcMatUsu)  // se matr�cula vazia, pois usu�rio prestador de servi�o
			gcMatUsu := Ret_Matr(SubStr(cUsuario,7,15))  // fun��o que retorna a matr�cula do usu�rio
		EndIf

    Else
		cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
		cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "					
		cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And " 
///		cQuery += "             ZZE.ZZE_CDSOL  = '" + M->ZZE_CDSOL   + "' And "    
		cQuery += "             ZZE.ZZE_CDUSU  = '" + M->ZZE_CDUSU   + "' And "    		
		cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

		TCQUERY cQuery Alias TMP NEW                                      

		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
			gcMatUsu := ZZE->ZZE_MATUSU  // matr�cula do usu�rio
		EndIf

		TMP->(DbCloseArea())	
    
		If Empty(gcMatUsu)  // se matr�cula vazia, pois usu�rio prestador de servi�o                
			gcMatUsu := Ret_Matr(M->ZZE_IDUSU)  // fun��o que retorna a matr�cula do usu�rio		
		EndIf
		
	EndIf

Else
	gcMatUsu := Ret_Matr(SubStr(cUsuario,7,15))  // fun��o que retorna a matr�cula do usu�rio
EndIf
                                     
If Empty(gcMatUsu)  // se matr�cula vazia, pois usu�rio prestador de servi�o
	gcMatUsu = "******"  // grava falsa matr�cula em mem�ria pois campo obrigat�rio
EndIf

Return gcMatUsu  // retorno da fun��o
****************************************************************************************************************************************************

Static Function Ret_Matr(_gCdUsu)  // fun��o que retorna a matr�cula do usu�rio
// _gCdUsu => C�digo do usu�rio

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

	cQuery += "Select SRA.RA_MAT As MATRICULA "
	cQuery += "  FROM SRA" + SM0->M0_CODIGO + "0 SRA "					
	cQuery += " Where SRA.RA_IDUSU   = '" + _gCdUsu        + "' And "    
	cQuery += "       SRA.RA_SITFOLH = ' '                      And "      						
	cQuery += "       SRA.D_E_L_E_T_ = ' '                          "

	cEmpAnt := SM0->M0_CODIGO  // pega empresa
	
	SM0->(DbSkip())  // incrementa contador de registro
	
	If !SM0->(Eof())
		cQuery += "Union                                                       "	
	EndIf                    
	
EndDo
cQuery += "Order By SRA.RA_MAT "

TCQUERY cQuery Alias TMP NEW                                      

_cMatricula := TMP->MATRICULA  // Matr�cula
	
TMP->(DbCloseArea())			
                                                                       
Return _cMatricula  // retorno da fun��o