// gen-move-math
//
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

import "github.com/spf13/cobra"

func genIntRange(start, end, step uint) []uint {
	r := []uint{}
	for i := start; i <= end; i = i + step {
		r = append(r, i)
	}

	return r
}

const longDescription = `Generate missing math functions for move-lang.

The standard library and built-in types of move (https://github.com/move-language/move)
only support a subset of math functions that we generally use.

gen-move-math will generate code for
- signed math
- u16 and u256
- decimal (such as u128 based 9 digits - Decimal128N9)
- signed decimal with a dynamic decimal and a predefiend precision.

and possibly more.
`

func main() {
	rootCmd := cobra.Command{
		Use:   "gen-move-math",
		Short: "generate missing math functions before official move-lang support matures.",
		Long:  longDescription,
		Args:  cobra.NoArgs,
	}

	rootCmd.AddCommand(
		newSignedMathCmd(),
		newDoubleWidthUnsignedCmd(),
		newDecimalCmd(),
		newSignedDecimalCmd(),
		newMoreMathCmd(),
	)

	rootCmd.Execute()
}
