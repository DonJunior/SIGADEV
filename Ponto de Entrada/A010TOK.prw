// ################################################################################################
// -----------+------------------+-----------------------------------------------------------------
// Data       | Autor: 	         | Descricao
// -----------+------------------+-----------------------------------------------------------------
// 04/07/2018 | Don Junior       | Ponto Entrada para validações após a confirmação da inclusão ou
//            |                  | alteração, antes da gravação do Produto.
// -----------+------------------+-----------------------------------------------------------------

#Include 'Protheus.ch'
#define CRLF Chr(13)+Chr(10)

User Function A010TOK()

	Local lExecuta := .T.
	Local cMsg     := ""
	
	If Empty(M->B1_CONTA) 
		cMsg += "Aba Cadastrais - Cta Contabil (B1_CONTA)" + CRLF
	EndIf
	
	If Empty(M->B1_TE) 
		cMsg += "Aba Cadastrais - TE Padrao (B1_TE)"  + CRLF
	EndIf

	If Empty(M->B1_IRRF) 
		cMsg += "Aba Impostos - Impos.Renda (B1_IRRF)"  + CRLF
	EndIf

	// Só validar PIS/COFINS/CSLL se o tipo for SV = Serviço 
	If M->B1_TIPO == "SV"
		If M->B1_PIS == "2"
			cMsg += "Aba Impostos - Retem PIS (B1_PIS) Deve Ser Igual a 1-Sim"  + CRLF
		EndIf
		
		If M->B1_COFINS == "2" 
			cMsg += "Aba Impostos - Retem COF (B1_COFINS) Deve Ser Igual a 1-Sim"  + CRLF
		EndIf
		
		If M->B1_CSLL == "2"
			cMsg += "Aba Impostos - Retem CSLL (B1_CSLL) Deve Ser Igual a 1-Sim"  + CRLF
		EndIf
	EndIf

	If !Empty(cMsg)
		If !MsgYesNo(cMsg + CRLF + CRLF + "Deseja Continuar ?","Campos Não Informados:")
			lExecuta := .F.
		EndIf
	EndIf

/*	
	If Empty(M->B1_GRUPO) 
		cMsg += "Aba Cadastrais - Grupo (B1_GRUPO)" + CRLF
	EndIf
	
	If Empty(M->B1_TS) 
		cMsg += "TS Padrao (B1_TS)"  + CRLF
	EndIf

	If Empty(M->B1_INSS) 
		cMsg += "Calcula INSS (B1_INSS)"  + CRLF
	EndIf
	
	If Empty(M->B1_ALIQISS) 
		cMsg += "Aba Impostos - Aliq. ISS (B1_ALIQISS)" + CRLF
	EndIf
	
	If Empty(M->B1_CODISS) 
		cMsg += "Aba Impostos - Cod. Serv. ISS (B1_CODISS)" + CRLF
	EndIf
	
	If Empty(M->B1_REDINSS) 
		cMsg += "Aba Impostos - % Red. INSS (B1_REDINSS)"  + CRLF
	EndIf
	
	If Empty(M->B1_REDIRRF) 
		cMsg += "% Red. IRRF (B1_REDIRRF)"  + CRLF
	EndIf
	
	If Empty(M->B1_REDPIS) 
		cMsg += "Aba Impostos - % Red. PIS (B1_REDPIS)"  + CRLF
	EndIf
	
	If Empty(M->B1_REDCOF) 
		cMsg += "Aba Impostos - % Red. COFINS (B1_REDCOF)"  + CRLF
	EndIf
	
	If Empty(M->B1_PCSLL) 
		cMsg += "Aba Impostos - Perc. CSLL (B1_PCSLL)"  + CRLF
	EndIf
	
	If Empty(M->B1_PCOFINS) 
		cMsg += "Aba Impostos - Perc. COFINS (B1_PCOFINS)"  + CRLF
	EndIf
	
	If Empty(M->B1_PPIS) 
		cMsg += "Aba Impostos - Perc. PIS (B1_PPIS)"  + CRLF
	EndIf
	
	If Empty(M->B1_CNATREC) 
		cMsg += "Aba Impostos - Cod Nat Rec (B1_CNATREC)"  + CRLF
	EndIf
	
	If Empty(M->B1_TNATREC) 
		cMsg += "Aba Impostos - Tab. Na. Rec (B1_TNATREC)"
	EndIf
*/	

Return lExecuta

