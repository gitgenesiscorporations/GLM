/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � mhB Sistemas Ltda.                                         ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gCADZZC � Autor � George A.C. Gon�alves � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gCADZZC � Autor � George A.C. Gon�alves � Data � 10/12/08  ���
���          � gINCZZC � Autor � George A.C. Gon�alves � Data � 11/01/09  ���
���          � gEXCZZC � Autor � George A.C. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o no cadastro de m�dulo/perfil de acesso          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gCADZZC()  // Manuten��o no cadastro de m�dulo/perfil de acesso

AxCadastro("ZZC","Manuten��o no cadastro de m�dulo/perfil de acesso","U_gEXCZZC()","U_gINCZZC()")  // chamada a fun��o de Manuten��o no cadastro de m�dulo/perfil de acesso

Return  // retorno da fun��o
***************************************************************************************************************************************************

User Function gINCZZC()  // valida��o inclus�o do m�dulo/perfil de acesso

lRet := .T.  // retorno da fun��o

U_gEspT002()  // chamada a fun��o que processa atualiza��o de perfil de acesso (Grupo)

Return lRet  // retorno da fun��o
***************************************************************************************************************************************************

User Function gEXCZZC()  // valida��o exclus�o do m�dulo/perfil de acesso

lRet := .T.  // retorno da fun��o                                                     

U_gEspT003()  // chamada a fun��o que processa atualiza��o de perfil de acesso (Grupo)

Return lRet  // retorno da fun��o