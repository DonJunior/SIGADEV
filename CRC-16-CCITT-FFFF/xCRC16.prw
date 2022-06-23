// #########################################################################################
// -----------+-----------------+-----------------------------------------------------------
// Data       | Autor:          | Descricao
// -----------+-----------------+-----------------------------------------------------------
// 14/08/2021 | Don Junior  	| Função genérica para cálculo do CRC-16 
//            |                 | (Cyclic Redundancy Check)
// -----------+-----------------^-----------------------------------------------------------
// Observação | Manual BR Code BANCO CENTRAL - Versão 2.0.1
// -----------+-----------------------------------------------------------------------------
//            | Segundo seção 4.7.3 CRC (ID “63”) da referência #1, utiliza-se para o 
//            | cálculo do CRC, o polinômio '1021' (hexa) e valor inicial 'FFFF' (hexa),
//            | que corresponde ao CRC 'CRC-16-CCITT-FFFF'.
// -----------^-----------------------------------------------------------------------------

#Include 'protheus.ch'

Function U_xCRC16(cInPut)

    Local nX
    Local nPos
    Local cAux1
    Local cAux2
    Local cByte
    Local aInPut
    Local n0xFF   := U_xDec2Bin("255")   // Conversão de decimal para binário
    Local cCrc16  := U_xDec2Bin("65535") // Conversão de decimal para binário
    Local n0xFFFF := cCrc16              // "65535"
    Local aTable  := FGetCRC()           // Criação do array de tabelas base 8 Bits

    // Incluído para testes
    If Empty(cInPut)
        cInPut := "14BR.GOV.BCB.PIX+DON JUNIOR"
    EndIf

    aInPut := FGetAsc(cInput) // Criação do array com os códigos ASC da string recebida por parametro

    For nX := 1 To Len(aInPut)

        cAux1  := U_xDec2Bin(aInPut[nX])    // Conversão de decimal para binário
        cByte  := U_xAnd2Bin(cAux1,n0xFF)   // Operação AND (x & y) de números binarios
       
        cAux1  := U_xBitWise(cByte,"<")     // Movimento do bit para esquerda
        cAux2  := U_xXor2Bin(cCrc16,cAux1)  // Operação XOR (x ^ y) de números binarios
        cCrc16 := U_xAnd2Bin(cAux2,n0xFFFF) // Operação AND (x & y) de números binarios

        cAux1  := U_xBitWise(cCrc16,">")    // Movimento do bit para direita
        cAux2  := U_xAnd2Bin(cAux1,n0xFF)   // Operação AND (x & y) de números binarios
        nPos   := U_xBin2Dec(cAux2) +1      // Conversão de binário para decimal - Somando +1 pois no javascript a matriz inicial em 0

        cAux1  := U_xBitWise(cCrc16,"<")    // Movimento do bit para esquerda
        cCrc16 := U_xAnd2Bin(cAux1,n0xFFFF) // Operação AND (x & y) de números binarios

        cAux1  := U_xDec2Bin(aTable[nPos])  // Conversão de decimal para binário
        cAux2  := U_xXor2Bin(cCrc16,cAux1)  // Operação XOR (x ^ y) de números binarios
        cCrc16 := U_xAnd2Bin(cAux2,n0xFFFF) // Operação AND (x & y) de números binarios

    Next nX

    cAux1  := U_xXor2Bin(cCrc16,"0")        // Operação XOR (x ^ y) de números binarios
    cCrc16 := U_xAnd2Bin(cAux1,n0xFFFF)     // Operação AND (x & y) de números binarios

    cAux1  := U_xBin2Dec(cCrc16)            // Conversão de binário para decimal
    cCrc16 := U_xDec2Hex(cAux1)             // Conversão de decimal para hexadecimal

    MsgInfo("CRC => " + cCrc16)

Return cCrc16


// -------------------------------------------------------------------
// Função para montagem do array com os códigos ASC
// -------------------------------------------------------------------
Static Function FGetAsc(cInput)

    Local nI
    Local nAsc
    Local aRet := {}
    Local nTam := Len(cInput)

    For nI := 1 To nTam
        
        nAsc := Asc( SubStr(cInput,nI,1) )
        
        // Testa se é código ASCII de 8 Bits
        If nAsc < 256
            AADD(aRet,cValToChar(nAsc))
        EndIf

    Next nI

Return aRet


// -------------------------------------------------------------------
// Função de montagem do array FIXO de CRC das tabelas base 8 Bits
// -------------------------------------------------------------------
Static Function FGetCRC()

	Local aCRC := { "0"     ,"4129"  ,"8258"  ,"12387" ,"16516" ,"20645" ,"24774" ,;
                    "28903" ,"33032" ,"37161" ,"41290" ,"45419" ,"49548" ,"53677" ,;
                    "57806" ,"61935" ,"4657"  ,"528"   ,"12915" ,"8786"  ,"21173" ,;
                    "17044" ,"29431" ,"25302" ,"37689" ,"33560" ,"45947" ,"41818" ,;
                    "54205" ,"50076" ,"62463" ,"58334" ,"9314"  ,"13379" ,"1056"  ,;
                    "5121"  ,"25830" ,"29895" ,"17572" ,"21637" ,"42346" ,"46411" ,;
                    "34088" ,"38153" ,"58862" ,"62927" ,"50604" ,"54669" ,"13907" ,;
                    "9842"  ,"5649"  ,"1584"  ,"30423" ,"26358" ,"22165" ,"18100" ,;
                    "46939" ,"42874" ,"38681" ,"34616" ,"63455" ,"59390" ,"55197" ,;
                    "51132" ,"18628" ,"22757" ,"26758" ,"30887" ,"2112"  ,"6241"  ,;
                    "10242" ,"14371" ,"51660" ,"55789" ,"59790" ,"63919" ,"35144" ,;
                    "39273" ,"43274" ,"47403" ,"23285" ,"19156" ,"31415" ,"27286" ,;
                    "6769"  ,"2640"  ,"14899" ,"10770" ,"56317" ,"52188" ,"64447" ,;
                    "60318" ,"39801" ,"35672" ,"47931" ,"43802" ,"27814" ,"31879" ,;
                    "19684" ,"23749" ,"11298" ,"15363" ,"3168"  ,"7233"  ,"60846" ,;
                    "64911" ,"52716" ,"56781" ,"44330" ,"48395" ,"36200" ,"40265" ,;
                    "32407" ,"28342" ,"24277" ,"20212" ,"15891" ,"11826" ,"7761"  ,;
                    "3696"  ,"65439" ,"61374" ,"57309" ,"53244" ,"48923" ,"44858" ,;
                    "40793" ,"36728" ,"37256" ,"33193" ,"45514" ,"41451" ,"53516" ,;
                    "49453" ,"61774" ,"57711" ,"4224"  ,"161"   ,"12482" ,"8419"  ,;
                    "20484" ,"16421" ,"28742" ,"24679" ,"33721" ,"37784" ,"41979" ,;
                    "46042" ,"49981" ,"54044" ,"58239" ,"62302" ,"689"   ,"4752"  ,;
                    "8947"  ,"13010" ,"16949" ,"21012" ,"25207" ,"29270" ,"46570" ,;
                    "42443" ,"38312" ,"34185" ,"62830" ,"58703" ,"54572" ,"50445" ,;
                    "13538" ,"9411"  ,"5280"  ,"1153"  ,"29798" ,"25671" ,"21540" ,;
                    "17413" ,"42971" ,"47098" ,"34713" ,"38840" ,"59231" ,"63358" ,;
                    "50973" ,"55100" ,"9939"  ,"14066" ,"1681"  ,"5808"  ,"26199" ,;
                    "30326" ,"17941" ,"22068" ,"55628" ,"51565" ,"63758" ,"59695" ,;
                    "39368" ,"35305" ,"47498" ,"43435" ,"22596" ,"18533" ,"30726" ,;
                    "26663" ,"6336"  ,"2273"  ,"14466" ,"10403" ,"52093" ,"56156" ,;
                    "60223" ,"64286" ,"35833" ,"39896" ,"43963" ,"48026" ,"19061" ,;
                    "23124" ,"27191" ,"31254" ,"2801"  ,"6864"  ,"10931" ,"14994" ,;
                    "64814" ,"60687" ,"56684" ,"52557" ,"48554" ,"44427" ,"40424" ,;
                    "36297" ,"31782" ,"27655" ,"23652" ,"19525" ,"15522" ,"11395" ,;
                    "7392"  ,"3265"  ,"61215" ,"65342" ,"53085" ,"57212" ,"44955" ,;
                    "49082" ,"36825" ,"40952" ,"28183" ,"32310" ,"20053" ,"24180" ,;
                    "11923" ,"16050" ,"3793"  ,"7920"}
Return aCRC
