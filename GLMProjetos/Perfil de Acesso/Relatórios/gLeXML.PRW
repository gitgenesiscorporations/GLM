/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gLeXML    � Autor � George AC. Gon�alves � Data � 19/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gLeXML    � Autor � George AC. Gon�alves � Data � 21/01/09 ���
���          � GravaDBF  � Autor � George AC. Gon�alves � Data � 21/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua leitura dos arquivos de menu em formato XML         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Relat�rio de Perfil de Acesso por M�dulo - Rotina gEspR005 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function gLeXML(cIdModI,cIDModF)  // Efetua leitura dos arquivos de menu em formato XML
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

///Private _cPatch := AllTrim(GetMv("PATCH_MENU"))
///Private _aMenus := Directory(_cPatch+"\*.XNU") 
Private _cPatch
Private _aMenus 
Private _cArquivo

Public c1ArqRec
Public c2ArqRec

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

c1ArqRec := CriaTrab(aStru, .T. )
///c2ArqRec := CriaTrab(aStru, .T. )     
c2ArqRec := Left(CriaTrab(Nil,.F.),7)+"A"

dbUseArea(.T.,,c1ArqRec,"TRB",.F.,.F.)
IndRegua("TRB",c1ArqRec,"ID_MOD+ID_ARQ+ID_NIV1+ID_NIV2+ID_NIV3+ID_NIV4+ID_NIV5",,,"Selecionando Registros...")  //"Selecionando Registros..."	
IndRegua("TRB",c2ArqRec,"ID_MOD+ID_NIV1+ID_NIV2+ID_NIV3+ID_NIV4+ID_NIV5+ID_ARQ",,,"Selecionando Registros...")  //"Selecionando Registros..."	

If Empty(cIdModI)
	cIdModI := "01"  // m�dulo inicial
EndIf	        
If cIdModF == "ZZ"
	cIdModF := "99"  // m�dulo final
EndIf
	
For gLn := Val(cIdModI) To Val(cIDModF)
	_cPatch := AllTrim(GetMv("PATCH_MENU"))+"\"+StrZero(gLn,2)
	_aMenus := Directory(_cPatch+"\*.XNU")

	SetRegua(Len(_aMenus)-1)

	For _ni := 1 To Len(_aMenus)

		IncRegua()
	
		_cArquivo := _cPatch+"\" + _aMenus[_ni,1]		
		_aDados   := XNULoad(_cArquivo) // Carrega os dados do menu

	    GRAVADBF(_aDados,_aMenus[_ni,1],cIdModI,cIDModF)  // chamada a fun��o de carga tabela de trabalho

	next _ni
	
	DbSelectArea("TRB")
	COPY TO MENUS.DBF
	
Next gLn	
	
Return  // retorno da fun��o
**************************************************************************************************************************************************

Static Function GravaDBF(_aDadMenu,_cArq,cIdModI,cIDModF)  // grava arquivo de trabalho

For Ln1 := 1 To Len (_aDadMenu)
	For Ln2 := 1 To Len(_aDadMenu[Ln1,3])               
		If ValType(_aDadMenu[Ln1,3,Ln2,3]) == "C"		
			If AllTrim(_aDadMenu[Ln1,3,Ln2,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
				Loop  // pega pr�ximo registro
			EndIf
			RecLock("TRB",.T.)		
			TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,6]								
			TRB->ID_ARQ   := Upper(_cArq)			
			TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
			TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
			TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3]
			TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,7]
			TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,2]
			TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,5]			
			MsUnlock()    				 
		Else		
			For Ln3 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3])
				If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3]) == "C"					
					If AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
						Loop  // pega pr�ximo registro
					EndIf				
					RecLock("TRB",.T.)		
					TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,6]
					TRB->ID_ARQ   := Upper(_cArq)			
					TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
					TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
					TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
					TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3]
					TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,7]
					TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,2]
					TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,5]
					MsUnlock()    									
				Else 
					For Ln4 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3])
						If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]) == "C"					
							If AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
								Loop  // pega pr�ximo registro
							EndIf										
							RecLock("TRB",.T.)		
							TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]
							TRB->ID_ARQ   := Upper(_cArq)			
							TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
							TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
							TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
							TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
							TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]
							TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,7]
							TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,2]
							TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,5]
							MsUnlock()    									
						Else 
							For Ln5 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3])
								If AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
									Loop  // pega pr�ximo registro
								EndIf																	
								RecLock("TRB",.T.)		
								TRB->ID_MOD   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]
								TRB->ID_ARQ   := Upper(_cArq)			
								TRB->ID_NIV1  := Upper(_aDadMenu[Ln1,1,1])
								TRB->ID_NIV2  := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
								TRB->ID_NIV3  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
								TRB->ID_NIV4  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
								TRB->ID_NIV5  := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,1,1])														
								TRB->ID_PRG   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,3]
								TRB->ID_TIPO  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,7]
								TRB->ID_STAT  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,2]
								TRB->ID_ACESS := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,5]
								MsUnlock()    									
							Next Ln5					
						EndIf	
					Next Ln4
				EndIf
			Next Ln3
		EndIf	
	Next Ln2
Next Ln1

Return  // retorno da fun��o