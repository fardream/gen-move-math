package main

import (
	_ "embed"
	"fmt"
	"math/big"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

//go:embed double_width_unsigned.move.template
var double_width_unsigned_template string

type doubleWidthUnsigned struct {
	DesiredWidth uint
	Address      string
	DoTest       bool
	Args         string
	Version      string
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

// unrolledUpper contains Ones that is ((1 << Width + 1) - 1) (Width number of ones)
type unrolledUpper struct {
	// Wdith is the number of 1s in the binary presentation.
	Width uint
	// Ones is Width ones together.
	Ones string
	// Trailing Ones
	TrailingOnes string
}

// newUnrolledUpper creates an unrolled
func newUnrolledUpper(n uint, w uint) unrolledUpper {
	return unrolledUpper{
		Width:        n,
		Ones:         big.NewInt(0).Lsh(big.NewInt(0).Sub(big.NewInt(0).Lsh(one, n), one), w-n).String(),
		TrailingOnes: big.NewInt(0).Sub(big.NewInt(0).Lsh(one, n), one).String(),
	}
}

func getDoubleWidthModuleName(desiredWith uint) string {
	return fmt.Sprintf("uint%d", desiredWith)
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

	r.ModuleName = getDoubleWidthModuleName(r.DesiredWidth)

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

func newDoubleWidthUnsignedCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "double-width",
		Short: "generate double width unsigned integer (for example, Uint16 based on u8)",
		Args:  cobra.NoArgs,
	}
	output := "./sources/double_width_unsigned.move"
	address := "more_math"
	widths := newIntWidth([]uint{16, 32, 64, 128, 256})
	doTest := false

	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(widths, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(widths.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")

	cmd.Run = func(cmd *cobra.Command, args []string) {
		allTexts := []string{}
		for _, w := range widths.values {
			s := doubleWidthUnsigned{
				DesiredWidth: w,
				Address:      address,
				DoTest:       doTest,
				Args:         strings.Join(os.Args[1:], " "),
				Version:      version,
			}

			code, err := newDoubleWidthUnsignedGenerated(&s).GenText()
			if err != nil {
				panic(err)
			}
			allTexts = append(allTexts, code)
		}

		os.WriteFile(output, []byte(strings.Join(allTexts, "\n")), 0o666)
	}

	return cmd
}
