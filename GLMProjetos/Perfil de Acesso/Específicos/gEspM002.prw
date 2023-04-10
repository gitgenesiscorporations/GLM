/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspM002 � Autor � George AC. Gon�alves � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspM002 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Aprova��o da Solicita��o de Perfil de Acesso - Gestores    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspM002()  // Aprova��o da Solicita��o de Perfil de Acesso - Gestores

Private cCadastro := "Aprova��o da Solicita��o de Perfil de Acesso - Gestores"  // define t�tulo da tela

// monta array com op��es de menu
aRotina := {{ "Pesquisar" , "AxPesqui"                     , 0, 1    },;
      		{ "Visualizar", 'EXECBLOCK("gEspV001",.F.,.F.)', 0, 2    },;      		
      		{ "Aprovar"   , 'EXECBLOCK("gEspA001",.F.,.F.)', 0, 3, 20}}
                      
DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do �ndice

///ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG))},'(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG))'))         		
ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG).And.ZZF->ZZF_TIPO<>"3".And.ZZF->ZZF_TIPO<>"4")},'(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG)).And.ZZF->ZZF_TIPO<>"3".And.ZZF->ZZF_TIPO<>"4"'))   
		        	             
mBrowse(6, 1, 22, 75, "ZZF" )  // montagem do browse            

ZZF->(DbClearFilter()) // Limpa o filtro 
  
Return .T.  // retorno da fun��o                                           