/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEWF005  � Autor � George AC. Gon�alves � Data � 29/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEWF003  � Autor � George AC. Gon�alves � Data � 29/06/09  ���
���          � gRecSuper� Autor � George AC. Gon�alves � Data � 29/06/09  ���
���          � gRecLocal� Autor � George AC. Gon�alves � Data � 29/06/09  ���
���          � gRecTelef� Autor � George AC. Gon�alves � Data � 29/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confec��o de mensagem para envio de workflow               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Fun��es de envio de workflow - Rotinas: SIGACOM            ���    
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gEWF005(gcTitulo,gcIDUsu,gcCdMod,gdDt1Acess,gcHr1Acess)  // Confec��o de mensagem para envio de workflow
//gcTitulo   = t�tulo da mensagem
//gcIDUsu    = ID do usu�rio                    
//gcCdMod    = C�digo do m�dulo                                       
//gdDt1Acess = Data do 1o. Acesso
//gcHr1Acess = Hora do 1o. acesso

cArea := GetArea()          
cAreaZZE := ZZE->(GetArea())
cAreaZZC := ZZC->(GetArea())
cAreaZZJ := ZZJ->(GetArea())

aUsers := AllUsers(.T.)   // vetor de usu�rios
                                  
DbSelectArea("SM0")  // seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // muda ordem do �ndice
SM0->(DbSeek(cEmpAnt+cFilAnt))  // posiciona registro

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(gcIDUsu) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()

	// Montagem do cabe�alho da mensagem
	_cCabec := '<html><head><title>'+gcTitulo+'</title></head><body bgcolor="#FFFFFF">'
	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr>'
	_cCabec += '            <td width="1200" bgcolor="#99FF99 " align="center">'
	_cCabec += '            <font size="3" face="Verdana"><b>'
	_cCabec += '            <img border="0" src="'+GetMv("LOGO_EMP")+'" width="75" height="50" align="left">'	
	_cCabec += SM0->M0_NOMECOM
	_cCabec += '              <br>'+SM0->M0_ENDCOB + ' ' + SM0->M0_COMPCOB
	_cCabec += '              <br>'+SM0->M0_BAIRCOB + ' - ' + SM0->M0_CIDCOB + ' / ' + SM0->M0_ESTCOB
	_cCabec += '              </b></font></td>'
	_cCabec += '        </tr>' 
	_cCabec += '    </table>'

	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="center"><b>' + gcTitulo + '<b></td>'
	_cCabec += '	    </tr>'                                                                          
	_cCabec += '    </table>'

	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Data do 1o. Acesso:</b> ' + DToC(gdDt1Acess) + '<b></td>'
	_cCabec += '            <td align="left"><b>Hora do 1o. Acesso:</b> ' + gcHr1Acess + '<b></td>'
	_cCabec += '	    </tr>'                                                                          
	_cCabec += '    </table>'
	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Usu�rio:</b> ' + aArray[1][4] + '<b></td>'
	_cCabec += '            <td align="left"><b>e-Mail:</b> ' + aArray[1][14] + '<b></td>'
	_cCabec += '	    </tr>'                                                 
	_cCabec += '    </table>'                       
	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Superior:</b> ' + gRecSuper(gcIDUsu) + '<b></td>'
	_cCabec += '	    </tr>'                      
	_cCabec += '    </table>'                       
	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Empresa Prestadora:</b> ' + ZZE->ZZE_EMPPRE + '<b></td>'	
	_cCabec += '            <td align="left"><b>Departamento:</b> ' + aArray[1][12] + '<b></td>'
	_cCabec += '            <td align="left"><b>Cargo/Fun��o:</b> ' + aArray[1][13] + '<b></td>'
	_cCabec += '	    </tr>'                      
	_cCabec += '    </table>'                       
	_cCabec += '    <table border="2" width="1200">'                                 
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Localiza��o:</b> ' + gRecLocal(gcIDUsu) + '<b></td>'
	_cCabec += '            <td align="left"><b>Telefone/Ramal:</b> ' + gRecTelef(gcIDUsu) + '<b></td>'
	_cCabec += '	    </tr>'                      
	_cCabec += '    </table>'                                                        
	_cCabec += '    <table border="2" width="1200">'                                 
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Ambiente:</b> ' + GetMv("AMB_EMP") + '<b></td>'
	_cCabec += '            <td align="left"><b>Controller:</b> ' + U_gVEsp010() + '<b></td>'
	_cCabec += '	    </tr>'                                                       
	_cCabec += '    </table>'                                                        
	_cCabec += '    <table border="2" width="1200">'                                 
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>Empresas:</b></td>'

	glInicio := .T.
	gl1Emp   := .T.
	For nG := 1 To Len(aArray[2][6])            
		gCdEmp := SubStr(SubStr(aArray[2][6][nG],1,4),1,2)  // c�digo da empresa
		gCdFil := SubStr(SubStr(aArray[2][6][nG],1,4),3,2)  // c�digo da filial		
		DbSelectArea("SM0")  // seleciona arquivo de empresas/filiais
		SM0->(DbSetOrder(1))  // muda ordem do �ndice
		If SM0->(DbSeek(gCdEmp+gCdFil))                                 
			If glInicio == .T.                                                                   
				_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'												
				_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
				glInicio := .F.				
				gl1Emp   := .F.					
			Else
				_cCabec += '        <tr bgcolor="#99FF99 ">'  
				_cCabec += '            <td align="left"><b> </b></td>'					   
				_cCabec += '            <td align="left"><b> </b> ' + gCdEmp+"/"+gCdFil + '<b></td>'			
				_cCabec += '            <td align="left"><b> </b> ' + SM0->M0_NOMECOM + '<b></td>'							
				_cCabec += '	    </tr>'                                                			
			EndIf	
		EndIf
	Next

	_cCabec += '    </table> '        
	_cCabec += '    </p> '        

	_cCabec += '    <table border="2" width="1200">'
	_cCabec += '        <tr bgcolor="#99FF99 ">'     
	_cCabec += '            <td align="left"><b>PERFIL:</b><b></td>'
	_cCabec += '	    </tr>'                                                                          
	_cCabec += '    </table> '        
	_cCabec += '    </p> '        

	_cCorpo := '    <table border="1" width="1200">'
	_cCorpo += '        <tr bgcolor="#99FF99 ">'     
	_cCorpo += '            <td align="left" width="20"> <b>DEPARTAMENTO</b></td>'
	_cCorpo += '            <td align="left" width="30"> <b>M�DULO      </b></td>'                               
	_cCorpo += '            <td align="left" width="200"><b>GESTOR      </b></td>'       
	_cCorpo += '            <td align="left" width="200"><b>PERFIL      </b></td>'             
	_cCorpo += '	    </tr>'   

	For nG := 1 To Len(aArray[1][10])            
		If SubStr(aArray[1][10][nG],1,2) == gcCdMod  // se m�dulo ativo
			gCdPerf := SubStr(aArray[1][10][nG],3,2)  // c�digo do perfil
			DbSelectArea("ZZC")  // seleciona arquivo de m�dulo/perfil de acesso
			ZZC->(DbSetOrder(1))  // muda ordem do �ndice
			If ZZC->(DbSeek(xFilial("ZZC")+gcCdMod+gCdPerf))  // posiciona registro
				DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
				ZZJ->(DbSetOrder(2))  // muda ordem do �ndice
				If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona registro
					_cCorpo += '        <tr>'                            
					_cCorpo += '            <td align="left" width="20">' +ZZJ->ZZJ_DSDEP +'</td>'					
					_cCorpo += '            <td align="left" width="30">' +ZZC->ZZC_DSMOD +'</td>'                               
					_cCorpo += '            <td align="left" width="200">'+ZZJ->ZZJ_NMGEST+'</td>'        
					_cCorpo += '            <td align="left" width="200">'+ZZC->ZZC_DSPERF+'</td>'  
				EndIf	
			EndIf
			_cCorpo += '	      </tr>'        
			
			If ASCAN(aModAnexo,{|X| X == gcCdMod+gCdPerf}) == 0  // se n�o encontrar m�dulo no array
				AaDd(aModAnexo,gcCdMod+gCdPerf)  // array dos m�dulos para anexo
			EndIf				

			mv_par01 := gcCdMod  // Id do M�dulo Inicial
			mv_par02 := gCdPerf  // C�digo do Perfil Final			
			                    
			U_gEspR002()  // Relat�rio de Perfil de Acesso por M�dulo								
			
	    EndIf
	Next

	_cCorpo += '    </table> '        

	// Finaliza o HTML
	_cCorpo += '</html>'

	cBody := _cCabec+_cCorpo  // Corpo da mensagem
	
EndIf	

ZZJ->(RestArea(cAreaZZJ))
ZZC->(RestArea(cAreaZZC))
ZZE->(RestArea(cAreaZZE))
RestArea(cArea)

Return cBody  // retorno da fun��o                                    
***************************************************************************************************************************************************

Static Function gRecSuper(gcIDUsu)  // fun��o para recuperar superior do usu�rio
//gcIDUsu = ID do usu�rio

cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "				
cQuery += "       Where ZZE.ZZE_FILIAL = ' '               And "
cQuery += "             ZZE.ZZE_CDUSU  = '" + gcIDUsu + "' And "    
cQuery += "			    ZZE.D_E_L_E_T_ = ' '                   "

TCQUERY cQuery Alias TMP NEW                                      

gcNmSuper := ""  // nome do superior
DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
	gcNmSuper := ZZE->ZZE_NMUSUP  // nome do superior 
EndIf

TMP->(DbCloseArea())                 

Return gcNmSuper  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gRecLocal(gcIDUsu)  // fun��o para recuperar localiza��o do usu�rio
//gcIDUsu = ID do usu�rio

cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "				
cQuery += "       Where ZZE.ZZE_FILIAL = ' '               And "
cQuery += "             ZZE.ZZE_CDUSU  = '" + gcIDUsu + "' And "    
cQuery += "			    ZZE.D_E_L_E_T_ = ' '                   "

TCQUERY cQuery Alias TMP NEW                                      

gcLocal := ""  // localiza��o do usu�rio
DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
	gcLocal := ZZE->ZZE_LOCALU  // localiza��o do usu�rio
EndIf

TMP->(DbCloseArea())                 

Return gcLocal  // retorno da fun��o
***************************************************************************************************************************************************

Static Function gRecTelef(gcIDUsu)  // fun��o para recuperar telefone/ramal do usu�rio
//gcIDUsu = ID do usu�rio

cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "				
cQuery += "       Where ZZE.ZZE_FILIAL = ' '               And "
cQuery += "             ZZE.ZZE_CDUSU  = '" + gcIDUsu + "' And "    
cQuery += "			    ZZE.D_E_L_E_T_ = ' '                   "

TCQUERY cQuery Alias TMP NEW                                      

gcTelRamal := ""  // localiza��o do usu�rio
DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
ZZE->(DbSetOrder(1))  // muda ordem do �ndice
If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
	gcTelRamal := ZZE->ZZE_TELUSU  // telefone/ramal do usu�rio
EndIf

TMP->(DbCloseArea())                 

Return gcTelRamal  // retorno da fun��o