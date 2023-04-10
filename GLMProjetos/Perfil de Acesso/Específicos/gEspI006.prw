/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspI006 � Autor � George AC. Gon�alves � Data � 22/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspI006 � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFHelpA � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFHelpE � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFCtrlC � Autor � George AC. Gon�alves � Data � 26/05/09  ���
���          � gWFGestor� Autor � George AC. Gon�alves � Data � 03/06/09  ���
���          � gWFUser  � Autor � George AC. Gon�alves � Data � 03/06/09  ���
���          � gWFARede � Autor � George AC. Gon�alves � Data � 03/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o no Bloqueio de Acesso do Usu�rio                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Sele��o da op��o bloqueio de usu�rio - Rotina gEspM008     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "tbiconn.ch"
#Include "Ap5Mail.ch"
#include "Topconn.ch"      

User Function gEspI006()  // Manuten��o no Bloqueio de Acesso de Usu�rio

Public cTo       // para
Public cBody     // mensagem
Public cSubject  // t�tulo
Public cAnexo    // anexo

//��������������������������������������������������������������Ŀ
//� Opcoes de acesso para a Modelo 3                             �
//����������������������������������������������������������������
cOpcao := "INCLUIR"
nOpcE  := 3
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
	If Alltrim(SX3->x3_campo) == "ZZF_FILIAL" .Or. Alltrim(SX3->x3_campo) == "ZZF_NUM"    .Or.;
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVG" .Or.;		          
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETG" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_STATG"  .Or. Alltrim(SX3->x3_campo) == "ZZF_OBSGES" .Or.;		   
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_STATC"  .Or. Alltrim(SX3->x3_campo) == "ZZF_OBSCON" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_TIPO"
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

aCols             := {Array(nUsado+1)}
aCols[1,nUsado+1] := .F.
For _ni := 1 To nUsado
	aCols[1,_ni] := CriaVar(aHeader[_ni,2])
Next

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
                              
	// recupera n�mero da solicita��o de acesso
	M->ZZE_NUMSOL := StrZero(Val(GetSX8NUM("ZZE","ZZE_NUMSOL"))+1,12)
	If Val(SubStr(M->ZZE_NUMSOL,1,4)) <> Val(SubStr(DToS(dDataBase),1,4))  
		M->ZZE_NUMSOL := SubStr(DToS(dDataBase),1,4)+"00000001"
	EndIf

	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	//��������������������������������������������������������������Ŀ
	//� Executar processamento                                       �
	//����������������������������������������������������������������
	If _lRet  // se confirma grava��o                                                                  
	
	    // grava arquivo de solicita��o de acesso - usu�rio
		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(!DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se n�o existir registro de solicita��o      
			RecLock("ZZE",.T.)  // se bloquear registro
			ZZE->ZZE_FILIAL := xFilial("ZZE")  // c�digo da filial
			ZZE->ZZE_NUMSOL := M->ZZE_NUMSOL   // n�mero da solicita��o
			ZZE->ZZE_DTSOL  := M->ZZE_DTSOL    // data da solicita��o
			ZZE->ZZE_HRSOL  := M->ZZE_HRSOL    // hora da solicita��o
			ZZE->ZZE_STATUS := "3"             // status da solicita��o: 3-Encerrada
			ZZE->ZZE_TIPO   := "3"             // tipo da solicita��o: 3-Bloqueio Perfil			
			ZZE->ZZE_CDSOL  := M->ZZE_CDSOL    // c�digo do usu�rio solicitante
			ZZE->ZZE_IDUSUS := M->ZZE_IDUSUS   // ID do usu�rio solicitante			
			ZZE->ZZE_MATSOL := M->ZZE_MATSOL   // matr�cula do solicitante
			ZZE->ZZE_NMSOL  := M->ZZE_NMSOL    // nome do usu�rio solicitante
			ZZE->ZZE_CDDEPT := M->ZZE_CDDEPT   // c�digo do departamento do solicitante
			ZZE->ZZE_DSDEPT := M->ZZE_DSDEPT   // descri��o do departamento do solicitante
			ZZE->ZZE_CDFUNC := M->ZZE_CDFUNC   // c�digo do cargo/fun��o do solicitante
			ZZE->ZZE_DSFUNC := M->ZZE_DSFUNC   // descri��o do cargo/fun��o do solicitante
			ZZE->ZZE_EMAILS := M->ZZE_EMAILS   // e-Mail do solicitante
			ZZE->ZZE_LOCAL  := M->ZZE_LOCAL    // localidade do solicitante
			ZZE->ZZE_TELSOL := M->ZZE_TELSOL   // telefone/ramal do solicitante
			ZZE->ZZE_CDUSU  := M->ZZE_CDUSU    // c�digo do usu�rio
			ZZE->ZZE_VFUNC  := M->ZZE_VFUNC    // vinculo funcional
			ZZE->ZZE_EMPPRE := M->ZZE_EMPPRE   // empresa prestadora do servi�o			
			ZZE->ZZE_MATUSU := M->ZZE_MATUSU   // matr�cula do usu�rio
			ZZE->ZZE_NMUSU  := M->ZZE_NMUSU    // nome do usu�rio
			ZZE->ZZE_USUSUP := M->ZZE_USUSUP   // c�digo de usu�rio do supervisor
			ZZE->ZZE_NMUSUP := M->ZZE_NMUSUP   // nome de usu�rio do supervisor
			ZZE->ZZE_CDDEPU := M->ZZE_CDDEPU   // c�digo do departamento do usu�rio       
			ZZE->ZZE_NMDEPU := M->ZZE_NMDEPU   // descri��o do departamento do usu�rio
			ZZE->ZZE_CDFUNU := M->ZZE_CDFUNU   // c�digo do cargo/fun��o do usu�rio
			ZZE->ZZE_DSFUNU := M->ZZE_DSFUNU   // decri��o do cargo/fun��o do usu�rio
			ZZE->ZZE_EMAILU := M->ZZE_EMAILU   // e-Mail do usu�rio
			ZZE->ZZE_LOCALU := M->ZZE_LOCALU   // localidade do usu�rio
			ZZE->ZZE_TELUSU := M->ZZE_TELUSU   // telefone/ramal do usu�rio
			ZZE->ZZE_EMP    := M->ZZE_EMP      // empresas
			ZZE->ZZE_CTRL   := M->ZZE_CTRL     // controller
			ZZE->ZZE_IDCTRL := M->ZZE_IDCTRL   // ID do controller			                    
			ZZE->ZZE_DTENC  := dDataBase       // data de encerramento da solicita��o
			ZZE->ZZE_HRENC  := TIME()          // hora de encerramento da solicita��o				  
			ZZE->ZZE_DTIBLQ := M->ZZE_DTIBLQ   // data de in�cio do bloqueio
			ZZE->ZZE_DTFBLQ := M->ZZE_DTFBLQ   // data de t�rmino do bloqueio
			ZZE->ZZE_MOTBLQ := M->ZZE_MOTBLQ   // motivo do bloqueio		       
			ZZE->ZZE_IDUSU  := M->ZZE_IDUSU    // C�digo do usu�rio
			ZZE->ZZE_SOLIC  := "06"            // 01=Solicita��o de perfil de acesso;02=Altera��o de cargo/fun��o;03=Transfer�ncia departamental;04=Transfer�ncia entre empresas/filias;05=Transfer�ncia entre SA�s;06=Bloqueio de usu�rio;07=Desligamento de usu�rio;08=Desbloqueio de acesso;09=Reinicializa��o de senha;10=Sele��o de ambiente/empresa;
			MsUnLock()  // libera registro bloqueado    
			ConfirmSX8("ZZE","ZZE_NUMSOL")  // grava n�mero da solicita��o de acesso			
 		EndIf

		gGestorAnt := ""   // gestor anterior
		
	    // grava arquivo de solicita��o de acesso - perfil
		DBSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
		ZZF->(DbSetOrder(1))  // muda ordem do �ndice
		
		For n1 := 1 To Len(aCols)  // linhas  	          
			cSeqOa := aCols[n1,Ascan(aHeader,{|x|alltrim(x[2])=="ZZF_ITEM"})]  // busca as sequencias das linhas da getdados para procura na linha abaixo
			If ZZF->(!DbSeek(xFilial("ZZF")+M->ZZE_NUMSOL+cSeqOa ))  // busca a linha da getdados
				// Se � uma linha nova inclui a linha no arquivo
				RecLock("ZZF",.T.)  // trava o arquivo e inclui uma linha em branco para a inclusao dos dados novos
				For n2 := 1 To Len(aHeader)  // Colunas
					If aCols[n1,Len(aCols[n1])] == .F.  // se linha n�o deletada
						FieldPut(FieldPos(aHeader[n2,2]),aCols[n1,n2])              
					EndIf
				Next 	        
				ZZF->ZZF_FILIAL := xFilial("ZZF")  // c�digo da filial
				ZZF->ZZF_NUM    := M->ZZE_NUMSOL   // n�mero da solicita��o
				ZZF->ZZF_ITEM   := StrZero(n1,2)   // grava sequencia      
				ZZF->ZZF_TIPO   := "3"             // tipo da solicita��o: 3-Bloqueio Perfil							
				MsUnlock()	        

				DbSelectArea("ZZH")  // seleciona arquivo de log de movimenta��o de perfil
				RecLock("ZZH",.T.)  // se bloquear registro
				ZZH->ZZH_FILIAL := xFilial("ZZE")    // c�digo da filial
				ZZH->ZZH_NUMSOL := ZZE->ZZE_NUMSOL   // n�mero da solicita��o
				ZZH->ZZH_DTMOV  := dDataBase         // data da movimenta��o
				ZZH->ZZH_CDSOL  := ZZE->ZZE_CDSOL    // c�digo do usu�rio solicitante
				ZZH->ZZH_NMSOL  := ZZE->ZZE_NMSOL    // nome do usu�rio solicitante
				ZZH->ZZH_CDUSU  := ZZE->ZZE_CDUSU    // c�digo do usu�rio
				ZZH->ZZH_NMUSU  := ZZE->ZZE_NMUSU    // nome do usu�rio
				ZZH->ZZH_EMP    := ZZE->ZZE_EMP      // empresas
				ZZH->ZZH_ITEM   := cSeqOa            // sequencial da solicita��o
				ZZH->ZZH_CDMOD  := ZZF->ZZF_CDMOD    // c�digo do m�dulo
				ZZH->ZZH_DSMOD  := ZZF->ZZF_DSMOD    // descri��o do m�dulo
				ZZH->ZZH_CDGEST := ZZF->ZZF_GESTOR   // c�digo do usu�rio do gestor
				ZZH->ZZH_NMGEST := ZZF->ZZF_NMGEST   // nome do gestor
				ZZH->ZZH_CDPERF := ZZF->ZZF_CDPERF   // c�digo do perfil
				ZZH->ZZH_DSPERF := ZZF->ZZF_DSPERF   // descri��o do perfil
				ZZH->ZZH_CDCTRL := ZZF->ZZF_IDCTRL   // c�digo do usu�rio do controller
				ZZH->ZZH_TIPO   := ZZE->ZZE_TIPO     // novo acesso
				MsUnLock()  // libera registro bloqueado    

				If !Empty(gGestorAnt) .And. ZZF->ZZF_GESTOR <> gGestorAnt  // se gestor atual diferente do anterior 
					gWFGestor(gGestorAnt)  // chamada a fun��o de montagem do workflow para aprova��o dos gestores
					U_gEspEWF(gGestorAnt,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
					gGestorAnt := ZZF->ZZF_GESTOR                 // iguala posi��o de gestores       
                EndIf                                                           
                
				gGestorAnt := ZZF->ZZF_GESTOR                 // iguala posi��o de gestores                

			EndIf   
		Next 

		DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
		ZZI->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZI->(DbSeek(xFilial("ZZI")+gGestorAnt))  // posiciona regsitro
			gWFGestor(ZZI->ZZI_EMAIL)  // fun��o de montagem do workflow para controller sobre capacita��o do usu�rio
			U_gEspEWF(ZZI->ZZI_EMAIL,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow																				
		EndIf
		
		U_gEspP002(ZZE->ZZE_NUMSOL,"B")  // chamada a fun��o que processa atualiza��o de usu�rio/perfil							

		// Envio de WORKFLOW�s
		gWFHelpA()  // chamada a fun��o de montagem do workflow para o helpdesk registrar abertura do chamado
		If U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a fun��o de envio de workflow
			DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
			ZZE->(DbSetOrder(1))  // muda ordem do �ndice
			If ZZE->(DbSeek(xFilial("ZZE")+M->ZZE_NUMSOL))  // se existir registro de solicita��o      
				RecLock("ZZE",.F.)  // se bloquear registro
				ZZE->ZZE_DTEWFM := dDataBase  // data de envio do workflow para o helpdesk
				ZZE->ZZE_HREWFM := TIME()     // hora de envio do workflow para o helpdesk
				MsUnlock()	        				
			EndIf		
		EndIf
		
		DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
		ZZI->(DbSetOrder(4))  // muda ordem do �ndice
		If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
			gWFCtrlC(ZZI->ZZI_EMAIL)  // fun��o de montagem do workflow para controller sobre capacita��o do usu�rio
			U_gEspEWF(ZZI->ZZI_EMAIL,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow																				
		EndIf

		gWFUser()  // chamada a fun��o de montagem do workflow para usu�rio informando o bloqueio
		U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow					
						
		gWFARede()  // chamada a fun��o de montagem do workflow para Help Desk avisar a Administra��o de rede bloquear o REMOTE
		U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow

		gWFHelpE()  // chamada a fun��o de montagem do workflow para o helpdesk registrar encerramento do chamado
		U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a fun��o de envio de workflow
    
	Else 
		RollBackSX8("ZZE","ZZE_NUMSOL")  // se n�o confirmou volta a numera��o sequencial do arquivo de solicita��o
	Endif
Endif

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFHelpA()  // fun��o de montagem do workflow para o helpdesk registrar abertura do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
cSubject := "Abertura da solicita��o de bloqueio de perfil de acesso para o usu�rio "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFCtrlC(cTo)  // fun��o de montagem do workflow para controller sobre capacita��o do usu�rio
//cTo = Destinat�rio do envio do workflow para o gestor

cSubject := "Comunica��o de bloqueio de perfil de acesso para o usu�rio "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFHelpE()  // fun��o de montagem do workflow para o helpdesk registrar encerramento do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
cSubject := "Encerramento da solicita��o de bloqueio de perfil de acesso para o usu�rio "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFARede()  // fun��o de montagem do workflow para Help Desk avisar a Administra��o de rede instalaro REMOTE

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
cSubject := "Bloquear tempor�riamente o acesso a rede do usu�rio "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o                                                                               
***************************************************************************************************************************************************

Static Function gWFUser()  // fun��o de montagem do workflow para usu�rio informando o bloqueio

cTo      := ZZE->ZZE_EMAILU  // Destinat�rio do envio do workflow para o usu�rio
cSubject := "Seu acesso foi Bloqueado tempor�riamente "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFGestor(cTo)  // fun��o de montagem do workflow para gestor sobre bloqueio do usu�rio
//cTo = Destinat�rio do envio do workflow para o gestor

cSubject := "Comunica��o de bloqueio de perfil de acesso para o usu�rio "+AllTrim(ZZE->ZZE_NMUSU)+" pelo motivo de " +AllTrim(ZZE->ZZE_MOTBLQ)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"B")  // chamada a fun��o de montagem da mensagem para workflow
                                                                 
Return  // retorno da fun��o