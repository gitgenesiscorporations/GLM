/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gLeXML2   � Autor � George AC. Gon�alves � Data � 19/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gLeXML2   � Autor � George AC. Gon�alves � Data � 19/01/09 ���
���          � GravaDBF  � Autor � George AC. Gon�alves � Data � 19/01/09 ���
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

User Function gLeXML2(cIDModI,cIDModF)  // Efetua leitura dos arquivos de menu em formato XML
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

	    GRAVADBF(_aDados,_aMenus[_ni,1],cIDModI,cIDModF)  // chamada a fun��o de carga tabela de trabalho

	next _ni
	
Next gLn	
	
Return  // retorno da fun��o
**************************************************************************************************************************************************

Static Function GravaDBF(_aDadMenu,_cArq,cIDModI,cIDModF)  // grava arquivo de trabalho

DbSelectArea("ZZZ")  // seleciona arquivo de perfil de acesso

For Ln1 := 1 To Len (_aDadMenu)
	For Ln2 := 1 To Len(_aDadMenu[Ln1,3])               
		If ValType(_aDadMenu[Ln1,3,Ln2,3]) == "C"		
			If AllTrim(_aDadMenu[Ln1,3,Ln2,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
				Loop  // pega pr�ximo registro
			EndIf
			RecLock("ZZZ",.T.)		                                                
			ZZZ->ZZZ_FILIAL := xFilial("ZZZ")
			ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))
			ZZZ->ZZZ_MOD    := _aDadMenu[Ln1,3,Ln2,6]								
			ZZZ->ZZZ_ARQ    := Upper(_cArq)			
			ZZZ->ZZZ_NIV1   := Upper(_aDadMenu[Ln1,1,1])
			ZZZ->ZZZ_NIV2   := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
			ZZZ->ZZZ_PRG    := _aDadMenu[Ln1,3,Ln2,3]
			ZZZ->ZZZ_TIPO   := _aDadMenu[Ln1,3,Ln2,7]
			ZZZ->ZZZ_STAT   := _aDadMenu[Ln1,3,Ln2,2]
			ZZZ->ZZZ_ACESS  := _aDadMenu[Ln1,3,Ln2,5]			
			MsUnlock()    				 
		Else		
			For Ln3 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3])
				If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3]) == "C"					
					If AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
						Loop  // pega pr�ximo registro
					EndIf				
					RecLock("ZZZ",.T.)		 
					ZZZ->ZZZ_FILIAL := xFilial("ZZZ")					
					ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))					
					ZZZ->ZZZ_MOD    := _aDadMenu[Ln1,3,Ln2,3,Ln3,6]
					ZZZ->ZZZ_ARQ    := Upper(_cArq)			
					ZZZ->ZZZ_NIV1   := Upper(_aDadMenu[Ln1,1,1])
					ZZZ->ZZZ_NIV2   := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
					ZZZ->ZZZ_NIV3   := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
					ZZZ->ZZZ_PRG    := _aDadMenu[Ln1,3,Ln2,3,Ln3,3]
					ZZZ->ZZZ_TIPO   := _aDadMenu[Ln1,3,Ln2,3,Ln3,7]
					ZZZ->ZZZ_STAT   := _aDadMenu[Ln1,3,Ln2,3,Ln3,2]
					ZZZ->ZZZ_ACESS  := _aDadMenu[Ln1,3,Ln2,3,Ln3,5]
					MsUnlock()    									
				Else 
					For Ln4 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3])
						If ValType(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]) == "C"					
							If AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
								Loop  // pega pr�ximo registro
							EndIf										
							RecLock("ZZZ",.T.)		

							ZZZ->ZZZ_FILIAL := xFilial("ZZZ")							
							ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))							
							ZZZ->ZZZ_MOD    := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]
							ZZZ->ZZZ_ARQ    := Upper(_cArq)			
							ZZZ->ZZZ_NIV1   := Upper(_aDadMenu[Ln1,1,1])
							ZZZ->ZZZ_NIV2   := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
							ZZZ->ZZZ_NIV3   := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
							ZZZ->ZZZ_NIV4   := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
							ZZZ->ZZZ_PRG    := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3]
							ZZZ->ZZZ_TIPO   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,7]
							ZZZ->ZZZ_STAT   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,2]
							ZZZ->ZZZ_ACESS  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,5]
							MsUnlock()    									
						Else 
							For Ln5 := 1 To Len(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3])
								If AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]) < AllTrim(cIdModI) .Or. AllTrim(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]) > AllTrim(cIdModF)  // se registro fora do intervalo de ID do usu�rio 
									Loop  // pega pr�ximo registro
								EndIf																	
								RecLock("ZZZ",.T.)		
								ZZZ->ZZZ_FILIAL := xFilial("ZZZ")								
								ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))								
								ZZZ->ZZZ_MOD    := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]
								ZZZ->ZZZ_ARQ    := Upper(_cArq)			
								ZZZ->ZZZ_NIV1   := Upper(_aDadMenu[Ln1,1,1])
								ZZZ->ZZZ_NIV2   := Upper(_aDadMenu[Ln1,3,Ln2,1,1])
								ZZZ->ZZZ_NIV3   := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,1,1])
								ZZZ->ZZZ_NIV4   := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,1,1])						
								ZZZ->ZZZ_NIV5   := Upper(_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,1,1])														
								ZZZ->ZZZ_PRG    := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,3]
								ZZZ->ZZZ_TIPO   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,7]
								ZZZ->ZZZ_STAT   := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,2]
								ZZZ->ZZZ_ACESS  := _aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,5]
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