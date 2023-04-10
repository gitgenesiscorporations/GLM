/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspP002 � Autor � George AC. Gon�alves � Data � 23/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspP002 � Autor � George AC. Gon�alves � Data � 23/05/09  ���
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

User Function gEspP002(gcNumSol,gcOpc)  // Processa atualiza��o de usu�rio/perfil
// gcNumSol = N�mero da solicita��o  
// gcOpc    = identifica op��o para grava��o
//            "B" = Bloqueio de usu�rio
//            "S" = Reinicia senha   
//            "D" = Desbloqueio de usu�rio

lRet := .T.  // retorno da fun��o

DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
If ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // posiciona registro
	U_gEspT004(gcOpc)  // chamada a fun��o que processa atualiza��o de usu�rio/perfil
EndIf

Return  // retorno da fun��o                                                            