/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp047 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp047 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe c�digo do departamento do usu�rio                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo c�d. depto. usu�rio - Rotina gEspI013   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp047()  // Exibe c�digo do departamento do usu�rio

gcCdDepto := ""  // Retorna o c�digo do departamento do usu�rio

///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcCdDepto := Replicate("*",2)  // Retorna o c�digo do departamento do usu�rio

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
			gcCdDepto := ZZE->ZZE_CDDEPU  // c�digo do departamento do usu�rio
		EndIf

		TMP->(DbCloseArea())	
		                                   
		If Empty(gcCdDepto)  // se c�digo do departamento vazio			
		   gcCdDepto := Ret_CD_CC(SubStr(cUsuario,7,15))  // fun��o que retorna o c�digo do centro de custo			
		EndIf
					
	Else
///		gcCdDepto := M->ZZE_CDDEPT
		If M->ZZE_CDDEPT <> "**"        
			gcCdDepto := Ret_CD_CC(M->ZZE_IDUSU)  // fun��o que retorna o c�digo do centro de custo			
		EndIf
	EndIf

	If Empty(gcCdDepto)  // se c�digo do departamento vazio
		gcCdDepto := Replicate("*",2)  // Retorna o c�digo do departamento do usu�rio solicitante
	EndIf
		
///EndIf

Return gcCdDepto  // retorno da fun��o
****************************************************************************************************************************************************

Static Function Ret_CD_CC(_gCdUsu)  // fun��o que retorna o c�digo do centro de custo
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

	cQuery += "Select SRA.RA_CC As CC "
	cQuery += "  FROM SRA" + SM0->M0_CODIGO + "0 SRA "					
	cQuery += " Where SRA.RA_IDUSU   = '" + _gCdUsu + "' And "    	
	cQuery += "       SRA.RA_SITFOLH = ' '               And "      						
	cQuery += "       SRA.D_E_L_E_T_ = ' '                   "
	      
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