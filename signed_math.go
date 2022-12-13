package main

import (
	_ "embed"
	"fmt"
	"math/big"
	"os"
	"strings"

	"github.com/spf13/cobra"
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

func newSignedMathCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "signed-math",
		Short: "",
		Args:  cobra.NoArgs,
	}

	output := "./sources/signed_math.move"
	address := "more_math"
	widths := newIntWidth([]uint{8, 16, 32, 64, 128, 256})
	doTest := false

	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(widths, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(widths.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")

	cmd.Run = func(cmd *cobra.Command, args []string) {
		allTexts := []string{}
		for _, w := range widths.values {
			s := signedMath{
				BaseWidth: w,
				Address:   address,
				DoTest:    doTest,
				Args:      strings.Join(os.Args[1:], " "),
				Version:   version,
			}

			code, err := newSignedMathGenerated(&s).GenText()
			if err != nil {
				panic(err)
			}
			allTexts = append(allTexts, code)
		}

		os.WriteFile(output, []byte(strings.Join(allTexts, "\n")), 0o666)
	}

	return cmd
}
