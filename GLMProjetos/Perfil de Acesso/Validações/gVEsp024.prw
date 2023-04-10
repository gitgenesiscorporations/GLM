/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp024 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp024 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe C�digo do Cargo/Fun��o do Usu�rio                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo c�digo cargo usu�rio - Rotina gEspI002  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp024()  // Exibe C�digo do Cargo/Fun��o do Usu�rio

gcCdCargUsu := ""  // Retorna o C�digo do cargo/fun��o do usu�rio

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
	cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "	
	cQuery += "       Where ZZE.ZZE_FILIAL = ' '                    And "
	cQuery += "             ZZE.ZZE_CDUSU  = '" + M->ZZE_CDUSU + "' And "    
	cQuery += "			    ZZE.D_E_L_E_T_ = ' '                        "

	TCQUERY cQuery Alias TMP NEW                                      

	ZZE->(DbClearFilter()) // Limpa o filtro
	DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
	ZZE->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
		gcCdCargUsu := ZZE->ZZE_CDFUNU  // c�digo do cargo/fun��o do usu�rio
	EndIf
	ZZE->(DbSetFilter({||(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))).Or.AllTrim(Upper(ZZE->ZZE_IDUSU))==AllTrim(Upper(SubStr(cUsuario,7,15))))},'(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))).Or.AllTrim(Upper(ZZE->ZZE_IDUSU))==AllTrim(Upper(SubStr(cUsuario,7,15))))'))	

	TMP->(DbCloseArea())	
EndIf

Return gcCdCargUsu  // retorno da fun��o