User Function TesteDirectory
   Local _aArquivos         
   
   Private cCaminho := GetNewPar("PAT_REDE", "http://192.168.0.15/VALIDACAO/SPOOL/")
   Private cLocal   := GetNewPar("MV_RELT" , "\SPOOL")
   
    For y = 1 To 2
       PERFILMODULO := IIF(y = 1,"perfilmodulo-06-07-financeiro-cadastro de natureza","perfil_acesso_menu")+".CSV"
       
       cDiretorio := AllTrim(cLocal+PERFILMODULO)
       Alert(cDiretorio )
   
   	   _aArquivos := Directory(cDiretorio)
   	   	   
   	   Alert( Len(_aArquivos) )
   	   For x = 1 to Len(_aArquivos)
   	      Alert(_aArquivos[x][1])                                    
   		  Alert(_aArquivos[1][x])
   	   Next x
   	Next y
Return