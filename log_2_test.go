package main

import (
	"math/big"
	"math/rand"
	"testing"

	"github.com/ALTree/bigfloat"
)

const FloatOperationPrec = 1024

func getLog2BigFloat(y *big.Int, precision uint, one *big.Float, twoLog *big.Float) (*big.Int, error) {
	f := big.NewFloat(0).SetPrec(FloatOperationPrec).SetInt(y)
	f.Quo(f, one)

	f = bigfloat.Log(f)
	f.Quo(f, twoLog)

	f.Mul(f, one)

	r, _ := f.Int(nil)
	return r, nil
}

func FuzzGetLog2(t *testing.F) {
	r := rand.New(rand.NewSource(0))
	for i := 0; i < 15; i++ {
		v := make([]byte, 8)
		r.Read(v)
		t.Add(v)
	}

	one := big.NewInt(0).Lsh(big.NewInt(1), 64)
	two := big.NewInt(0).Lsh(big.NewInt(2), 64)
	oneFloat := big.NewFloat(0).SetPrec(FloatOperationPrec).SetInt(one)
	twoLogFloat := bigfloat.Log(big.NewFloat(2).SetPrec(FloatOperationPrec))
	t.Fuzz(func(t *testing.T, v []byte) {
		if len(v) > 8 {
			v = v[:8]
		}
		x := big.NewInt(0).SetBytes(v)
		x.Add(x, one)

		l, err := getLog2(x, 64, one, two)
		if err != nil {
			t.Errorf("failed to get log 2: %s", err.Error())
		}
		r, _ := getLog2BigFloat(x, 64, oneFloat, twoLogFloat)
		diff := big.NewInt(0).Sub(l, r).Int64()
		if diff <= -4 || diff >= 4 {
			t.Errorf("want: %s\ngot:  %s\n", r.String(), l.String())
		}
	})
}
