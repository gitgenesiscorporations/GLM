/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspT003 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspT003 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa atualiza��o(EXC) de perfil de acesso (Grupo)      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada ap�s a exclus�o do m�dulo/perfil - Rotina: gCADZZC ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspT003()  // Processa atualiza��o (exclus�o) de perfil de acesso (Grupo)

Local cPswFile  := "SIGAPSS.SPF"
Local nRet      := 0
               
//Abro a Tabela de Senhas
SPF_CanOpen(cPswFile) 

// aReturn[1] => array com dados do grupo
g1_cIdGrupo := ZZC->ZZC_CDMOD+ZZC->ZZC_CDPERF  // [01]-ID do grupo

// posiciona registro de grupi - Chave 1G
nRet := SPF_Seek(cPswFile,"1G"+g1_cIdGrupo,1)

If nRet > 0  // se encontrar ID do usu�rio

     //Excluindo o grupo
     SPF_Delete(cPswFile,nRet)
     
EndIf

Return  // retorno da fun��o