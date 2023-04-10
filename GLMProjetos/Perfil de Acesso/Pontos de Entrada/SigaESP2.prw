/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � SigaESP2 � Autor � George AC Gon�alves  � Data � 04/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � SigaESP2 � Autor � George AC Gon�alves  � Data � 30/06/09  ���
���          � gWFGestor� Autor � George AC. Gon�alves � Data � 30/06/09  ���
���          � gWFCtrl  � Autor � George AC. Gon�alves � Data � 30/06/09  ���
���          � gWFAutit � Autor � George AC. Gon�alves � Data � 30/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Identifica 1o. acesso do usu�rio ao m�dulo de ESPEC�FICOS 2���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inicializa��o do projeto                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function SigaESP2()  // Identifica 1o. acesso do usu�rio ao m�dulo de ESPEC�FICOS 2

cArea := GetArea()          
cAreaZZK := ZZK->(GetArea())
cAreaZZI := ZZI->(GetArea())
cAreaZZJ := ZZJ->(GetArea())
                                                                        
Public cTo       // para
Public cBody     // mensagem
Public cSubject  // t�tulo
Public cAnexo    // anexo 
Public aModAnexo := {}  // array dos m�dulos para anexo

Public gcCdMod := "96"  // C�digo do m�dulo de espec�ficos 2                   

DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
ZZJ->(DbSetOrder(2))  // muda ordem do �ndice
If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona regsitro
	If ZZJ->ZZJ_MODCRI == "S"  // se m�dulo critico

		DbSelectArea("ZZK")  // seleciona arquivo de 1o. acesso aos m�dulos criticos
		ZZK->(DbSetOrder(2))  // muda ordem do �ndice
		If ZZK->(DbSeek(xFilial("ZZK")+SubStr(cUsuario,7,15)+gcCdMod))  // posiciona ponteiro
			If ZZK->ZZK_1ACESS <> "S"  // se 1o. acesso do usu�rio ao m�dulo
				RecLock("ZZK",.F.)  // se bloquear registro
				ZZK->ZZK_1ACESS := "S"        // 1o. acesso do usu�rio ao m�dulo
				ZZK->ZZK_DT1ACE := dDataBase  // data do 1o. acesso do usu�rio ao m�dulo
				ZZK->ZZK_HR1ACE := TIME()     // hora do 1o. acesso do usu�rio ao m�dulo				
				MsUnLock()  // libera registro bloqueadO

				cAnexo := gWFGestor(gcCdMod,ZZK->ZZK_IDUSU,ZZK->ZZK_NMUSU,ZZK->ZZK_DT1ACE,ZZK->ZZK_HR1ACE)  // chamada a fun��o de montagem do workflow para gestores
				U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
		
				cAnexo := gWFCtrl(gcCdMod,ZZK->ZZK_IDUSU,ZZK->ZZK_NMUSU,ZZK->ZZK_DT1ACE,ZZK->ZZK_HR1ACE)  // chamada a fun��o de montagem do workflow para controllers
				U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
		
				cAnexo := gWFAudit(gcCdMod,ZZK->ZZK_IDUSU,ZZK->ZZK_NMUSU,ZZK->ZZK_DT1ACE,ZZK->ZZK_HR1ACE)  // chamada a fun��o de montagem do workflow para auditoria interna
				U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow				
											
			EndIf	
		EndIf		
		
	EndIf
EndIf		

ZZJ->(RestArea(cAreaZZJ))
ZZI->(RestArea(cAreaZZI))
ZZK->(RestArea(cAreaZZK))
RestArea(cArea)
			
Return  // Retorno da Fun��o 
***************************************************************************************************************************************************

Static Function gWFGestor(gcCdMod,gcIDUsu,gcNmUsu,gdDt1Acess,gcHr1Acess)  // fun��o de montagem do workflow para gestores
//gcCdMod = C�digo do m�dulo             
//gcIDUsu    = ID do usu�rio
//gcNmUsu    = Nome do usu�rio                                            
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo    := {}                                                                       // array dos m�dulos para anexo             
aDescModulos := RetModName(.T.)                                                          // array com os dados dos m�dulos
cDescMod     := AllTrim(aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3])  // recupera descri��o do m�dulo		
		
DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
ZZJ->(DbSetOrder(2))  // muda ordem do �ndice
If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona regsitro
     
	cTo := ""  // Destinat�rio do envio do workflow para o gestor
	DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
	ZZI->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZI->(DbSeek(xFilial("ZZI")+ZZJ->ZZJ_GESTOR))  // posiciona regsitro
		cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
	EndIf
                                                     
	cSubject := "1o. acesso ao m�dulo de "+cDescMod+" pelo usu�rio "+AllTrim(gcNmUsu)+"."  // Assunto da mensagem
	cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
	cBody    := U_gEWF005(cSubject,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // chamada a fun��o de montagem da mensagem para workflow	

// ;	_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

    _aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

	For Ln1 := 1 To Len(aModAnexo)         
		gCdMod  := SubStr(aModAnexo[Ln1],1,2)                                
		gCdPerf := SubStr(aModAnexo[Ln1],3,2)		
		For Ln2 := 1 To Len(_aArquivos)         	
			If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
				cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
			EndIf	
		Next	
	Next	                                                                                

	aAnexo[1] := cAnexo                                            
                            
EndIf

Return aAnexo[1]  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFCtrl(gcCdMod,gcIDUsu,gcNmUsu,gdDt1Acess,gcHr1Acess)  // fun��o de montagem do workflow para controllers
//gcCdMod = C�digo do m�dulo             
//gcIDUsu    = ID do usu�rio
//gcNmUsu    = Nome do usu�rio                                            
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo    := {}                                                                       // array dos m�dulos para anexo                          
aDescModulos := RetModName(.T.)                                                          // array com os dados dos m�dulos
cDescMod     := AllTrim(aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3])  // recupera descri��o do m�dulo		

gcCtrl := U_gVEsp011()  // Recupera ID do Controller da Empresa
     
cTo := ""  // Destinat�rio do envio do workflow para o gestor
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(4))  // muda ordem do �ndice
If ZZI->(DbSeek(xFilial("ZZI")+gcCtrl))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf
                                                     
cSubject := "1o. acesso ao m�dulo de "+cDescMod+" pelo usu�rio "+AllTrim(gcNmUsu)+"."  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF005(cSubject,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // chamada a fun��o de montagem da mensagem para workflow	

// _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)                                
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)		
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

aAnexo[1] := cAnexo                                            
	
Return aAnexo[1]  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFAudit(gcCdMod,gcIDUsu,gcNmUsu,gdDt1Acess,gcHr1Acess)  // fun��o de montagem do workflow para auditoria interna
//gcCdMod = C�digo do m�dulo             
//gcIDUsu    = ID do usu�rio
//gcNmUsu    = Nome do usu�rio                                            
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo    := {}                                                                       // array dos m�dulos para anexo                                       
aDescModulos := RetModName(.T.)                                                          // array com os dados dos m�dulos
cDescMod     := AllTrim(aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(gcCdMod)})][3])  // recupera descri��o do m�dulo		
		
cTo      := GetMV('MV_EAUDINT')  // Destinat�rio do envio do workflow para o helpdesk                                                     
cSubject := "1o. acesso ao m�dulo de "+cDescMod+" pelo usu�rio "+AllTrim(gcNmUsu)+"."  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF005(cSubject,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // chamada a fun��o de montagem da mensagem para workflow	

// _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)                                
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)		
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se m�dulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

aAnexo[1] := cAnexo                                            
	
Return aAnexo[1]  // retorno da fun��o