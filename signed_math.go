package main

import (
	"bytes"
	_ "embed"
	"fmt"
	"math/big"
	"text/template"
)

//go:embed signed_math.move.template
var signed_math_template string

var one *big.Int = big.NewInt(1)

type signedMath struct {
	BaseWidth     uint
	ModuleNameFmt string
	Address       string
}

type signedMathGenerated struct {
	signedMath

	BaseTypeName           string
	BreakPoint             string
	MaxUnsigned            string
	MaxPositive            string
	ModuleName             string
	TypeName               string
	UnderlyingUnsignedType string
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

	r.ModuleName = fmt.Sprintf(s.ModuleNameFmt, s.BaseWidth)

	r.TypeName = fmt.Sprintf("Int%d", s.BaseWidth)

	r.UnderlyingUnsignedType = fmt.Sprintf("u%d", s.BaseWidth)

	return r
}

func (s signedMathGenerated) GenText() (string, error) {
	tmpl, err := template.New(fmt.Sprintf(s.ModuleNameFmt, s.BaseWidth)).Parse(signed_math_template)
	if err != nil {
		return "", err
	}
	var buf bytes.Buffer
	err = tmpl.Execute(&buf, &s)
	if err != nil {
		return "", err
	}

	return buf.String(), nil
}
