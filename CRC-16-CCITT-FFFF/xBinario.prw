// #########################################################################################
// -----------+-----------------+-----------------------------------------------------------
// Data       | Autor:          | Descricao
// -----------+-----------------+-----------------------------------------------------------
// 14/08/2021 | Don Junior  	| Agrupador de funções para conversão binária
// -----------^-----------------^-----------------------------------------------------------

// #########################################################################################
//             LINKS DE REFERENCIA USADOS PARA IMPLEMENTAÇÃO EM CÓDIGO ADVPL 
// #########################################################################################
// www.convertalot.com/bitwise_operators.html
// developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Left_shift
// developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Right_shift
// developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_AND
// developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Operators/Bitwise_XOR
// Conversão de decimal para binário - www.youtube.com/watch?v=mttrG_kbHN4
// Conversão de binário para decimal - www.youtube.com/watch?v=zToihF2FE9I
// Conversão de decimal para hexadecimal - www.youtube.com/watch?v=aScMxxd48js
// #########################################################################################

#Include 'protheus.ch'

// -------------------------------------------------------------------
// Função para conversão de decimal para binário
// -------------------------------------------------------------------
Function U_xDec2Bin(cDecimal)

    Local nB
    Local nValDiv  := 0
    Local nValRes  := 0
    Local aBinario := {}
    Local cBinario := ""
    Local lDivide  := .T.
    Local nValDec  := Val(cDecimal)

    While lDivide 

        nValDiv := Int(nValDec / 2)
        nValRes := Mod(nValDec,2)
        nValDec := nValDiv

        If nValDiv == 0
            lDivide := .F.
        EndIf

        AADD(aBinario,{nValDec,cValToChar(nValRes)})

    EndDo

    // Ordenando o array de traz pra frente
    ASort(aBinario,,, { |x, y| x[1] < y[1] } )

    For nB := 1 To Len(aBinario)

        cBinario += aBinario[nB][2]

    Next nB

Return cBinario


// -------------------------------------------------------------------
// Função para conversão de binário para decimal
// -------------------------------------------------------------------
Function U_xBin2Dec(cBinario)

    Local nD
    Local aBits    := {}
    Local nDecimal := 0
    Local nTamBin  := Len(cBinario)

    // Preenchendo com zeros para não gerar erro array
    If nTamBin < 32
        cBinario += Replicate("0", (32 - nTamBin) )
    EndIf

    // Criando array de bits
    For nD := 31 To 0 Step -1
        AADD(aBits, 2 ^ nD )
    Next nD

    // Realizando o cálculo de conversão da base 2 para base 10
    For nD := 1 To Len(aBits)
        nDecimal += aBits[nD] * Val(SubStr(cBinario,nD,1))
    Next nD

Return nDecimal


// -------------------------------------------------------------------
// Função para conversão de decimal para hexadecimal
// -------------------------------------------------------------------
Function U_xDec2Hex(nDecimal)

    Local nH
    Local cHexade
    Local nValDiv := 0
    Local nValRes := 0
    Local aHexade := {}
    Local nValDec := nDecimal

    // Realizando o cálculo de conversão da base 10 para base 16
    For nH := 1 To 16

        nValDiv := Int(nValDec / 16)
        nValRes := Mod(nValDec,16)
        nValDec := nValDiv

        If nValRes == 0
            Exit
        EndIf

        Do Case
            Case nValRes == 10
                cHexade := "A"
            Case nValRes == 11
                cHexade := "B"
            Case nValRes == 12
                cHexade := "C"
            Case nValRes == 13
                cHexade := "D"
            Case nValRes == 14
                cHexade := "E"
            Case nValRes == 15
                cHexade := "F"
            Otherwise
                cHexade := cValToChar(nValRes)
        EndCase

        AADD(aHexade,{nH,cHexade})

    Next nH

    // Ordenando o array de traz pra frente
    ASort(aHexade,,, { |x, y| x[1] > y[1] } )

    cHexade := ""
    For nH := 1 To Len(aHexade)

        cHexade += aHexade[nH][2]

    Next nH

Return cHexade


// -------------------------------------------------------------------
// Função de operação AND (x & y) de números binarios
// -------------------------------------------------------------------
Function U_xAnd2Bin(cBinario1,cBinario2)

    Local nA
    Local cBin1
    Local cBin2
    Local cRetA := ""
    Local nTam1 := Len(cBinario1)
    Local nTam2 := Len(cBinario2)

    If nTam1 < nTam2
        cBin1 := Replicate(" ", nTam2 - nTam1) + cBinario1
        cBin2 := cBinario2
    ElseIf nTam1 > nTam2
        cBin1 := cBinario1
        cBin2 := Replicate(" ", nTam1 - nTam2) + cBinario2
    EndIf

    For nA := 1 To Len(cBin1)
    
        If SubStr(cBin1,nA,1) == SubStr(cBin2,nA,1)
            cRetA += "1"
        Else
            cRetA += "0"
        EndIf

    Next nA

Return cRetA


// -------------------------------------------------------------------
// Função de operação XOR (x ^ y) de números binarios
// -------------------------------------------------------------------
Function U_xXor2Bin(cBinario1,cBinario2)

    Local nX
    Local cBin1
    Local cBin2
    Local cRetX := ""
    Local nTam1 := Len(cBinario1)
    Local nTam2 := Len(cBinario2)

    If nTam1 < nTam2
        cBin1 := Replicate("0", nTam2 - nTam1) + cBinario1
        cBin2 := cBinario2
    ElseIf nTam1 > nTam2
        cBin1 := cBinario1
        cBin2 := Replicate("0", nTam1 - nTam2) + cBinario2
    Else
        cBin1 := cBinario1
        cBin2 := cBinario2
    EndIf

    For nX := 1 To Len(cBin1)
    
        If SubStr(cBin1,nX,1) == SubStr(cBin2,nX,1)
            cRetX += "0"
        Else
            cRetX += "1"
        EndIf

    Next nX

Return cRetX


// -------------------------------------------------------------------
// Função de movimento do bit para esquerda ou direita
// -------------------------------------------------------------------
Function U_xBitWise(cBinario,cLado)

    Local nIni
    Local cRetBin
    Local nTamBin := Len(cBinario)

    Default cLado := "<"

    // Preenchendo com zeros para garantir o tamanho do retorno
    If nTamBin < 32
        cBinario := Replicate("0", (32 - nTamBin) ) + cBinario
    EndIf

    If cLado == ">"
        nIni := 0
        cRetBin := Replicate("0",8) + cBinario
    Else
        cRetBin := cBinario + Replicate("0",8)
        nIni := 9
    EndIf

    cRetBin := SubStr(cRetBin, nIni, 32 )

Return cRetBin
