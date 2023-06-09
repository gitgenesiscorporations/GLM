/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp011 � Autor � George AC Gon�alves  � Data � 28/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp011 � Autor � George AC Gon�alves  � Data � 29/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta acols com os m�dulos/perfis                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do usu�rio - Rotina gEspI002           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp011()  // Monta acols com os m�dulos/perfis

gcPNivel := ""
cCampo   := ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDDEPT"})]  // campo de retorno

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
Else	              
	aArray := {}
EndIf	

If Len(aCols) <= 1  // se start na primeira linha                    

	vLinha := AClone(aCols[N])

	For gLn := 1 To Len(aArray[1][10])
		gcCdMod  := SubStr(aArray[1][10][gLn],1,2)  // c�digo do m�dulo
		gcCdPerf := SubStr(aArray[1][10][gLn],3,2)  // c�digo do perfil
		
		For gwN := 1 To Len(aArray[3])
			If SubStr(aArray[3][gwN],1,2) == gcCdMod  // identifica m�dulo
				gcPNivel := SubStr(aArray[3][gwN],3,1)  // n�vel de acesso
			EndIf
		Next			

		gcCdDepto := ""  // c�digo do departamento
		gcDsDepto := ""  // descri��o do departamento
		gcDsMod   := ""  // descri��o do m�dulo
		gcCdGest  := ""  // C�digo do gestor do m�dulo
		gcNmGest  := ""  // Nome do gestor do m�dulo  
		gcIDGest  := ""  // ID do gestor do m�dulo				
		DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
		ZZJ->(DbSetOrder(2))  // muda ordem do �ndice
		If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona ponteiro
			gcCdDepto := ZZJ->ZZJ_CDDEP   // c�digo do departamento
			gcDsDepto := ZZJ->ZZJ_DSDEP   // descri��o do departamento			
			gcDsMod   := ZZJ->ZZJ_DSMOD   // descri��o do m�dulo			
			gcCdGest  := ZZJ->ZZJ_GESTOR  // C�digo do gestor do m�dulo
			gcNmGest  := ZZJ->ZZJ_NMGEST  // Nome do gestor do m�dulo					
			
			PSWORDER(1)  // muda ordem de �ndice
			If PswSeek(gcCdGest) == .T.  // se encontrar usu�rio no arquivo
				aArrGest := PSWRET()
				gcIDGest := aArrGest[1][2] // Retorna o ID do usu�rio
			EndIf						
		EndIf

		gcDsPerf := ""  // descri��o do perfil
		gcPConf  := ""  // perfil conflitante?
		DbSelectArea("ZZC")  // seleciona arquivo de m�dulo/perfil
		ZZC->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZC->(DbSeek(xFilial("ZZC")+gcCdMod+gcCdPerf))  // posiciona ponteiro
			gcDsPerf := ZZC->ZZC_DSPERF  // descri��o do perfil
			gcPConf  := ZZC->ZZC_PCRIT   // perfil conflitante?
		EndIf		
		
		gcIDCtrl := M->ZZE_IDCTRL  // ID do Controller

		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_ITEM"   })] := StrZero(Len(aCols),2)
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDDEPT" })] := gcCdDepto
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_DSDEPT" })] := gcDsDepto
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDMOD"  })] := gcCdMod
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_DSMOD"  })] := gcDsMod
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_GESTOR" })] := gcCdGest
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_NMGEST" })] := gcNmGest
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_IDGEST" })] := gcIDGest
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDPERF" })] := gcCdPerf
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_DSPERF" })] := gcDsPerf		
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_PCRIT"  })] := gcPConf
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_NIVEL"  })] := gcPNivel
		ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_IDCTRL" })] := gcIDCtrl

		If Len(aCols) < Len(aArray[1][10])
			Aadd(aCols,AClone(vLinha))      
			N := Len(aCols)
		EndIf	

	Next

EndIf    

N := 1

GetdRefresh()

Return cCampo  // retorno da fun��o