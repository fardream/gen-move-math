// gen-move-math
// move-lang (https://github.com/move-language/move) is a growing language mainly aimed at smart contract development for blockchains.
// This package provides auto-code generation for
// - signed integer.
// - double width unsigned integer u256 and u16.
// - decimal.
//
// For each type of actions, there is the base data structure (which is provided through command line),
// such as `signedMath`, and the generated data structure, such as `signedMathGenerated`. After which the struct is
// fed into a template and results concatenated.
package main

import (
	_ "embed"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

const longDescription = `Generate missing math functions for move-lang.

The standard library and built-in types of move (https://github.com/move-language/move)
only support a subset of math functions that we generally use.

gen-move-math will generate code for
- signed math
- u16 and u256
- decimal (such as u128 based 9 digits - Decimal128N9)

and possibly more.
`

func newSignedMathCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "gen-move-math",
		Short: "generate missing math functions before official move-lang support matures.",
		Args:  cobra.NoArgs,
		Long:  longDescription,
	}

	output := "./sources/signed_math.move"
	moduleNameFmt := "int%d"
	address := "more_math"
	widths := newIntWidth([]uint{8, 64, 128})
	doTest := false

	cmd.Flags().StringVarP(&moduleNameFmt, "module", "m", moduleNameFmt, "module name string for signed integers")
	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(widths, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(widths.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")

	cmd.Run = func(cmd *cobra.Command, args []string) {
		allTexts := []string{}
		for _, w := range widths.values {
			s := signedMath{
				BaseWidth:     w,
				ModuleNameFmt: moduleNameFmt,
				Address:       address,
				DoTest:        doTest,
				Args:          strings.Join(os.Args[1:], " "),
				Version:       version,
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

func newDoubleWidthUnsignedCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "double-width",
		Short: "generate double width unsigned integer (for example, Uint16 based on u8)",
		Args:  cobra.NoArgs,
	}
	output := "./sources/double_width_unsigned.move"
	moduleNameFmt := "uint%d"
	address := "more_math"
	widths := newIntWidth([]uint{16, 128, 256})
	doTest := false

	cmd.Flags().StringVarP(&moduleNameFmt, "module", "m", moduleNameFmt, "module name string for double width unsigned integers")
	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(widths, "width", "w", fmt.Sprintf("int widths, must be one of %s. can be specified multiple times.", sliceToString(widths.permitted)))
	cmd.Flags().BoolVarP(&doTest, "do-test", "t", false, "generate test code")

	cmd.Run = func(cmd *cobra.Command, args []string) {
		allTexts := []string{}
		for _, w := range widths.values {
			s := doubleWidthUnsigned{
				DesiredWidth:  w,
				ModuleNameFmt: moduleNameFmt,
				Address:       address,
				DoTest:        doTest,
				Args:          strings.Join(os.Args[1:], " "),
				Version:       version,
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
	decimals := newIntWidth([]uint{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18})
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

func main() {
	// signed math method is the root,
	// since it's the first one developed.
	rootCmd := newSignedMathCmd()

	rootCmd.AddCommand(newDoubleWidthUnsignedCmd(), newDecimalCmd())

	rootCmd.Execute()
}
