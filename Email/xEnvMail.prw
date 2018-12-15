// ################################################################################################
// -----------+------------------+-----------------------------------------------------------------
// Data       | Autor: 	         | Descricao
// -----------+------------------+-----------------------------------------------------------------
// 09/05/2017 | Don Junior       | Interface para teste no envio de e-mails  
// -----------+------------------+-----------------------------------------------------------------

#Include 'Protheus.ch'

User Function xEnvMail()

	Local   oButton1
	Local   oButton2
	Local   oButton3
	Local   oButton4
	Local   oGet1
	Local   oGet2
	Local   oGet3
	Local   oGet4
	Local   oGet5
	Local   oGroup1
	Local   oGroup2
	Local   oGroup3
	Local   oGroup4
	Local   oMultiGe1
	Local   oPanel
	Local   oSay1
	Local   oSay2
	Local   oSay3
	Local   oSay4
	Local   oSay5
	Local   oDlg
	Local   cExt      := "Texto (*.txt) | *.txt"
	Local   nDir      := GETF_LOCALHARD + GETF_NETWORKDRIVE
	Private cDir      := "C:\TEMP\"
	Private cGet1     := "para.seu@email.com.br"
	Private cGet2     := "copia.seu@email.com.br"
	Private cGet3     := ""
	Private cGet4     := "Teste email ADVPL"
	Private cGet5     := cDir + "anexo.txt"
	Private cMultiGe1 := "Esta mensagem é um teste </br> Não responda!"

	DEFINE MSDIALOG oDlg TITLE "Teste Envio Email" STYLE DS_MODALFRAME FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

	@ 000, 001 MSPANEL oPanel SIZE 400, 273 OF oDlg COLORS 0, 16777215 RAISED
	
	@ 006, 003 GROUP oGroup1 TO 058, 393 OF oPanel COLOR 0, 16777215 PIXEL
	@ 015, 020 SAY oSay1 PROMPT "Para:" SIZE 020, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 013, 036 MSGET oGet1 VAR cGet1 SIZE 350, 010 OF oPanel COLORS 0, 16777215 PIXEL

	@ 030, 018 SAY oSay2 PROMPT "Copia:" SIZE 020, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 028, 036 MSGET oGet2 VAR cGet2 SIZE 350, 010 OF oPanel COLORS 0, 16777215 PIXEL

	@ 045, 022 SAY oSay3 PROMPT "CCo:" SIZE 020, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 043, 036 MSGET oGet3 VAR cGet3 SIZE 350, 010 OF oPanel COLORS 0, 16777215 PIXEL
	
	@ 060, 003 GROUP oGroup2 TO 086, 393 OF oPanel COLOR 0, 16777215 PIXEL
	@ 069, 012 SAY oSay4 PROMPT "Assunto:" SIZE 020, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 067, 036 MSGET oGet4 VAR cGet4 SIZE 350, 010 OF oPanel COLORS 0, 16777215 PIXEL
	
	@ 090, 003 GROUP oGroup3 TO 115, 393 OF oPanel COLOR 0, 16777215 PIXEL
	@ 099, 017 SAY oSay5 PROMPT "Anexo:" SIZE 020, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 097, 036 MSGET oGet5 VAR cGet5 SIZE 340, 010 OF oPanel COLORS 0, 16777215 PIXEL
	@ 097, 377 BUTTON oButton1 PROMPT "..." SIZE 011, 012 OF oDlg PIXEL ACTION cGet5 := cGetFile(cExt,cExt,1,cDir,.F.,nDir,.F.,)
	
	@ 119, 004 GROUP oGroup4 TO 230, 393 OF oPanel COLOR 0, 16777215 PIXEL
	@ 125, 009 GET oMultiGe1 VAR cMultiGe1 OF oPanel MULTILINE SIZE 380, 100 COLORS 0, 16777215 HSCROLL PIXEL
	@ 237, 030 BUTTON oButton2 PROMPT "Enviar" SIZE 037, 012 OF oDlg PIXEL ACTION EnvMsg()
	@ 237, 070 BUTTON oButton3 PROMPT "Limpar" SIZE 037, 012 OF oDlg PIXEL ACTION Limpar()
	@ 237, 330 BUTTON oButton4 PROMPT "Fechar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

// -----------------------------------------------------------
// Função de chamada para user function de envio de emails
// -----------------------------------------------------------
Static Function EnvMsg()
	
	// U_SENDMAIL(seus parametros)
	MsgInfo("Mensagem Enviada")
	
	// Chamada par limpa as variáveis
	Limpar()
Return


// -----------------------------------------------------------
// Função para limpa as variáveis
// -----------------------------------------------------------
Static Function Limpar()
	
	cGet1     := ""
	cGet2     := ""
	cGet3     := ""
	cGet4     := ""
	cGet5     := ""
	cMultiGe1 := ""

Return
