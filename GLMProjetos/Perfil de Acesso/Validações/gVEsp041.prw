/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp041 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp041 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe descri��o cargo/fun��o                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo descri��o cargo/fun��o - Rotina gEspI013���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp041()  // Exibe descri��o do cargo/fun��o

gcDsCarg := ""  // Retorna a descri��o do cargo/fun��o

///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcDsCarg := Replicate("*",30)  // Retorna a descri��o do cargo/fun��o
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
		gcDsCarg := ZZE->ZZE_DSFUNU  // descri��o do cargo/fun��o
	EndIf

	TMP->(DbCloseArea())	
	
	If Empty(gcDsCarg)  // se descri��o do cargo/fun��o vazio
		DbSelectArea("SRJ")  // seleciona arquivo de cargo/fun��o
		SRJ->(DbSetOrder(1))  // muda ordem do �ndice
		If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNU))  // posiciona registro
			gcDsCarg := SRJ->RJ_DESC  // descri��o do cargo/fun��o
		EndIf			
	EndIf
				
EndIf

If Empty(gcDsCarg)  // se descri��o do cargo/fun��o vazio
	gcDsCarg := Replicate("*",30)  // Retorna a descri��o do cargo/fun��o do usu�rio solicitante
EndIf

Return gcDsCarg  // retorno da fun��o