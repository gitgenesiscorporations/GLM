                                                           
#Include "rwmake.ch"  
#include "Topconn.ch" 

User Function gEspT001

	Local cUsrId
	Local aArray		:= {}
	Local lFlagUser	:= .F.
	Local aGrupos		:= {}		

	Private oPswPerfilAcesso
	
	Public u1_cCdUser
	Public u1_cSenha
	
	cUsrId := IIf( Empty(ZZE->ZZE_CDUSU),"000000",ZZE->ZZE_CDUSU )
		
	u1_cUsrId         := gChkUser("ID",ZZE->ZZE_NMUSU)                                       // chamada a fun��o que recupera o ID do usu�rio
	u1_cCdUser        := gChkUser(u1_cUsrId,AllTrim(ZZE->ZZE_NMUSU))                         // chamada a fun��o que recupera o c�digo do usu�rio
	u1_cNomeC         := ZZE->ZZE_NMUSU                                                      // Nome completo do usu�rio
	u1_aSenha         := {}                                                                  // Vetor com n�mero das �ltimas senhas
	u1_dDtValid       := CToD("  /  /  ")                                                    // Data da validade da senha
	u1_nQtdExpira     := 0                                                                   // Expira senha ap�s N dias
	u1_lAutAltSenha   := .T.                                                                 // Usu�rio autorizado a alterar senha
	u1_lAltSenhaLogon := .T. 
	
	u1_aGrupo	:= {}                                                                			// Altera senha no pr�ximo logon

	DbSelectArea("ZZF")
	ZZF->(DbSetOrder(1))
	If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))
		Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL
			If ZZF->ZZF_STATC == "1"
				Aadd(u1_aGrupo,ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF)
			EndIf
			ZZF->(DbSkip())
		EndDo
	EndIf

	u1_cIdSuper       :=  __cUserID		                                                     // ID do superior do usu�rio
	
	If !Empty(ZZE->ZZE_EMPPRE)
		u1_cDepart    := AllTrim(ZZE->ZZE_EMPPRE)+"/"+AllTrim(ZZE->ZZE_NMDEPU)               // Empresa Prestadora Servi�o + Departamento do usu�rio
	Else                                                                                                                   
		u1_cDepart    := AllTrim(ZZE->ZZE_NMDEPU)                                            // Departamento do usu�rio
	EndIf	
	
	u1_cCargo         := ZZE->ZZE_DSFUNU                                                     // Cargo do usu�rio
	u1_cEmail         := ZZE->ZZE_EMAILU                                                     // e-Mail do usu�rio
	u1_nAcessoSim     := 1                                                                   // N�mero de acessos simult�neos do usu�rio
	u1_dDtUltAlt      := dDataBase                                                           // Data da �ltima altera��o
	u1_lUsuBloqueio   := .F.                                                                 // Usu�rio bloqueado
	u1_nDigAno        := 2                                                                   // N�mero de d�gitos para o ano
	u1_lListner       := .F.                                                                 // Listner de liga��es
	u1_cRamal         := AllTrim(ZZE->ZZE_TELUSU)                                            // Telefone do usu�rio
	u1_cRamal         := SubStr(u1_cRamal,Len(u1_cRamal)-3,4)                                // Ramal do usu�rio
	u1_V21            := ""                                                                  //
	u1_V22            := "0000"                                                              //
	u1_aRetAvDias     := {If(ZZE->ZZE_PERAVR=="S",.T.,.F.),ZZE->ZZE_RETROC,ZZE->ZZE_AVANCO}  // Vetor com informa��es de avan�o ou retrocesso de dias referente a data base
	u1_V24            := dDataBase                                                           // Data de inclus�o do registro
	u1_V25            := ""
	
// aReturn[2] => array com dados de acesso
	u2_aHorario       := {"  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  ","  :  |  :  "}  // Vetor com os hor�rios para acesso
	u2_nIdioma        := 1                                                                                                    // Idioma
	u2_cDiretorio     := "\SPOOL\"                                                                                            // Diret�rio para grava��o dos relat�rios em disco
	u2_cDriveImp      := "EPSON.DRV"                                                                                          // Drive impressora
	u2_cAcesso        := "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNNNNNNNNNNSNSNNSNNSNSSNNSSSSSSSSNNNNNSSSSNNNSSSSSSSSSSSNNNNNNSNNNSNNSSSSSSSSSNNSSS                                                                                                                                                                                                                                                                                                                                                   "  // Acessos
	u2_aEmpresas      := gArrayEmp()                                                                                          // Chamada a fun��o para para montar vetor com as empresas acessadas
	u2_cPontoEnt      := ""                                                                                                   // Ponto de entrada
	u2_nTipoImpr      := 2                                                                                                    // Tipo de impress�o 1- Em Disco / 2 - Via windows / 3 - Direto na Porta
	u2_nFormato       := 1                                                                                                    // Formato - 1 Retrato / 2 - Paisagem
	u2_nAmbiente      := 1                                                                                                    // Ambiente - 1 Servidor 2 Local
	u2_lPrioridade    := .F.                                                                                                  // Prioridade para configura��o do grupo/perfil
	u2_cOpcaoImp      := ""                                                                                                   // Op��o de imprees�o
	u2_lAcOutDirImp   := .F.                                                                                                  // Acesso a outros diret�rios de impress�o

// aReturn[4] => array com dados de ???
	u4_V1             := .F.  // 
	u4_V2             := ""   // 
	u4_V3             := ""   // 
	u4_V4             := 1    // 
	
 	oPswPerfilAcesso := FwUserControl():New()
	                                            
	If oPswPerfilAcesso:LoadByName(Alltrim(u1_cCdUser))
		lFlagUser := .T.
	EndIf
	
// Objeto General

   If !lFlagUser   		
		oPswPerfilAcesso:oGeneral:cName 								:= u1_cCdUser								// Login do Usuario
//		oPswPerfilAcesso:oGeneral:cPassword							:= 											// Nova Senha
		oPswPerfilAcesso:oGeneral:cFullName 						:= u1_cNomeC								// Nome Completo
//		oPswPerfilAcesso:oGeneral:aOldPassWord	  					:= 											// Senha Antiga
		oPswPerfilAcesso:oGeneral:dValidate		 					:= u1_dDtValid								// Data Validae da Senha
		oPswPerfilAcesso:oGeneral:nNumVezExpirar 					:= u1_nQtdExpira							// Numero de Vezes para Expirar
		oPswPerfilAcesso:oGeneral:lChangePassW	  					:= u1_lAutAltSenha						// Usu�rio autorizado a alterar senha
		oPswPerfilAcesso:oGeneral:lChangeNextLogin				:= u1_lAltSenhaLogon	 					// For�a trocar a senha no proximo login
		oPswPerfilAcesso:oGeneral:nNumAcesSim	  					:=	u1_nAcessoSim							// N�mero de acessos simult�neos do usu�rio
		oPswPerfilAcesso:oGeneral:lUserBlock	  					:= u1_lUsuBloqueio						// Usu�rio bloqueado
		oPswPerfilAcesso:oGeneral:nNumDigitosAno 					:= u1_nDigAno								// N�mero de d�gitos para o ano
		oPswPerfilAcesso:oGeneral:lListLigacoes  					:= u1_lListner								// Listner de liga��es
	//	oPswPerfilAcesso:oGeneral:cLogOpSistema  					:= 
	//	oPswPerfilAcesso:oGeneral:cGlbNivel							:= 
	//	oPswPerfilAcesso:oGeneral:cCampos26							:= 
	//	oPswPerfilAcesso:oGeneral:dExpUsr							:= 
	//	oPswPerfilAcesso:oGeneral:cTOTVSUPUS						:= 
	//	oPswPerfilAcesso:oGeneral:cTOTVSUPPS						:= 
	//	oPswPerfilAcesso:oGeneral:aAudit								:= 
		oPswPerfilAcesso:oGeneral:dDtaInclusao						:= dDataBase								// Data da Inclusao do Registros
		
// Objeto Detalhe
		oPswPerfilAcesso:oDetail:aHoraAcesso						:= u2_aHorario								// Vetor de Horarios dos Acessos
//		oPswPerfilAcesso:oDetail:nIdoma								:= u2_nIdioma								// Idioma Padrao
		oPswPerfilAcesso:oDetail:cDiretorio							:= u2_cDiretorio							// Diretorio Padrao de Impressao
		oPswPerfilAcesso:oDetail:cDriveImpresora					:= u2_cDriveImp							// Drive impressora
		oPswPerfilAcesso:oDetail:cAcessos							:= u2_cAcesso								// Acesso	
		oPswPerfilAcesso:oDetail:cPontoEntrada						:= u2_cPontoEnt							// Ponto de entrada
		oPswPerfilAcesso:oDetail:nTipoImpressao					:= u2_nTipoImpr							// Tipo de impress�o
		oPswPerfilAcesso:oDetail:nFormato							:= u2_nFormato								// Formato
		oPswPerfilAcesso:oDetail:nAmbiente							:= u2_nAmbiente							// Ambiente
		oPswPerfilAcesso:oDetail:lPrioConfGrupo					:= u2_lPrioridade							// Prioridade para configura��o do grupo/perfil
		oPswPerfilAcesso:oDetail:cOpcaoImpresao					:= u2_cOpcaoImp							// Op��o de imprees�o
		oPswPerfilAcesso:oDetail:lAcessOtherDir					:= u2_lAcOutDirImp						// Acesso a outros diret�rios de impress�o	
		
		oPswPerfilAcesso:SetDefaultM()
		
	EndIf
	
	oPswPerfilAcesso:aMenu						:= gArrayXNU()						  		// Array com os Menus dos Usuarios
	
	oPswPerfilAcesso:oGeneral:cIdSuperior	 						:= '' //u1_cIdSuper						// ID do superior do usu�rio
	oPswPerfilAcesso:oGeneral:cDepartamento 						:= u1_cDepart			  					// Departamento do Usuario
	oPswPerfilAcesso:oGeneral:cCargo			 						:= u1_cCargo            		      // Cargo do Usuario
	oPswPerfilAcesso:oGeneral:cEmail			 						:= u1_cEmail			  					// Email do Usuario
	oPswPerfilAcesso:oGeneral:dDtaLastChange						:= u1_dDtUltAlt							// Data da �ltima altera��o
	oPswPerfilAcesso:oGeneral:cRamal									:= u1_cRamal					   		// Telefone do usu�rio
	
// Objeto General - Funcional
//		oPswPerfilAcesso:oGeneral:oUserFuncional:cEmpresa		:= 											// Empresa onde esta Locado
//		oPswPerfilAcesso:oGeneral:oUserFuncional:_cFilial		:= 											// Filial onde esta Locado
//		oPswPerfilAcesso:oGeneral:oUserFuncional:cMatricula	:= 											// Matricula 

// Objeto General - Informa��es do Usuario
		
	oPswPerfilAcesso:oGeneral:oUserInfo:lAlterData				:= u1_aRetAvDias[1]				 		// Se pode Alterar data
	oPswPerfilAcesso:oGeneral:oUserInfo:nDiasRetrocede			:= Int(u1_aRetAvDias[2])			   // Qtde de Retorcedes
	oPswPerfilAcesso:oGeneral:oUserInfo:nDiasAvanca				:= Int(u1_aRetAvDias[3])				// Qtde de Avan�o
			
	oPswPerfilAcesso:oDetail:aEmpresas								:= u2_aEmpresas							// Chamada a fun��o para para montar vetor com as empresas acessadas	
	
// Array com as Informa�oes dos Grupos e Inclusao do Grupo Perfil de usuario	
	If Len(u1_aGrupo) # 0
		If aScan(u1_aGrupo,{ |Z|  "9807" == Z }) == 0
			aadd(u1_aGrupo,"9807")  // Inclusao do Usuario
			aadd(u1_aGrupo,"0620")	// Inclusao Solicitante de RD
		EndIf
		
		For x := 1 To Len(u1_aGrupo)					
			nPos := aScan(aAllGruposPerfil,{ |Z| u1_aGrupo[x] $ Z[1][2] } )
			If nPOS # 0
				AADD( aGrupos, aAllGruposPerfil[nPos][1][1] )
			EndIf
		Next x
	EndIf
	
	oPswPerfilAcesso:oGeneral:aGroups		:= aGrupos	
		
// Objeto SenhaAP
//		oPswPerfilAcesso:oSenhaAP:lUserSenhaAP 					:=
//		oPswPerfilAcesso:oSenhaAP:cSerie								:=
//		oPswPerfilAcesso:oSenhaAP:cChave								:=
//		oPswPerfilAcesso:oSenhaAP:cSequencia						:=
		
// Array com as informa�oes do Paniel de Gestao    
//		oPswPerfilAcesso:aPainelGestao								:= 

// Array com as informa�oes dos Indicadores
//		oPswPerfilAcesso:aIndicadores									:= 

// Array com as informa�oes dos PassWords Temporarios
//		oPswPerfilAcesso:aTempPassWord								:= 

// Faz a Grava��o dos Dados do Usuario	

	// Objeto Control
	
 	oPswPerfilAcesso:SaveUser()
 	
 	FreeObj(oPswPerfilAcesso)
 						
	RecLock("ZZE",.F.)
	ZZE->ZZE_CDUSU := u1_cUsrId
	ZZE->ZZE_IDUSU := u1_cCdUser
	ZZE->(MsUnlock())
	
	If !"*" $ ZZE->ZZE_EMPREG	
		cQuery := "  Update SRA" + SubStr(ZZE->ZZE_EMPREG,1,2) + "0 "
		cQuery += "  Set RA_IDUSU   = '" + ZZE->ZZE_CDUSU  + "'" 
		cQuery += "  Where RA_MAT   = '" + ZZE->ZZE_MATUSU + "'"
		
		If (TCSQLExec(cQuery) < 0)
 			Conout("TCSQLError() " + TCSQLError())
	   EndIf
   EndIf
   
	Arq1Acess(u1_cUsrId,u1_cCdUser,u1_cNomeC,u1_aGrupo)  // chamada a fun��o que atualiza arquivo do 1o. acesso aos m�dulo criticos     
	
Return 

****************************************************************************************************************************************************

Static Function gArrayXNU
	Local aMenu
	Local cFiltro
	Local aIndex := {}
	
	DbSelectArea("ZZF")
	cFiltro := ZZF->(DbFilter())
	ZZF->(DbClearFilter())

	aMenus := oPswPerfilAcesso:aMenu
	
	For x := 1 To Len(aMenus)
		
		DbSelectArea("ZZF")
		ZZF->(DbSetOrder(2))
		
		If !ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+SubStr(aMenus[x],1,2)))
			aMenus[x] := SubStr(aMenus[x],1,2)+"X"+SubStr(aMenus[x],4)
			Loop
		EndIf
		
		DbSelectArea("ZZC") 
		ZZC->(DbSetOrder(1))
				
		Do While ZZF->ZZF_NUM	== ZZE->ZZE_NUMSOL			.And. ;
					ZZF->ZZF_CDMOD == SubStr(aMenus[x],1,2)	.And. ;
					ZZF->(!Eof())
				
			If ZZF->ZZF_STATC # "1"
				aMenus[x] := SubStr(aMenus[x],1,2)+"X"+SubStr(aMenus[x],4)			
				ZZF->(DbSkip())
				Loop
			EndIf
				
			If ZZC->(DbSeek(xFilial("ZZC")+ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF))
				aMenus[x] := SubStr(aMenus[x],1,2)+ZZF->ZZF_NIVEL+AllTrim(ZZC->ZZC_XNU)
			EndIf
				
			ZZF->(DbSkip())
				
		EndDo
			
	Next x
	
	If ZZC->(DbSeek(xFilial("ZZC")+"9807"))   // Inclusao do Usuario
		nPos := aScan(aMenus,{|Z| "98" $ Z })
		aMenus[nPOS] := SubStr(aMenus[nPOS],1,2)+"5"+AllTrim(ZZC->ZZC_XNU)
	EndIf 
	
	If ZZC->(DbSeek(xFilial("ZZC")+"0620"))   // Inclusao do Solicitante de RD
		nPos := aScan(aMenus,{|Z| "06" $ Z })
		aMenus[nPOS] := SubStr(aMenus[nPOS],1,2)+"5"+AllTrim(ZZC->ZZC_XNU)
	EndIf
	
	Eval({ || FilBrowse("ZZF",@aIndex,@cFiltro) })
	
Return(aMenus)  // retorno da fun��o 

****************************************************************************************************************************************************

Static Function gArrayEmp() // fun��o para para montar vetor com as empresas acessadas

	u2_aEmpresas := {}
	gCdEmpresas  := AllTrim(ZZE->ZZE_EMP)
	
	For nG := 1 To Len(gCdEmpresas)            
		If Len(gCdEmpresas) > 0
			nPosF := At(",",gCdEmpresas) 
			If nPosF > 0
				gCdEmpFil := SubStr(gCdEmpresas,1,4)  // c�digo da empresa/filial
			Else
				gCdEmpFil := SubStr(gCdEmpresas,Len(gCdEmpresas)-4,4)  // c�digo da empresa/filial
				gCdEmpresas	:= ""
			EndIf	
			gCdEmpresas	:= SubStr(gCdEmpresas,nPosF+1,Len(gCdEmpresas))	
		Else
			Exit
		EndIf			
		Aadd(u2_aEmpresas,gCdEmpFil)
	Next

Return u2_aEmpresas  // retorno da fun��o
****************************************************************************************************************************************************

Static Function gChkUser(g_cID,g_cCDUSER)  // fun��o que recupera o ID e o c�digo do usu�rio
//g_cID     = "ID"          -> para retornar o ID do usu�rio
//g_cID     = ID do usu�rio -> para retornar o c�digo do usu�rio 
//g_cCDUSER = Nome do usu�rio

	If g_cID == "ID"  // se retorna o ID do usu�rio
		g_cUser := StrZero(Val(aAllUserPerfil[Len(aAllUserPerfil)][1][1])+1,6)  // ID do usu�rio
		For lN := 1 To Len(aAllUserPerfil)  // percorre arquivo de usu�rios
			If Upper(AllTrim(aAllUserPerfil[lN][1][4])) == Upper(AllTrim(ZZE->ZZE_NMUSU))  // verifica exist�ncia do usu�rio
				g_cUser := aAllUserPerfil[lN][1][1]  // ID do usu�rio             
				Exit  // aborta loop
			EndIf
		Next
	Else  // se retorna o c�digo do usu�rio
		PSWORDER(1)  // muda ordem de �ndice
		If PswSeek(g_cID) == .T. .And. ZZE->ZZE_UHOMO == "N"  // se encontrar usu�rio no arquivo e n�o for hom�nimo
			aArray  := PSWRET()      // vetor dados do usu�rio
			g_cUser := aArray[1][2]  // Retorna o c�digo do usu�rio
		Else                     
			If ZZE->ZZE_UHOMO == "S"  // se usu�rio hom�nimo
				u1_cUsrId := StrZero(Val(aAllUserPerfil[Len(aAllUserPerfil)][1][1])+1,6)  // ID do usu�rio
			EndIf
			
			g_cCDUSER := StrTran(g_cCDUSER,"."," ")
			
			g_1Nome := SubStr(g_cCDUSER,1,At(" ",g_cCDUSER)-1)  // primeiro nome
			For Ln := Len(g_cCDUSER) To 1 Step -1
				If SubStr(g_cCDUSER,Ln,1) == " " .Or. Empty(SubStr(g_cCDUSER,Ln,1))
					g_2Nome := SubStr(g_cCDUSER,Ln+1,Len(g_cCDUSER))
					Exit
				EndIf
			Next
			g_cUser := SubStr(g_1Nome+"."+g_2Nome,1,25)
			PSWORDER(2)  // muda ordem de �ndice
			nCont := 0  // contador de nomes
			Do While .T.  // loop enquanto verdadeiro
				If PswSeek(g_cUser) == .F.  // se n�o encontrar usu�rio no arquivo
					Exit  // aborta loop
				Else	            
					nCont := nCont + 1  // contador de nomes				
					If nCont <= 9  // se considerar 2 digitos                            
						g_cUser := AllTrim(SubStr(g_cUser,1,24))+StrZero(nCont,1)					
					Else
						g_cUser := AllTrim(SubStr(g_cUser,1,23))+StrZero(nCont,2)
					EndIf	
				EndIf		
			EndDo
		EndIf
		g_cUser := AllTrim(g_cUser)+Space(25-Len(g_cUser))
		
	EndIf

Return g_cUser  // retorno da fun��o     
****************************************************************************************************************************************************
 
Static Function Arq1Acess(u1_cUsrId,u1_cCdUser,u1_cNomeC,u1_aGrupo)  // fun��o que atualiza arquivo do 1o. acesso aos m�dulo criticos
	// u1_cUsrId  => ID do usu�rio
	// u1_cCdUser => C�digo do usu�rio
	// u1_cNomeC  => Nome do usu�rio
	// u1_aGrupo  => Perfil de acesso
	
	aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos
	
	For gLn := 1 To Len(u1_aGrupo)
		gcCdMod   := SubStr(u1_aGrupo[gLn],1,2)
		gcDescMod := aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3]  // recupera descri��o do m�dulo			
		
		DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
		ZZJ->(DbSetOrder(2))  // muda ordem do �ndice
		If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona ponteiro
			If ZZJ->ZZJ_MODCRI == "S"  // se m�dulo critico
			
				DbSelectArea("ZZK")  // seleciona arquivo de 1o. acesso aos m�dulos criticos
				ZZK->(DbSetOrder(2))  // muda ordem do �ndice
				If ZZK->(!DbSeek(xFilial("ZZK")+u1_cUsrId+gcCdMod))  // posiciona ponteiro
					RecLock("ZZK",.T.)  // se bloquear registro
					ZZK->ZZK_FILIAL := xFilial("ZZK")  // c�digo da filial
					ZZK->ZZK_IDUSU  := u1_cUsrId       // ID do usu�rio
					ZZK->ZZK_CDUSU  := u1_cCdUser      // c�digo do usu�rio
					ZZK->ZZK_NMUSU  := u1_cNomeC       // nome do usu�rio
					ZZK->ZZK_CDMOD  := gcCdMod         // c�digo do m�dulo
					ZZK->ZZK_DSMOD  := gcDescMod       // descri��o do m�dulo
					MsUnLock()  // libera registro bloqueado    			
				EndIf		
			
		    EndIf
		EndIf
	Next

Return  // retorno da fun��o
