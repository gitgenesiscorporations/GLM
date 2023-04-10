/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspM003 � Autor � George AC. Gon�alves � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspM003 � Autor � George AC. Gon�alves � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Aprova��o da Solicita��o de Perfil de Acesso - Controller  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspM003()  // Aprova��o da Solicita��o de Perfil de Acesso - Controller

Private cCadastro := "Aprova��o da Solicita��o de Perfil de Acesso - Controller"  // define t�tulo da tela

// monta array com op��es de menu
aRotina := {{ "Pesquisar" , "AxPesqui"                     , 0, 1    },;
      		{ "Visualizar", 'EXECBLOCK("gEspV001",.F.,.F.)', 0, 2    },;      		
      		{ "Aprovar"   , 'EXECBLOCK("gEspA002",.F.,.F.)', 0, 3, 20}}

DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do �ndice
      		
///ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   
ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3".And.ZZF->ZZF_TIPO<>"4")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1".And.ZZF->ZZF_TIPO<>"3".And.ZZF->ZZF_TIPO<>"4")'))   
		        	             
mBrowse(6, 1, 22, 75, "ZZF" )  // montagem do browse            

ZZF->(DbClearFilter()) // Limpa o filtro 
  
Return .T.  // retorno da fun��o         