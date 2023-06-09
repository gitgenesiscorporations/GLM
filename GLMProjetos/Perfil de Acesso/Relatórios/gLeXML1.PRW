/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gLeXML1   � Autor � George AC. Gon�alves � Data � 19/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gLeXML1   � Autor � George AC. Gon�alves � Data � 21/01/09 ���
���          � GravaDBF  � Autor � George AC. Gon�alves � Data � 21/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua leitura dos arquivos de menu em formato XML         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Relat�rio de Perfil de Acesso por M�dulo - Rotina gEspR002 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function gLeXML1(cIdUsuI,cIdUsuF,cPerfI,cPerfF,cIdModI,cIdModF)  // Efetua leitura dos arquivos de menu em formato XML
//cIdUsuI = ID do usu�rio inicial
//cIdUsuF = ID do usu�rio final
//cPerfI  = C�digo do perfil inicial
//cPerfF  = C�digo do perfil final
//cIdModI = ID do m�dulo inicial
//cIdModF = ID do m�dulo final

/*
Estrutura do retorno da Xnuload:
[i,1] Array de 3 posi��es com o nome da fun��o:
[i,1,1] T�tulo em Portugues
[i,1,2] T�tulo em Espanhol
[i,1,3] T�tulo em Ingles
[i,2] Status - E ativada (<menuitem status=enable>), D desativada (<menuitem status=disable>)
[i,3] Array com outro aMenu(recursivo) ou o nome da fun��o (as posi��es de 4 a 7 s� existem no caso do tipo [i,3] for igual a caracter)
[i,4] Array com as tabelas que a fun��o usa
[i,5] Acesso
[i,6] N�mero do m�dulo
[i,7] Tipo da fun��o
*/

Local aStru := {}

Private aUsers  := AllUsers(.T.)
Private aGroups := AllGroups()
///Private _cPatch := AllTrim(GetMv("PATCH_MENU"))
///Private _aMenus := Directory(_cPatch+"\*.XNU")
Private _cPatch 
Private _aMenus 
Private _cArquivo

aAdd(aStru,{"ID_USUA" ,"C",15,00})
aAdd(aStru,{"ID_PERF" ,"C",20,00})
aAdd(aStru,{"ID_MOD"  ,"C",03,00})
aAdd(aStru,{"ID_ARQ"  ,"C",20,00})
aAdd(aStru,{"ID_NIV1" ,"C",30,00})
aAdd(aStru,{"ID_NIV2" ,"C",30,00})
aAdd(aStru,{"ID_NIV3" ,"C",30,00})
aAdd(aStru,{"ID_NIV4" ,"C",30,00})
aAdd(aStru,{"ID_NIV5" ,"C",30,00})
aAdd(aStru,{"ID_PRG"  ,"C",20,00})
aAdd(aStru,{"ID_TIPO" ,"N",05,00})
aAdd(aStru,{"ID_STAT" ,"C",05,00})
aAdd(aStru,{"ID_ACESS","C",20,00})
aAdd(aStru,{"ID_ATIVO","C",01,00})

Public cArqRec1 := CriaTrab(aStru, .T. )

dbUseArea(.T.,,cArqRec1,"TRB",.F.,.F.)
IndRegua("TRB",cArqRec1,"ID_USUA+ID_PERF+ID_MOD+ID_ARQ+ID_NIV1+ID_NIV2+ID_NIV3+ID_NIV4+ID_NIV5",,,"Selecionando Registros...")  //"Selecionando Registros..."
DbClearIndex()
DbSetIndex(cArqRec1 + OrdBagExt())

For gLn := Val(cIdModI) To Val(cIDModF)
	_cPatch := AllTrim(GetMv("PATCH_MENU"))+"\"+StrZero(gLn,2)
	_aMenus := Directory(_cPatch+"\*.XNU")

	GRAVADBF(_aMenus,cIdUsuI,cIdUsuF,cPerfI,cPerfF,cIdModI,cIdModF)  // chamada a fun��o de carga tabela de trabalho    

	DbSelectArea("TRB")
	COPY TO MENUS.DBF
                     
Next gLn	

Return  // retorno da fun��o
**************************************************************************************************************************************************

Static Function GravaDBF(_cArq,cIdUsuI,cIdUsuF,cPerfI,cPerfF,cIdModI,cIdModF)  // grava arquivo de trabalho

_gUsuario := ""
_gPerfil  := ""
_cAtivo   := ""
lExit1    := .F.
lExit2    := .F.

For _nCont1 := 1 To Len(aUsers)
	If aUsers[_nCont1,1,1] <> '000000'
	
		If AllTrim(aUsers[_nCont1,1,1]) < AllTrim(cIdUsuI) .Or. AllTrim(aUsers[_nCont1,1,1]) > AllTrim(cIdUsuF)  // se registro fora do intervalo de ID do usu�rio 
			Loop  // pega pr�ximo registro
		EndIf

		If Len(aUsers[_nCont1,1,10]) > 0				
           	For gLn := 1 To Len(aUsers[_nCont1,1,10]) 
				If Type("aGroups["+StrZero(Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]}),6)+",2]") == "A"  
					For _nCont2 := 1 To Len(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2])
						If SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],3,1) <> "X"
							If File(AllTrim(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50)))						
								If File(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))        			
									If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
										PswOrder(1)
										If PswSeek(aUsers[_nCont1,1,1],.T.)				
											aInf := PswRet()
											_gUsuario := aInf[1,2]
											_cAtivo   := If(aInf[1][17]==.F.,"S","N")
											If Len(aUsers[_nCont1,1,10]) > 0
												_gPerfil  := aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2]
											Else	
												_gPerfil  := ""					
											EndIf	
						
											If Upper(AllTrim(_gPerfil)) < Upper(AllTrim(cPerfI)) .Or. Upper(AllTrim(_gPerfil)) > AllTrim(cPerfF)  // se registro fora do intervalo de ID do usu�rio 
												Loop  // pega pr�ximo registro
											EndIf
						
											_aDadMenu := XNULoad(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))) // Carrega os dados do menu

											For Ln1 := 1 To Len (_aDadMenu)
												For Ln2 := 1 To Len(_aDadMenu[Ln1,3])               
													If ValType(_aDadMenu[Ln1,3,Ln2,3]) == "C"		
														If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
															Loop  // pega pr�ximo registro
														EndIf								
														RecLock("TRB",.T.)		
														TRB->ID_USUA  := _gUsuario
														TRB->ID_PERF  := _gPerfil
														TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,6]														
														TRB->ID_ARQ   := Upper(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50))									
														TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
														TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
														TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3]
														TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,7]
														TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,2]
														TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,5]			
														TRB->ID_ATIVO := _cAtivo
														MsUnlock()    				 
													Else		
														For Ln3 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3])
															If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3]) == "C"					
																If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
																	Loop  // pega pr�ximo registro
																EndIf																		
																RecLock("TRB",.T.)		
																TRB->ID_USUA  := _gUsuario
																TRB->ID_PERF  := _gPerfil
																TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,6]
																TRB->ID_ARQ   := Upper(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50))
																TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
																TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
																TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
																TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3]
																TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,7]
																TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,2]
																TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,5]
																TRB->ID_ATIVO := _cAtivo																
																MsUnlock()    									
															Else 
																For Ln4 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3])
																	If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]) == "C"					
																		If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
																			Loop  // pega pr�ximo registro
																		EndIf																														
																		RecLock("TRB",.T.)		
																		TRB->ID_USUA  := _gUsuario
																		TRB->ID_PERF  := _gPerfil
																		TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]
																		TRB->ID_ARQ   := Upper(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50))
																		TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
																		TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
																		TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
																		TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
																		TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]
																		TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,7]
																		TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,2]
																		TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,5]
																		TRB->ID_ATIVO := _cAtivo																		
																		MsUnlock()    									
																	Else 
																		For Ln5 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3])
																			If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
																				Loop  // pega pr�ximo registro
																			EndIf																																											
																			RecLock("TRB",.T.)		
																			TRB->ID_USUA  := _gUsuario
																			TRB->ID_PERF  := _gPerfil
																			TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]
																			TRB->ID_ARQ   := Upper(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50))
																			TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
																			TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
																			TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
																			TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
																			TRB->ID_NIV5  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,1,1])																												
																			TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,3]
																			TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,7]
																			TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,2]
																			TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,5]
																			TRB->ID_ATIVO := _cAtivo																			
																			MsUnlock()    									
																		Next Ln5					
																	EndIf	
																Next Ln4
															EndIf
														Next Ln3
													EndIf	
												Next Ln2
											Next Ln1
										EndIf	
									EndIf		
								EndIf
                            EndIf
                        EndIf
					Next _nCont2

				Else 
					For _nCont2 := 1 To Len(aUsers[_nCont1,3])
						If File(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))        			
							If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
								PswOrder(1)
								If PswSeek(aUsers[_nCont1,1,1],.T.)				
									aInf := PswRet()
									_gUsuario := aInf[1,2]
									_cAtivo   := If(aInf[1][17]==.F.,"S","N")
									If Len(aUsers[_nCont1,1,10]) > 0
										_gPerfil  := aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,1]})][1][2]					
									Else	
										_gPerfil  := ""					
									EndIf	

									If Upper(AllTrim(_gPerfil)) < Upper(AllTrim(cPerfI)) .Or. Upper(AllTrim(_gPerfil)) > AllTrim(cPerfF)  // se registro fora do intervalo de ID do usu�rio 
										Loop  // pega pr�ximo registro
									EndIf
						
									_aDadMenu := XNULoad(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))) // Carrega os dados do menu
									
									For Ln1 := 1 To Len (_aDadMenu)
										For Ln2 := 1 To Len(_aDadMenu[Ln1,3])               
											If ValType(_aDadMenu[Ln1,3,Ln2,3]) == "C"		
												If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
													Loop  // pega pr�ximo registro
												EndIf								
												RecLock("TRB",.T.)		
												TRB->ID_USUA  := _gUsuario
												TRB->ID_PERF  := _gPerfil
												TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,6]														
												TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
												TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
												TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
												TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3]
												TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,7]
												TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,2]
												TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,5]			
												TRB->ID_ATIVO := _cAtivo												
												MsUnlock()    				 
											Else		
												For Ln3 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3])
													If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3]) == "C"					
														If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
															Loop  // pega pr�ximo registro
														EndIf																		
														RecLock("TRB",.T.)		
														TRB->ID_USUA  := _gUsuario
														TRB->ID_PERF  := _gPerfil
														TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,6]
														TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
														TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
														TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
														TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
														TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3]
														TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,7]
														TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,2]
														TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,5]
														TRB->ID_ATIVO := _cAtivo														
														MsUnlock()    									
													Else 
														For Ln4 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3])
															If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]) == "C"					
																If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
																	Loop  // pega pr�ximo registro
																EndIf																														
																RecLock("TRB",.T.)		
																TRB->ID_USUA  := _gUsuario
																TRB->ID_PERF  := _gPerfil
																TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]
																TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
																TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
																TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
																TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
																TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
																TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]
																TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,7]
																TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,2]
																TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,5]
																TRB->ID_ATIVO := _cAtivo																
																MsUnlock()    									
															Else 
																For Ln5 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3])
																	If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
																		Loop  // pega pr�ximo registro
																	EndIf																																											
																	RecLock("TRB",.T.)		
																	TRB->ID_USUA  := _gUsuario
																	TRB->ID_PERF  := _gPerfil
																	TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]
																	TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
																	TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
																	TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
																	TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
																	TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
																	TRB->ID_NIV5  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,1,1])																												
																	TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,3]
																	TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,7]
																	TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,2]
																	TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,5]
																	TRB->ID_ATIVO := _cAtivo																	
																	MsUnlock()    									
																Next Ln5					
															EndIf	
														Next Ln4
													EndIf
												Next Ln3
											EndIf	
										Next Ln2
									Next Ln1
								EndIf	
							EndIf		
						EndIf
					Next _nCont2

				EndIf				

			Next gLn
			
		Else
		
			For _nCont2 := 1 To Len(aUsers[_nCont1,3])
				If File(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))        			
					If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
						PswOrder(1)
						If PswSeek(aUsers[_nCont1,1,1],.T.)				
							aInf := PswRet()
							_gUsuario := aInf[1,2]
							_cAtivo   := If(aInf[1][17]==.F.,"S","N")
							If Len(aUsers[_nCont1,1,10]) > 0
								_gPerfil  := aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,1]})][1][2]					
							Else	
								_gPerfil  := ""					
							EndIf	

							If Upper(AllTrim(_gPerfil)) < Upper(AllTrim(cPerfI)) .Or. Upper(AllTrim(_gPerfil)) > AllTrim(cPerfF)  // se registro fora do intervalo de ID do usu�rio 
								Loop  // pega pr�ximo registro
							EndIf
						
							_aDadMenu := XNULoad(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))) // Carrega os dados do menu

							For Ln1 := 1 To Len (_aDadMenu)
								For Ln2 := 1 To Len(_aDadMenu[Ln1,3])               
									If ValType(_aDadMenu[Ln1,3,Ln2,3]) == "C"		
										If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
											Loop  // pega pr�ximo registro
										EndIf								
										RecLock("TRB",.T.)		
										TRB->ID_USUA  := _gUsuario
										TRB->ID_PERF  := _gPerfil
										TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,6]														
										TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
										TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
										TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
										TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3]
										TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,7]
										TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,2]
										TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,5]			
										TRB->ID_ATIVO := _cAtivo										
										MsUnlock()    				 
									Else		
										For Ln3 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3])
											If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3]) == "C"					
												If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
													Loop  // pega pr�ximo registro
												EndIf																		
												RecLock("TRB",.T.)		
												TRB->ID_USUA  := _gUsuario
												TRB->ID_PERF  := _gPerfil
												TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,6]
												TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
												TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
												TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
												TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
												TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3]
												TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,7]
												TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,2]
												TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,5]
												TRB->ID_ATIVO := _cAtivo												
												MsUnlock()    									
											Else 
												For Ln4 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3])
													If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]) == "C"					
														If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
															Loop  // pega pr�ximo registro
														EndIf																														
														RecLock("TRB",.T.)		
														TRB->ID_USUA  := _gUsuario
														TRB->ID_PERF  := _gPerfil
														TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]
														TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
														TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
														TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
														TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
														TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
														TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]
														TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,7]
														TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,2]
														TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,5]
														TRB->ID_ATIVO := _cAtivo														
														MsUnlock()    									
													Else 
														For Ln5 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3])
															If Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6])) < Upper(AllTrim(cIdModI)) .Or. Upper(AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6])) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
																Loop  // pega pr�ximo registro
															EndIf																																											
															RecLock("TRB",.T.)		
															TRB->ID_USUA  := _gUsuario
															TRB->ID_PERF  := _gPerfil
															TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]
															TRB->ID_ARQ   := Upper(AllTrim(Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))))			
															TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
															TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
															TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
															TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
															TRB->ID_NIV5  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,1,1])																												
															TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,3]
															TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,7]
															TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,2]
															TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,5]
															TRB->ID_ATIVO := _cAtivo															
															MsUnlock()    									
														Next Ln5					
													EndIf	
												Next Ln4
											EndIf
										Next Ln3
									EndIf	
								Next Ln2
							Next Ln1
						EndIf	
					EndIf		
				EndIf
			Next _nCont2		
			
		EndIf						
	EndIf
Next _nCont1

Return  // retorno da fun��o