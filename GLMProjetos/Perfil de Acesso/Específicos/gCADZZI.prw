/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gCADZZI � Autor � George A.C. Gon�alves � Data � 30/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gCADZZI � Autor � George A.C. Gon�alves � Data � 30/12/08  ���
���          � gVALZZI � Autor � George A.C. Gon�alves � Data � 30/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o no cadastro de aprovadores (Gestor/Controller)  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gCADZZI()  // Manuten��o no cadastro de aprovadores (Gestor/Controller)                                            

AxCadastro("ZZI","Manuten��o no cadastro de aprovadores (Gestor/Controller)",".T.","U_gVALZZI()")  // chamada a fun��o de Manuten��o no cadastro de aprovadores (Gestor/Controller)

Return  // retorno da fun��o                                                                   
***************************************************************************************************************************************************

User Function gVALZZI()  // valida��o grava��o de aprovadores

lRet := .T.  // retorno da fun��o

If M->ZZI_TIPO <> "1"  // verifica se j� informado controller para a empresa                
	cQuery := "    SELECT COUNT(*) AS QTD_TIPO "
	cQuery += "      FROM " + RetSqlname("ZZI") + " ZZI "
	cQuery += "     WHERE ZZI.ZZI_FILIAL = '" + xFilial("ZZI") + "' And " 
	cQuery += "           ZZI.ZZI_TIPO  <> '1'                      And "    
	cQuery += "           ZZI.D_E_L_E_T_ = ' '                          "
                                
	TCQUERY cQuery Alias TMP NEW                                      

	If INCLUI == .T. .And. TMP->QTD_TIPO > 0  // se existir tipo controller
		lRet := .F.  // retorno da fun��o
		MsgStop("J� existe Controller registrado.","Aten��o")			
	EndIf
	
	If ALTERA == .T. .And. ZZI->ZZI_TIPO <> M->ZZI_TIPO  // se empresa modificada
		If TMP->QTD_TIPO > 0  // se existir tipo controller
			lRet := .F.  // retorno da fun��o
			MsgStop("J� existe Controller registrado.","Aten��o")			
		EndIf
	EndIf

	TMP->(DbCloseArea())	
	
EndIf

Return lRet  // retorno da fun��o