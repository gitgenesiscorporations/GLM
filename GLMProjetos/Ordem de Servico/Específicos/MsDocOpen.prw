#include "rwMake.ch"
#include "TopConn.CH"
#include 'MsOle.ch'
#INCLUDE "PROTHEUS.CH"

User Function MsDocOpen()
             
///Local cFileName := "E:\GLM\GLMProtheus\Protheus11\TESTE\Protheus_Data\spool\Solicitação de Alteração do Produto - GLM 2014000002.docx" 
///Local cFileName := "G:\GLMProtheus\Protheus11\TESTE\Protheus_Data\spool\Solicitação de Alteração do Produto - GLM 2014000002.docx" 
                                  
DbSelectArea("SB1")
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+"1000SV0000001"))

cPatchName := "\\192.168.0.23\Glm\GLMProtheus\Protheus11\TESTE\Protheus_Data\spool\"                                         
cFileName  := SB1->B1_CODBAR


// usando OLE_PrintFile
hWord := OLE_CreateLink()
OLE_SetPropertie( hWord, oleWdPrintBack, .F.)
OLE_SetPropertie( hWord, oleWdVisible, .F.)
OLE_NewFile(hWord, cPatchName+cFileName)
OLE_PrintFile( hWord, "ALL", , , 1)
OLE_CloseFile( hWord )
OLE_CloseLink( hWord )


Return( .T. )