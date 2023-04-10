/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp036 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp036 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Vinculo Funcional                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo vinculo funcional - Rotina gEspI013     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp036()  // Exibe vinculo funcional

gcVincFunc := ""  // Retorna o vinculo funcional

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
			gcVincFunc := ZZE->ZZE_VFUNC  // vinculo funcional
		EndIf

		TMP->(DbCloseArea())	
		
		If Empty(gcVincFunc)  // se vinculo n�o preenchido
			_cMat := Ret_Matr()  // fun��o que retorna a matr�cula do usu�rio		
	
			If !Empty(_cMat)  // se matr�cula preenchido			
				gcVincFunc := "1"
			Else	             
				gcVincFunc := "2"			
			EndIf	
		EndIf
		
	EndIf
		
EndIf

Return gcVincFunc  // retorno da fun��o
****************************************************************************************************************************************************

Static Function Ret_Matr()  // fun��o que retorna a matr�cula do usu�rio

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
	cQuery += " Where SRA.RA_IDUSU   = '" + SubStr(cUsuario,7,15) + "' And "    
	cQuery += "       SRA.RA_SITFOLH = ' '                             And "      						
	cQuery += "       SRA.D_E_L_E_T_ = ' '                                 "
	      
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