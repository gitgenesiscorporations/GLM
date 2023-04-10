/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspA001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 07/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspA001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFSolic ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gVerItem ³ Autor ³ George AC. Gonçalves ³ Data ³ 08/01/09  ³±±
±±³          ³ gWFHelpD ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±³          ³ gWFCtrl  ³ Autor ³ George AC. Gonçalves ³ Data ³ 26/05/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Aprovação da Solicitação de Perfil de Acesso - Gestores    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Seleção da opção aprovação gestores - Rotina gEspM002      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function gEspA001()  // Aprovação da Solicitação de Perfil de Acesso - Gestores

Public cTo              // para
Public cBody            // mensagem
Public cSubject         // título
Public cAnexo           // anexo
Public aModAnexo := {}  // array dos módulos para anexo

Public gcNumSol := ZZF->ZZF_NUM  // Número da solicitação

DBSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
ZZE->(DbSetOrder(1))  // muda ordem do índice
ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // busca a linha da getdados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOpcao := "ALTERAR"
nOpcE  := 2
nOpcG  := 3
N      := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("ZZE",(cOpcao=="INCLUIR"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado  := 0
aHeader := {}

DbSelectArea("SX3")  // Seleciona arquivo de dicionário de dados
SX3->(DbSeek("ZZF"))  // Posiciona registro - arquivo ZZF
Do While SX3->(!Eof()) .And. SX3->x3_arquivo == "ZZF"  // percorre registro enquanto o arquivo for o ZZF
	If Alltrim(SX3->x3_campo) == "ZZF_FILIAL" .Or. Alltrim(SX3->x3_campo) == "ZZF_NUM"    .Or.;
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVG" .Or.;		          
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETG" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETG" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_DTENVC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRENVC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_DTRETC" .Or. Alltrim(SX3->x3_campo) == "ZZF_HRRETC" .Or.;	
	   Alltrim(SX3->x3_campo) == "ZZF_STATC"  .Or. Alltrim(SX3->x3_campo) == "ZZF_OBSCON"
		sx3->(DbSkip())  // incrementa contador de registro
		Loop  // pega próximo registro
	EndIf	
	If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel  // se campo em uso e o nível do usuário permite visualização
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
DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do índice
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo        := cCadastro
	cAliasEnchoice := "ZZE"
	cAliasGetD     := "ZZF"
	cLinOk         := "AllwaysTrue()"
	cTudOk         := "AllwaysTrue()"
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"ZZE_NUMSOL"}

	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executar processamento                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lRet  // se confirma gravação

		For n1 := 1 To Len(aCols)  // linhas  	          
			cSeqOa := aCols[n1,Ascan(aHeader,{|x|alltrim(x[2])=="ZZF_ITEM"})]  // busca as sequencias das linhas da getdados para procura na linha abaixo
			If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL+cSeqOa))  // busca a linha da getdados
				RecLock("ZZF",.F.)  // trava o arquivo e inclui uma linha em branco para a inclusao dos dados novos
				ZZF->ZZF_STATG  := aCols[n1][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_STATG'})]   // status do retorno da aprovação do gestor
				ZZF->ZZF_OBSGES := aCols[n1][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_OBSGES'})]  // observação do retorno da aprovação do gestor								
				ZZF->ZZF_DTRETG := dDataBase                                                   // status do retorno da aprovação do gestor
				ZZF->ZZF_HRRETG := Time()                                                      // status do retorno da aprovação do gestor								

				If ZZF->ZZF_STATG == "1"  // aprovada                                                  				
					cAnexo := gWFCtrl(ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF+ZZF->ZZF_NIVEL+",")  // chamada a função de montagem do workflow para aprovação do controller
					If U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow  
						ZZF->ZZF_DTENVC := dDataBase  // status do retorno da aprovação do gestor
						ZZF->ZZF_HRENVC := Time()     // status do retorno da aprovação do gestor								
					EndIf
				Else	                                                                                    
					gWFSolic()  // chamada a função de montagem do workflow para solicitante sobre recusa do gestor
					U_gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a função de envio de workflow
				EndIf						

				MsUnlock()	        

				gVerItem()  // chamada a função de verificação de itens para encerramento da solicitação
				
			EndIf   

		Next 
             
	Endif
	
Endif

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFSolic()  // função de montagem do workflow para solicitante sobre recusa do gestor
     
cTo := ZZE->ZZE_EMAILS  // Destinatário do envio do workflow para o solicitante
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Recusa na aprovação para inclusão de perfil de acesso para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Recusa na aprovação para alteração de perfil de acesso para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.F.,ZZF->ZZF_STATG,"G","",.F.,.F.,.F.,"","4",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
                            
Return  // retorno da função
***************************************************************************************************************************************************

Static Function gVerItem()  // chamada a função de verificação de itens para encerramento da solicitação

cArea    := GetArea()
cAreaZZF := ZZF->(GetArea())

gnCont := 0  // contador de item

ZZF->(DbClearFilter()) // Limpa o filtro 

cQuery := "    SELECT Count(*) AS QTD_ITEM "
cQuery += "      FROM " + RetSqlname("ZZF") + " ZZF "
cQuery += "     WHERE ZZF.ZZF_FILIAL = '" + xFilial("ZZF")  + "' And " 
cQuery += "           ZZF.ZZF_NUM    = '" + gcNumSol        + "' And " 
cQuery += "           ZZF.D_E_L_E_T_ = ' '                           "
                                
TCQUERY cQuery Alias TMP NEW                                      

DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
ZZF->(DbSetOrder(1))  // muda ordem do índice
If ZZF->(DbSeek(xFilial("ZZF")+gcNumSol))  // posiciona registro
	Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == gcNumSol  // percorre o arquivo no intervalo
		If ZZF->ZZF_STATG == "2"  // recusada
			gnCont := gnCont + 1  // contador de item		
		EndIf	
		ZZF->(DbSkip())  // incrementa contador de regsitro
	EndDo
EndIf

If TMP->QTD_ITEM == gnCont  // se todos os itens recusados pelos gestores
	gWFHelpD()  // chamada a função de montagem do workflow para o helpdesk registrar encerramento do chamado	
	If U_gEspEWF(cTo,cBody,cSubject,cAnexo) == .T.  // chamada a função de envio de workflow
		DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
		ZZE->(DbSetOrder(1))  // muda ordem do índice
		If ZZE->(DbSeek(xFilial("ZZE")+gcNumSol))  // se existir registro de solicitação      
			RecLock("ZZE",.F.)  // se bloquear registro
			ZZE->ZZE_STATUS := "3"  // status da solicitação: 3-Encerrada
			ZZE->ZZE_DTENC := dDataBase  // data de encerramento da solicitação
			ZZE->ZZE_HRENC := TIME()     // hora de encerramento da solicitação
			MsUnlock()	        				
		EndIf			
	EndIf
EndIf

TMP->(DbCloseArea())	

///ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG))},'(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG))'))   
ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG).And.ZZF->ZZF_TIPO<>"3")},'(AllTrim(Upper(ZZF->ZZF_IDGEST))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATG)).And.ZZF->ZZF_TIPO<>"3"'))

ZZF->(RestArea(cAreaZZF))
RestArea(cArea)

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFHelpD()  // função de montagem do workflow para o helpdesk registrar encerramento do chamado

cTo      := GetMV('MV_EWFMAX')  // Destinatário do envio do workflow para o helpdesk
If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Encerramento da solicitação de inclusão de perfil de acesso para o NOVO usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
Else	                                                                                                                                  
	cSubject := "Encerramento da solicitação de alteração de perfil de acesso para o usuário: "+ZZE->ZZE_NMUSU  // Assunto da mensagem
EndIf	
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.F.,.F.,"","6",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow

Return  // retorno da função
***************************************************************************************************************************************************

Static Function gWFCtrl(gcModPerf)  // função de montagem do workflow para aprovação do controller
//gcModPerf = Códigos do(s) módulo(s)/perfil(is)                                                        
                                                
Declare aAnexo[1]  // Caminho e nome do arquivo a ser enviado como anexo

aModAnexo := {}  // array dos módulos para anexo

cTo := ""  // Destinatário do envio do workflow para o gestor

/*
PSWORDER(2)  // muda ordem de índice
If PswSeek(ZZE->ZZE_IDCTRL) == .T.  // se encontrar usuário no arquivo
	aArray  := PSWRET()      // vetor dados do usuário
	DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
	ZZI->(DbSetOrder(1))  // muda ordem do índice
	If ZZI->(DbSeek(xFilial("ZZI")+aArray[1][1]))  // posiciona regsitro
		cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
	EndIf
EndIf
*/
         
DbSelectArea("ZZI")  // seleciona arquivo de aprovadores
ZZI->(DbSetOrder(4))  // muda ordem do índice
If ZZI->(DbSeek(xFilial("ZZI")+ZZE->ZZE_IDCTRL))  // posiciona regsitro
	cTo := ZZI->ZZI_EMAIL  // e-mail do aprovador
EndIf            

If ZZE->ZZE_TIPO == "1"  // se novo usuário
	cSubject := "Solicitação de aprovação para inclusão de perfil de acesso para o NOVO usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
Else
	cSubject := "Solicitação de aprovação para alteração de perfil de acesso para o usuário: "+M->ZZE_NMUSU  // Assunto da mensagem
EndIf		
cBody    := U_gEWF001(cSubject,.F.,"","G","",.T.,.F.,.F.,gcModPerf,"2",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow
cAnexo   := ' '   // Caminho e nome do arquivo a ser enviado como anexo
                
// _aArquivos := Directory(AllTrim(GetMv("PATCH_REDE"))+AllTrim(GetMv("MV_RELT"))+"PERFILMODULO*.CSV")	

_aArquivos := Directory(GetNewPar("MV_RELT","\SPOOL\")+"PERFILMODULO*.CSV")	

For Ln1 := 1 To Len(aModAnexo)         
	gCdMod  := SubStr(aModAnexo[Ln1],1,2)
	gCdPerf := SubStr(aModAnexo[Ln1],3,2)	
	For Ln2 := 1 To Len(_aArquivos)         	
		If SubStr(_aArquivos[Ln2,1],14,5) == gCdMod+"-"+gCdPerf  // se módulo igual ao aprovado
			cAnexo += AllTrim(GetMv("MV_RELT"))+_aArquivos[Ln2,1]+";"	
		EndIf	
	Next	
Next	                                                                                

aAnexo[1] := cAnexo                                            

Return aAnexo[1]  // retorno da função