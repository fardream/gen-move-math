// gen-move-math
// move-lang (https://github.com/move-language/move) is a growing language mainly aimed at smart contract development for blockchains.

package main

import (
	_ "embed"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

const long_description = `Generate missing math functions for move-lang.

The standard library and built-in types of move (https://github.com/move-language/move)
only support a subset of math functions that we generally use.

gen-move-math will generate code for
- signed math

Planned: decimal, more unsigned integers (u16, u32, u256), and possibly more.
`

func new_signed_math_cmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "gen-move-math",
		Short: "generate missing math functions before official move-lang support matures.",
		Args:  cobra.NoArgs,
		Long:  long_description,
	}

	output := "./sources/signed_math.move"
	module_name_fmt := "int%d"
	address := "more_math"
	int_to_run := newIntWidth([]uint{8, 64, 128})

	cmd.Flags().StringVarP(&module_name_fmt, "module", "m", module_name_fmt, "module name string for signed integers")
	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.MarkFlagFilename("out")
	cmd.Flags().StringVarP(&address, "address", "p", address, "(named) address")
	cmd.Flags().VarP(int_to_run, "width", "w", "int widths, must be one of 8, 64, 128. can be specified multiple times.")

	cmd.Run = func(cmd *cobra.Command, args []string) {
		all_texts := []string{}
		for _, w := range int_to_run.values {
			s := signedMath{BaseWidth: w, ModuleNameFmt: module_name_fmt, Address: address}
			code, err := newSignedMathGenerated(&s).GenText()
			if err != nil {
				panic(err)
			}
			all_texts = append(all_texts, code)
		}

		os.WriteFile(output, []byte(strings.Join(all_texts, "\n")), 0o666)
	}

	return cmd
}

func main() {
	root_cmd := new_signed_math_cmd()

	root_cmd.Execute()
}
