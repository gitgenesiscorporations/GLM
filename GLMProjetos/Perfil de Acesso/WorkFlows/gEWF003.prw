/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEWF003  � Autor � George AC. Gon�alves � Data � 22/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEWF003  � Autor � George AC. Gon�alves � Data � 22/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confec��o de mensagem para envio de workflow               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Fun��es de envio de workflow - Rotinas: gEspI006           ���    
���                                                  : gEspI007           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEWF003(gcTitulo,glItens,glSenha,lFlag)  // Confec��o de mensagem para envio de workflow
//gcTitulo = t�tulo da mensagem
//glItens  = flag para varrer array dos itens ou item mem�ria
//glSenha  = flag para informar usu�rio e senha de usu�rio
//lFlag    = flag que indica: "B" = Bloqueio de usu�rio
//                            "S" = Reinicializa��o de senha
//                            "D" = Desbloqueio de usu�rio

cArea    := GetArea()
cAreaZZE := ZZE->(GetArea())
cAreaZZF := ZZF->(GetArea())

aUsers := AllUsers(.T.)   // vetor de usu�rios

Public gFlagParam := .F.  // determina sele��o de par�metros: .T. = seleciona, .F. = n�o seleciona
                                  
DbSelectArea("SM0")  // seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // muda ordem do �ndice
SM0->(DbSeek(cEmpAnt+cFilAnt))  // posiciona registro

// Montagem do cabe�alho da mensagem
_cCabec := '<html><head><title>'+gcTitulo+'</title></head><body bgcolor="#FFFFFF">'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr>'
_cCabec += '            <td width="1200" bgcolor="#FF0033" align="center">'
_cCabec += '            <font size="3" face="Verdana"><b>'
_cCabec += '            <img border="0" src="'+GetMv("LOGO_EMP")+'" width="75" height="50" align="left">'	
_cCabec += SM0->M0_NOMECOM
_cCabec += '              <br>'+SM0->M0_ENDCOB + ' ' + SM0->M0_COMPCOB
_cCabec += '              <br>'+SM0->M0_BAIRCOB + ' - ' + SM0->M0_CIDCOB + ' / ' + SM0->M0_ESTCOB
_cCabec += '              </b></font></td>'
_cCabec += '        </tr>' 
_cCabec += '    </table>'

_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#FF0033">'     
If lFlag == "B"  // se bloqueio de usu�rio
	_cCabec += '            <td align="center"><b>Bloqueio de acesso de Usu�rio<b></td>'
ElseIf lFlag == "S"  // se reinicializa senha                                           
	_cCabec += '            <td align="center"><b>Reinicializa��o de senha de usu�rio<b></td>'
ElseIf lFlag == "D"  // se reinicializa senha                                           
	_cCabec += '            <td align="center"><b>Desbloqueio de acesso de Usu�rio<b></td>'
EndIf	
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table>'

_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>N�mero da Solicita��o:</b> ' + SubSTr(ZZE->ZZE_NUMSOL,1,4)+"/"+SubSTr(ZZE->ZZE_NUMSOL,5,8) + '<b></td>'
_cCabec += '            <td align="left"><b>Data da Solicita��o:</b> ' + DToC(ZZE->ZZE_DTSOL) + '<b></td>'
_cCabec += '            <td align="left"><b>Hora da Solicita��o:</b> ' + ZZE->ZZE_HRSOL + '<b></td>'
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>Solicitante:</b> ' + ZZE->ZZE_NMSOL + '<b></td>'
_cCabec += '	    </tr>'                                                     
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>Usu�rio:</b> ' + ZZE->ZZE_NMUSU + '<b></td>'
_cCabec += '            <td align="left"><b>e-Mail:</b> ' + ZZE->ZZE_EMAILU + '<b></td>'
_cCabec += '	    </tr>'                                                 
_cCabec += '    </table>'                       
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>Empresa Prestadora:</b> ' + ZZE->ZZE_EMPPRE + '<b></td>'
_cCabec += '            <td align="left"><b>Departamento:</b> ' + ZZE->ZZE_NMDEPU + '<b></td>'
_cCabec += '            <td align="left"><b>Cargo/Fun��o:</b> ' + ZZE->ZZE_DSFUNU + '<b></td>'
_cCabec += '	    </tr>'                      
_cCabec += '    </table>'                       
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>Localiza��o:</b> ' + ZZE->ZZE_LOCALU + '<b></td>'
_cCabec += '            <td align="left"><b>Telefone/Ramal:</b> ' + ZZE->ZZE_TELUSU + '<b></td>'
_cCabec += '	    </tr>'                      
_cCabec += '    </table>'                                                        
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>Ambiente:</b> ' + GetMv("AMB_EMP") + '<b></td>'
_cCabec += '            <td align="left"><b>Controller:</b> ' + ZZE->ZZE_CTRL + '<b></td>'
_cCabec += '	    </tr>'                                                       
_cCabec += '    </table>'                                                        
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>Empresas:</b></td>'

glInicio    := .T.
gl1Emp      := .T.
gCdEmpresas := AllTrim(ZZE->ZZE_EMP)

For nG := 1 To Len(gCdEmpresas)            
	If Len(gCdEmpresas) > 0
		nPosF := At(",",gCdEmpresas) 
		If nPosF > 0
			gCdEmp := SubStr(SubStr(gCdEmpresas,1,4),1,2)  // c�digo da empresa
			gCdFil := SubStr(SubStr(gCdEmpresas,1,4),3,2)  // c�digo da filial		
			DbSelectArea("SM0")  // seleciona arquivo de empresas/filiais
			SM0->(DbSetOrder(1))  // muda ordem do �ndice
			If SM0->(DbSeek(gCdEmp+gCdFil))                                 
				If glInicio == .T.                                                                   
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'												
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
					glInicio := .F.				
					gl1Emp   := .F.					
				Else
					_cCabec += '        <tr bgcolor="#FF0033">'  
					_cCabec += '            <td align="left"><b> </b></td>'					   
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'			
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
					_cCabec += '	    </tr>'                                                			
				EndIf	
			EndIf
		Else
			gCdEmp := SubStr(SubStr(gCdEmpresas,Len(gCdEmpresas)-4,4),1,2)  // c�digo da empresa
			gCdFil := SubStr(SubStr(gCdEmpresas,Len(gCdEmpresas)-4,4),3,2)  // c�digo da filial		
			DbSelectArea("SM0")  // seleciona arquivo de empresas/filiais
			SM0->(DbSetOrder(1))  // muda ordem do �ndice
			If SM0->(DbSeek(gCdEmp+gCdFil))                                 
				If glInicio == .T. .And. gl1Emp == .F.
					_cCabec += SM0->M0_NOMECOM + '<b></td>'		
					glInicio := .F.				
				ElseIf gl1Emp == .T.
					_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'												
					_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'											
				Else
					_cCabec += '        <tr bgcolor="#FF0033">'                                    
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
_cCabec += '        <tr bgcolor="#FF0033">'     
_cCabec += '            <td align="left"><b>PERFIL:</b><b></td>'
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table> '        
_cCabec += '    </p> '        

_cCorpo := '    <table border="1" width="1200">'
_cCorpo += '        <tr bgcolor="#FF0033">'     
_cCorpo += '            <td align="left" width="20"> <b>DEPARTAMENTO</b></td>'
_cCorpo += '            <td align="left" width="30"> <b>M�DULO      </b></td>'                               
_cCorpo += '            <td align="left" width="200"><b>GESTOR      </b></td>'       
_cCorpo += '            <td align="left" width="200"><b>PERFIL      </b></td>'             
_cCorpo += '            <td align="left" width="200"><b>NIVEL       </b></td>'             
_cCorpo += '	    </tr>'   

If glItens == .T.  // percorre os itens
	DbSelectArea("ZZF")  // seleciona arquivo de solicita��o de acesso - perfil
	ZZF->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZF->(DbSeek(xFilial("ZZF")+ZZE->ZZE_NUMSOL))  // posiciona registro
		Do While ZZF->(!Eof()) .And. ZZF->ZZF_NUM == ZZE->ZZE_NUMSOL  // percorre o arquivo no intervalo
			_cCorpo += '        <tr>'     
			_cCorpo += '            <td align="left" width="20">' +ZZF->ZZF_DSDEPT+'</td>'
			_cCorpo += '            <td align="left" width="30">' +ZZF->ZZF_DSMOD +'</td>'                               
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NMGEST+'</td>'        
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_DSPERF+'</td>'  
			Do Case
				Case ZZF->ZZF_NIVEL == "5"  // se n�vel default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Default)" +'</td>'  			
				Case ZZF->ZZF_NIVEL == "6"  // se n�vel default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 6)" +'</td>'  								
				Case ZZF->ZZF_NIVEL == "7"  // se n�vel default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 7)" +'</td>'  								
				Case ZZF->ZZF_NIVEL == "8"  // se n�vel default
					_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 8)" +'</td>'  																		
			EndCase								
			_cCorpo += '	     </tr>'        
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
		Case ZZF->ZZF_NIVEL == "5"  // se n�vel default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Default)" +'</td>'  			
		Case ZZF->ZZF_NIVEL == "6"  // se n�vel default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 6)" +'</td>'  								
		Case ZZF->ZZF_NIVEL == "7"  // se n�vel default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 7)" +'</td>'  								
		Case ZZF->ZZF_NIVEL == "8"  // se n�vel default
			_cCorpo += '            <td align="left" width="200">'+ZZF->ZZF_NIVEL+"(Acesso Restrito 8)" +'</td>'  																		
	EndCase						
	_cCorpo += '	    </tr>'        
EndIf	

_cCorpo += '	     </tr>'        
_cCorpo += '    </table> '        

If glSenha == .T.  // se enviar usu�rio e senha
	_cCorpo += '    </p> '        
	_cCorpo += '    </p> '        	
	_cCorpo += '    <table border="2" width="1200">'
	_cCorpo += '        <tr bgcolor="#FF0033">'     
	_cCorpo += '            <td align="left"><b>Usu�rio:</b> ' + u1_cCdUser + '<b></td>'
	_cCorpo += '            <td align="left"><b>Senha:</b> ' + PswEncript(u1_cSenha,1) + '<b></td>'
	_cCorpo += '	    </tr>'                                                                          
	_cCorpo += '    </table>'     
	_cCorpo += '    </p> '        	
EndIf	

// Finaliza o HTML
_cCorpo += '</html>'

cBody := _cCabec+_cCorpo  // Corpo da mensagem

ZZF->(RestArea(cAreaZZF))
ZZE->(RestArea(cAreaZZE))
RestArea(cArea)

Return cBody  // retorno da fun��o