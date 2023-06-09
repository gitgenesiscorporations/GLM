/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gCEsp003 � Autor � George AC Gon�alves  � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gCEsp003 � Autor � George AC Gon�alves  � Data � 19/01/09  ���
���          � gMarcaS  � Autor � George AC Gon�alves  � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta das semanas - Rotina gCADZZG                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o * no c�digo da semana                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#INCLUDE "RWMAKE.CH"

User Function gCEsp003()  // Consulta das semanas

Local cArea    := GetArea()
 
// � necess�rio utilizar esta vari�vel para a marca��o ser feita com um x gr�fico                     
Private cMarca    := GetMark()                             
Private lInverte  := .F.
Private aRotina   := {}
Private cCadastro := "Sele��o das Semanas"
Private gcSemana  := ""

// Estrutura Arquivo Temporario
cEstrutura := {{"MARCA" , "C", 02, 0},;
               {"SEMANA", "C", 03, 0}}            

// Estrutura para montagem do browse              
aCampos := {}
AAdd(aCampos, {"MARCA" , "", ""      , ""  })
AAdd(aCampos, {"SEMANA", "", "Semana", "@!"})  

// Cria Nome e Arquivos Temporarios
Private aRotina := {{'OK', 'U_gMarcaS()', 0, 1}}

// Cria e abre Arquivo Temporario 
cArqTrab := CriaTrab(cEstrutura,.T.)  
DBUSEAREA(.T.,,cArqTrab,"gTEMP",.T.)                  
Index on SEMANA to (cArqTrab) 

For gLn := 1 To 4  // grava as 4 semanas
	RecLock("gTEMP",.T.)                            // se bloquear registro      
	Replace gTEMP->SEMANA With StrZero(gLn,1)+"a."  // semana
	MsUnLock()                                      // libera registro bloqueado
Next	

DbSelectArea("gTEMP")  // seleciona arquivo empor�rio
gTEMP->(DbGoTop())  // vai para o in�cio do arquivo

MarkBrowse("gTEMP", "MARCA",, aCampos, lInverte, cMarca)

gTEMP->(DbCloseArea())    

RestArea(cArea)        

Return gcSemana  // retorno da fun��o
***************************************************************************************************************************************************

User Function gMarcaS()  // Seleciona empresas

DbSelectArea("gTEMP")  // seleciona arquivo empor�rio
gTEMP->(DbGoTop())  // vai para o in�cio do arquivo
Do While gTEMP->(!Eof())  // percorre todo o arquivo
	If Marked("MARCA")  // se documento marcado
		gcSemana := gcSemana + "," + SubStr(gTEMP->SEMANA,1,1)
	EndIf
	gTEMP->(Dbskip())  // incrementa contador de registro
Enddo   

If !Empty(gcSemana)  // se existir semana selecionada
	gcSemana := SubStr(gcSemana,2,Len(gcSemana)-1)
EndIf	

CloseBrowse()  // fecha markbrowse

Return  // retorno da fun��o