/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspP001 � Autor � George AC. Gon�alves � Data � 06/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspP001 � Autor � George AC. Gon�alves � Data � 30/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa atualiza��o de usu�rio/perfil                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � rotina executada atrav�s de schedule                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspP001(gcNumSol)  // Processa atualiza��o de usu�rio/perfil
// gcNumSol = N�mero da solicita��o

DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
If ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // posiciona registro
	If ZZE->ZZE_STATUS <> "2"  // se status da solicita��o ainda n�o aprovada
		MsgStop("Solicita��o ainda n�o enviada ao Gestor do M�dulo","Aten��o")				
	Endif                                        

	ZZF->(DbClearFilter()) // Limpa o filtro 	
	U_gEspT001()  // chamada a fun��o que processa atualiza��o de usu�rio/perfil
	ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   		
	
EndIf

Return  // retorno da fun��o                                                            