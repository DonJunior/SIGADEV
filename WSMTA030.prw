// ################################################################################################
// -----------+------------------+-----------------------------------------------------------------
// Data       | Autor: 	         | Descricao
// -----------+------------------+-----------------------------------------------------------------
// 12/06/2017 | Don Junior       | WebService para cadastro automático de clientes (MATA030)
// -----------+------------------+-----------------------------------------------------------------

#include 'protheus.ch'
#include 'apwebsrv.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'

#define CRLF Chr(13) + Chr(10)
#define STR0001 "Web Service de Cadastro de Clientes"
#define STR0002 "Método de gravação do Cliente."

WSSERVICE CADASTRARCLIENTE DESCRIPTION STR0001

	WSDATA CgcCpf             AS String // CGC ou CPF do cliente
	WSDATA NomeCliente        AS String	// Nome do cliente 
	WSDATA NomeFantasia       AS String // Nome fantasia
	WSDATA Endereco           AS String // Endereço
	WSDATA Complemento        AS String // Complemento (endereço)
	WSDATA Bairro             AS String // Bairro
	WSDATA UF                 AS String // UF
	WSDATA CEP                AS String // CEP
	WSDATA CodigoMunicipio    AS String // Codigo do município
	WSDATA TipoPessoa         AS String // PF/PJ/Outros
	WSDATA DDD                AS String // DDD
	WSDATA Telefone           AS String // Telefone
	WSDATA Contato            AS String // Contato
	WSDATA Email              AS String // Email
	WSDATA InscricaoEstadual  AS String // Inscrição Estadual
	WSDATA InscricaoMunicipal AS String // Inscrição Municipal
	WSDATA RetornarCliente    AS String // Retorno do webservice

	WSMETHOD IncluirCliente DESCRIPTION STR0002

ENDWSSERVICE

WSMETHOD IncluirCliente WSRECEIVE CgcCpf,NomeCliente,NomeFantasia,Endereco,Complemento,;
                                  Bairro,UF,CEP,CodigoMunicipio,DDD,Telefone,Contato,Email,;
                                  InscricaoEstadual,InscricaoMunicipal;
	WSSEND RetornarCliente WSSERVICE CADASTRARCLIENTE

	Private cCadastrado       := ""
	Private WsCgcCpf          := ::CgcCpf  
	Private WsLojaCliente	  := '01' // (Padrão = 01)
	Private WsNomeCliente     := ::NomeCliente
	Private WsNomeFantasia    := ::NomeFantasia 
	Private WsEndereco        := ::Endereco  
	Private WsComplemento     := ::Complemento 
	Private WsBairro          := ::Bairro 
	Private WsUF              := ::UF 
	Private WsCEP             := ::CEP 
	Private WsCodigoMunicipio := ::CodigoMunicipio 
	Private cNomeMunicipio    := ""
	Private WsTipoPessoa      := "" 
	Private WsTipoCliente     := 'F' // (Padrão = F - Consumidor Final) 
	Private WsDDD             := ::DDD 
	Private WsTelefone        := ::Telefone 
	Private WsContato         := ::Contato 
	Private WsEmail           := ::Email
	Private WsInscrEstadual   := ::InscricaoEstadual 
	Private WsInscrMunicipal  := ::InscricaoMunicipal 
	Private WsPais            := '105'   // Brasil 
	Private WsPaisBacen       := '01058' // Brasil  
	Private WsICMS            := '2' // 2 = não contribuinte de ICMS
	Private WsMSBLQL          := '1' // 1 = Bloqueado
	Private WsOrigCad         := '3' // Origem Cadastro 3 = WEB

	// preparando o ambiente do Protheus
	RpcSetType(3)
	If RpcSetEnv('99','01')

		// Validação de campos
		If Empty(WsCgcCpf)	  
			::RetornarCliente := 'NOK|CNPJ/CPF não informado.|'
			Return .T.
		Else
			WsCgcCpf := StrTran(WsCgcCpf, ".", "") // Removendo ponto
			WsCgcCpf := StrTran(WsCgcCpf, "/", "") // Removendo barra
			WsCgcCpf := StrTran(WsCgcCpf, "-", "") // Removendo traço
			WsCgcCpf := StrTran(WsCgcCpf, "\", "") // Removendo barra invertida

			If Len(WsCgcCpf) == 11 .Or. Len(WsCgcCpf) == 14

				// retorno ZERO da função val() indica existência de caractere não numérico
				If Val(WsCgcCpf) == 0 .And. WsCgcCpf <> "00000000000" .And. WsCgcCpf <> "00000000000000"
					::RetornarCliente := 'NOK|CNPJ/CPF possui caractere não numerico.|' + WsCgcCpf
					Return .T.
				ElseIf(!CGC(WsCgcCpf,,.F.)) .Or.                                              ;
					  (WsCgcCpf == "00000000000000" .Or.                                 ;
					   WsCgcCpf == "00000000000"    .Or. WsCgcCpf == "11111111111" .Or. ;
					   WsCgcCpf == "22222222222"    .Or. WsCgcCpf == "33333333333" .Or. ;
					   WsCgcCpf == "44444444444"    .Or. WsCgcCpf == "55555555555" .Or. ;
					   WsCgcCpf == "66666666666"    .Or. WsCgcCpf == "77777777777" .Or. ;
					   WsCgcCpf == "88888888888"    .Or. WsCgcCpf == "99999999999")
					::RetornarCliente := 'NOK|CNPJ/CPF Inválido.|' + WsCgcCpf
					Return .T.
				EndIf

				// Retorna o código do cliente caso já exista na SA1
				cCadastrado := RetCad()
				If !Empty(cCadastrado)
					::RetornarCliente := 'NOK|Cliente Já Cadastrado!|' + cCadastrado
					Return .T.
				EndIF
			Else
				::RetornarCliente := 'NOK|CNPJ/CPF Inválido.|' + WsCgcCpf
				Return .T.
			EndIf
			
			// atribuição do tipo de pessoa (F = Física, J = Jurídica, X = Estrangeiro)
			Do Case
				Case Len(WsCgcCpf) == 14
					WsTipoPessoa := "J"
				Case Len(WsCgcCpf) == 11
					WsTipoPessoa := "F"
				Otherwise
					WsTipoPessoa :=  "X"
			EndCase

		EndIf

		If Empty(WsNomeCliente)	  
			::RetornarCliente := 'NOK|Nome do Cliente não informado.|' + WsNomeCliente
			Return .T.
		Else
			WsNomeCliente := Upper(FwNoAccent(WsNomeCliente))
		EndIf

		If Empty(WsNomeFantasia)	  
			::RetornarCliente := 'NOK|Nome do Fantasia não informado.|' + WsNomeFantasia
			Return .T.
		Else
			WsNomeFantasia := Upper(FwNoAccent(WsNomeFantasia))
		EndIf

		If Empty(WsEndereco)	  
			::RetornarCliente := 'NOK|Endereço não informado.|' + WsEndereco
			Return .T.
		Else
			WsEndereco := StrTran(StrTran(Upper(FwNoAccent(WsEndereco)),'º',''),'ª','') 
		EndIf

		If Empty(WsBairro)	  
			::RetornarCliente := 'NOK|Bairro não informado.|' + WsBairro
			Return .T.
		Else
			WsBairro := Upper(FwNoAccent(WsBairro))
		EndIf

		If Empty(WsUF)	  
			::RetornarCliente := 'NOK|UF não informada.|' + WsUF
			Return .T.
		Else
			WsUF := Upper(AllTrim(WsUF))
			
			DbSelectArea("SX5")
			SX5->(DbSetOrder(1))
			If !SX5->(dbSeek(xFilial("SX5")+"12"+WsUF))
				::RetornarCliente := 'NOK|UF Inválida.|' + WsUF
				Return .T.
			Endif
		EndIf
		
		If Empty(WsCEP)	  
			::RetornarCliente := 'NOK|CEP não informado.|' + WsCEP
			Return .T.
		Else
			WsCEP := StrTran(WsCEP, "-", "") // Removendo traço

			// retorno ZERO da função val() indica existência de caractere não numérico
			If Val(WsCEP) == 0 
				::RetornarCliente := 'NOK|CEP Inválido.|' + WsCEP
				Return .T.
			EndIf
		EndIf

		If Empty(WsCodigoMunicipio)	  
			::RetornarCliente := 'NOK|Código do Municipio não informado.|' + WsCodigoMunicipio
			Return .T.
		Else
			DbSelectArea("CC2")
			CC2->(DbSetOrder(1))
			If CC2->(DbSeek(xFilial("CC2")+WsUF+WsCodigoMunicipio))
				cNomeMunicipio := CC2->CC2_MUN
				WsUF           := CC2->CC2_EST
			Else
				::RetornarCliente := 'NOK|Código do Municipio (IBGE) Inválido.|' + WsCodigoMunicipio
				Return .T.
			EndIf
		EndIf

		// Static Função de gravação Cliente
		::RetornarCliente := GravarCliente()
		Return .T.

	Else
		::RetornarCliente := "NOK|Falha de conexão com ambiente|RpcSetEnv('99','01')."
		Return .T.
	EndIf

Return .T.


// -------------------------------------------------------------------
// Função de gravação Cliente 
// -------------------------------------------------------------------
Static Function GravarCliente()

	Local aDados      := {}
	Local aErros      := {}
	Local c_Ret       := ''
	Local cNumCliente := ''
	Local nE          := 0

	// força a gravação das informações de erro em array, ao invés de gravar em arquivo temporário
	Private lMsHelpAuto	   := .T.
	Private lAutoErrNoFile := .T.
	Private lMsErroAuto    := .F.

//	AADD(aDados, {"A1_COD" 		,"123456"        	,Nil})
	AADD(aDados, {"A1_CGC" 		,WsCgcCpf        	,Nil})
	AADD(aDados, {"A1_LOJA" 	,WsLojaCliente	 	,Nil})
	AADD(aDados, {"A1_NOME" 	,WsNomeCliente    	,Nil})
	AADD(aDados, {"A1_NREDUZ" 	,WsNomeFantasia   	,Nil})
	AADD(aDados, {"A1_END" 		,WsEndereco       	,Nil})
	AADD(aDados, {"A1_COMPLEM" 	,WsComplemento    	,Nil})
	AADD(aDados, {"A1_BAIRRO" 	,WsBairro         	,Nil})
	AADD(aDados, {"A1_EST" 		,WsUF             	,Nil})
	AADD(aDados, {"A1_CEP" 		,WsCEP            	,Nil})
	AADD(aDados, {"A1_COD_MUN" 	,WsCodigoMunicipio	,Nil})
	AADD(aDados, {"A1_MUN" 		,cNomeMunicipio     ,Nil})
	AADD(aDados, {"A1_PESSOA" 	,WsTipoPessoa     	,Nil})
	AADD(aDados, {"A1_TIPO" 	,WsTipoCliente    	,Nil})
	AADD(aDados, {"A1_DDD" 		,WsDDD            	,Nil})
	AADD(aDados, {"A1_TEL" 		,WsTelefone       	,Nil})
	AADD(aDados, {"A1_CONTATO" 	,WsContato        	,Nil})
	AADD(aDados, {"A1_EMAIL" 	,WsEmail          	,Nil})
	AADD(aDados, {"A1_INSCR"    ,WsInscrEstadual    ,Nil})
	AADD(aDados, {"A1_INSCRM" 	,WsInscrMunicipal 	,Nil})
	AADD(aDados, {"A1_PAIS" 	,WsPais           	,Nil})
	AADD(aDados, {"A1_CODPAIS" 	,WsPaisBacen      	,Nil})
	AADD(aDados, {"A1_CONTRIB" 	,WsICMS 	      	,Nil})
	AADD(aDados, {"A1_MSBLQL" 	,WsMSBLQL	      	,Nil})
	AADD(aDados, {"A1_IBGE" 	,WsCodigoMunicipio  ,Nil})
	AADD(aDados, {"A1_ORIGCT" 	,WsOrigCad          ,Nil})

	// Função ordenar o vetor conforme o dicionário, em rotinas de MSExecAuto.
	aDados := FWVetByDic(aDados, "SA1", .F.)
	MsExecAuto({|x,y| Mata030(x,y)},aDados,3) //3- Inclusão, 4- Alteração, 5- Exclusão 

	If lMsErroAuto
		aErros := GetAutoGRLog() //retorna o erro encontrado no execauto.
	EndIf

	If Len(aErros) > 0
		c_Ret := "NOK|Erro de inclusão no Protheus (MsExecAuto) conforme:|" + CRLF

		For nE := 1 To Len(aErros)
			c_Ret += aErros[nE] + CRLF
		Next nE
	Else
		// Retorna o código do cliente
		cNumCliente := RetCad()
		
		If !Empty(cNumCliente)
			c_Ret += "OK|Cliente Incluído com sucesso!|" + cNumCliente
		Else
			c_Ret := "NOK|Falha ao recuperar o código do cliente.|" + cNumCliente + CRLF
		EndIf
	EndIf

Return c_Ret


// -------------------------------------------------------------------
// Função de retorno do código do cliente 
// -------------------------------------------------------------------
Static Function RetCad()

	Local cAliasSA1 := GetNextAlias()
	Local cQry      := ''
	Local cCodClie  := ''

	cQry := "SELECT SA1.A1_COD "
	cQry += "FROM "+RetSqlName("SA1")+" SA1 "
	cQry += "WHERE SA1.D_E_L_E_T_ = ' ' "
	cQry += "AND SA1.A1_CGC = '" + WsCgcCpf + "'"
	cQry += "AND SA1.A1_LOJA = '" + WsLojaCliente + "'"

	TcQuery cQry New Alias cAliasSA1

	If cAliasSA1->(!Eof())
		cCodClie := cAliasSA1->A1_COD
	EndIf

	cAliasSA1->(DbCloseArea())

Return cCodClie
