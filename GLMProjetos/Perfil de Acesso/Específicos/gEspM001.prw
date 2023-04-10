/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspM001 � Autor � George AC. Gon�alves � Data � 01/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspM001 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
���          � gEspL001 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o na Solicita��o de Perfil de Acesso              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspM001()  // Manuten��o na Solicita��o de Perfil de Acesso

Private cCadastro := "Manuten��o na Solicita��o de Perfil de Acesso"  // define t�tulo da tela

// monta array com op��es de menu
aRotina := {{ "Pesquisar" , "AxPesqui"                     , 0, 1    },;
      		{ "Visualizar", 'EXECBLOCK("gEspV001",.F.,.F.)', 0, 2    },;      		
      		{ "Solicitar" , 'EXECBLOCK("gEspI001",.F.,.F.)', 0, 3, 20},;      		      		
            { "Legenda"   , 'U_gEspL001'                   , 0, 8    }}
     		
aCores := {{"ZZE->ZZE_STATUS='1'", 'BR_VERDE'   },;           
           {"ZZE->ZZE_STATUS='2'", 'BR_AZUL'    },;           
           {"ZZE->ZZE_STATUS='3'", 'BR_VERMELHO'}}

DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
      		
ZZE->(DbSetFilter({||(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))))},'(AllTrim(Upper(ZZE->ZZE_IDUSUS))==AllTrim(Upper(SubStr(cUsuario,7,15))))'))   
		        	             
mBrowse(6, 1, 22, 75, "ZZE" , , , , , , aCores)  // montagem do browse            

ZZE->(DbClearFilter()) // Limpa o filtro 
  
Return .T.  // retorno da fun��o                                           
***************************************************************************************************************************************************

User Function gEspL001(cAlias, nReg, nOpc)  // legenda
                 
BrwLegenda(OemToAnsi("Solicita��o de Perfil de Acesso"),;
                     "Legenda",;
                     {{"BR_VERDE"   ,"Em Aberto"           },;
                      {"BR_AZUL"    ,"Aguardando Aprova��o"},;                         
                      {"BR_VERMELHO","Encerrada"           }})                                                                                                      

Return NIL  // retorno da fun��o