/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gCEsp001 � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gCEsp001 � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � F3 - Consulta dos m�dulos do Protheus - Rotina gCADZZJ     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o F3 no c�digo do m�dulo                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function gCEsp001()  // Consulta m�dulo

Local aArea := GetArea()

Public gcModulo     := "" 
Public gcDescModulo := ""
Public aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

Private aMod := ARRAY(Len(aDescModulos))               
Private nMod := 0

Private oDlg1

For gN := 1 To Len(aDescModulos)
	aMOD[gN] := aDescModulos[gN][3]  // recupera o c�digo
Next

ASORT(aMOD,,, { |x, y| UPPER(x) < UPPER(y) })

DEFINE MSDIALOG oDlg1 TITLE "Consulta Padr�o - M�dulos" FROM 050,050 To 400,750 OF oMainWnd PIXEL
@ 005,005 ListBox nMod Items aMod Size 300,165 Object oSource
@ 132,308 BUTTON "Ok"       SIZE 40,15 ACTION (Processa({||g_OK()}), oDlg1:End()) PIXEL OF oDlg1
@ 152,308 BUTTON "Cancelar" SIZE 40,15 ACTION (oDlg1:End()) PIXEL OF oDlg1

ACTIVATE MSDIALOG oDlg1 CENTER

RestArea(aArea)  // restaura �rea atual

Return .T.  // retorno da fun��o
***************************************************************************************************************************************************

Static Function g_OK()  // retorno OK

gcModulo     := StrZero(Ascan(aDescModulos,{|X| X[3] = aMod[nMod]}),2)  // recupera c�digo do m�dulo  
gcDescModulo := aMod[nMod]                                              // recupera descri��o do m�dulo

Return  // retorno da fun��o