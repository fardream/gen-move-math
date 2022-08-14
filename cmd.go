// gen-move-math
// move-lang (https://github.com/move-language/move) is a growing language mainly aimed at smart contract development for blockchains.
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

Planned: decimal, and possibly more.
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

func newDoubleWidthUnsigned() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "double-width",
		Short: "generate double width unsigned integer (for example, Uint16 based on u8)",
		Args:  cobra.NoArgs,
	}
	output := "./sources/double_width_unsigned.move"
	moduleNameFmt := "uint%d"
	address := "more_math"
	widths := newIntWidth([]uint{16, 256})
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

func main() {
	rootCmd := newSignedMathCmd()

	rootCmd.AddCommand(newDoubleWidthUnsigned())

	rootCmd.Execute()
}
