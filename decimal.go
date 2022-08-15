package main

import (
	_ "embed"
	"fmt"
	"math/big"
)

//go:embed decimal.move.template
var decimal_template string

type decimalInfo struct {
	BaseWidth     uint
	ModuleNameFmt string
	Address       string
	DoTest        bool
	Decimal       uint
}

type decimalGenerated struct {
	decimalInfo

	BaseTypeName           string
	ModuleName             string
	TypeName               string
	UnderlyingUnsignedType string
	DoubleWidthType        string
	DoubleWidthModule      string

	Multiplier        string
	SquaredMultiplier string
}

// tenTo raise 10 to the power of `d`.
func tenTo(d uint) *big.Int {
	ten := big.NewInt(10)
	r := big.NewInt(1)

	for ; d > 0; d-- {
		r.Mul(r, ten)
	}

	return r
}

func newDecimalGenerated(s *decimalInfo) *decimalGenerated {
	r := &decimalGenerated{decimalInfo: *s}

	r.BaseTypeName = fmt.Sprintf("u%d", r.BaseWidth)

	r.ModuleName = fmt.Sprintf(s.ModuleNameFmt, r.BaseWidth, r.Decimal)

	r.TypeName = fmt.Sprintf("Decimal%dN%d", r.BaseWidth, r.Decimal)

	r.DoubleWidthModule = fmt.Sprintf("uint%d", r.BaseWidth*2)
	r.DoubleWidthType = fmt.Sprintf("Uint%d", r.BaseWidth*2)

	r.Multiplier = tenTo(s.Decimal).String()
	r.SquaredMultiplier = tenTo(s.Decimal * 2).String()

	return r
}

func (d *decimalGenerated) GenText() (string, error) {
	return GenText(d.ModuleName, decimal_template, d)
}
