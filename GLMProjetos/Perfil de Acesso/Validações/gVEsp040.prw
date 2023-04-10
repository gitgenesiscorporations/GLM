/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp040 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp040 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe c�digo cargo/fun��o                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo c�digo do cargo/fun��o - Rotina gEspI013���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp040()  // Exibe c�digo do cargo/fun��o

gcCdCarg := ""  // Retorna o c�digo do cargo/fun��o

///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcCdCarg := Replicate("*",2)  // Retorna o c�digo do cargo/fun��o
///EndIf	

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
		gcCdCarg := ZZE->ZZE_CDFUNU  // c�digo do cargo/fun��o
	EndIf

	TMP->(DbCloseArea())	
	
	If Empty(gcCdCarg)  // se c�digo do cargo/fun��o vazio			
		gcCdCarg := Ret_CD_Cargo()  // fun��o que retorna o c�digo do cargo/fun��o			
	EndIf
	
EndIf

If Empty(gcCdCarg)  // se c�digo do cargo/fun��o vazio
	gcCdCarg := Replicate("*",2)  // Retorna o c�digo do cargo/fun��o do usu�rio solicitante
EndIf

Return gcCdCarg  // retorno da fun��o
****************************************************************************************************************************************************

Static Function Ret_CD_Cargo()  // fun��o que retorna o c�digo do cargo/fun��o

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

	cQuery += "Select SRA.RA_CODFUNC As CARGO "
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
cQuery += "Order By SRA.RA_CODFUNC "

TCQUERY cQuery Alias TMP NEW                                      

_cCC := TMP->CARGO  // cargo
	
TMP->(DbCloseArea())			
                                                                       
Return _cCC  // retorno da fun��o