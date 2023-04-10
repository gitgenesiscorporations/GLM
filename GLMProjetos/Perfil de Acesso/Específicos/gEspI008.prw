/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspI008 � Autor � George AC. Gon�alves � Data � 25/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspI008 � Autor � George AC. Gon�alves � Data � 25/06/09  ���
���          � gWFGestor� Autor � George AC. Gon�alves � Data � 25/06/09  ���
���          � gWFCtrl  � Autor � George AC. Gon�alves � Data � 25/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Reenvio da Solicita��o de Perfil de Acesso                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Sele��o da op��o reenvio de solicita��o - Rotina gEspM010  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gEspI008()  // Reenvio da Solicita��o de Perfil de Acesso

Public cTo              // para
Public cBody            // mensagem
Public cSubject         // t�tulo
Public cAnexo           // anexo
Public aModAnexo := {}  // array dos m�dulos para anexo

Public gcNumSol := ZZE->ZZE_NUMSOL  // N�mero da solicita��o

DBSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // busca a linha da getdados

//��������������������������������������������������������������Ŀ
//� Opcoes de acesso para a Modelo 3                             �
//����������������������������������������������������������������
cOpcao := "ALTERAR"
nOpcE  := 2
nOpcG  := 2
N      := 1

//��������������������������������������������������������������Ŀ
//� Cria variaveis M->????? da Enchoice                          �
//����������������������������������������������������������������
RegToMemory("ZZE",(cOpcao=="INCLUIR"))

//��������������������������������������������������������������Ŀ
//� Cria aHeader e aCols da GetDados                             �
//����������������������������������������������������������������
nUsado  := 0
aHeader := {}

DbSelectArea("SX3")  // Seleciona arquivo de dicion�rio de dados
SX3->(DbSeek("ZZF"))  // Posiciona registro - arquivo ZZF
Do While SX3->(!Eof()) .And. SX3->x3_arquivo == "ZZF"  // percorre registro enquanto o arquivo for o ZZF
	If Alltrim(SX3->x3_campo) == "ZZF_FILIAL" .Or. Alltrim(SX3->x3_campo) == "ZZF_NUM"
		sx3->(DbSkip())  // incrementa contador de registro
		Loop  // pega pr�ximo registro
	EndIf	
	If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel  // se campo em uso e o n�vel do usu�rio permite visualiza��o
    	nUsado := nUsado+1
        Aadd(aHeader, {AllTrim(SX3->x3_titulo),;
                       SX3->x3_campo,;
                       SX3->x3_picture,;
	                   SX3->x3_tamanho,;
	                   SX3->x3_decimal,;
	                   "AllwaysTrue()",;
    	               SX3->x3_usado,;
    	               SX3->x3_tipo,;
    	               SX3->x3_arquivo,;
    	               SX3->x3_context})
	EndIf
	    SX3->(DbSkip())  // incrementa contador de regsitro    
EndDo

aCols := {}
DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do �ndice
If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
	Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
		AADD(aCols,Array(nUsado+1))
		For _ni := 1 To nUsado
			aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
		Next 
		aCols[Len(aCols),nUsado+1]:=.F.
		ZZF->(DbSkip())  // incrementa contador de registro
	EndDo   
EndIf

If Len(aCols) > 0
	//��������������������������������������������������������������Ŀ
	//� Executa a Modelo 3                                           �
	//����������������������������������������������������������������
	cTitulo        := cCadastro
	cAliasEnchoice := "ZZE"
	cAliasGetD     := "ZZF"
	cLinOk         := "AllwaysTrue()"
	cTudOk         := "AllwaysTrue()"
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"ZZE_NUMSOL"}

	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	//��������������������������������������������������������������Ŀ
	//� Executar processamento                                       �
	//����������������������������������������������������������������
	If _lRet  // se confirma grava��o                                                                  

		DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
		ZZF->(DbSetOrder(3))  // muda ordem do �ndice
		If ZZF->(DbSeek(xFilial("ZZF")+M->ZZE_NUMSOL))  // posiciona registro
			Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == M->ZZE_NUMSOL  // percorre o arquivo no intervalo
			    
				If ZZF->ZZF_STATG <> "1"  // se solicita��o ainda n�o aprovada pelo gestor
					RecLock("ZZF",.F.)  // se bloquear registro
					ZZF->ZZF_DTENVG := dDataBase  // data de envio ao gestor
					ZZF->ZZF_HRENVG := TIME()     // hora de envio ao gestor					
					MsUnLock()  // libera registro bloqueado    				
                          
					cAnexo    := gWFGestor(ZZF->ZZF_GESTOR,ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF+ZZF->ZZF_NIVEL+",")  // chamada a fun��o de montagem do workflow para aprova��o dos gestores
					U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
					DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
					ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		   			If ZZE->(DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se n�o existir registro de solicita��o      
						RecLock("ZZE",.F.)  // se bloquear registro
						ZZE->ZZE_STATUS := "2"  // status da solicita��o: 2-Aguardando Aprova��o
						MsUnLock()  // libera registro bloqueado    
		 			EndIf
	            ElseIf ZZF->ZZF_STATG == "1" .And. ZZF->ZZF_STATC <> "1"  // se aprovada pelo gestor e ainda n�o aprovado pelo controller                                                  				
					cAnexo := gWFCtrl(ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF+ZZF->ZZF_NIVEL+",")  // chamada a fun��o de montagem do workflow para aprova��o do controller
					If U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow  
						RecLock("ZZF",.F.)  // se bloquear registro					
						ZZF->ZZF_DTENVC := dDataBase  // status do retorno da aprova��o do gestor
						ZZF->ZZF_HRENVC := Time()     // status do retorno da aprova��o do gestor								
						MsUnLock()  // libera registro bloqueado    						
					EndIf
				EndIf	
				ZZF->(DbSkip())  // incrementa contador de registro		
				
			EndDo

	 	EndIf	
	 	
	Else 
		RollBackSX8("ZZE","ZZE_NUMSOL")  // se n�o confirmou volta a numera��o sequencial do arquivo de solicita��o
	Endif
	
Endif

Return  // retorno da fun��o
***************************************************************************************************************************************************
Static Function gWFCtrl(gcModPerf)  // fun��o de montagem do workflow para aprova��o do controller
//gcModPerf = C�digos do(s) m�dulo(s)/perfil(is)
                                                
Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo

cTo := ""  // Destinat�rio do envio do workflow para o gestor

/*
PSWORDER(2)  // muda ordem de �ndice
If PswSeek(ZZE->ZZE_IDCTRL) == .T.  // se encontrar usu�rio no arquivo
	aArray  := PSWRET()      // vetor dados do usu�rio
	DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
	ZZI->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZI->(DbSeek(xFilial("ZZI")+aArray[1][1]))  // posiciona regsitro
		cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
	EndIf
EndIf
*/
         
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(4))  // muda ordem do �ndice
If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf            

If ZZE->ZZE_TIPO == "1"  // se novo usu�rio
	cSubject := "Solicita��o de aprova��o para inclus�o de perfil de acesso para o NOVO usu�rio: "+M->ZZE_NMUSU  // Assunto da mensagem
	cBody    := U_gEWF001(cSubject,.T.,"","G",gcGestor,.F.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
Else
	cSubject := "Solicita��o de aprova��o para altera��o de perfil de acesso para o usu�rio: "+M->ZZE_NMUSU  // Assunto da mensagem
	cBody    := U_gEWF004(cSubject,.T.,"","G",gcGestor,.T.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
EndIf		
///cBody    := U_gEWF001(cSubject,.F.,"","G","",.T.,.F.,.F.,gcModPerf,"2",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
                
// ;_aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	 

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

Static Function gWFGestor(gcGestor,gcModPerf)  // fun��o de montagem do workflow para aprova��o dos gestores
//gcGestor  = C�digo do gestor               
//gcModPerf = C�digos do(s) m�dulo(s)/perfil(is)

Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos m�dulos para anexo
     
cTo := ""  // Destinat�rio do envio do workflow para o gestor
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(1))  // muda ordem do �ndice
If ZZI->(DbSeek(xFilial("ZZI")+gcGestor))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf

cSubject := "Solicita��o de aprova��o para inclus�o de perfil de acesso para o NOVO usu�rio: "+M->ZZE_NMUSU  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","G",gcGestor,.T.,.F.,.F.,gcModPerf,"1",ZZE->ZZE_TIPO)  // chamada a fun��o de montagem da mensagem para workflow
                            
//  _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

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