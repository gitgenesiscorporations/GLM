#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#DEFINE cWSUserNAME "teste" //Verificar se vai criar parametron SX6 para essa duas variaveis
#DEFINE cWSUserPASS "aqswdefr" 

//-------------------------------------------------------------------
/*/{Protheus.doc} EbxWebServicesUsers
WebServices resposáveis pela disponiblização de serviços de login 
do Protheus

@author Rodrigo Antonio
@since 13/08/2010
@version EBX
/*/
//-------------------------------------------------------------------
User Function __EBXWBSU()
return Nil

WSService EbxWebServicesUsers Description "<b>WebServices resposáveis pela disponiblização de serviços de login do Protheus</b>";
NAMESPACE "http://webservices.ebx.com/ebxwebservicesusers.apw"
    
	WSData	USERLOGIN			AS STRING
	WSData  USERPASSWORD		AS STRING
	WSData  TOKEN				AS STRING
	WSData 	EbxAccount			AS erEbxAccount
	WSData 	EbxLogin			AS String
	WSData 	EbxID				AS String    
	WSData 	EbxEmpresa			AS String    	  
	WSData 	ListOFEbxLogin		AS Array of String
	WSMethod Login			DESCRIPTION "Autoriza o login no webservices, retorna um token para ser utilizado nas transações, valido por 2 minutos."
	WSMethod Incluir		DESCRIPTION "Inclui um usuário no sistema, retornando o ID do usuário criado."	
	WSMethod Alterar		DESCRIPTION "Altera as informações do usuário no sistema."	
	WSMethod Desabilitar	DESCRIPTION "Bloqueia o usuário."	
	WSMethod Habilitar		DESCRIPTION "DesBloqueia o usuário."	
	WSMethod Listar			DESCRIPTION "Retorna uma lista com os IDs de todos usuários"	
	WSMethod Detalhar		DESCRIPTION "Retorna uma estrutura com os dados do usuario passado"		
	WSMethod ListarEmpresas	DESCRIPTION "Retorna um array de estrutra de empresas. Retorna na propria estrutura do usuario em branco, so utilizando as estruturas de empresa"
	WSMethod ListarFilias	DESCRIPTION "Retorna um array de estrutra de Filial de uma Empresa Passada."
	WSMethod ListarPerfis	DESCRIPTION "Retorna um array de estrutra de Perfil,Retorna na propria estrutura do usuario em branco."	
ENDWSSERVICE

//-------------------------------------------------------------------
/*/{Protheus.doc} Login
Efetua o login no webservice, retornando um Token(numerico) se sucesso, 
caso falhar retorna 0

@param cUser - Usuário
@param cSenha - Senha 
@return nToken - Token para ser utilizado nas proximas transações
@author Rodrigo Antonio
@since 13/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod Login WSRECEIVE USERLOGIN,USERPASSWORD WSSEND TOKEN WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory
Local lRetorno := .T.
If USERLOGIN == cWSUserNAME .And. USERPASSWORD == cWSUserPASS
	oFWTokenFactory := GetTokenFactory()
	self:TOKEN:= oFWTokenFactory:GetNewToken()
Else 
	self:TOKEN:= ""
	SetSoapFault("EbxWebServicesUsers:Login","Usuário ou Senha Invalida.")
	lRetorno := .F.

Endif

RETURN lRetorno

//-------------------------------------------------------------------
/*/{Protheus.doc} Incluir
Inclui um usuário no sistema, retornando o ID do usuário criado.

@param cToken - Token de Autenticação
@param UsrStruct - Estrutura do tipo erEbxAccount com os dados
@return cIdUser - Codigo do usuario
@author Rodrigo Antonio
@since 13/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod Incluir WSRECEIVE TOKEN, EbxAccount WSSEND EbxID WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local oFwUserControl	
Local lRetorno := .t.
If oFWTokenFactory:Authentic(self:Token)          
	oFwUserControl := FwUserControl():New()
	If !oFwUserControl:LoadByName(Alltrim(self:EbxAccount:erEbxLogin))
		
		oFwUserControl:oGeneral:cName 				:= self:EbxAccount:erEbxLogin
		oFwUserControl:oGeneral:cFullName 			:= self:EbxAccount:erEbxNome
		oFwUserControl:oGeneral:cPassword			:= self:EbxAccount:erEbxSenha
		oFwUserControl:oGeneral:dDtaInclusao		:= Date()
		oFwUserControl:oGeneral:cEmail				:= self:EbxAccount:erEbxEmail
		oFwUserControl:oGeneral:aGroups				:= GetGroup(EbxAccount:erEbxPefil)
		oFwUserControl:oGeneral:cDepartamento		:= self:EbxAccount:erEbxCargoDepartamento
		oFwUserControl:oGeneral:cIDSuperior 		:= GetSuperId(self:EbxAccount:erEbxSuperiorLogin)
		oFwUserControl:oGeneral:lChangeNextLogin 	:= .T. // Força trocar asenha no proximo login
		oFwUserControl:oDetail:lPrioConfGrupo   	:= .T.
		oFwUserControl:ODETAIL:AEMPRESAS			:= GetEmpresas(self:EbxAccount:erEbxFilias)
		oFwUserControl:setDefaultM()
		oFwUserControl:saveUser()
		self:EbxID := oFwUserControl:oGeneral:cId                                              
	Else
		SetSoapFault("EbxWebServicesUsers:Incluir","Usuário ja cadastrado.")	
		lRetorno := .F.
	Endif
Else
	SetSoapFault("EbxWebServicesUsers:Incluir","Token de Conexão Invalido.")
	lRetorno := .F.
Endif
RETURN lRetorno

//-------------------------------------------------------------------
/*/{Protheus.doc} Alterar
Altera as informações do usuário no sistema.

@param cToken - Token de Autenticação
@param UsrStruct - Estrutura do tipo erEbxAccount com os dados

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod Alterar WSRECEIVE TOKEN, EbxAccount  WSSEND EbxID WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local oFwUserControl	
Local lRetorno := .t.
If oFWTokenFactory:Authentic(self:Token)          
	oFwUserControl := FwUserControl():New()
	If oFwUserControl:LoadByName(Alltrim(self:EbxAccount:erEbxLogin))
		oFwUserControl:oGeneral:cFullName 			:= self:EbxAccount:erEbxNome
		oFwUserControl:oGeneral:cEmail				:= self:EbxAccount:erEbxEmail
		oFwUserControl:oGeneral:aGroups				:= GetGroup(EbxAccount:erEbxPefil)
		oFwUserControl:oGeneral:cDepartamento		:= self:EbxAccount:erEbxCargoDepartamento
		oFwUserControl:ODETAIL:AEMPRESAS			:= GetEmpresas(self:EbxAccount:erEbxFilias)
		oFwUserControl:saveUser()
		self:EbxID := oFwUserControl:oGeneral:cId          
	Else
		SetSoapFault("EbxWebServicesUsers:Alterar","Usuário nao encontrado")	
		lRetorno := .F.
	Endif
Else
	SetSoapFault("EbxWebServicesUsers:Alterar","Token de Conexão Invalido.")
	lRetorno := .F.
Endif
RETURN lRetorno
//-------------------------------------------------------------------
/*/{Protheus.doc} Desabilitar
Bloqueia o usuário

@param cToken - Token de Autenticação
@param EbxLogin - Login do usuário a se bloquear

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod Desabilitar WSRECEIVE TOKEN, EbxLogin WSSEND EbxID WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local oFwUserControl	
Local lRetorno := .t.
If oFWTokenFactory:Authentic(self:Token)          
	oFwUserControl := FwUserControl():New()
	If oFwUserControl:LoadByName(Alltrim(self:EbxLogin))
		PswBlock(Alltrim(self:EbxLogin))
		self:EbxID := oFwUserControl:oGeneral:cId          
	Else
		SetSoapFault("EbxWebServicesUsers:Desabilitar","Usuário nao encontrado")	
		lRetorno := .F.
	Endif
Else
	SetSoapFault("EbxWebServicesUsers:Desabilitar","Token de Conexão Invalido.")
	lRetorno := .F.
Endif

RETURN lRetorno
//-------------------------------------------------------------------
/*/{Protheus.doc} Habilitar
DesBloqueia o usuário

@param cToken - Token de Autenticação
@param EbxLogin - Login do usuário a se liberar

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod Habilitar WSRECEIVE TOKEN, EbxLogin WSSEND EbxID WSSERVICE EbxWebServicesUsers

Local oFWTokenFactory := GetTokenFactory()
Local oFwUserControl	
Local lRetorno := .t.
If oFWTokenFactory:Authentic(self:Token)          
	oFwUserControl := FwUserControl():New()
	If oFwUserControl:LoadByName(Alltrim(self:EbxLogin))
		oFwUserControl:oGeneral:lUserBlock := .F.
		oFwUserControl:saveUser()
		self:EbxID := oFwUserControl:oGeneral:cId          
	Else
		SetSoapFault("EbxWebServicesUsers:Habilitar","Usuário nao encontrado")	
		lRetorno := .F.
	Endif
Else
	SetSoapFault("EbxWebServicesUsers:Habilitar","Token de Conexão Invalido.")
	lRetorno := .F.
Endif

RETURN lRetorno
//-------------------------------------------------------------------
/*/{Protheus.doc} Listar
DesBloqueia o usuário

@param cToken - Token de Autenticação
@return ARet Array contendo a lista de IDs dos usuários
@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------
WSMethod Listar WSRECEIVE TOKEN  WSSEND ListOFEbxLogin WSSERVICE EbxWebServicesUsers
Local lRetorno := .t.          
Local oFWTokenFactory := GetTokenFactory()
Local nI
If oFWTokenFactory:Authentic(self:Token)          
	self:ListOFEbxLogin := {}
	aUsers := AllUsers()
	For nI := 1 to Len(aUsers)
		If aUsers[ni] <> NIL
			aAdd(self:ListOFEbxLogin,aUsers[ni][1][2])
		Endif
	Next 
Else
	SetSoapFault("EbxWebServicesUsers:Listar","Token de Conexão Invalido.")
	lRetorno := .F.
Endif

RETURN lRetorno



//-------------------------------------------------------------------
/*/{Protheus.doc} Detalhar
Retorna uma estrutura com os dados do usuario.

@param cToken - Token de Autenticação
@param UsrStruct - Variavel erEbxLogin, com o login do usuario desejado

@return erEbxAccount
@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod Detalhar WSRECEIVE TOKEN, EbxID  WSSEND EbxAccount WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local oFwUserControl	
Local lRetorno := .t.
If oFWTokenFactory:Authentic(self:Token)          
	oFwUserControl := FwUserControl():New()
	If oFwUserControl:LoadByName(Alltrim(self:EbxID))
		self:EbxAccount:erEbxLogin 				 := oFwUserControl:oGeneral:cName
		self:EbxAccount:erEbxNome 				 := oFwUserControl:oGeneral:cFullName
		self:EbxAccount:erEbxEmail 				 := oFwUserControl:oGeneral:cEmail
		self:EbxAccount:erEbxSuperiorLogin 		 := FWGetUserName(oFwUserControl:oGeneral:cIDSuperior)
		self:EbxAccount:erEbxCargoDepartamento 	 := oFwUserControl:oGeneral:cDepartamento	
		self:EbxAccount:erEbxPefil				 := MakeGrupsStr(oFwUserControl:oGeneral:aGroups)
		MakeEmpFil(oFwUserControl:ODETAIL:AEMPRESAS,@self:EbxAccount:erEbxEmpresas,@self:EbxAccount:erEbxFilias)

	Else
		SetSoapFault("EbxWebServicesUsers:Detalhar","Usuário nao encontrado")	
		lRetorno := .F.
	Endif
Else
	SetSoapFault("EbxWebServicesUsers:Detalhar","Token de Conexão Invalido.")
	lRetorno := .F.
Endif
RETURN lRetorno

//-------------------------------------------------------------------
/*/{Protheus.doc} ListarEmpresas
Retorna um array de estrutra de empresas. Retorna na propria estrutura do usuario em branco, so utilizando as
estruturas de empresa 
@param cToken - Token de Autenticação

@return erEbxAccount
@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod ListarEmpresas WSRECEIVE TOKEN  WSSEND EbxAccount WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local lRetorno := .t.
Local cEmpAtual := ""  
Local oerEbxEmpresas
self:EbxAccount:erEbxEmpresas := {}
If oFWTokenFactory:Authentic(self:Token)          
	SM0->(DBGotop())
	While (SM0->(!Eof()))
		If cEmpAtual != SM0->M0_CODIGO
			oerEbxEmpresas := WSCLASSNEW ('erEbxGrupoEmpresa')	
			cEmpAtual := SM0->M0_CODIGO
			oerEbxEmpresas:erEbxGrupoEmpresaID := SM0->M0_CODIGO
			oerEbxEmpresas:erEbxGrupoEmpresaNome := SM0->M0_NOME
	     	aAdd(self:EbxAccount:erEbxEmpresas,oerEbxEmpresas)
		Endif	
		SM0->(DbSkip())
	End

Else
	SetSoapFault("EbxWebServicesUsers:ListarEmpresas","Token de Conexão Invalido.")
	lRetorno := .F.
Endif
RETURN lRetorno


//-------------------------------------------------------------------
/*/{Protheus.doc} ListarFilias
Retorna um array de estrutra de Filial de uma Empresa Passada
@param cToken - Token de Autenticação
@param EbxEmpresa - Codigo da empresa

@return erEbxAccount
@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod ListarFilias WSRECEIVE TOKEN,EbxEmpresa  WSSEND EbxAccount WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local lRetorno := .t.
Local cEmpAtual := ""  
Local oerEbxFilias
Local oerEbxEmpresas
self:EbxAccount:erEbxEmpresas := {}
self:EbxAccount:erEbxFilias   := {}
If oFWTokenFactory:Authentic(self:Token)          
	SM0->(DBGotop())
	SM0->(DbSeek(self:EbxEmpresa))
	While (SM0->(!Eof() .And. M0_CODIGO == self:EbxEmpresa) )
		If cEmpAtual != SM0->M0_CODIGO
			oerEbxEmpresas := WSCLASSNEW ('erEbxGrupoEmpresa')	
			cEmpAtual := SM0->M0_CODIGO
			oerEbxEmpresas:erEbxGrupoEmpresaID := SM0->M0_CODIGO
			oerEbxEmpresas:erEbxGrupoEmpresaNome := SM0->M0_NOME
	     	aAdd(self:EbxAccount:erEbxEmpresas,oerEbxEmpresas)
		Endif	                                                
		oerEbxFilias := WSCLASSNEW ('erEbxEmpresaFilial')			
		oerEbxFilias:erEbxGrupoEmpresaID			:= SM0->M0_CODIGO
		oerEbxFilias:erEbxEmpresaFilialID			:= SM0->M0_CODFIL
		oerEbxFilias:erEbxEmpresaFilialNome			:= SM0->M0_FILIAL
		aAdd(self:EbxAccount:erEbxFilias ,oerEbxFilias)

		SM0->(DbSkip())
	End

Else
	SetSoapFault("EbxWebServicesUsers:ListarFilias","Token de Conexão Invalido.")
	lRetorno := .F.
Endif
RETURN lRetorno


//-------------------------------------------------------------------
/*/{Protheus.doc} ListarPerfis
Retorna um array de estrutra de Perfil,Retorna na propria estrutura do usuario em branco.
@param cToken - Token de Autenticação

@return erEbxAccount
@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------

WSMethod ListarPerfis WSRECEIVE TOKEN WSSEND EbxAccount WSSERVICE EbxWebServicesUsers
Local oFWTokenFactory := GetTokenFactory()
Local lRetorno := .t.
Local aGroups := {}
Local nX
Local oerEbxPerfil
If oFWTokenFactory:Authentic(self:Token)          
	aGroups := AllGroups(.T.)
	For nX := 1 to Len 	(aGroups)
		oerEbxPerfil := WSCLASSNEW ('erEbxPerfil')
		oerEbxPerfil:EREBXGRUPOPERFILID 	:= aGroups[nX][1][1]
		oerEbxPerfil:EREBXGRUPOPERFILNOME	:= aGroups[nX][1][2]			
		aAdd(self:EbxAccount:erEbxPefil,oerEbxPerfil)
	Next 
Else
	SetSoapFault("EbxWebServicesUsers:ListarPerfis","Token de Conexão Invalido.")
	lRetorno := .F.
Endif
RETURN lRetorno


//---------------------------
// Funcoes Auxliares
//--------------------------- 
Static Function GetSuperId(cUserName)
Local oFwUserControl := FwUserControl():New()
Local cId	:=	""                  
cUserName := Alltrim(cUserName)
If !(Upper(cUserName) == "ADMIN" .Or. Upper(cUserName) == "ADMINISTRADOR" )
	If !oFwUserControl:LoadByName(cUserName)
		cId := oFwUserControl:oGeneral:cID
	Endif
Else
	cID := "000000"
Endif
Return cID
//--------------------------------	
//oFwUserControl:ODETAIL:AEMPRESAS,self:EbxAccount:erEbxEmpresas,self:EbxAccount:erEbxFilias)
Static Function MakeEmpFil(aPSWEmp,aEmps,aFils)
Local nX    
Local oerEbxEmpresas                                                                        
Local oerEbxFilias
Local cEmpAtual := ""
Local cEmpresa
Local cFil
aEmps := {} 
aFils := {}
For nX := 1 to Len(aPSWEmp)
	cEmpresa := SubStr(aPSWEmp[nX],1,2)
	cFil	 :=	SubStr(aPSWEmp[nX],3)
	If SM0->(Dbseek(cEmpresa+cFil))
		If cEmpAtual != cEmpresa
			oerEbxEmpresas := WSCLASSNEW ('erEbxGrupoEmpresa')	
			cEmpAtual := cEmpresa	
			oerEbxEmpresas:erEbxGrupoEmpresaID := cEmpresa
			oerEbxEmpresas:erEbxGrupoEmpresaNome := SM0->M0_NOME
	     	aAdd(aEmps,oerEbxEmpresas)
		Endif	
			oerEbxFilias := WSCLASSNEW ('erEbxEmpresaFilial')			
			oerEbxFilias:erEbxGrupoEmpresaID			:= cEmpresa
			oerEbxFilias:erEbxEmpresaFilialID			:= cFil
			oerEbxFilias:erEbxEmpresaFilialNome			:= SM0->M0_FILIAL
			aAdd(aFils,oerEbxFilias)
	Endif	
Next
Return

//---------------------------

Static Function MakeGrupsStr(aUsrGrp)
Local oerEbxPerfil
Local nX
Local aGroups := AllGroups(.T.)
Local aRet :={}     
Local nPos
For nX := 1 to Len (aUsrGrp)                  
	nPos := aScan( aGroups, {|x|x[1][1] == aUsrGrp[nX]})   
	If nPos > 0
		oerEbxPerfil := WSCLASSNEW ('erEbxPerfil')
		oerEbxPerfil:EREBXGRUPOPERFILID 	:= aUsrGrp[nX]
		oerEbxPerfil:EREBXGRUPOPERFILNOME	:= aGroups[nPos][1][2]
		aAdd(aRet,oerEbxPerfil)
	Endif
Next nX

Return aRet
//----------------------------
Static Function GetGroup(aPerfil)
Local nX
Local aRet := {}
For nX :=1 to Len(aPerfil)
	aAdd(aRet,aPerfil[nX]:EREBXGRUPOPERFILID)
Next nX
Return aret     
//----------------------------
Static Function GetEmpresas(aFil)
Local nX
Local aRet := {}      
Local cEmp
For nX :=1 to Len(aFil)
	cEmp := aFil[nX]:EREBXGRUPOEMPRESAID
	aAdd(aRet,cEmp+aFil[Nx]:EREBXEMPRESAFILIALID)
Next   
Return aret
//-------------------------------------------------------------------
/*/{Protheus.doc} erEbxAccount
Estrura para os dados do usuario

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------
WsStruct erEbxAccount
	WsData erEbxNome					as String
	WsData erEbxLogin 					as String
	WsData erEbxSenha                  	as String	OPTIONAL
	WsData erEbxCargoDepartamento       as String
	WsData erEbxSuperiorLogin			as String
	WsData erEbxEmail	            	as String
	WsData erEbxEmpresas				as Array of erEbxGrupoEmpresa OPTIONAL
	WsData erEbxFilias					as Array of erEbxEmpresaFilial OPTIONAL
	WsData erEbxPefil					as Array of erEbxPerfil OPTIONAL
EndWsStruct


//-------------------------------------------------------------------
/*/{Protheus.doc} erEbxGrupoEmpresa
Estrura para os dados do Grupo de Empresa

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------
WsStruct erEbxGrupoEmpresa
	WsData erEbxGrupoEmpresaID			as String
	WsData erEbxGrupoEmpresaNome		as String
EndWsStruct


//-------------------------------------------------------------------
/*/{Protheus.doc} erEbxEmpresaFilial
Estrura para os dados da filial

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------
WsStruct erEbxEmpresaFilial                      
	WsData erEbxGrupoEmpresaID			as String
	WsData erEbxEmpresaFilialID			as String
	WsData erEbxEmpresaFilialNome		as String
EndWsStruct                  

//-------------------------------------------------------------------
/*/{Protheus.doc} erEbxPerfil
Estrura para os dados do grupos de usuario

@author Rodrigo Antonio
@since 14/08/2010
@version EBX
/*/
//-------------------------------------------------------------------
WsStruct erEbxPerfil
	WsData erEbxGrupoPerfilID		as String
	WsData erEbxGrupoPerfilNome		as String
EndWsStruct                  

/*
Retorna um objeto para a classe de Token para pegar o token ativo

*/

Static Function GetTokenFactory()
Local oFWTokenFactory
oFWTokenFactory := FWTokenFactory():New("WEB_SERVICE_USERS",120) //120 = 2 Miuntos de validade
oFWTokenFactory:SetSeedBlock({||U_ExecSeed()})
oFWTokenFactory:Activate()
Return oFWTokenFactory


User Function ExecSeed()
Return GETMV("MV_MARK4")
