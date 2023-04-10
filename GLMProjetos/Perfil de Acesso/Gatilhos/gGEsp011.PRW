/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gGEsp011 ³ Autor ³ George AC Gonçalves  ³ Data ³ 28/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gGEsp011 ³ Autor ³ George AC Gonçalves  ³ Data ³ 29/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Monta acols com os módulos/perfis                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Digitação do código do usuário - Rotina gEspI002           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp011()  // Monta acols com os módulos/perfis

gcPNivel := ""
cCampo   := ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDDEPT"})]  // campo de retorno

PSWORDER(1)  // muda ordem de índice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usuário no arquivo
	aArray := PSWRET()
Else	              
	aArray := {}
EndIf	

If Len(aCols) <= 1  // se start na primeira linha                    

	vLinha := AClone(aCols[N])

	For gLn := 1 To Len(aArray[1][10])
		gcCdMod  := SubStr(aArray[1][10][gLn],1,2)  // código do módulo
		gcCdPerf := SubStr(aArray[1][10][gLn],3,2)  // código do perfil
		
		For gwN := 1 To Len(aArray[3])
			If SubStr(aArray[3][gwN],1,2) == gcCdMod  // identifica módulo
				gcPNivel := SubStr(aArray[3][gwN],3,1)  // nível de acesso
			EndIf
		Next			

		gcCdDepto := ""  // código do departamento
		gcDsDepto := ""  // descrição do departamento
		gcDsMod   := ""  // descrição do módulo
		gcCdGest  := ""  // Código do gestor do módulo
		gcNmGest  := ""  // Nome do gestor do módulo  
		gcIDGest  := ""  // ID do gestor do módulo				
		DbSelectArea("ZZJ")  // seleciona arquivo de departamento/módulo
		ZZJ->(DbSetOrder(2))  // muda ordem do índice
		If ZZJ->(DbSeek(xFilial("ZZJ")+gcCdMod))  // posiciona ponteiro
			gcCdDepto := ZZJ->ZZJ_CDDEP   // código do departamento
			gcDsDepto := ZZJ->ZZJ_DSDEP   // descrição do departamento			
			gcDsMod   := ZZJ->ZZJ_DSMOD   // descrição do módulo			
			gcCdGest  := ZZJ->ZZJ_GESTOR  // Código do gestor do módulo
			gcNmGest  := ZZJ->ZZJ_NMGEST  // Nome do gestor do módulo					
			
			PSWORDER(1)  // muda ordem de índice
			If PswSeek(gcCdGest) == .T.  // se encontrar usuário no arquivo
				aArrGest := PSWRET()
				gcIDGest := aArrGest[1][2] // Retorna o ID do usuário
			EndIf						
		EndIf

		gcDsPerf := ""  // descrição do perfil
		gcPConf  := ""  // perfil conflitante?
		DbSelectArea("ZZC")  // seleciona arquivo de módulo/perfil
		ZZC->(DbSetOrder(1))  // muda ordem do índice
		If ZZC->(DbSeek(xFilial("ZZC")+gcCdMod+gcCdPerf))  // posiciona ponteiro
			gcDsPerf := ZZC->ZZC_DSPERF  // descrição do perfil
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

Return cCampo  // retorno da função