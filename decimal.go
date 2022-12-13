package main

import (
	_ "embed"
	"fmt"
	"math/big"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

//go:embed decimal.move.template
var decimal_template string

type decimalInfo struct {
	BaseWidth     uint
	ModuleNameFmt string
	Address       string
	DoTest        bool
	Decimal       uint
	Args          string
	Version       string
}

type decimalGenerated struct {
	decimalInfo

	BaseTypeName           string
	ModuleName             string
	TypeName               string
	UnderlyingUnsignedType string
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

	r.DoubleWidthModule = getDoubleWidthModuleName(r.BaseWidth * 2)

	r.Multiplier = tenTo(s.Decimal).String()
	r.SquaredMultiplier = tenTo(s.Decimal * 2).String()

	return r
}

func (d *decimalGenerated) GenText() (string, error) {
	return GenText(d.ModuleName, decimal_template, d)
}

func newDecimalCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "decimal",
		Short: "generate decimal based on unsigned integer and a predefined decimal place",
		Args:  cobra.NoArgs,
	}

	output := "./sources/decimal.move"
	moduleNameFmt := "decimal%dn%d"
	address := "more_math"
	widths := newIntWidth([]uint{64, 128})
	doTest := false
	decimals := newIntWidth(genIntRange(1, 18, 1))
	decimals.values = []uint{5, 6, 7, 8, 9, 10, 18}

	cmd.Flags().StringVarP(&moduleNameFmt, "module", "m", moduleNameFmt, "module name string for decimal type")
	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(widths, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(widths.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")
	cmd.Flags().VarP(decimals, "decimal", "d", "decimal")

	cmd.Run = func(*cobra.Command, []string) {
		allTexts := []string{}
		for _, w := range widths.values {
			for _, decimal := range decimals.values {
				if w == 64 && decimal >= 10 {
					continue
				}

				d := decimalInfo{
					DoTest:        doTest,
					BaseWidth:     w,
					ModuleNameFmt: moduleNameFmt,
					Address:       address,
					Decimal:       decimal,
					Args:          strings.Join(os.Args[1:], " "),
					Version:       version,
				}

				code, err := newDecimalGenerated(&d).GenText()
				if err != nil {
					panic(err)
				}
				allTexts = append(allTexts, code)
			}
		}

		os.WriteFile(output, []byte(strings.Join(allTexts, "\n")), 0o666)
	}

	return cmd
}
