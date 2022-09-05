package main

import (
	_ "embed"
	"fmt"
)

//go:embed signed_decimal.move.template
var signed_decimal_template string

type signedDecimalInfo struct {
	BaseWidth uint
	Address   string
	DoTest    bool
	Args      string
	Version   string
	Precision uint
}

type signedDecimalGenerated struct {
	signedDecimalInfo

	ModuleName        string
	TypeName          string
	BaseTypeName      string
	SignedIntType     string
	SignedIntModule   string
	DoubleWidthModule string
}

func newSignedDecimalGenerated(s *signedDecimalInfo) *signedDecimalGenerated {
	r := &signedDecimalGenerated{signedDecimalInfo: *s}

	r.ModuleName = fmt.Sprintf("signed_decimal%d_p%d", r.BaseWidth, r.Precision)

	r.TypeName = fmt.Sprintf("SDecimal%d", r.BaseWidth)
	r.BaseTypeName = fmt.Sprintf("u%d", r.BaseWidth)

	r.SignedIntType = getSignedIntType(r.BaseWidth)
	r.SignedIntModule = getSignedIntModuleName(r.BaseWidth)

	r.DoubleWidthModule = getDoubleWidthModuleName(r.BaseWidth * 2)

	return r
}

func (d *signedDecimalGenerated) GenText() (string, error) {
	return GenText(d.ModuleName, signed_decimal_template, d)
}
