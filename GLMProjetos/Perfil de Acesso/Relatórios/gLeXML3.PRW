/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gLeXML3   � Autor � George AC. Gon�alves � Data � 19/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gLeXML3   � Autor � George AC. Gon�alves � Data � 21/01/09 ���
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

User Function gLeXML3(cIDMod,cCdPerf)  // Efetua leitura dos arquivos de menu em formato XML
//cIDMod  = ID do m�dulo
//cCdPerf = C�digo do perfil

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

Private _cPatch := AllTrim(GetMv("PATCH_MENU"))
Private _aMenus := Directory(_cPatch+"\"+cIDMod+"\*.XNU")

SetRegua(Len(_aMenus)-1)

DbSelectArea("ZZC")  // seleciona arquivo de m�dulo/perfil
ZZC->(DbSetOrder(1))  // muda ordem do �ndice
If ZZC->(DbSeek(xFilial("ZZC")+cIDMod+cCdPerf))  // posiciona registro
	_aDados := XNULoad(ZZC->ZZC_XNU) // Carrega os dados do menu

    GRAVADBF(_aDados,ZZC->ZZC_XNU,cIDMod,cCdPerf)  // chamada a fun��o de carga tabela de trabalho

EndIf

Return  // retorno da fun��o
**************************************************************************************************************************************************

Static Function GravaDBF(_aDadMenu,_cArq,cIDMod,cCdPerf)  // grava arquivo de trabalho
//_aDadMenu = Estrutura do arquivo .XNU
//_cArq     = Nome do Arquivo .XNU
//cIDMod    = ID do m�dulo
//cCdPerf   = C�digo do perfil

DbSelectArea("ZZZ")  // seleciona arquivo de perfil de acesso

For Ln1 := 1 To Len (_aDadMenu)
	For Ln2 := 1 To Len(_aDadMenu[Ln1,3])               
		If ValType(_aDadMenu[Ln1,3,Ln2,3]) == "C"		
			RecLock("ZZZ",.T.)		                                                
			ZZZ->ZZZ_FILIAL := xFilial("ZZZ")
			ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))
			ZZZ->ZZZ_MOD    := cIDMod  ///_aDadMenu[Ln1,3,Ln2,6]								
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
					RecLock("ZZZ",.T.)		 
					ZZZ->ZZZ_FILIAL := xFilial("ZZZ")					
					ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))					
					ZZZ->ZZZ_MOD    := cIDMod  ///_aDadMenu[Ln1,3,Ln2,3,Ln3,6]
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
							RecLock("ZZZ",.T.)		
							ZZZ->ZZZ_FILIAL := xFilial("ZZZ")							
							ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))							
							ZZZ->ZZZ_MOD    := cIDMod  ///_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,6]
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
								RecLock("ZZZ",.T.)		
								ZZZ->ZZZ_FILIAL := xFilial("ZZZ")								
								ZZZ->ZZZ_USU    := Upper(SubStr(cUsuario,7,15))								
								ZZZ->ZZZ_MOD    := cIDMod  ///_aDadMenu[Ln1,3,Ln2,3,Ln3,3,Ln4,3,Ln5,6]
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