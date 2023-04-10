#INCLUDE "PROTHEUS.CH"

User Function IncUser

Local Token
Local oFwUserControl	
Local lRetorno := .t.

Local EBXLogin := "usuario.teste6"
Local EBXNome  := "Nome Completo Teste"
Local EBXSenha := "tst123"
Local EbxEmail := "paulo.coelho@ebx.com.br"
Local EbxPefil := {"000000","000003"}
Local EbxDepartamento := "TI Sistemas"
Local EbxSuperiorLogin := ""
Local EbxEmpresas := {"0101","0201","0301","0401"}
//Local EbxID := "000241"

//Local EBXAccount := erEbxAccount:New()

oFwUserControl := FwUserControl():New()
If !oFwUserControl:LoadByName(Alltrim(EBXLogin))
	
	oFwUserControl:oGeneral:cName 				:= EbxLogin
	oFwUserControl:oGeneral:cFullName 			:= EbxNome
	oFwUserControl:oGeneral:cPassword			:= EbxSenha
	oFwUserControl:oGeneral:dDtaInclusao		:= Date()
	oFwUserControl:oGeneral:cEmail				:= EbxEmail
	oFwUserControl:oGeneral:aGroups				:= EbxPefil
	oFwUserControl:oGeneral:cDepartamento		:= EbxDepartamento
	oFwUserControl:oGeneral:cIDSuperior 		:= EbxSuperiorLogin
	oFwUserControl:oGeneral:lChangeNextLogin 	:= .T. // Força trocar asenha no proximo login
	oFwUserControl:oDetail:lPrioConfGrupo   	:= .F.
	oFwUserControl:oDetail:aEmpresas			:= EbxEmpresas
	oFwUserControl:setDefaultM()
	oFwUserControl:saveUser()

Else
	conout("ERRO: Usuário já existe")
	lRetorno := .F.
endif

return



