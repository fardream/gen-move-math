package main

import (
	_ "embed"
	"fmt"
	"math/big"
	"math/rand"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

//go:embed more_math.move.template
var moreMathTemplateText string

// MoreMath are math utilities functions that don't introduce new types.
type MoreMath struct {
	UintWidth uint

	Address string
	Args    string
	Version string

	DoTest bool
}
type SqrtTestCase struct {
	Squared string
	Root    string
}
type MoreMathGenerated struct {
	MoreMath

	ModuleName   string
	UintTypeName string
	AllOnes      string

	HalfWidth    uint
	MaxShiftSize uint

	UnrolledForLeadingZeros []unrolledUpper

	SqrtTestCases []SqrtTestCase
}

func NewSqrtTestCase(b *big.Int) SqrtTestCase {
	c := big.NewInt(0).Sqrt(b)
	return SqrtTestCase{
		Squared: b.String(),
		Root:    c.String(),
	}
}

func NewMoreMathGenerated(m MoreMath) *MoreMathGenerated {
	result := &MoreMathGenerated{
		MoreMath: m,
	}

	result.ModuleName = fmt.Sprintf("more_math_u%d", m.UintWidth)
	result.UintTypeName = fmt.Sprintf("u%d", m.UintWidth)
	result.AllOnes = big.NewInt(0).Sub(big.NewInt(0).Lsh(big.NewInt(1), m.UintWidth), big.NewInt(1)).String()
	result.HalfWidth = m.UintWidth / 2
	result.MaxShiftSize = m.UintWidth - 1

	for n := result.UintWidth >> 1; n > 0; n = n >> 1 {
		result.UnrolledForLeadingZeros = append(result.UnrolledForLeadingZeros, newUnrolledUpper(n, result.UintWidth))
	}

	r := rand.New(rand.NewSource(0))
	upperBound := big.NewInt(0).Lsh(big.NewInt(1), m.UintWidth)
	zero := big.NewInt(0)
	one := big.NewInt(1)
	t := big.NewInt(0)

	nTests := int(2 * m.UintWidth)
	if nTests > 256 {
		nTests = 256
	}

	for i := 0; i < nTests; i++ {
		t = t.Rand(r, upperBound)
		result.SqrtTestCases = append(result.SqrtTestCases, NewSqrtTestCase(t))
		t = t.Sqrt(t)
		t = t.Mul(t, t)
		if t.Cmp(zero) > 0 {
			t = t.Sub(t, one)
		}
		result.SqrtTestCases = append(result.SqrtTestCases, NewSqrtTestCase(t))
	}

	return result
}

func (m MoreMathGenerated) GenText() (string, error) {
	return GenText(m.ModuleName, moreMathTemplateText, m)
}

func newMoreMathCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "more-math",
		Short: "more math utils for move-lang",
		Args:  cobra.NoArgs,
	}

	output := "./sources/more.move"
	address := "more_math"
	width := newIntWidth([]uint{8, 16, 32, 64, 128, 256})
	doTest := false

	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be in teh sources folder of your move package")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(width, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(width.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")

	cmd.Run = func(*cobra.Command, []string) {
		allTexts := []string{}
		for _, w := range width.values {
			s := MoreMath{
				UintWidth: w,
				Address:   address,
				Args:      strings.Join(os.Args[1:], " "),
				Version:   version,
				DoTest:    doTest,
			}

			code, err := NewMoreMathGenerated(s).GenText()
			if err != nil {
				panic(err)
			}
			allTexts = append(allTexts, code)
		}

		os.WriteFile(output, []byte(strings.Join(allTexts, "\n")), 0o666)
	}
	return cmd
}
