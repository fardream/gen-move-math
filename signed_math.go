package main

import (
	_ "embed"
	"fmt"
	"math/big"
)

//go:embed signed_math.move.template
var signed_math_template string

var one *big.Int = big.NewInt(1)

type signedMath struct {
	BaseWidth uint
	Address   string
	DoTest    bool
	Args      string
	Version   string
}

type signedMathGenerated struct {
	signedMath

	BaseTypeName string
	BreakPoint   string
	MaxUnsigned  string
	MaxPositive  string
	ModuleName   string
	TypeName     string
}

func getSignedIntModuleName(baseWidth uint) string {
	return fmt.Sprintf("int%d", baseWidth)
}

func getSignedIntType(baseWidth uint) string {
	return fmt.Sprintf("Int%d", baseWidth)
}

func newSignedMathGenerated(s *signedMath) *signedMathGenerated {
	r := &signedMathGenerated{
		signedMath: *s,
	}

	r.BaseTypeName = fmt.Sprintf("u%d", s.BaseWidth)

	break_point := big.NewInt(0)
	break_point.Lsh(one, s.BaseWidth-1)
	r.BreakPoint = break_point.String()

	max_unsigned := big.NewInt(0)
	max_unsigned.Lsh(one, s.BaseWidth)
	max_unsigned.Sub(max_unsigned, one)
	r.MaxUnsigned = max_unsigned.String()

	max_positive := big.NewInt(0)
	max_positive.Lsh(one, s.BaseWidth-1)
	max_positive.Sub(max_positive, one)
	r.MaxPositive = max_positive.String()

	r.ModuleName = getSignedIntModuleName(s.BaseWidth)

	r.TypeName = getSignedIntType(s.BaseWidth)

	return r
}

func (s signedMathGenerated) GenText() (string, error) {
	return GenText(s.ModuleName, signed_math_template, s)
}
