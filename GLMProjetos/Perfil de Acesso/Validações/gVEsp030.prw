/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp030 � Autor � George AC Gon�alves  � Data � 28/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp030 � Autor � George AC Gon�alves  � Data � 28/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Empresas Selecionadas                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo Empresas - Rotina gEspI002              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp030()  // Exibe Empresas Selecionadas

gcEmpresas := ""  // Retorna o empresas selecionadas

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	PSWORDER(1)  // muda ordem de �ndice
	If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()
		For gLn := 1 To Len(aArray[2][6])
			gcEmpresas += aArray[2][6][gLn]+","  // Retorna as empresas selecionadas
		Next
		gcEmpresas := SubStr(gcEmpresas,1,Len(gcEmpresas)-1)		
	EndIf
EndIf

Return gcEmpresas  // retorno da fun��o