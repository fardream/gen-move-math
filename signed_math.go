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

func (s *signedMath) BaseTypeName() string {
	return fmt.Sprintf("u%d", s.BaseWidth)
}

func (s *signedMath) BreakPoint() string {
	bp := big.NewInt(0)
	bp.Lsh(one, s.BaseWidth-1)
	return bp.String()
}

func (s *signedMath) MaxUnsigned() string {
	m := big.NewInt(0)
	m.Lsh(one, s.BaseWidth)
	m.Sub(m, one)
	return m.String()
}

func (s *signedMath) MaxPositive() string {
	bp := big.NewInt(0)
	bp.Lsh(one, s.BaseWidth-1)
	bp.Sub(bp, one)
	return bp.String()
}

func (s *signedMath) ModuleName() string {
	return fmt.Sprintf(s.ModuleNameFmt, s.BaseWidth)
}

func (s *signedMath) TypeName() string {
	return fmt.Sprintf("Int%d", s.BaseWidth)
}

func (s *signedMath) UnderlyingUnsignedType() string {
	return fmt.Sprintf("u%d", s.BaseWidth)
}

func (s signedMath) GenText() (string, error) {
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
