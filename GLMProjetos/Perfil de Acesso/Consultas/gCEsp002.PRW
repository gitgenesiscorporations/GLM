/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gCEsp002 � Autor � George AC Gon�alves  � Data � 05/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gCEsp002 � Autor � George AC Gon�alves  � Data � 05/01/09  ���
���          � gMarcaM  � Autor � George AC Gon�alves  � Data � 05/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta das empresas - Rotina gEspI001                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o * no c�digo da empresa                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#INCLUDE "RWMAKE.CH"

User Function gCEsp002()  // Consulta das empresas

Local cArea    := GetArea()
Local cAreaSM0 := SM0->(GetArea())
 
Private wGaRotina    := aRotina
Private wGcCadastro  := cCadastro

// � necess�rio utilizar esta vari�vel para a marca��o ser feita com um x gr�fico                     
Private cMarca     := GetMark()                             
Private lInverte   := .F.
Private aRotina    := {}
Private cCadastro  := "Sele��o de Empresas"

Public gcEmpsFils := ""
Public cOldEmpFis := M->ZZE_EMP  // empresa/filial em mem�ria

// Estrutura Arquivo Temporario
cEstrutura := {{"MARCA"  , "C", 02, 0},;
               {"EMPRESA", "C", 02, 0},;    
               {"FILIAL" , "C", 02, 0},; 
               {"NOME"   , "C", 40, 0}}            

// Estrutura para montagem do browse              
aCampos := {}
AAdd(aCampos, {"MARCA"  , "", ""            , ""  })
AAdd(aCampos, {"EMPRESA", "", "Empresa"     , "99"})  
AAdd(aCampos, {"FILIAL" , "", "Filial"      , "99"})  
AAdd(aCampos, {"NOME"   , "", "Raz�o Social", "@!"})

// Cria Nome e Arquivos Temporarios
Private aRotina := {{'OK', 'U_gMarcaM()', 0, 1}}

// Cria e abre Arquivo Temporario 
cArqTrab := CriaTrab(cEstrutura,.T.)  
DBUSEAREA(.T.,,cArqTrab,"gTEMP",.T.)                  
Index on EMPRESA+FILIAL to (cArqTrab) 

DbSelectArea("SM0")  // seleciona arquivo de empresa/filial
SM0->(DbSetorder(1))  // muda ordem do �ndice
SM0->(DbGoTop())  // vai para o in�cio do arquivo
Do While SM0->(!Eof())  // percorre o arquivo no intervalo
	RecLock("gTEMP",.T.)                         // se bloquear registro      
	If SM0->M0_CODIGO+SM0->M0_CODFIL $ cOldEmpFis  // se empresa selecionada          
		Replace gTEMP->MARCA With "Vj"           // Marca
	EndIf	   
	Replace gTEMP->EMPRESA With SM0->M0_CODIGO   // empresa
	Replace gTEMP->FILIAL  With SM0->M0_CODFIL   // filial
	Replace gTEMP->NOME    With SM0->M0_NOMECOM  // raz�o social
	MsUnLock()                                   // libera registro bloqueado
	SM0->(DbSkip())  // incrementa contador de registro
EndDo   

DbSelectArea("gTEMP")  // seleciona arquivo empor�rio
gTEMP->(DbGoTop())  // vai para o in�cio do arquivo

MarkBrowse("gTEMP", "MARCA",, aCampos, lInverte, cMarca)

gTEMP->(DbCloseArea())    
        
aRotina   := wGaRotina
cCadastro := wGcCadastro
INCLUI    := .T.

SM0->(RestArea(cAreaSM0))
RestArea(cArea)        

Return .T.  // retorno da fun��o
***************************************************************************************************************************************************

User Function gMarcaM()  // Seleciona empresas

DbSelectArea("gTEMP")  // seleciona arquivo empor�rio
gTEMP->(DbGoTop())  // vai para o in�cio do arquivo
Do While gTEMP->(!Eof())  // percorre todo o arquivo
	If Marked("MARCA")  // se documento marcado
		gcEmpsFils := gcEmpsFils + "," + gTEMP->EMPRESA+gTEMP->FILIAL 
	EndIf
	gTEMP->(Dbskip())  // incrementa contador de registro
Enddo   

If !Empty(gcEmpsFils)  // se existir empresa/filial selecionada
	gcEmpsFils := SubStr(gcEmpsFils,2,Len(gcEmpsFils)-1)
EndIf	

CloseBrowse()  // fecha markbrowse

Return  // retorno da fun��o