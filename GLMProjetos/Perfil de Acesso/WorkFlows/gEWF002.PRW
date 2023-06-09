/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEWF002  � Autor � George AC. Gon�alves � Data � 14/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEWF002  � Autor � George AC. Gon�alves � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confec��o de mensagem para envio de workflow               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Fun��es de envio de workflow - Rotinas: gEspA002           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gEWF002(gcTitulo)  // Confec��o de mensagem para envio de workflow
//gcTitulo    = t�tulo da mensagem
                                         
DbSelectArea("SM0")  // seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // muda ordem do �ndice
SM0->(DbSeek(cEmpAnt+cFilAnt))  // posiciona registro

// Montagem do cabe�alho da mensagem
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
_cCabec += '            <td align="left"><b>N�mero da Solicita��o:</b> ' + SubSTr(ZZE->ZZE_NUMSOL,1,4)+"/"+SubSTr(ZZE->ZZE_NUMSOL,5,8) + '<b></td>'
_cCabec += '            <td align="left"><b>Data da Solicita��o:</b> ' + DToC(ZZE->ZZE_DTSOL) + '<b></td>'
_cCabec += '            <td align="left"><b>Hora da Solicita��o:</b> ' + ZZE->ZZE_HRSOL + '<b></td>'
_cCabec += '	    </tr>'                                                                          
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Solicitante:</b> ' + ZZE->ZZE_NMSOL + '<b></td>'
_cCabec += '	    </tr>'                                                     
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Usu�rio:</b> ' + ZZE->ZZE_NMUSU + '<b></td>'
_cCabec += '            <td align="left"><b>e-Mail:</b> ' + ZZE->ZZE_EMAILU + '<b></td>'
_cCabec += '	    </tr>'                                                 
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Empresa Prestadora:</b> ' + ZZE->ZZE_EMPPRE + '<b></td>'
_cCabec += '            <td align="left"><b>Departamento:</b> ' + ZZE->ZZE_NMDEPU + '<b></td>'
_cCabec += '            <td align="left"><b>Cargo/Fun��o:</b> ' + ZZE->ZZE_DSFUNU + '<b></td>'
_cCabec += '	    </tr>'                                                       
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Localiza��o:</b> ' + ZZE->ZZE_LOCALU + '<b></td>'
_cCabec += '            <td align="left"><b>Telefone/Ramal:</b> ' + ZZE->ZZE_TELUSU + '<b></td>'
_cCabec += '	    </tr>'   
_cCabec += '    </table>'
_cCabec += '    <table border="2" width="1200">'
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Ambiente:</b> ' + GetMv("AMB_EMP") + '<b></td>'
_cCabec += '            <td align="left"><b>Controller:</b> ' + ZZE->ZZE_CTRL + '<b></td>'
_cCabec += '	    </tr>'   
_cCabec += '    </table> '        
_cCabec += '    <table border="2" width="1200">'                                 
_cCabec += '        <tr bgcolor="#99CCFF">'     
_cCabec += '            <td align="left"><b>Permiss�o p/ avan�o/retrocesso de dias � data base:</b> ' + If(ZZE->ZZE_PERAVR=="S","SIM","N�O") + '<b></td>'
_cCabec += '            <td align="left"><b>N�mero de Dias a Avan�ar:</b> ' + StrZero(ZZE->ZZE_AVANCO,2) + '<b></td>'
_cCabec += '            <td align="left"><b>N�mero de Dias a Retroceder:</b> ' + StrZero(ZZE->ZZE_RETROC,2) + '<b></td>'
_cCabec += '	    </tr>'                                                       
_cCabec += '    </table>'                                                        
_cCabec += '    </p> '        

// Finaliza o HTML
_cCabec += '</html>'

cBody := _cCabec  // Corpo da mensagem

Return cBody  // retorno da fun��o