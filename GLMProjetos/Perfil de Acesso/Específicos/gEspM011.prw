/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspM011 � Autor � George AC. Gon�alves � Data � 22/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspM011 � Autor � George AC. Gon�alves � Data � 22/05/09  ���
���          � gEspL001 � Autor � George AC. Gon�alves � Data � 22/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o na Consulta de Status da Solicita��o de Acesso  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspM011()  // Manuten��o na Consulta de Status da Solicta��o de Acesso

Private cCadastro := "Manuten��o na Consulta de Status da Solicita��o de Acesso"  // define t�tulo da tela

// monta array com op��es de menu
aRotina := {{ "Pesquisar" , "AxPesqui"                     , 0, 1    },;
      		{ "Visualizar", 'EXECBLOCK("gEspV001",.F.,.F.)', 0, 2    },;      		
            { "Legenda"   , 'U_gEspL001'                   , 0, 8    }}
     		
aCores := {{"ZZE->ZZE_STATUS='1'", 'BR_VERDE'   },;           
           {"ZZE->ZZE_STATUS='2'", 'BR_AZUL'    },;           
           {"ZZE->ZZE_STATUS='3'", 'BR_VERMELHO'}}

mBrowse(6, 1, 22, 75, "ZZE" , , , , , , aCores)  // montagem do browse            
  
Return .T.  // retorno da fun��o                                           