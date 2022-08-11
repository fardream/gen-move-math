package main

import (
	"fmt"
	"strconv"
)

type int_width []uint

var intWidthNotSet bool = true

func (i *int_width) Set(s string) error {
	if intWidthNotSet {
		*i = int_width([]uint{})
		intWidthNotSet = false
	}

	parsed, err := strconv.Atoi(s)
	if err != nil {
		return err
	}
	if parsed != 128 && parsed != 64 && parsed != 8 {
		return fmt.Errorf("%d is not supported (only 8, 64, 128)", parsed)
	}
	for _, already := range *i {
		if int(already) == parsed {
			return fmt.Errorf("%d is already specified", parsed)
		}
	}

	*i = append(*i, uint(parsed))

	return nil
}

func (i int_width) String() string {
	return fmt.Sprintf("%v", ([]uint)(i))
}

func (i int_width) Type() string {
	return "list of uint widths, must be 128, 64, or 8"
}
