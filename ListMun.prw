// ################################################################################################
// -----------+------------------+-----------------------------------------------------------------
// Data       | Autor: 	         | Descricao
// -----------+------------------+-----------------------------------------------------------------
// 21/12/2017 | Don Carvalho     | WebService para geração de listagem de municípios (tabela CC2)
// -----------+------------------+-----------------------------------------------------------------
// Id         | String           | Nome do Sistema + Data do Sistema + UF
// -----------+------------------+-----------------------------------------------------------------

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'apwebsrv.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'

#define STR0001 "Retorna Listagem de Municípios Protheus"
#define STR0002 "Método de pesquisa do cadastro de municipios.<br><br>Informe uma UF para retornar os respectivos municípios.<br><b>* Se Não informado, o método retorná todos os Municipios</b><br>"

WSSTRUCT MunicipiosProtheus
	WSDATA CodigoUF            AS String // Unidade Federativa
	WSDATA CodigoMunicipio     AS String // Código do Municipio
	WSDATA DescricaoMunicipio  AS String // Descrição do Municipio
ENDWSSTRUCT

WSSERVICE ListarMunicipios DESCRIPTION STR0001
	WSDATA Id                 AS String // Nome do Sistema + Data do Sistema + UF
	WSDATA Sistema            AS String // Nome do Sistema chamador
	WSDATA CodigoUF   	      AS String	
	WSDATA CadastroMunicipios AS Array OF MunicipiosProtheus // Retorno do webservice

	WSMETHOD BuscarMunicipios DESCRIPTION STR0002
ENDWSSERVICE

WSMETHOD BuscarMunicipios WSRECEIVE Id, Sistema, CodigoUF;
                   WSSEND CadastroMunicipios WSSERVICE ListarMunicipios

	Local   nAADD      := 0
	Local   cQry       := ''
	Local   cAliasCC2  := ''
	Private cIdConexao := ::Id
	Private cSistema   := ::Sistema
	Private cCodigoUF  := ::CodigoUF
	
	// preparando o ambiente do Protheus
	RpcSetType(3)
	If RpcSetEnv('99','01')
		
		// Retorna erro caso não seja passado Id e Sistema
		If Empty(cIdConexao) .Or. Empty(cSistema)
			AADD(::CadastroMunicipios,WSClassNew("MunicipiosProtheus"))
			::CadastroMunicipios[1]:CodigoUF           := ""
			::CadastroMunicipios[1]:CodigoMunicipio    := ""
			::CadastroMunicipios[1]:DescricaoMunicipio := "NOK|Campo ID ou Sistema não informado!"
			Return .T.
		Else	
			// Valida acesso pelo Id
			If !XACESSO(cIdConexao,cSistema,cCodigoUF)
				AADD(::CadastroMunicipios,WSClassNew("MunicipiosProtheus"))
				::CadastroMunicipios[1]:CodigoUF           := ""
				::CadastroMunicipios[1]:CodigoMunicipio    := ""
				::CadastroMunicipios[1]:DescricaoMunicipio := "NOK|Falha de Acesso, ID ou Sistema Inválido!"
				Return .T.
			EndIf
		EndIf
		
		cAliasCC2 := GetNextAlias()
			
		cQry := "SELECT CC2.CC2_EST, CC2.CC2_CODMUN, CC2.CC2_MUN"
		cQry += "FROM "+RetSqlName("CC2")+" CC2 "
		cQry += "WHERE CC2.D_E_L_E_T_ <> '*' "
	
		If !Empty(cCodigoUF)
			cQry += "AND CC2.CC2_EST = '" + Upper(cCodigoUF) + "' "
		EndIf
	
		cQry += "ORDER BY CC2.CC2_MUN"
	
		cQry := ChangeQuery(cQry)
		TcQuery cQry New Alias cAliasCC2

		While !cAliasCC2->(Eof())
	
			nAADD++
			AADD(::CadastroMunicipios,WSClassNew("MunicipiosProtheus"))
			::CadastroMunicipios[nAADD]:CodigoUF           := cAliasCC2->CC2_EST
			::CadastroMunicipios[nAADD]:CodigoMunicipio    := cAliasCC2->CC2_CODMUN
			::CadastroMunicipios[nAADD]:DescricaoMunicipio := FwNoAccent(cAliasCC2->CC2_MUN)

			cAliasCC2->(DbSkip()) 
		End

		cAliasCC2->(DbCloseArea())
		
	Else
		AADD(::CadastroMunicipios,WSClassNew("MunicipiosProtheus"))
		::CadastroMunicipios[1]:CodigoUF           := ""
		::CadastroMunicipios[1]:CodigoMunicipio    := ""
		::CadastroMunicipios[1]:DescricaoMunicipio := "NOK|Erro de conexão com servidor Protheus RpcSetEnv('01','0101')"
	EndIf
	
Return .T.

// --------------------------------------------
// Validação do acesso
// --------------------------------------------
Static Function XACESSO()

	Local lRet := .F.
	Local cTkn := Md5(Sistema + cValToChar(Date()) + CodigoUF,2)
	
	If Id == cTkn
		lRet := .T.
	EndIf
	
Return lRet
