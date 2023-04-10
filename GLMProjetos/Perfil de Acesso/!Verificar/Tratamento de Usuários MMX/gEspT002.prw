/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspT002 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspT002 � Autor � George AC. Gon�alves � Data � 11/01/09  ���
���          � gArrayXNU� Autor � George AC. Gon�alves � Data � 11/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa atualiza��o(INC/ALT) de perfil de acesso (Grupo)  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada ap�s a confirma��o do m�dulo/perfil-Rotina: gCADZZC���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEspT002()  // Processa atualiza��o (inclus�o/altera��o) de perfil de acesso (Grupo)

	Local lIncGrupos  := .T.
	Local cNameGrupo	:= SubStr(M->ZZC_CDMOD+M->ZZC_CDPERF+"-"+M->ZZC_DSPERF,1,28)

	Private oGroup		:= FwGrpControl():New()
	
	Public aAllGruposPerfil := {}
	
	If oGroup:LoadByName(cNameGrupo)
		lIncGrupos := .F.
	EndIf
	
	If lIncGrupos	
		oGroup:SetDefaultM()
  		oGroup:oGeneral:aEmpresas	:= gArrayEmp()
		oGroup:oGeneral:cName		:= cNameGrupo
		oGroup:aMenu 					:= gArrayXNU()
/*
		oGroup:oGeneral:aHoraAcesso
		
		oGroup:oGeneral:cAcessos			:= gArrayEmp()
		oGroup:oGeneral:cDiretorio			:= "\SPOOL\"
		oGroup:oGeneral:cDriveImpressora	:= "EPSON.DRV"
		oGroup:oGeneral:cGlbNivel			:= 
		oGroup:oGeneral:cId
		oGroup:oGeneral:cOpcaoImpressao
		oGroup:oGeneral:dDtaInclusao
		oGroup:oGeneral:dDtaLastChange
		oGroup:oGeneral:dValiDate
		
		oGroup:oGeneral:lAcessoTherDir
		oGroup:oGeneral:lChangePassw
		oGroup:oGeneral:nAmbiente
		oGroup:oGeneral:nFormato
		oGroup:oGeneral:nIdioma
		oGroup:oGeneral:nNumVezExpirar
		oGroup:oGeneral:nTipoImpressao
		
		oGroup:oGrpInfo:lAlterData
		oGroup:oGrpInfo:nDiasAvanca
		oGroup:oGrpInfo:nDiasRetrocede
		
		oGroup:aPainelGestao
		oGroup:aIndicadores
		oGroup:aTempPassWord
*/
	Else
		nPos 						:= aScan(oGroup:aMenu,{ |x| M->ZZC_CDMOD == SubStr(X,1,2) })
		oGroup:aMenu[nPOS]	:= SubStr(oGroup:aMenu[nPOS],1,3)+AllTrim(M->ZZC_XNU)
	EndIf
	
	oGroup:SaveGroup()	
	FreeObj(oGroup)
	
	aAllGruposPerfil	:= AllGroups()
	
Return

****************************************************************************************************************************************************

Static Function gArrayXNU()

	Declare g2_aMenus[ Len(oGroup:aMenu) ]
	
	For Ln := 1 To Len(oGroup:aMenu)
	
		g2_aMenus[Ln] := IIf( M->ZZC_CDMOD == SubStr(oGroup:aMenu[Ln],1,2),;
									 SubStr(oGroup:aMenu[Ln],1,2)+"5"+AllTrim(M->ZZC_XNU),;
									 SubStr(oGroup:aMenu[Ln],1,2)+"X"+AllTrim(SubStr(oGroup:aMenu[Ln],4)) )	
	Next
	
Return g2_aMenus
****************************************************************************************************************************************************

Static Function gArrayEmp() // fun��o para para montar vetor com as empresas acessadas

	Local u2_aEmpresas := {}
	
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())
	
	Do While SM0->(!Eof())
		Aadd(u2_aEmpresas,SM0->M0_CODIGO+SM0->M0_CODFIL)                  
		SM0->(DbSkip())
	EndDo

Return(u2_aEmpresas)