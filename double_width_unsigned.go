package main

import (
	_ "embed"
	"fmt"
	"math/big"
)

//go:embed double_width_unsigned.move.template
var double_width_unsigned_template string

type doubleWidthUnsigned struct {
	DesiredWidth  uint
	ModuleNameFmt string
	Address       string
	DoTest        bool
}

type doubleWidthUnsignedGenerated struct {
	doubleWidthUnsigned

	BaseWidth uint
	HalfWidth uint

	BaseTypeName string
	BreakPoint   string
	MaxUnsigned  string
	MaxPositive  string
	ModuleName   string
	TypeName     string
	Lower1s      string
	Upper1s      string
	MaxShiftSize uint

	UnrolledForLeadingZeros []unrolledUpper
}

type unrolledUpper struct {
	Width uint
	Ones  string
}

func newUnrolledUpper(n uint, w uint) unrolledUpper {
	return unrolledUpper{
		Width: n,
		Ones:  big.NewInt(0).Lsh(big.NewInt(0).Sub(big.NewInt(0).Lsh(one, n), one), w-n).String(),
	}
}

func newDoubleWidthUnsignedGenerated(s *doubleWidthUnsigned) *doubleWidthUnsignedGenerated {
	r := &doubleWidthUnsignedGenerated{
		doubleWidthUnsigned: *s,
	}

	r.BaseWidth = r.DesiredWidth / 2
	r.HalfWidth = r.BaseWidth / 2

	r.BaseTypeName = fmt.Sprintf("u%d", r.BaseWidth)

	break_point := big.NewInt(0)
	break_point.Lsh(one, r.BaseWidth-1)
	r.BreakPoint = break_point.String()

	max_unsigned := big.NewInt(0)
	max_unsigned.Lsh(one, r.BaseWidth)
	max_unsigned.Sub(max_unsigned, one)
	r.MaxUnsigned = max_unsigned.String()

	max_positive := big.NewInt(0)
	max_positive.Lsh(one, r.BaseWidth-1)
	max_positive.Sub(max_positive, one)
	r.MaxPositive = max_positive.String()

	r.ModuleName = fmt.Sprintf(s.ModuleNameFmt, r.DesiredWidth)

	r.TypeName = fmt.Sprintf("Uint%d", r.DesiredWidth)

	lower_1s := big.NewInt(1)
	lower_1s = lower_1s.Lsh(lower_1s, r.HalfWidth)
	lower_1s = lower_1s.Sub(lower_1s, one)
	r.Lower1s = lower_1s.String()

	upper_1s := big.NewInt(0)
	upper_1s = upper_1s.Lsh(lower_1s, r.HalfWidth)
	r.Upper1s = upper_1s.String()

	r.MaxShiftSize = r.DesiredWidth - 1

	for n := r.BaseWidth >> 1; n > 0; n = n >> 1 {
		r.UnrolledForLeadingZeros = append(r.UnrolledForLeadingZeros, newUnrolledUpper(n, r.BaseWidth))
	}

	return r
}

func (s doubleWidthUnsignedGenerated) GenText() (string, error) {
	return GenText(s.ModuleName, double_width_unsigned_template, s)
}
