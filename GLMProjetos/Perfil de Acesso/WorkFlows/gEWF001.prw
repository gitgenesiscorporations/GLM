/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEWF001  ³ Autor ³ George AC. Gonçalves ³ Data ³ 07/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEWF001  ³ Autor ³ George AC. Gonçalves ³ Data ³ 03/02/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Confecção de mensagem para envio de workflow               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Funções de envio de workflow - Rotinas: gEspI001           ³±±
±±³                                                  : gEspA001           ³±±
±±³                                                  : gEspA002           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gEWF001(gcTitulo,glItens,gFlAprov,gFlGestCtrl,gGestor,glPerfil,glCapacit,glSenha,gcModPerf,gcIdProc,gcTipo)  // Confecção de mensagem para envio de workflow
//gcTitulo    = título da mensagem
//glItens     = flag para varrer array dos itens ou item memória
//gFlAprov    = flag identificando aprovação ou recusa: "" = sem informação, 1 = aprovada, 2 = recusada
//gFlGestCtrl = flag identificando aprovação ou recusa: "" = sem informação, G = informação do gestor, C = informação do controller 
//gGestor     = código do gestor para envio apenas para o próprio   
//glPerfil    = flag para informar perfil atual
//glCapacit   = flag para informar matriz de capacitação
//glSenha     = flag para informar usuário e senha de usuário
//gcModPerf   = código do módulo/perfil
//gcIdProc    = identificação do processo:
//				1 = Solicitação do perfil de acesso
//				2 = Aprovação do gestor
//				3 = Aprovação do controller
//				4 = Recusa do gestor
//				5 = Recusa do controller
//				6 = Encerramento da solicitação do perfil de acesso
//gcTipo      = flag para identificar o tipo de acesso:
//				1 = Novo
//				2 = Alteração
                           
///cBody    := U_gEWF001(cSubject,.T.,"","","",.F.,.T.,.T.,"","3",ZZE->ZZE_TIPO)  // chamada a função de montagem da mensagem para workflow

cArea    := GetArea()
cAreaZZE := ZZE->(GetArea())
cAreaZZF := ZZF->(GetArea())
cAreaZZC := ZZC->(GetArea())
cAreaZZJ := ZZJ->(GetArea())

Private aUsers := AllUsers(.T.)   // vetor de usuários

Public gFlagParam := .F.  // determina seleção de parâmetros: .T. = seleciona, .F. = não seleciona
           
DbSelectArea("SM0")  // seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // muda ordem do índice
SM0->(DbSeek(cEmpAnt+cFilAnt))  // posiciona registro

// Montagem do cabeçalho da mensagem
_cCabec := '<html><head><title>'+gcTitulo+'</title></head><body bgcolor="#FFFFFF">'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr>'
_cCabec += '            <td width="1200" bgcolor="#99CCFF" align="center">'
_cCabec += '            <font size="3" face="Verdana"><b>'
_cCabec += '            <img border="0" src="'+GetMv("LOGO_EMP")+'" width="75" height="50" align="left">'	
_cCabec += SM0->M0_NOMECOM
_cCabec += '              <br>'+SM0->M0_ENDCOB + ' ' + SM0->M0_COMPCOB
_cCabec += '              <br>'+SM0->M0_BAIRCOB + ' - ' + SM0->M0_CIDCOB + ' / ' + SM0->M0_ESTCOB
_cCabec += '              </b></font></td>'
_cCabec += '        </tr>' 
_cCabec += '    </table>'

_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="center"><b>Solicitação de acesso para ' + If(gcTipo=="1","NOVO","ALTERAÇÃO de") + ' Usuário<b></td>'
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table>'

_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Número da Solicitação:</b> ' + SubSTr(ZZE->ZZE_NUMSOL,1,4)+"/"+SubSTr(ZZE->ZZE_NUMSOL,5,8) + '<b></td>'
_cCabec += '            <td align="left"><b>Data da Solicitação:</b> ' + DToC(ZZE->ZZE_DTSOL) + '<b></td>'
_cCabec += '            <td align="left"><b>Hora da Solicitação:</b> ' + ZZE->ZZE_HRSOL + '<b></td>'
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Solicitante:</b> ' + ZZE->ZZE_NMSOL + '<b></td>'
_cCabec += '	    </tr>'                                                     
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Usuário:</b> ' + ZZE->ZZE_NMUSU + '<b></td>'
_cCabec += '            <td align="left"><b>e-Mail:</b> ' + ZZE->ZZE_EMAILU + '<b></td>'
_cCabec += '	    </tr>'                                                 
_cCabec += '    </table>'                       
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'                                                   
_cCabec += '            <td align="left"><b>Empresa Prestadora:</b> ' + ZZE->ZZE_EMPPRE + '<b></td>'
_cCabec += '            <td align="left"><b>Departamento:</b> ' + ZZE->ZZE_NMDEPU + '<b></td>'
_cCabec += '            <td align="left"><b>Cargo/Função:</b> ' + ZZE->ZZE_DSFUNU + '<b></td>'
_cCabec += '	    </tr>'                      
_cCabec += '    </table>'                       
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Localização:</b> ' + ZZE->ZZE_LOCALU + '<b></td>'
_cCabec += '            <td align="left"><b>Telefone/Ramal:</b> ' + ZZE->ZZE_TELUSU + '<b></td>'
_cCabec += '	    </tr>'                      
_cCabec += '    </table>'                                                        
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Ambiente:</b> ' + GetMv("AMB_EMP") + '<b></td>'
_cCabec += '            <td align="left"><b>Controller:</b> ' + ZZE->ZZE_CTRL + '<b></td>'
_cCabec += '	    </tr>'                                                       
_cCabec += '    </table>'                                                        
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Permissão p/ avanço/retrocesso de dias à data base:</b> ' + If(ZZE->ZZE_PERAVR=="S","SIM","NÃO") + '<b></td>'
_cCabec += '            <td align="left"><b>Número de Dias a Avançar:</b> ' + StrZero(ZZE->ZZE_AVANCO,2) + '<b></td>'
_cCabec += '            <td align="left"><b>Número de Dias a Retroceder:</b> ' + StrZero(ZZE->ZZE_RETROC,2) + '<b></td>'
_cCabec += '	    </tr>'                                                       
_cCabec += '    </table>'                                                        
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Empresas:</b></td>'

glInicio    := .T.
gl1Emp      := .T.
gCdEmpresas := AllTrim(ZZE->ZZE_EMP)

For nG := 1 To Len(gCdEmpresas)            
	If Len(gCdEmpresas) > 0
		nPosF := At(",",gCdEmpresas) 
		If nPosF > 0
			gCdEmp := SubStr(SubStr(gCdEmpresas,1,4),1,2)  // código da empresa
			gCdFil := SubStr(SubStr(gCdEmpresas,1,4),3,2)  // código da filial		
			DbSelectArea("SM0")  // seleciona arquivo de empresas/filiais
			SM0->(DbSetOrder(1))  // muda ordem do índice
			If SM0->(DbSeek(gCdEmp+gCdFil))                                 
				If glInicio == .T.                                                                   
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'												
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
					glInicio := .F.				
					gl1Emp   := .F.					
				Else
					_cCabec += '        <tr bgcolor="#99CCFF">'  
					_cCabec += '            <td align="left"><b> </b></td>'					   
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'			
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
					_cCabec += '	    </tr>'                                                			
				EndIf	
			EndIf
		Else
			gCdEmp := SubStr(SubStr(gCdEmpresas,Len(gCdEmpresas)-4,4),1,2)  // código da empresa
			gCdFil := SubStr(SubStr(gCdEmpresas,Len(gCdEmpresas)-4,4),3,2)  // código da filial		
			DbSelectArea("SM0")  // seleciona arquivo de empresas/filiais
			SM0->(DbSetOrder(1))  // muda ordem do índice
			If SM0->(DbSeek(gCdEmp+gCdFil))                                 
				If glInicio == .T. .And. gl1Emp == .F.
					_cCabec += SM0->M0_NOMECOM + '<b></td>'		
					glInicio := .F.				
				ElseIf gl1Emp == .T.
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'												
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'											
				Else
					_cCabec += '        <tr bgcolor="#99CCFF">'                                    
					_cCabec += '            <td align="left"><b> </b></td>'					   					
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'			
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
					_cCabec += '	    </tr>'                                                			
				EndIf	
			EndIf			
			gCdEmpresas	:= ""
		EndIf	
		gCdEmpresas	:= SubStr(gCdEmpresas,nPosF+1,Len(gCdEmpresas))	
	Else
		Exit
	EndIf			
Next

_cCabec += '    </table> '        
_cCabec += '    </p> '        

_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>PERFIL SOLICITADO:</b><b></td>'
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table> '        
_cCabec += '    </p> '        

_cCorpo := '    <table border="1" width="1200">'
_cCorpo += '        <tr bgcolor="#99CCFF">'     
_cCorpo += '            <td align="left" width="20"> <b>DEPARTAMENTO</b></td>'
_cCorpo += '            <td align="left" width="30"> <b>MÓDULO      </b></td>'                               
_cCorpo += '            <td align="left" width="200"><b>GESTOR      </b></td>'       
_cCorpo += '            <td align="left" width="200"><b>PERFIL      </b></td>'             
_cCorpo += '            <td align="left" width="200"><b>NIVEL       </b></td>'             
If !Empty(gFlAprov)  // se existe informação de status
	_cCorpo += '            <td align="left" width="300"><b>STATUS      </b></td>'             
	_cCorpo += '            <td align="left" width="300"><b>OBSERVAÇÃO  </b></td>'             
EndIf	
If glCapacit == .T.  // se informar matriz de capacitação                                      
	_cCorpo += '            <td align="left" width="300"><b>CAPACITAÇÃO</b></td>'             
EndIf
_cCorpo += '	      </tr>'   

If glItens == .T.  // percorre os itens
             
	If gcIdProc == "3"  // se processo de aprovação do controller
		ZZF->(DbClearFilter()) // Limpa o filtro 	

		DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
		ZZF->(DbSetOrder(3))  // muda ordem do índice
		ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro

		ZZF->(DbSetFilter({||(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")},'(AllTrim(Upper(ZZF->ZZF_IDCTRL))==AllTrim(Upper(SubStr(cUsuario,7,15))).And.Empty(ZZF->ZZF_STATC).And.ZZF->ZZF_STATG=="1")'))   		
	Else
		DbSelectArea("ZZF")  // seleciona arquivo de solicitação de acesso - perfil
		ZZF->(DbSetOrder(3))  // muda ordem do índice
		ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
	EndIf
	    
	If Found()  // se encontrou registro
		Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
			If !Empty(gGestor) .And. ZZF->ZZF_GESTOR <> gGestor  // se existir gestor e o mesmo diferente do arquivo
				ZZF->(DbSkip())  // incrementa contador de registro
				Loop  // pega próximo registro
			EndIf
			_cCorpo += '        <tr>'     
			_cCorpo += '            <td align="left" width="20">' +ZZF->ZZF_DSDEPT+'</td>'
			_cCorpo += '            <td align="left" width="30">' +ZZF->ZZF_DSMOD +'</td>'                               
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NMGEST+'</td>'        
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_DSPERF+'</td>'              
			Do Case
				Case ZZF->ZZF_NIVEL == "5"  // se nível default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Default)" +'</td>'  			
				Case ZZF->ZZF_NIVEL == "6"  // se nível default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 6)" +'</td>'  								
				Case ZZF->ZZF_NIVEL == "7"  // se nível default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 7)" +'</td>'  								
				Case ZZF->ZZF_NIVEL == "8"  // se nível default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 8)" +'</td>'  																		
			EndCase					
			If !Empty(gFlAprov)  // se existe informação de status
				If gFlGestCtrl == "G" .And. !Empty(ZZF->ZZF_STATG)  // se informação do gestor
					_cCorpo += '            <td align="left" width="200">'+If(ZZF->ZZF_STATG=="1","APROVADA","RECUSADA")+'</td>'  			
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_OBSGES+'</td>'  				
				ElseIf gFlGestCtrl == "C" .And. !Empty(ZZF->ZZF_STATC)  // se informação do controller
					_cCorpo += '            <td align="left" width="200">'+If(ZZF->ZZF_STATC=="1","APROVADA","RECUSADA")+'</td>'  			
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_OBSCON+'</td>'  				
				EndIf				
			EndIf
			
			If glCapacit == .T.  // se informar matriz de capacitação                                      
				Declare gDia[7]  // dia da semana
				gDia[1] := "SEGUNDAS-FEIRA"
				gDia[2] := "TERÇAS-FEIRA"
				gDia[3] := "QUARTAS-FEIRA"
				gDia[4] := "QUINTAS-FEIRA"
				gDia[5] := "SEXTAS-FEIRA"
				gDia[6] := "SÁBADOS"
				gDia[7] := "DOMINGOS"
                                                           
				DbSelectArea("ZZG")  // seleciona arquivo de matriz de capacitação
				ZZG->(DbSetOrder(1))  // muda ordem do índice
				If ZZG->(DbSeek(xFilial("ZZG")+ZZF->ZZF_CDMOD))  // posiciona registro
					gMsg    := gDia[Val(ZZG->ZZG_DIA)] + " NA "
					gSemana := AllTrim(ZZG->ZZG_SEMANA)  // semana
					For gLn := 1 To Len(gSemana)
						If At(",",gSemana) > 0                
							gDiaSem := SubStr(gSemana,1,At(",",gSemana)-1)
							gMsg    := gMsg + gDiaSem + "a. E "
							gSemana := SubStr(gSemana,At(",",gSemana)+1,999)							
						Else	                               
							gMsg    := gMsg + SubStr(gSemana,1,1) + "a. "                                
							Exit  // aborta laço
						EndIf
					Next
					gMsg := gMsg + "SEMANA(S) DO MÊS"
					_cCorpo += '            <td align="left" width="200">'+gMsg+'</td>'  				
				EndIf	
			EndIf
			
			_cCorpo += '	      </tr>'        
			ZZF->(DbSkip())  // incrementa contador de registro		
		EndDo                                                          
	EndIf			
Else
	_cCorpo += '        <tr>'     
	_cCorpo += '            <td align="left" width="20">' +ZZF->ZZF_DSDEPT+'</td>'
	_cCorpo += '            <td align="left" width="30">' +ZZF->ZZF_DSMOD +'</td>'                               
	_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NMGEST+'</td>'        
	_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_DSPERF+'</td>'  
	Do Case
		Case ZZF->ZZF_NIVEL == "5"  // se nível default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Default)" +'</td>'  			
		Case ZZF->ZZF_NIVEL == "6"  // se nível default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 6)" +'</td>'  								
		Case ZZF->ZZF_NIVEL == "7"  // se nível default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 7)" +'</td>'  								
		Case ZZF->ZZF_NIVEL == "8"  // se nível default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 8)" +'</td>'  																		
	EndCase						
	If !Empty(gFlAprov)  // se existe informação de status
		If gFlGestCtrl == "G" .And. !Empty(ZZF->ZZF_STATG)  // se informação do gestor
			_cCorpo += '            <td align="left" width="200">'+If(ZZF->ZZF_STATG=="1","APROVADA","RECUSADA")+'</td>'  			
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_OBSGES+'</td>'  				
		ElseIf gFlGestCtrl == "C" .And. !Empty(ZZF->ZZF_STATC)  // se informação do controller
			_cCorpo += '            <td align="left" width="200">'+If(ZZF->ZZF_STATC=="1","APROVADA","RECUSADA")+'</td>'  			
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_OBSCON+'</td>'  				
		EndIf				
	EndIf	     
                                               
	Private mv_par01 := ""  // Id do Módulo
	Private mv_par02 := ""  // Código do Perfil
	
	If ASCAN(aModAnexo,{|X| X == ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF}) == 0  // se não encontrar módulo no array
		AaDd(aModAnexo,ZZF->ZZF_CDMOD+ZZF->ZZF_CDPERF)  // array dos módulos para anexo
	EndIf				                                                     
	
	mv_par01 := ZZF->ZZF_CDMOD   // Id do Módulo Inicial
	mv_par02 := ZZF->ZZF_CDPERF  // Código do Perfil Final			
    
	U_gEspR002()  // Relatório de Perfil de Acesso por Módulo
	
	If glCapacit == .T.  // se informar matriz de capacitação                                      
		Declare gDia[7]  // dia da semana
		gDia[1] := "SEGUNDAS-FEIRA"
		gDia[2] := "TERÇAS-FEIRA"
		gDia[3] := "QUARTAS-FEIRA"
		gDia[4] := "QUINTAS-FEIRA"
		gDia[5] := "SEXTAS-FEIRA"
		gDia[6] := "SÁBADOS"
		gDia[7] := "DOMINGOS"
                                                           
		DbSelectArea("ZZG")  // seleciona arquivo de matriz de capacitação
		ZZG->(DbSetOrder(1))  // muda ordem do índice
		If ZZG->(DbSeek(xFilial("ZZG")+ZZF->ZZF_CDMOD))  // posiciona registro
			gMsg    := gDia[Val(ZZG->ZZG_DIA)] + " NA "
			gSemana := AllTrim(ZZG->ZZG_SEMANA)  // semana
			For gLn := 1 To Len(gSemana)
				If At(",",gSemana) > 0                
					gDiaSem := SubStr(gSemana,1,At(",",gSemana)-1)
					gMsg    := gMsg + gDiaSem + "a. E "
					gSemana := SubStr(gSemana,At(",",gSemana)+1,999)							
				Else	                               
					gMsg    := gMsg + SubStr(gSemana,1,1) + "a. "
					Exit  // aborta laço
				EndIf
			Next
			gMsg := gMsg + "SEMANA(S) DO MÊS"
			_cCorpo += '            <td align="left" width="200">'+gMsg+'</td>'  				
		EndIf	
	EndIf	
	
	_cCorpo += '	      </tr>'        
EndIf	

_cCorpo += '    </table> '        

If glPerfil == .T.  // se informar perfil atual

	Private mv_par01 := ""  // Id do Módulo
	Private mv_par02 := ""  // Código do Perfil

	_cCorpo += '    <table border="1" width="1200">'
	_cCorpo += '        <tr bgcolor="#99CCFF">'     
	_cCorpo += '            <td align="left"><b>PERFIL ATUAL:</b><b></td>'
	_cCorpo += '	    </tr>'                                                                          
	_cCorpo += '    </table> '        
	_cCorpo += '    </p> '        

	_cCorpo += '    <table border="1" width="1200">'
	_cCorpo += '        <tr bgcolor="#99CCFF">'     
	_cCorpo += '            <td align="left" width="30"> <b>MÓDULO      </b></td>'                               
	_cCorpo += '            <td align="left" width="200"><b>GESTOR      </b></td>'       
	_cCorpo += '            <td align="left" width="200"><b>PERFIL      </b></td>'             
	_cCorpo += '            <td align="left" width="200"><b>NIVEL       </b></td>'             	

	If glCapacit == .T.  // se informar matriz de capacitação                                      
		_cCorpo += '            <td align="left" width="300"><b>CAPACITAÇÃO</b></td>'             
	EndIf	
	
	_cCorpo += '	      </tr>'   

	If ZZE->ZZE_TIPO == "1"  // tipo da solicitação: 1-Novo Perfil
	
		For nG := 1 To Len(gcModPerf)            
			If Len(gcModPerf) > 0
				nPosF := At(",",gcModPerf) 
				If nPosF > 0
					gCdMod  := SubStr(gcModPerf,1,2)  // código do módulo
					gCdPerf := SubStr(gcModPerf,3,2)  // código do perfil
					gcNivel := SubStr(gcModPerf,5,1)  // nível de acesso

					DbSelectArea("ZZC")  // seleciona arquivo de módulo/perfil de acesso
					ZZC->(DbSetOrder(1))  // muda ordem do índice
					If ZZC->(DbSeek(xFilial("ZZC")+gCdMod+gCdPerf))  // posiciona registro
						DbSelectArea("ZZJ")  // seleciona arquivo de departamento/módulo
						ZZJ->(DbSetOrder(2))  // muda ordem do índice
						If ZZJ->(DbSeek(xFilial("ZZJ")+gCdMod))  // posiciona registro
							_cCorpo += '        <tr>'     
							_cCorpo += '            <td align="left" width="30">' +ZZC->ZZC_DSMOD +'</td>'                               
							_cCorpo += '            <td align="left" width="200">'+ZZJ->ZZJ_NMGEST+'</td>'        
							_cCorpo += '            <td align="left" width="200">'+ZZC->ZZC_DSPERF+'</td>'  
							Do Case
								Case gcNivel == "5"  // se nível default
									_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Default)" +'</td>'  			
								Case gcNivel == "6"  // se nível default
									_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Acesso Restrito 6)" +'</td>'  								
								Case gcNivel == "7"  // se nível default
									_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Acesso Restrito 7)" +'</td>'  								
								Case gcNivel == "8"  // se nível default
									_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Acesso Restrito 8)" +'</td>'  																		
							EndCase												
						EndIf	
					EndIf
               
					If ASCAN(aModAnexo,{|X| X == gCdMod+gCdPerf}) == 0  // se não encontrar módulo no array
						AaDd(aModAnexo,gCdMod+gCdPerf)  // array dos módulos para anexo
					EndIf				

					_cCorpo += '	      </tr>'        
			
					mv_par01 := gCdMod   // Id do Módulo Inicial
					mv_par02 := gCdPerf  // Código do Perfil Final			
			        
					U_gEspR002()  // Relatório de Perfil de Acesso por Módulo
					
				EndIf	
				gcModPerf := SubStr(gcModPerf,nPosF+1,Len(gcModPerf))	
				
			EndIf  
		Next    

	Else

		PSWORDER(1)  // muda ordem de índice
		If PswSeek(ZZE->ZZE_CDUSU) == .T.  // se encontrar usuário no arquivo
			aArray := PSWRET()      // vetor dados do usuário
			For gLnP := 1 To Len(aArray[1][10])  // percorre o arquivo de menus
				gCdMod  := SubStr(aArray[1][10][gLnP],1,2)  // código do módulo
				gCdPerf := SubStr(aArray[1][10][gLnP],3,2)  // código do perfil        
				Do Case
					Case Val(gCdMod) < 96
						gcNivel := SubStr(aUsers[Ascan(aUsers,{|X| X[1][1] = ZZE->ZZE_CDUSU})][3][Val(gCdMod)],3,1)				
					Case Val(gCdMod) == 96                                                                                      
						gcNivel := SubStr(aUsers[Ascan(aUsers,{|X| X[1][1] = ZZE->ZZE_CDUSU})][3][Val("80")],3,1)									
					Case Val(gCdMod) == 97                                                                                      
						gcNivel := SubStr(aUsers[Ascan(aUsers,{|X| X[1][1] = ZZE->ZZE_CDUSU})][3][Val("78")],3,1)									
					Case Val(gCdMod) == 98                                                                                      
						gcNivel := SubStr(aUsers[Ascan(aUsers,{|X| X[1][1] = ZZE->ZZE_CDUSU})][3][Val("79")],3,1)									
					OtherWise						                                                                            
						gcNivel := SubStr(aUsers[Ascan(aUsers,{|X| X[1][1] = ZZE->ZZE_CDUSU})][3][Val(gCdMod)],3,1)									
				EndCase						
			
				DbSelectArea("ZZC")  // seleciona arquivo de módulo/perfil de acesso
				ZZC->(DbSetOrder(1))  // muda ordem do índice
				If ZZC->(DbSeek(xFilial("ZZC")+gCdMod+gCdPerf))  // posiciona registro
					DbSelectArea("ZZJ")  // seleciona arquivo de departamento/módulo
					ZZJ->(DbSetOrder(2))  // muda ordem do índice
					If ZZJ->(DbSeek(xFilial("ZZJ")+gCdMod))  // posiciona registro
						_cCorpo += '        <tr>'     
						_cCorpo += '            <td align="left" width="30">' +ZZC->ZZC_DSMOD +'</td>'                               
						_cCorpo += '            <td align="left" width="200">'+ZZJ->ZZJ_NMGEST+'</td>'        
						_cCorpo += '            <td align="left" width="200">'+ZZC->ZZC_DSPERF+'</td>'  
						
						Do Case
							Case gcNivel == "5"  // se nível default
								_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Default)" +'</td>'  			
							Case gcNivel == "6"  // se nível default
								_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Acesso Restrito 6)" +'</td>'  								
							Case gcNivel == "7"  // se nível default
								_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Acesso Restrito 7)" +'</td>'  								
							Case gcNivel == "8"  // se nível default
								_cCorpo += '            <td align="left" width="200">'+gcNivel+"(Acesso Restrito 8)" +'</td>'  																		
						EndCase																		
						
					EndIf	
				EndIf
               
				If ASCAN(aModAnexo,{|X| X == gCdMod+gCdPerf}) == 0  // se não encontrar módulo no array
					AaDd(aModAnexo,gCdMod+gCdPerf)  // array dos módulos para anexo
				EndIf				
			
				If glCapacit == .T.  // se informar matriz de capacitação                                      
					Declare gDia[7]  // dia da semana
					gDia[1] := "SEGUNDAS-FEIRA"
					gDia[2] := "TERÇAS-FEIRA"
					gDia[3] := "QUARTAS-FEIRA"
					gDia[4] := "QUINTAS-FEIRA"
					gDia[5] := "SEXTAS-FEIRA"
					gDia[6] := "SÁBADOS"
					gDia[7] := "DOMINGOS"
                                                           
					DbSelectArea("ZZG")  // seleciona arquivo de matriz de capacitação
					ZZG->(DbSetOrder(1))  // muda ordem do índice
					If ZZG->(DbSeek(xFilial("ZZG")+gCdMod))  // posiciona registro
						gMsg    := gDia[Val(ZZG->ZZG_DIA)] + " NA "
						gSemana := AllTrim(ZZG->ZZG_SEMANA)  // semana
						For gLnS := 1 To Len(gSemana)
							If At(",",gSemana) > 0                
								gDiaSem := SubStr(gSemana,1,At(",",gSemana)-1)
								gMsg    := gMsg + gDiaSem + "a. E "
								gSemana := SubStr(gSemana,At(",",gSemana)+1,999)							
							Else	                               
								gMsg    := gMsg + SubStr(gSemana,1,1) + "a. "
								Exit  // aborta laço
							EndIf
						Next gLnS
						gMsg := gMsg + "SEMANA(S) DO MÊS"
						_cCorpo += '            <td align="left" width="200">'+gMsg+'</td>'  				
					EndIf	
				EndIf				
			
				_cCorpo += '	      </tr>'        
			
				mv_par01 := gCdMod   // Id do Módulo Inicial
				mv_par02 := gCdPerf  // Código do Perfil Final			

				U_gEspR002()  // Relatório de Perfil de Acesso por Módulo
			
			Next gLnP
		EndIf	
	
	EndIf
	_cCorpo += '    </table> '        
EndIf

If glSenha == .T.  // se enviar usuário e senha
	_cCorpo += '    </p> '        
	_cCorpo += '    </p> '        	
	_cCorpo += '    <table border="2" width="1200">'
	_cCorpo += '        <tr bgcolor="#99CCFF">'     
	_cCorpo += '            <td align="left"><b>Usuário:</b> ' + u1_cCdUser + '<b></td>'
	_cCorpo += '            <td align="left"><b>Senha:</b> ' + PswEncript(u1_cSenha,1) + '<b></td>'
	_cCorpo += '	    </tr>'                                                                          
	_cCorpo += '    </table>'     
	_cCorpo += '    </p> '        	
EndIf	

// Finaliza o HTML
_cCorpo += '</html>'

cBody := _cCabec+_cCorpo  // Corpo da mensagem

ZZJ->(RestArea(cAreaZZJ))
ZZC->(RestArea(cAreaZZC))
ZZF->(RestArea(cAreaZZF))
ZZE->(RestArea(cAreaZZE))
RestArea(cArea)

Return cBody  // retorno da função