/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp007 � Autor � George AC Gon�alves  � Data � 05/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp007 � Autor � George AC Gon�alves  � Data � 05/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida exist�ncia de usu�rio                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do nome do usu�rio - Rotina gEspI001             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp007(cFlag)  // Valida exist�ncia de usu�rio
//cFlag = identifica��o do processo:
//	      1 = executa �dentifica��o de usu�rio hom�nimo
//		  2 = n�o executa �dentifica��o de usu�rio hom�nimo

Local lRet := .T.  // retorno da fun��o       
                                                                 
Private mv_par01 := ""                      // C�digo de Usu�rio Inicial	    
Private mv_par02 := "999999"                // C�digo de Usu�rio Final
Private mv_par03 := ""                      // Departamento Inicial
Private mv_par04 := "ZZZZZZZZZZZZZZZZZZZZ"  // Departamento Final
Private mv_par05 := ""                      // Cargo/Fun��o Inicial
Private mv_par06 := "ZZZZZZZZZZZZZZZZZZZZ"  // Cargo/Fun��o Final
Private mv_par07 := ""                      // Superior Inicial
Private mv_par08 := "ZZZZZZZZZZZZZZZZZZZZ"  // Superior Final
Private mv_par09 := ""                      // Perfil de Acesso Inicial
Private mv_par10 := "ZZZZZZZZZZZZZZZZZZZZ"  // Perfil de Acesso Final
Private mv_par11 := "3"                     // Status Usu�rio

Public gFlagParam := .F.  // determina sele��o de par�metros: .T. = seleciona, .F. = n�o seleciona

aUsers := AllUsers(.T.)  // array com dados do usu�rio

If cFlag == "1"  // se executa �dentifica��o de usu�rio hom�nimo
	For lN := 1 To Len(aUsers)  // percorre arquivo de usu�rios
		If Upper(AllTrim(aUsers[lN][1][4])) == Upper(AllTrim(M->ZZE_NMUSU))  // verifica exist�ncia do usu�rio
			nOp := Aviso("Aten��o","J� existe um usu�rio cadastrado com este nome. O que deseja fazer ?",{"Verificar","Confirmar","Cancelar"})
			If nOp == 1  // Verificar perfil do usu�rio
				mv_par01 := aUsers[lN][1][1]  // C�digo de Usu�rio Inicial	    
				mv_par02 := aUsers[lN][1][1]  // C�digo de Usu�rio Final	    
				U_gEspR001()  // Relat�rio de Perfil de Acesso por Usu�rio			
				If Aviso("Aten��o","Mant�m o nome do usu�rio como hom�nimo ?",{"Sim","N�o"}) == 2  // se n�o aceitar o nome do usu�rio
					lRet := .F.  // retorno da fun��o
					Exit  // aborta opera��o			
				EndIf
			ElseIf nOp == 2  // Confirma nome do usu�rio
				Exit  // aborta opera��o		
			Else  // N�o aceita o nome do usu�rio
				lRet := .F.  // retorno da fun��o
				Exit  // aborta opera��o
			EndIf
		EndIf
	Next
ElseIf cFlag == "2"  // se n�o executa �dentifica��o de usu�rio hom�nimo	
	lRet := .F.  // retorno da fun��o
	For lN := 1 To Len(aUsers)  // percorre arquivo de usu�rios
		If Upper(AllTrim(aUsers[lN][1][4])) == Upper(AllTrim(M->ZZE_NMUSU))  // verifica exist�ncia do usu�rio
			lRet := .T.  // retorno da fun��o	
		EndIf	
	Next	
EndIf

Return lRet   // retorno da fun��o