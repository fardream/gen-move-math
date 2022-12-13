package main

import (
	_ "embed"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
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

func newSignedDecimalCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "signed-decimal",
		Short: "generate signed decimal based on signed integer",
		Args:  cobra.NoArgs,
	}

	output := "./sources/signed_decimal.move"
	address := "more_math"
	widths := newIntWidth([]uint{64, 128})
	doTest := false
	precision := newIntWidth(genIntRange(6, 34, 2))
	precision.values = genIntRange(12, 18, 2)

	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(widths, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(widths.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")
	cmd.Flags().Var(precision, "precision", "precision")

	cmd.Run = func(*cobra.Command, []string) {
		allTexts := []string{}
		for _, w := range widths.values {
			for _, precision := range precision.values {
				if w == 64 && precision >= 6 {
					continue
				}

				d := signedDecimalInfo{
					DoTest:    doTest,
					BaseWidth: w,
					Address:   address,
					Precision: precision,
					Args:      strings.Join(os.Args[1:], " "),
					Version:   version,
				}

				code, err := newSignedDecimalGenerated(&d).GenText()
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
