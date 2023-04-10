/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gCEsp003 ³ Autor ³ George AC Gonçalves  ³ Data ³ 19/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gCEsp003 ³ Autor ³ George AC Gonçalves  ³ Data ³ 19/01/09  ³±±
±±³          ³ gMarcaS  ³ Autor ³ George AC Gonçalves  ³ Data ³ 19/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Consulta das semanas - Rotina gCADZZG                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Digitação * no código da semana                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#INCLUDE "RWMAKE.CH"

User Function gCEsp003()  // Consulta das semanas

Local cArea    := GetArea()
 
// É necessário utilizar esta variável para a marcação ser feita com um x gráfico                     
Private cMarca    := GetMark()                             
Private lInverte  := .F.
Private aRotina   := {}
Private cCadastro := "Seleção das Semanas"
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

DbSelectArea("gTEMP")  // seleciona arquivo emporário
gTEMP->(DbGoTop())  // vai para o início do arquivo

MarkBrowse("gTEMP", "MARCA",, aCampos, lInverte, cMarca)

gTEMP->(DbCloseArea())    

RestArea(cArea)        

Return gcSemana  // retorno da função
***************************************************************************************************************************************************

User Function gMarcaS()  // Seleciona empresas

DbSelectArea("gTEMP")  // seleciona arquivo emporário
gTEMP->(DbGoTop())  // vai para o início do arquivo
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

Return  // retorno da função