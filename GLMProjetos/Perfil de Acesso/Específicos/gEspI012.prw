/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspI012 � Autor � George AC. Gon�alves � Data � 03/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspI012  � Autor � George AC. Gon�alves � Data � 03/06/09 ���
���          � gVReiSenha� Autor � George AC. Gon�alves � Data � 22/06/09 ���
���          � gWFHelpA  � Autor � George AC. Gon�alves � Data � 03/06/09 ���
���          � gWFHelpE  � Autor � George AC. Gon�alves � Data � 03/06/09 ���
���          � gWFUser   � Autor � George AC. Gon�alves � Data � 03/06/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o na Reinicializa��o de Senha                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Sele��o da op��o reinicializa��o de senha - Rotina gEspM014���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "tbiconn.ch"
#Include "Ap5Mail.ch"
#include "Topconn.ch"      

User Function gEspI012()  // Manuten��o na Reinicializa��o de Senha

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
	cTudOk         := "U_gVReiSenha()"	
///	cTudOk         := "AllwaysTrue()"
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
			ZZE->ZZE_IDUSU  := M->ZZE_IDUSU    // C�digo do usu�rio
			ZZE->ZZE_SOLIC  := "09"            // 01=Solicita��o de perfil de acesso;02=Altera��o de cargo/fun��o;03=Transfer�ncia departamental;04=Transfer�ncia entre empresas/filias;05=Transfer�ncia entre SA�s;06=Bloqueio de usu�rio;07=Desligamento de usu�rio;08=Desbloqueio de acesso;09=Reinicializa��o de senha;10=Sele��o de ambiente/empresa;
			MsUnLock()  // libera registro bloqueado    
			ConfirmSX8("ZZE","ZZE_NUMSOL")  // grava n�mero da solicita��o de acesso			
 		EndIf

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
			EndIf   
		Next 

		U_gEspP002(ZZE->ZZE_NUMSOL,"S")  // chamada a fun��o que processa atualiza��o de usu�rio/perfil							

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
		
		gWFUser()  // chamada a fun��o de montagem do workflow para usu�rio informando o bloqueio
		U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow					
	
		gWFHelpE()  // chamada a fun��o de montagem do workflow para o helpdesk registrar encerramento do chamado
		U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow
    
	Else 
		RollBackSX8("ZZE","ZZE_NUMSOL")  // se n�o confirmou volta a numera��o sequencial do arquivo de solicita��o                     
	Endif
Endif

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFHelpA()  // fun��o de montagem do workflow para o helpdesk registrar abertura do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
cSubject := "Abertura da solicita��o de reinicializa��o de senha para o usu�rio "+AllTrim(ZZE->ZZE_NMUSU)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"S")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFHelpE()  // fun��o de montagem do workflow para o helpdesk registrar encerramento do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinat�rio do envio do workflow para o helpdesk
cSubject := "Encerramento da solicita��o de reinicializa��o de senha para o usu�rio "+AllTrim(ZZE->ZZE_NMUSU)  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.F.,"S")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gWFUser()  // fun��o de montagem do workflow para usu�rio informando o bloqueio

cTo      := ZZE->ZZE_EMAILU  // Destinat�rio do envio do workflow para o usu�rio
cSubject := "Sua senha foi reinicializada conforme solicita��o"  // Assunto da mensagem
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF003(cSubject,.T.,.T.,"S")  // chamada a fun��o de montagem da mensagem para workflow

Return  // retorno da fun��o                                             
***************************************************************************************************************************************************

User Function gVReiSenha()  // valida��o digita��o da reinicializa��o de senha

lRet    := .T.  // retorno da fun��o
                                                                              
If Empty(M->ZZE_CDUSU)  // se c�difo de usu�rio n�o informado
	MsgStop("N�o � possivel gravar solicita��o sem o preenchimento do c�digo de usu�rio","Aten��o")
	lRet := .F.  // retorno da fun��o					
EndIf	

Return lRet  // retorno da fun��o