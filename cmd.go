// gen-move-math
// move-lang (https://github.com/move-language/move) is a growing language mainly aimed at smart contract development for blockchains.

package main

import (
	_ "embed"
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

func new_cmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "gen-move-math",
		Short: "generate missing math functions before official move-lang support matures.",
		Args:  cobra.NoArgs,
	}

	output := "./sources/signed_math.move"
	module_name_fmt := "int%d"
	package_name := "more_math"
	int_to_run := int_width([]uint{8, 64, 128})

	cmd.Flags().StringVarP(&module_name_fmt, "module", "m", module_name_fmt, "module name string for signed integers")
	cmd.Flags().StringVarP(&output, "out", "o", output, "output file. this should be the in the sources folder of your move package module")
	cmd.Flags().StringVarP(&package_name, "package", "p", package_name, "package name")
	cmd.Flags().VarP(&int_to_run, "width", "w", "int widths, must be one of 8, 64, 128. can be specified multiple times.")

	cmd.Run = func(cmd *cobra.Command, args []string) {
		all_texts := ""
		for _, w := range int_to_run {
			s := signedMath{BaseWidth: w, ModuleNameFmt: module_name_fmt, PackageName: package_name}
			code, err := s.GenText()
			if err != nil {
				panic(err)
			}
			all_texts = fmt.Sprintf("%s\n%s", all_texts, code)
		}

		os.WriteFile(output, []byte(all_texts), 0o666)
	}

	return cmd
}

func main() {
	new_cmd().Execute()
}
