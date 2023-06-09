/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � UPDPerfil � Autor � George AC Gon�alves � Data � 04/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � UPDPerfil � Autor � George AC Gon�alves � Data � 04/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria��o da estrutura de dados                              ���
���          � (SX2, SX3, SIX, SX6, SX7, SXA, SXB, SXE, SXF)              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inicializa��o do projeto                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#Include "Ap5Mail.ch"

User Function UPDPerfil()  // Cria��o da estrutura de dados (SX2, SX3, SIX, SX6, SX7, SXA, SXB, SXE, SXF)

Private _lRetOK  // Retorno da fun��o
                                               
// Tratamento para abrir o arquivo SM0 Exclusivo
If !OpenSM0Exc()  // Chamada a fun��o para Efetuar a abertura do SM0 exclusivo
	Return
EndIf

RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)  // Abre ambiente da empresa

// Salva �rea de trabalho dos arquivo abertos
cArea    := GetArea()          
cAreaSX2 := SX2->(GetArea())
cAreaSX3 := SX3->(GetArea())
cAreaSIX := SIX->(GetArea())
cAreaSX6 := SX6->(GetArea())
cAreaSX7 := SX7->(GetArea())
cAreaSXA := SXA->(GetArea())
cAreaSXB := SXB->(GetArea())
///cAreaSXE := SXE->(GetArea())
///cAreaSXF := SXF->(GetArea())                                               

// Chamada a fun��o de sele��o de par�metros/configura��o do m�dulo de perfil de acesso
If ConfigPerfil() == .F.  // Chamada a fun��o de sele��o de par�metros/configura��o do m�dulo de perfil de acesso

	Aviso("Atencao","Configura��o do m�dulo de perfil de acesso foi abortada!", {"Ok"} )			

	Return  // retorno da fun��o
EndIf
                                                                                    
// Tratamento da empresa consolidadora
_cEmpConsol := "99"+"0"  // C�digo da empresa consolidadora
                                      
// Tratamento do arquivo SX2
_SX2 := "SX2"+_cEmpConsol  // Arquivo SX2 da empresa consolidadora

// Array arquivos utilizados no m�dulo de perfil de acesso
_aChave := {}
Aadd(_aChave, {"ZZC","CADASTRO DE MODULO/PERFIL"})       // Cadastro de m�dulo/perfil
Aadd(_aChave, {"ZZD","MODULO/PERFIL CONFLITANTES"})      // Cadastro de m�dulo/perfil conflitantes
Aadd(_aChave, {"ZZE","SOLICITACAO - SOLIC/USUARIO"})     // Cadastro de solicita��o - solicita��o/usu�rio
Aadd(_aChave, {"ZZF","SOLICITACAO - PERFIL DE ACESSO"})  // Cadastro de solicita��o - perfil de acesso
Aadd(_aChave, {"ZZG","MATRIZ DE CAPACITACAO"})           // Cadastro de matriz de capacita��o
Aadd(_aChave, {"ZZH","LOG DE MOVIMENTACAO PERFIL"})      // Cadastro de log de movimenta��o do perfil
Aadd(_aChave, {"ZZI","CADASTRO APROVADORES"})            // Cadastro de aprovadores
Aadd(_aChave, {"ZZJ","CADASTRO DEPARTAMENTO/MODULO"})    // Cadastro de departamento/m�dulo
Aadd(_aChave, {"ZZK","CTRL 1O. ACESSO MODULO CRITICO"})  // Cadastro de controle do 1o. acesso aos m�dulos criticos
Aadd(_aChave, {"ZZY","PERFIL USUARIO"})                  // Arquivo tempor�tio para relat�rio de perfil por usu�rio 
Aadd(_aChave, {"ZZZ","PERFIL DE ACESSO"})                // Arquivo tempor�tio para relat�rio de perfil de acesso
             
// Popula arquivo SX2                                                                                                                 
// Abre arquivo SX2 da Empresa Controladora
DbUseArea(.T.,"TOPCONN",_SX2,"tSX2",.F.,.F.)

DbSelectArea("tSX2")  // seleciona arquivo SX2
RecLock("tSX2",.T.)  // se bloquear registro

For _Ln := 1 To 11
	tSX2->X2_CHAVE   := _aChave[_Ln,1]              // chave do arquivo
	tSX2->X2_PATH    := "\DATA\"                    // patch do arquivo
	tSX2->X2_ARQUIVO := _aChave[_Ln,1]+_cEmpConsol  // nome do arquivo
	tSX2->X2_NOME    := _aChave[_Ln,2]              // descri��o em portugu�s do arquivo
	tSX2->X2_NOMESPA := _aChave[_Ln,2]              // descri��o em espanhol do arquivo
	tSX2->X2_NOMEENG := _aChave[_Ln,2]              // descri��o em ingl�s do arquivo
	tSX2->X2_ROTINA  := ""                          // nome da rotina a ser executada
	tSX2->X2_MODO    := "C"                         // modo de abertura do arquivo [C-Compartilhado,E-Exclusivo) - Filial
	tSX2->X2_MODOUN  := "C"                         // modo de abertura do arquivo [C-Compartilhado,E-Exclusivo) - Unidade de Neg�cio	
	tSX2->X2_MODOEMP := "C"                         // modo de abertura do arquivo [C-Compartilhado,E-Exclusivo) - Empresa
	tSX2->X2_DELET   := 0                           // 
	tSX2->X2_TTS     := ""                          // 
	tSX2->X2_UNICO   := ""                          // �ndice de chave �nica
	tSX2->X2_PYME    := ""                          // 	           
	tSX2->X2_MODULO  := gcCdMod                     // c�digo do m�dulo
	tSX2->X2_DYSPLAY := ""                          // display do �ndice da chave �nica
	tSX2->X2_SYSOBJ  := ""                          // 
	tSX2->X2_USROBJ  := ""                          // 
	tSX2->X2_POSLGT  := ""                          // c�digo do m�dulo	
Next _Ln

MsUnLock()  // libera registro bloqueado
tSX2->(DBCloseArea())  // fecha �rea tempor�ria

///SXF->(RestArea(cAreaSXF))
///SXE->(RestArea(cAreaSXE))
SXB->(RestArea(cAreaSXB))
SXA->(RestArea(cAreaSXA))
SX7->(RestArea(cAreaSX7))
///SX6->(RestArea(cAreaSX6))                  
SIX->(RestArea(cAreaSIX))
SX3->(RestArea(cAreaSX3))
SX2->(RestArea(cAreaSX2))
RestArea(cArea)

Return  // retorno da fun��o
*************************************************************************************************************************************************************

Static Function ConfigPerfil()  // Fun��o de sele��o de par�metros/configura��o do m�dulo de perfil de acesso
           
Private oTela    := Nil
Private oBmp

Private cLabEmpC := "C�digo da Empresa Consolidadora"
Private cGetEmpC := Space(2)
Private oGetEmpC

Private cLabMod  := "C�digo do M�dulo do Perfil de Acesso"                         
Private aGetMod  := {"97-SIGAESP", "98-SIGAESP1","96-SIGAESP2"}
Private cGetMod  := ""
Private oGetMod
               
Private cLabArqA := "Arquivo p/ Aprovadores"
Private cGetArqA := Space(3)
Private oGetArqA
                
Private cLabArqB := "Arquivo p/ Departamento/M�dulo"
Private cGetArqB := Space(3)
Private oGetArqB

Private cLabArqC := "Arquivo p/ M�dulo/Perfil"
Private cGetArqC := Space(3)
Private oGetArqC

Private cLabArqD := "Arquivo p/ M�dulo/Perfil Conflitantes"
Private cGetArqD := Space(3)
Private oGetArqD 

Private cLabArqE := "Arquivo p/ Solicita��o Acesso - Solicita��o/Usu�rio"
Private cGetArqE := Space(3)
Private oGetArqE

Private cLabArqF := "Arquivo p/ Solicita��o Acesso - Perfil de Acesso"
Private cGetArqF := Space(3)
Private oGetArqF

Private cLabArqG := "Arquivo p/ Log de Movimenta��o do Perfil"
Private cGetArqG := Space(3)
Private oGetArqG

Private cLabArqH := "Arquivo p/ Controle do 1o. Acesso aos M�dulos Criticos"
Private cGetArqH := Space(3)
Private oGetArqH

Private cLabArqI := "Arquivo p/ Matriz de Capacita��o"
Private cGetArqI := Space(3)
Private oGetArqI

Private cLabArqJ := "Arquivo Tempor�rio p/ Relat�rio de Perfil por Usu�rio"
Private cGetArqJ := Space(3)
Private oGetArqJ

Private cLabArqK := "Arquivo Tempor�rio p/ Relat�rio de Perfil de Acesso"
Private cGetArqK := Space(3)
Private oGetArqK

Define MsDialog oTela Title "Parametriza��o/Configura��o Estrutura - Perfil de Acesso" From 0,0 To 440,620	Pixel

@ 005,010 Say   cLabEmpC																					Pixel                                                                                   
@ 005,170 MsGet oGetEmpC    Var cGetEmpC  Picture "@!" Size 035,008 F3 "EMP" Valid fValEmp(cGetEmpC)		Pixel

@ 020,010 SAY   cLabMod 																					Pixel
@ 020,170 Combobox oGetMod  Var cGetMod  Items aGetMod Size 070,008											Pixel

@ 035,010 SAY   cLabArqA    																				Pixel
@ 035,170 MsGet oGetArqA    Var cGetArqA  Picture "@!" Size 035,008          Valid fValArq(cGetArqA)		Pixel

@ 050,010 SAY   cLabArqB    																				Pixel
@ 050,170 MsGet oGetArqB    Var cGetArqB  Picture "@!" Size 035,008          Valid fValArq(cGetArqB)		Pixel
                           
@ 065,010 SAY   cLabArqC    																				Pixel
@ 065,170 MsGet oGetArqC    Var cGetArqC  Picture "@!" Size 035,008          Valid fValArq(cGetArqC)		Pixel

@ 080,010 SAY   cLabArqD    																				Pixel
@ 080,170 MsGet oGetArqD    Var cGetArqD  Picture "@!" Size 035,008          Valid fValArq(cGetArqD)		Pixel

@ 095,010 SAY   cLabArqE    																				Pixel
@ 095,170 MsGet oGetArqE    Var cGetArqE  Picture "@!" Size 035,008          Valid fValArq(cGetArqE)		Pixel

@ 110,010 SAY   cLabArqF																					Pixel
@ 110,170 MsGet oGetArqF    Var cGetArqF  Picture "@!" Size 035,008          Valid fValArq(cGetArqF)		Pixel

@ 125,010 Say   cLabArqG																					Pixel
@ 125,170 MsGet oGetArqG    Var cGetArqG  Picture "@!" Size 035,008          Valid fValArq(cGetArqG)		Pixel

@ 140,010 SAY  cLabArqH																						Pixel
@ 140,170 Get  oGetArqH     Var cGetArqH  Picture "@!" Size 035,008          Valid fValArq(cGetArqH)		Pixel

@ 155,010 SAY  cLabArqI																						Pixel
@ 155,170 Get  oGetArqI     Var cGetArqI  Picture "@!" Size 035,008          Valid fValArq(cGetArqI)		Pixel

@ 170,010 SAY  cLabArqJ																						Pixel
@ 170,170 Get  oGetArqJ     Var cGetArqJ  Picture "@!" Size 035,008          Valid fValArq(cGetArqJ)		Pixel

@ 185,010 SAY  cLabArqK																						Pixel
@ 185,170 Get  oGetArqK     Var cGetArqJ  Picture "@!" Size 035,008          Valid fValArq(cGetArqK)		Pixel

@ 202,160 BUTTON "&OK"       PIXEL SIZE 40,12 OF oTela ACTION Processa( {|| fOK(), oTela:End() },,,.F.)
@ 202,210 BUTTON "&Cancelar" PIXEL SIZE 40,12 OF oTela ACTION oTela:End()

Activate MsDialog oTela Centered

Return()  // retorno da funcao
*************************************************************************************************************************************************************

Static Function fValEmp(_cEmp)  // Valida c�digo da empresa consolidadora

Local aArea := GetARea()
Local lRet := .T.

DbSelectArea("SM0")  // Seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // Muda ordem do indice
If SM0->(!DbSeek(xFilial("SM0")+_cEmp))  // Posiciona registro                                              
	Aviso("Atencao","Este codigo de empresa nao pode ser utilizado para esta operacao!", {"Ok"} )			
	lRet := .F.
EndIf	

RestARea(aArea)

Return lRet  // retorno da funcao
*************************************************************************************************************************************************************

Static Function fValArq(_cArq)  // Valida c�digo dos arquivos informados

Local aArea := GetARea()
Local lRet := .T.

DbSelectArea("SX2")  // Seleciona arquivo SX2
SX2->(DbSetOrder(1))  // Muda ordem do indice
If SX2->(DbSeek(_cArq))  // Posiciona registro
	Aviso("Atencao","Este codigo de arquivo nao pode ser utilizado para esta operacao!", {"Ok"} )			
	lRet := .F.
EndIf	

RestARea(aArea)

Return lRet  // retorno da funcao
*************************************************************************************************************************************************************

Static Function fOK()  // Confirma��o da sele��o de par�metros

_lRetOK := .T.

Return  // retorno da fun��o
*************************************************************************************************************************************************************

Static Function OpenSM0Exc()  // Fun��o para Efetuar a abertura do SM0 exclusivo

Local _lOpen := .F.
Local _nLoop := 0

For _nLoop := 1 To 20
	DbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		_lOpen := .T.
		DbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep( 500 )
Next _nLoop

If !_lOpen
	MsgStop("Nao foi possivel a abertura da tabela de empresas de forma exclusiva !")
EndIf

Return(_lOpen)