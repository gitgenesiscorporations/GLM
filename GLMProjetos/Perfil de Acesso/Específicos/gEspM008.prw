/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspM008 � Autor � George AC. Gon�alves � Data � 22/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspM008 � Autor � George AC. Gon�alves � Data � 22/05/09  ���
���          � gEspL001 � Autor � George AC. Gon�alves � Data � 22/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o no Bloqueio de Usu�rio                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspM008()  // Manuten��o no Bloqueio de Usu�rio

Private cCadastro := "Manuten��o no Bloqueio de Usu�rio"  // define t�tulo da tela

// monta array com op��es de menu
aRotina := {{ "Pesquisar" , "AxPesqui"                     , 0, 1    },;
      		{ "Visualizar", 'EXECBLOCK("gEspV001",.F.,.F.)', 0, 2    },;      		
      		{ "Solicitar" , 'EXECBLOCK("gEspI006",.F.,.F.)', 0, 3, 20},;      		      		
            { "Legenda"   , 'U_gEspL001'                   , 0, 8    }}
     		
aCores := {{"ZZE->ZZE_STATUS='1'", 'BR_VERDE'   },;           
           {"ZZE->ZZE_STATUS='2'", 'BR_AZUL'    },;           
           {"ZZE->ZZE_STATUS='3'", 'BR_VERMELHO'}}

DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
      		
///ZZE->(DbSetFilter({||(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))))},'(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))))'))   
ZZE->(DbSetFilter({||(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))).Or.AllTrim(Upper(ZZE->ZZE_IDUSU))==AllTrim(Upper(SubStr(cUsuario,7,15))))},'(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))).Or.AllTrim(Upper(ZZE->ZZE_IDUSU))==AllTrim(Upper(SubStr(cUsuario,7,15))))'))   
		        	             
mBrowse(6, 1, 22, 75, "ZZE" , , , , , , aCores)  // montagem do browse            

ZZE->(DbClearFilter()) // Limpa o filtro 
  
Return .T.  // retorno da fun��o                                           