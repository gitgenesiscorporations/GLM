/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspR001 � Autor � George AC. Gon�alves � Data � 05/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspR001 � Autor � George AC. Gon�alves � Data � 25/06/09  ���
���          � GeralRel � Autor � George AC. Gon�alves � Data � 25/06/09  ���
���          � gERel001 � Autor � George AC. Gon�alves � Data � 25/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de Perfil de Acesso por Usu�rio                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Sele��o da op��o verifica��o perfil acesso-Rotina gEspG007 ���
���Partida   � Chamada Via Menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "Topconn.ch"      

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

User Function gEspR001()  // Relat�rio de Perfil de Acesso por Usu�rio

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,CPERG,NLASTKEY,LI")
SetPrvt("CABEC1,CABEC2,TAMANHO,NOMEPROG,M_PAG")

//+--------------------------------------------------------------+
//� Define Variaveis.                                            �
//+--------------------------------------------------------------+
titulo   := "Rela��o de Perfil de Acesso por Usu�rio"
cDesc1   := "Este programa ir� emitir o relat�rio de perfil de "
cDesc2   := "acesso por usu�rio"
cDesc3   := ""
aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
nLastKey := 0
nomeprog := "gEspR001"
m_pag    := 1                                              
tamanho  := "G"                                       
cabec1   := OemToAnsi("USU�RIO           NOME COMPLETO                              DEPARTAMENTO           CARGO/FUN��O           SUPERIOR               PERFIL                 MENU�s                                               STATUS ARQUIVO    BLOQUEADO    DT ULT ALTERA��O    E-MAIL")
cabec2   := ""
li       := 9999
lFlag    := .F.                    
LcPath   := GetNewPar("MV_RELT","\SPOOL\")
LcNmArq  := "PERFIL_ACESSO_USUARIOS.CSV"
aDbStru	 := {}
aTamSX3  := {}
cUsuAnt  := ""
cLin     := ""
cPerg    := "CFGR01"

// define v�rias privates
Private _nCont1
Private _nCont2
Private aUsers  := AllUsers(.T.)
Private aGroups := AllGroups()
Private cArqTxt := LcPath+LcNmArq
Private cEOL    := "CHR(13)+CHR(10)"

//+--------------------------------------------------------------+
//� Verifica as perguntas selecionadas                           �
//+--------------------------------------------------------------+
ValidPerg()  // chamada a fun��o de valida��o de grupo de perguntas

//+---------------------------------------------+
//� Variaveis utilizadas para parametros        �
//� mv_par01  // C�digo de Usu�rio Inicial	    �
//� mv_par02  // C�digo de Usu�rio Final	    �
//� mv_par03  // Departamento Inicial           �
//� mv_par04  // Departamento Final             �
//� mv_par05  // Cargo/Fun��o Inicial     	    �
//� mv_par06  // Cargo/Fun��o Final     	    �
//� mv_par07  // Superior Inicial          	    �
//� mv_par08  // Superior Final          	    �
//� mv_par09  // Perfil de Acesso Inicial       �
//� mv_par10  // Perfil de Acesso Final         � 
//� mv_par11  // Status Usu�rio				    �
//+---------------------------------------------+ 
///Pergunte(cPerg,.F.)  // chamada a fun��o de grupo de perguntas

//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT.                       �
//+--------------------------------------------------------------+
If gFlagParam == .T.  // se selecionar par�metros
	wnrel := SetPrint(,nomeprog,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
Else	
	wnrel := SetPrint(,nomeprog,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
EndIf
	
If LastKey() == 27 .Or. nLastKey == 27
   #IFNDEF WINDOWS
      RestScreen(3,0,24,79,cSavScr1)
   #ENDIF
   Return
EndIf

SetDefault(aReturn,cString)
 
If LastKey() == 27 .Or. nLastKey == 27
   #IFNDEF WINDOWS
      RestScreen(3,0,24,79,cSavScr1)
   #ENDIF
   Return
EndIf

RptStatus({|| GeraRel()},,"Gerando Relat�rio... " + Time())

Set Device To Screen  // define dispositivo para v�deo           

//+------------------------------------------------------------------+
//� Se impressao em Disco, chama Spool.                              �
//+------------------------------------------------------------------+
If aReturn[5] == 1
   Set Printer To 
   OurSpool(wnrel)
EndIf

//+------------------------------------------------------------------+
//� Libera relatorio para Spool da Rede.                             �
//+------------------------------------------------------------------+
FT_PFLUSH() 

Return  // retorno da fun��o      
****************************************************************************************************************************************************

Static Function GeraRel()  // gerando relat�rio

SetRegua(Len(aUsers)-1)

DbSelectArea("ZZY")  // seleciona arquivo de perfil de usu�rio

For _nCont1 := 1 To Len(aUsers)  // percorre todo o array de usu�rios

	IncRegua()
	
	If aUsers[_nCont1,1,1] <> '000000'  // se usu�rio n�o for o administrador
	
		If AllTrim(aUsers[_nCont1,1,1]) < AllTrim(mv_par01) .Or. AllTrim(aUsers[_nCont1,1,1]) > AllTrim(mv_par02)  // se registro fora do intervalo de ID do usu�rio 
			Loop  // pega pr�ximo registro
		EndIf
		If Upper(AllTrim(aUsers[_nCont1,1,12])) < Upper(AllTrim(mv_par03)) .Or. Upper(AllTrim(aUsers[_nCont1,1,12])) > Upper(AllTrim(mv_par04))  // se registro fora do intervalo de Departamento
			Loop  // pega pr�ximo registro
		EndIf		
		If Upper(AllTrim(aUsers[_nCont1,1,13])) < Upper(AllTrim(mv_par05)) .Or. Upper(AllTrim(aUsers[_nCont1,1,13])) > Upper(AllTrim(mv_par06))  // se registro fora do intervalo de Cargo/Fun��o
			Loop  // pega pr�ximo registro
		EndIf				   
		Do Case
			Case ValType(mv_par11) == "C" .And. mv_par11 == "1"  // se usu�rios liberados
				If aUsers[_nCont1,1,17] == .T.  // usu�rio bloqueado
					Loop
				EndIf
			Case ValType(mv_par11) == "C" .And. mv_par11 == "2"  // se usu�rios bloqueados
				If aUsers[_nCont1,1,17] == .F.  // usu�rio liberados
					Loop
				EndIf			
		EndCase	
		
		If !Empty(aUsers[_nCont1,1,11]) 		
			PswOrder(1)
			If PswSeek(aUsers[_nCont1,1,11],.T.)				
				inf := PswRet()
				If Upper(AllTrim(inf[1,4])) < Upper(AllTrim(mv_par07)) .Or. Upper(AllTrim(inf[1,4])) > Upper(AllTrim(mv_par08))  // se registro fora do intervalo de Superior
					Loop  // pega pr�ximo registro
				EndIf								
			EndIf	
		Else
			If !Empty(mv_par07)
				Loop  // pega pr�ximo registro
			EndIf
		EndIf	

		If Len(aUsers[_nCont1,1,10]) > 0				
           	For gLn := 1 To Len(aUsers[_nCont1,1,10]) 
				If Type("aGroups["+StrZero(Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]}),6)+",2]") == "A"  
				
					If Upper(AllTrim(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2])) < Upper(AllTrim(mv_par09)) .Or. Upper(AllTrim(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2])) > Upper(AllTrim(mv_par10))  // se registro fora do intervalo de Perfil
						Loop  // pega pr�ximo registro
					EndIf								
				
					For _nCont2 := 1 To Len(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2])
						If SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],3,1) <> "X"

							RecLock("ZZY",.T.)		                                                
							ZZY->ZZY_FILIAL := xFilial("ZZY")							
							ZZY->ZZY_USU    := Upper(SubStr(cUsuario,7,15))
							ZZY->ZZY_CDUSUA := aUsers[_nCont1,1,2]
							ZZY->ZZY_IDUSUA := aUsers[_nCont1,1,1]
							ZZY->ZZY_NMUSUA := aUsers[_nCont1,1,4]				
							ZZY->ZZY_DEPTO  := aUsers[_nCont1,1,12]				
							ZZY->ZZY_CARGO  := aUsers[_nCont1,1,13]		
							If !Empty(aUsers[_nCont1,1,11]) 		
								PswOrder(1)
								If PswSeek(aUsers[_nCont1,1,11],.T.)				
									inf := PswRet()
									ZZY->ZZY_SUPER := inf[1,4]
								EndIf	
							EndIf	
							ZZY->ZZY_PERFIL := aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2]
							ZZY->ZZY_MENU   := Upper(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50))
							If File(AllTrim(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50)))        							
								ZZY->ZZY_STATUS := "ARQ OK"
							Else                           
								ZZY->ZZY_STATUS := "ARQ INEXISTENTE"
							EndIf
							ZZY->ZZY_BLOQ   := If(aUsers[_nCont1,1,17]==.T.,"SIM" ,"N�O")
							ZZY->ZZY_EMAIL  := aUsers[_nCont1,1,14]									
							MsUnLock()
						EndIf	
					Next _nCont2
				Else 
					For _nCont2 := 1 To Len(aUsers[_nCont1,3])         
					
						If !Empty(mv_par09)
							Loop  // pega pr�ximo registro
						EndIf
										
						If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
							RecLock("ZZY",.T.)
							ZZY->ZZY_FILIAL := xFilial("ZZY")							
							ZZY->ZZY_USU    := Upper(SubStr(cUsuario,7,15))							
							ZZY->ZZY_CDUSUA := aUsers[_nCont1,1,2]
							ZZY->ZZY_IDUSUA := aUsers[_nCont1,1,1]
							ZZY->ZZY_NMUSUA := aUsers[_nCont1,1,4]				
							ZZY->ZZY_DEPTO  := aUsers[_nCont1,1,12]				
							ZZY->ZZY_CARGO  := aUsers[_nCont1,1,13]		
							If !Empty(aUsers[_nCont1,1,11]) 		
								PswOrder(1)
								If PswSeek(aUsers[_nCont1,1,11],.T.)				
									inf := PswRet()
									ZZY->ZZY_SUPER := inf[1,4]
								EndIf	
							EndIf	
							ZZY->ZZY_MENU := Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))
							If File(AllTrim(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))        
								ZZY->ZZY_STATUS := "ARQ OK"
							Else                           
								ZZY->ZZY_STATUS := "ARQ INEXISTENTE"
							EndIf
							ZZY->ZZY_BLOQ   := If(aUsers[_nCont1,1,17]==.T.,"SIM" ,"N�O")							
							ZZY->ZZY_EMAIL  := aUsers[_nCont1,1,14]																
							MsUnLock()
						EndIf	
					Next _nCont2				
				EndIf
			Next gLn	
		Else
			For _nCont2 := 1 To Len(aUsers[_nCont1,3])

				If !Empty(mv_par09)
					Loop  // pega pr�ximo registro
				EndIf			
			
				If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
					RecLock("ZZY",.T.)        
					ZZY->ZZY_FILIAL := xFilial("ZZY")					   
					ZZY->ZZY_USU    := Upper(SubStr(cUsuario,7,15))												
					ZZY->ZZY_CDUSUA := aUsers[_nCont1,1,2]
					ZZY->ZZY_IDUSUA := aUsers[_nCont1,1,1]
					ZZY->ZZY_NMUSUA := aUsers[_nCont1,1,4]				
					ZZY->ZZY_DEPTO  := aUsers[_nCont1,1,12]				
					ZZY->ZZY_CARGO  := aUsers[_nCont1,1,13]		
					If !Empty(aUsers[_nCont1,1,11]) 		
						PswOrder(1)
						If PswSeek(aUsers[_nCont1,1,11],.T.)				
							inf := PswRet()
							ZZY->ZZY_SUPER := inf[1,4]
						EndIf	
					EndIf	
					ZZY->ZZY_MENU := Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))
					If File(AllTrim(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))        
						ZZY->ZZY_STATUS := "ARQ OK"
					Else                           
						ZZY->ZZY_STATUS := "ARQ INEXISTENTE"
					EndIf
					ZZY->ZZY_BLOQ   := If(aUsers[_nCont1,1,17]==.T.,"SIM" ,"N�O")					
					ZZY->ZZY_EMAIL  := aUsers[_nCont1,1,14]														
					MsUnLock()
				EndIf	
			Next _nCont2
		EndIf	
	EndIf			
Next _nCont1

Private nHdl := fCreate(cArqTxt)

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgStop("O arquivo de nome "+cArqTxt+" n�o pode ser executado! Verifique os par�metros.","Aten��o!")
Else	
	cCabec := "COD USU�RIO"      +";" + ;
              "NOME DO USU�RIO"  +";" + ;
              "DEPARTAMENTO"     +";" + ;              
              "CARGO/FUN��O"     +";" + ;                            
              "NOME SUPERIOR"    +";" + ;              
              "PERFIL DE ACESSO" +";" + ;              
              "MENU DE ACESSO"   +";" + ;              
              "STATUS ARQUIVO"   +";" + ;                            
              "BLOQUEADO"        +";" + ;
              "DT ULT ALTERA��O" +";" + ;
              "E-MAIL"           +";" + ;
              "EMPRESAS"         +      ;                            
		      cEOL
		
	If fWrite(nHdl,cCabec,Len(cCabec)) != Len(cCabec)
		If !MsgAlert("Ocorreu um erro na grava��o do arquivo. Continua?","Aten��o!")
			Return
		Endif
	Endif

Endif

DbSelectArea("ZZY")  // seleciona arquivo de perfil de usu�rio
ZZY->(DbSetOrder(2))  // muda ordem do �ndice
ZZY->(DbGoTop())  // vai para o in�cio do arquivo
Do While !ZZY->(Eof())  // percorre todo o arquivo      

	If AllTrim(Upper(ZZY->ZZY_USU)) <> AllTrim(Upper(SubStr(cUsuario,7,15)))
		ZZY->(DbSkip())  // incrementa contador de registros	
		Loop  // pega pr�ximo registro
	EndIf
	
	// valida cancelamento pelo operador
	#IFNDEF WINDOWS
		If LASTKEY() == 286 .Or. LASTKEY() == 27             
			@ PROW()+1, 001 Psay "CANCELADO PELO OPERADOR"
			Exit 
		EndIf
	#ENDIF

	If li > 65  // se quebra de p�gina
		li := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIf(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
	EndIf   

	If !Empty(cUsuAnt) .And. cUsuAnt <> ZZY->ZZY_CDUSUA
		li := li + 1  // incrementa contador de linhas                              	               	
	EndIf

	@ li, 000 Psay ZZY->ZZY_CDUSUA  // display do ID do usu�rio
	@ li, 018 Psay ZZY->ZZY_NMUSUA  // display do nome do usu�rio
	@ li, 061 Psay ZZY->ZZY_DEPTO   // display do departamento
	@ li, 084 Psay ZZY->ZZY_CARGO   // display do cargo/fun��o
	@ li, 107 Psay ZZY->ZZY_SUPER   // display do superior
	@ li, 130 Psay ZZY->ZZY_PERFIL  // display do perfil de acesso
	@ li, 153 Psay ZZY->ZZY_MENU    // display do menu
	@ li, 206 Psay ZZY->ZZY_STATUS  // display do status do arquivo de menu  
	@ li, 224 Psay ZZY->ZZY_BLOQ    // display do bloqueio do usu�rio
	
	cDtUltAlt := ""  // Data da �ltima altera��o
	cEmpresas := ""  // empresas/filiais
	
	PSWORDER(2)  // muda ordem de �ndice
	If PswSeek(ZZY->ZZY_CDUSUA) == .T.  // se encontrar usu�rio no arquivo
		aArray    := PSWRET()
		cDtUltAlt := DToC(aArray[1][16])  // Data da �ltima altera��o
		For y = 1 To Len(aArray[2][6])  
			If "@" $ aArray[2][6][y] 
				cEmpresas += IIf(Empty(cEmpresas),"@@@@",'|'+"@@@@")
			Else   
			    cEmpresas += IIf(Empty(cEmpresas),StrZero(Val(aArray[2][6][y]),4),'|'+StrZero(Val(aArray[2][6][y]),4))
			EndIf		   		
		Next y		
	EndIf

	@ li, 235 Psay cDtUltAlt        // display da data da �ltima altera��o
	@ li, 255 Psay ZZY->ZZY_EMAIL   // display do e-mail do usu�rio	
	
	li := li + 1  // incrementa contador de linhas                              	               
	cUsuAnt := ZZY->ZZY_CDUSUA
                     
	cLin := ZZY->ZZY_CDUSUA + ";" + ;
			ZZY->ZZY_NMUSUA + ";" + ;
			ZZY->ZZY_DEPTO  + ";" + ;
			ZZY->ZZY_CARGO  + ";" + ;
			ZZY->ZZY_SUPER  + ";" + ;			
			ZZY->ZZY_PERFIL + ";" + ;
			ZZY->ZZY_MENU   + ";" + ;															
			ZZY->ZZY_STATUS + ";" + ;																		
			ZZY->ZZY_BLOQ   + ";" + ; 	        
			cDtUltAlt       + ";" + ; 	        
			ZZY->ZZY_EMAIL  + ";" + ; 	        
			cEmpresas       +       ;			
			cEOL // Variavel para criacao da linha do registros para gravacao
			
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na grava��o do arquivo. Continua?","Aten��o!")
			Exit
		Endif
	Endif

	ZZY->(DbSkip())  // incrementa contador de registros
    	  	
EndDo                                                         

fClose(nHdl)

//_cExec := AllTrim(GetMv("PATCHEXCEL"))
//_cDoc1 := AllTrim(GetMv("PATCH_REDE"))+LcPath+LcNmArq
  
//WinExec(_cExec + " " + _cDoc1)  // abre planilha no EXCEL

_cDoc1 := AllTrim(GetMv("PATCH_REDE"))+LcPath+LcNmArq
_cExec := u_ProcuraExcel()
 	
If Aviso("ATEN��O" , "Deseja gerar planilha em excel ?", {"Sim" , "N�o" } )  =  1
  	WinExec(_cExec + " " + _cDoc1)  // abre planilha no EXCEL
EndIf  
	
cQuery := "  DELETE " + RetSqlname("ZZY") + " WHERE ZZY_USU = '" + AllTrim(Upper(SubStr(cUsuario,7,15))) + "' " 

TCSQLExec(cQuery)
TCSQLExec("Commit")  // executa commit

Set Filter To

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do �ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","ID Usu�rio Inicial"    ,"ID Usu�rio Inicial"    ,"ID Usu�rio Inicial"    ,"mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","",""})
	Aadd(aRegs,{cPerg,"02","ID Usu�rio Final"      ,"ID Usu�rio Final"      ,"ID Usu�rio Final"      ,"mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","",""})
	Aadd(aRegs,{cPerg,"03","Departamento Inicial"  ,"Departamento Inicial"  ,"Departamento Inicial"  ,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"04","Departamento Final"    ,"Departamento Final"    ,"Departamento Final"	 ,"mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"05","Cargo/Fun��o Inicial"  ,"Cargo/Fun��o Inicial"  ,"Cargo/Fun��o Inicial"	 ,"mv_ch5","C",20,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"06","Cargo/Fun��o Final"    ,"Cargo/Fun��o Final"    ,"Cargo/Fun��o Final"	 ,"mv_ch6","C",20,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"07","Superior Inicial"      ,"Superior Inicial"      ,"Superior Inicial"	     ,"mv_ch7","C",20,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"08","Superior Final"        ,"Superior Final"        ,"Superior Final"	     ,"mv_ch8","C",20,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"09","Perfil Acesso Inicial" ,"Perfil Acesso Inicial" ,"Perfil Acesso Inicial" ,"mv_ch9","C",20,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"10","Perfil Acesso Final"   ,"Perfil Acesso Final"   ,"Perfil Acesso Final"	 ,"mv_chA","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"11","Status Usu�rio"        ,"Status Usu�rio"        ,"Status Usu�rio"	     ,"mv_chB","C",01,0,0,"C","","mv_par11","Liberados","Liberados","Liberados","","","Bloqueados","Bloqueados","Bloqueados","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","","",""})	

   For i := 1 To Len(aRegs)
      RecLock("SX1",.T.)
      For j := 1 To FCount()
         If j <= Len(aRegs[i])
            FieldPut(j,aRegs[i,j])              
         EndIf
      Next
      MsUnlock()
   Next
	
EndIf

Return  // Retorno da fun��o
****************************************************************************************************************************************************

User Function gERel001()  // Relat�rio de Perfil de Acesso por Usu�rio

Public gFlagParam := .T.  // determina sele��o de par�metros: .T. = seleciona, .F. = n�o seleciona

Public mv_par01 := ""                      // C�digo de Usu�rio Inicial	    
Public mv_par02 := "999999"                // C�digo de Usu�rio Final
Public mv_par03 := ""                      // Departamento Inicial
Public mv_par04 := "ZZZZZZZZZZZZZZZZZZZZ"  // Departamento Final
Public mv_par05 := ""                      // Cargo/Fun��o Inicial
Public mv_par06 := "ZZZZZZZZZZZZZZZZZZZZ"  // Cargo/Fun��o Final
Public mv_par07 := ""                      // Superior Inicial
Public mv_par08 := "ZZZZZZZZZZZZZZZZZZZZ"  // Superior Final
Public mv_par09 := ""                      // Perfil de Acesso Inicial
Public mv_par10 := "ZZZZZZZZZZZZZZZZZZZZ"  // Perfil de Acesso Final
Public mv_par11 := "3"                     // Status Usu�rio

U_gEspR001()  // Relat�rio de Perfil de Acesso por Usu�rio			
				
Return  // Retorno da fun��o