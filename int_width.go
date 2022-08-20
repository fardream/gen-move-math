package main

import (
	"fmt"
	"strconv"
	"strings"

	"golang.org/x/exp/slices"
)

type intWidth struct {
	permitted  []uint
	notDefault bool
	values     []uint
}

func newIntWidth(permitted []uint) *intWidth {
	r := &intWidth{}

	r.permitted = append(r.permitted, permitted...)
	r.values = append(r.values, permitted...)

	return r
}

func sliceToString(s []uint) string {
	var t []string
	for _, v := range s {
		t = append(t, strconv.Itoa(int(v)))
	}

	return strings.Join(t, ", ")
}

func (i *intWidth) Set(s string) error {
	if !i.notDefault {
		i.values = nil
		i.notDefault = true
	}

	parsed_signed, err := strconv.Atoi(s)
	if err != nil {
		return err
	}

	parsed := uint(parsed_signed)

	if !slices.Contains(i.permitted, parsed) {
		return fmt.Errorf("%d is not supported (only %s)", parsed, sliceToString(i.permitted))
	}

	for _, v := range i.values {
		if v == parsed {
			return fmt.Errorf("%d is already specified", parsed)
		}
	}

	i.values = append(i.values, uint(parsed))

	return nil
}

func (i intWidth) String() string {
	return fmt.Sprintf("%v", sliceToString(i.values))
}

func (i intWidth) Type() string {
	return fmt.Sprintf("list of uint widths, must be %s", sliceToString(i.permitted))
}
