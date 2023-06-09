/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � CallChgXNU� Autor � George AC Gon�alves � Data � 04/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � CallChgXNU� Autor � George AC Gon�alves � Data � 28/09/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Agrupa menu por grupos de usu�rio do Perfil de Acesso      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inicializa��o do projeto                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "RwMake.ch"
#include "FileIO.ch"

#define CRLF Chr(13)+Chr(10)

/*
Estrutura do retorno da Xnuload:
[i,1] Array de 3 posi��es com o nome da fun��o:
[i,1,1] T�tulo em Portugues
[i,1,2] T�tulo em Espanhol
[i,1,3] T�tulo em Ingles
[i,2] Status - E ativada (<menuitem status=enable>), D desativada (<menuitem status=disable>)
[i,3] Array com outro aMenu(recursivo) ou o nome da fun��o (as posi��es de 4 a 7 s� existem no caso do tipo [i,3] for igual a caracter)
[i,4] Array com as tabelas que a fun��o usa
[i,5] Acesso
[i,6] N�mero do m�dulo
[i,7] Tipo da fun��o
*/

User Function CallChgXNU()  // Agrupa menu por grupos de usu�rio do Perfil de Acesso

local _aUser
Local _aAllGroup
Local _aUserGroups
Local _aXNUs := {}
Local _cXNU
Local _aGroupXNU
Local _nPosXNU
Local _lGravou
Local i
Local e
Local _lPriorGrp

Private cTab        := chr(9)
Private _aMenuPrin  := {}
Private _cModulo
Private _aModulos
Private _cEmpresa
Private _cFilial
Private _cUserID 
Private _aMenusLoad := {}                                             

Return PARAMIXB[5]  // retorno da fun��o  // desconsidera opera��o

///- George
PSWORDER(1)  // muda ordem de �ndice
If PswSeek(PARAMIXB[1]) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
    _lPriorGrp := aArray[2][11] // recupera se prioriza grupo
EndIf
///- George

_cEmpresa 		:= PARAMIXB[2]  // SM0->M0_CODIGO
_cFilial		:= PARAMIXB[3]  // SM0->M0_CODFIL
_cUserID		:= PARAMIXB[1]
_aUser 			:= PswRet()
///_lPriorGrp 		:= _aUser[2][11]

///- George
// abre arquivo de par�metros e cria �ndice de pesquisa tempor�rio
dbUseArea(.T.,,"SX6"+_cEmpresa+"0","TMPX6",.T.,.F.)
DbSetIndex("SX6"+_cEmpresa+"0.CDX")

cDtPerf := StoD("20091016")  // data da entrada do projeto de perfil de acesso
DbSelectArea("TMPX6")  // abre arquivo tempor�rio
DbSetOrder(1)  // posiciona no �ndice tempor�rio
If DbSeek("  MV_XDTPERF")  // posiciona no registro
	cDtPerf := StoD(TMPX6->X6_CONTEUD)  // data da entrada do projeto de perfil de acesso
EndIf	
TMPX6->(DbCloseArea())  // fecha �rea tempor�ria

If _aUser[1][16] < cDtPerf  // se data da �ltima modifica��o do usu�rio menor que implanta��o do projeto
	Return PARAMIXB[5]  // retorno da fun��o  // desconsidera opera��o
EndIf
///- George

//////- George
///// Somente para usu�rios que priorizam grupos
///if !_lPriorGrp
///	return PARAMIXB[5]
///endif
///- George

_aAllGroup 		:= AllGroups()
_aUserGroups 	:= _aUser[1][10]
_aModulos		:= RetModName()
_nPosModulo := aScan( _aModulos , { |x| Upper( AllTrim( x[2] ) ) == oapp:cModName } )        

if _nPosModulo > 0
	_cModulo 	:= strzero(_aModulos[_nPosModulo][1],2)
else
	_cArquivo := PARAMIXB[5]
    return _cArquivo
endif

for i = 1 to len(_aUserGroups)
	_aGroupXNU := _aAllGroup[ascan(_aAllGroup, {|X| X[1][1]=_aUserGroups[i]})][2]
///	_aGroupXNU := _aAllGroup[ascan(_aAllGroup, {|X| X[1][1]=_aUserGroups[i]})][1][1]
	_nPosXNU := ascan(_aGroupXNU, {|X| substr(X,1,2)==_cModulo})
	if _nPosXNU > 0 .and. substr(alltrim(_aGroupXNU[_nPosXNU]),3,1) != "X" // N�o agrupa menus de grupos sem permiss�o para este m�dulo  
		_cXNU := alltrim(_aGroupXNU[_nPosXNU])
		_cXNU := substr(_cXNU,at("\",_cXNU))
		if ascan(_aXNUs, _cXNU) == 0 .and. file(_cXNU)
			aadd(_aXNUs,_cXNU)
		endif
	endif
next

if len(_aXNUs) = 0		
	return PARAMIXB[5]
elseif len(_aXNUs) = 1
	return _aXNUs[1]
endif

for i = 1 to len(_aXNUs)
	aadd(_aMenusLoad, XNULoad(_aXNUs[i],.F.))
next
	
_aMenuPrin := aclone(_aMenusLoad[1])
for i = 2 to len(_aMenusLoad)
	_aMenuPrin := MergeItens(_aMenuPrin, _aMenusLoad[i])
next

// Gravando em disco
_cArquivo := "\MenusDin\"+_cUserID+_cModulo+_cEmpresa+_cFilial+".xnu"

_lGravou := GravaXNU(_aMenuPrin, _cArquivo)

// Valida se a cria��o foi bem-sucedida
If !_lGravou
   Return paramIXB[5]
endif

Return _cArquivo  // retorno do arquivo
**********************ELIZABETH*****************************************************************************************************************************

Static Function MergeItens(aPrincipal, aNovo)  // Monta o array com os itens de todos os menus envolvidos

Local nPosExist
Local i
local e

for i = 1 to len(aNovo)
	lItem := .f.
	
	// Se n�o for um menu/item ENABLED ignora
	if aNovo[i][2]!="E"
		loop
	endif
	
	// Verifica se � um item ou menu
	if len(aNovo[i]) > 3
		lItem := .t.
	endif
	
	// Se for item	
	if lItem
		nPosExist := ascan(aPrincipal, {|X| len(x) > 3 .and. X[3]=aNovo[i][3] .and. X[7]=aNovo[i][7]})

		// Se n�o existir adiciona
		if nPosExist = 0
			aadd(aPrincipal, aclone(aNovo[i]))
			
		// Se existir, faz um MERGE dos acessos do item
		else
			_cAcesso := ""
			for e =1 to 10
				if lower(substr(aPrincipal[nPosExist][5],e,1)) = "x" .or. lower(substr(aNovo[i][5],e,1)) = "x"
					_cAcesso += "x"
				endif
			next
			aPrincipal[nPosExist][5] := _cAcesso
		endif
	
	// Se for menu
	else
		nPosExist := ascan(aPrincipal, {|X| RemAcentos(X[1][1])=RemAcentos(aNovo[i][1][1])})

		// Se n�o existir, adiciona este menu e todos os filhos
		if nPosExist = 0
			aadd(aPrincipal, aclone(aNovo[i]))
			
		// Se existir, faz um MERGE com os filhos (menus/itens)
		else
			aTmpArray := MergeItens(aPrincipal[nPosExist][3], aNovo[i][3])
			aPrincipal[nPosExist][3] := aTmpArray
		endif
	endif	
	
next

Return aclone(aPrincipal)  // retorno da fun��o
***************************************************************************************************************************************************

Static Function GravaXNU(_aMenuArray, _cXnuFile)  // Grava o array com o menu em arquivo .XNU

Local i
Local nHdl
Local _lOk 

//cria backup do arquivo
if file(_cXnuFile)
	fErase(_cXnuFile)
endif

//cria e verifica se houve sucesso
nHdl := Fcreate(_cXnuFile)
If nHdl < 0
	MsgAlert("N�o foi poss�vel criar o arquivo de menu","Aten��o")
	_lOk := .f.
Else
	
	FWrite( nHdl, '<ApMenu>' + CRLF )
	FWrite( nHdl, cTab + '<DocumentProperties>' + CRLF )
	FWrite( nHdl, cTab + cTab + '<Module>'+Subs(Upper(_cXnuFile), 1, At( '.', _cXnuFile ) -1 )+'</Module>' + CRLF )
	FWrite( nHdl, cTab + cTab + '<Version>8.11</Version>' + CRLF )
	FWrite( nHdl, cTab + '</DocumentProperties>' + CRLF )
	
	// Chamada a fun��o recursiva de grava��o de menus/itens
	GravaItens(_aMenuArray, nHdl, 1)

	FWrite( nHdl, '</ApMenu>' + CRLF )
	Fclose(nHdl)
	_lOk := .t.	
EndIf

Return _lOk  // retorno da fun��o
***************************************************************************************************************************************************

Static Function GravaItens(_aMenuArray, nHdl, nTabs)  // Fun��o Recursiva para grava��o em disco dos menus/itens

Local nJ
Local i
Local lItem 

for i = 1 to len(_aMenuArray)

	// Verifica se � um item ou menu
	lItem := iif(len(_aMenuArray[i]) > 3,.t.,.f.)
		
	// Se for item	
	if lItem
		
		FWrite( nHdl, Replicate(cTab, nTabs) + '<MenuItem Status="Enable">' + CRLF )		
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Title lang="pt">' + _aMenuArray[i][1][1] + '</Title>' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Title lang="es">' + _aMenuArray[i][1][2] + '</Title>' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Title lang="en">' + _aMenuArray[i][1][3] + '</Title>' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Function>' + AllTrim(_aMenuArray[i][3]) + '</Function>' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Type>' + AllTrim(Str(_aMenuArray[i][7]) ) + '</Type>' + CRLF )
		
		For nJ := 1 To Len( _aMenuArray[i][4] )
			FWrite( nHdl, Replicate(cTab, nTabs) + '	<Tables>' + _aMenuArray[i][4][nJ] + '</Tables>' + CRLF )		
		Next
		
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Access>' + _aMenuArray[i][5] + '</Access>' + CRLF )		
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Module>' + _aMenuArray[i][6] + '</Module>' + CRLF )		
   		FWrite( nHdl, Replicate(cTab, nTabs) + '</MenuItem>' + CRLF )

	else		
		
		FWrite( nHdl, Replicate(cTab, nTabs) + '<Menu Status="Enable">' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Title lang="pt">' + _aMenuArray[i][1][1] + '</Title>' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Title lang="es">' + _aMenuArray[i][1][2] + '</Title>' + CRLF )
		FWrite( nHdl, Replicate(cTab, nTabs) + '	<Title lang="en">' + _aMenuArray[i][1][3] + '</Title>' + CRLF )
		
		GravaItens(_aMenuArray[i][3], nHdl, nTabs + 1)
		
		FWrite( nHdl, Replicate(cTab, nTabs) + '</Menu>' + CRLF )

	endif

Next
	
Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function RemAcentos(_cStr)  // Remove os acentos da string informada

Local _cTemp := ""
Local i
Local _cChar
	
_cStr := lower(_cStr)

for i = 1 to len(_cStr)
	_cChar := substr(_cStr,i,1)
	if _cChar $ "�����"
		_cChar := "a"
	elseif _cChar $ "����"
		_cChar := "e"
	elseif _cChar $ "����"
		_cChar := "i"
	elseif _cChar $ "�����"
		_cChar := "o"
	elseif _cChar $ "����"
		_cChar := "u"
	elseif _cChar = "�"
		_cChar := "c"
	elseif _cChar = "&"
		_cChar := ""
	endif
	_cTemp += _cChar
next

Return _cTemp  // retorno da fun��o