module {{ .PackageName }}::{{ .ModuleName }} {{$typename := .TypeName }}{{$underlying := .UnderlyingUnsignedType}}{
    struct {{ $typename }} has store, copy, drop {
        value: {{ $underlying }},
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    // BreakPoint
    const BREAK_POINT: {{ $underlying }} = {{ .BreakPoint }};
    // Max Postive
    const MAX_POSITIVE: {{ $underlying }} = {{ .MaxPositive }};
    const MAX_U: {{ $underlying }} = {{ .MaxUnsigned }};

    public fun new(absolute_value: {{ $underlying }}, negative: bool): {{ $typename }} {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) { 
            {{ $typename }} {
                value: absolute_value,
            } 
        } else {
            {{ $typename }} {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    public fun is_negative(x: {{ $typename }}): bool {
        x.value >= BREAK_POINT
    }

    public fun negative(x: {{ $typename }}): {{ $typename }} {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            {{ $typename }} {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    public fun abs(x: {{ $typename }}): {{ $underlying }} {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    public fun zero(): {{ $typename }} {
        {{ $typename }} {
            value: 0
        }
    }

    public fun equal(x: {{ $typename }}, y: {{ $typename }}): bool {
        x.value == y.value
    }

    public fun greater(x: {{ $typename }}, y:{{ $typename }}): bool {
        if (is_negative(x)) {
            (x.value > y.value) && (is_negative(y))
        } else {
            (is_negative(y)) || x.value > y.value
        }
    }

    public fun less(x: {{ $typename }}, y: {{ $typename }}): bool {
        if (is_negative(x)) {
            (x.value < y.value) || (!is_negative(y))
        } else {
            !is_negative(y) && y.value > x.value
        }
    }

    public fun add(x: {{ $typename }}, y: {{ $typename }}): {{ $typename }} {
        if (is_negative(x) && is_negative(y)) {
            let x_abs = abs(x);
            let y_abs = abs(y);
            let r_abs = x_abs + y_abs;
            assert!(r_abs <= BREAK_POINT, E_OUT_OF_RANGE);
            {{ $typename }} {
                value: (r_abs^MAX_U) + 1,
            }
        } else if (!is_negative(x) && !is_negative(y)) {
            let r_abs = x.value + y.value;
            assert!(r_abs < BREAK_POINT, E_OUT_OF_RANGE);
            {{ $typename }} {
                value: r_abs,
            }
        } else if (is_negative(x)) {
            let x_abs = abs(x);
            if (x_abs > y.value) {
                {{ $typename }} {
                    value: x.value + y.value,
                }
            } else {
                {{ $typename }} {
                    value: y.value - x_abs,
                }
            }
        } else {
            let y_abs = abs(y);
            if (y_abs > x.value) {
                {{ $typename }} {
                    value: x.value + y.value,
                }
            } else {
                {{ $typename }} {
                    value: x.value - y_abs,
                }
            }
        }
    }

    public fun subtract(x: {{ $typename }}, y: {{ $typename }}): {{ $typename }} {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            assert!(x.value >= BREAK_POINT + 1, E_OUT_OF_RANGE);
            {{ $typename }} {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    public fun multiply(x: {{ $typename }}, y: {{ $typename }}): {{ $typename }} {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    public fun divide(x: {{ $typename }}, y: {{ $typename }}): {{ $typename }} {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    public fun mod(x: {{ $typename }}, y: {{ $typename }}): {{ $typename }} {
        subtract(x, multiply(y, divide(x, y)))
    }

    #[test]
    fun test_int{{ .BasedWidth }}() {
        assert!(abs(zero()) == 0, E_OUT_OF_RANGE);
        assert!(abs(new(5, false)) == 5, E_OUT_OF_RANGE);
        assert!(abs(new(5, true)) == 5, E_OUT_OF_RANGE);
        assert!(new(5, true).value == (MAX_U - 4), E_OUT_OF_RANGE);
        assert!(add(new(20, false), new(20, false)).value == 40, E_OUT_OF_RANGE);
        assert!(add(new(20, false), new(20, true)).value == 0, E_OUT_OF_RANGE);
        assert!(equal(add(new(25, true), new(20, true)), new(45, true)), E_OUT_OF_RANGE);
        assert!(equal(add(new(20, false), new(25, true)), new(5, true)), E_OUT_OF_RANGE);
        //
        assert!(equal(multiply(new(7, false), new(5,true)), new(35, true)), E_OUT_OF_RANGE);
        assert!(equal(multiply(new(7, false), new(5,false)), new(35, false)), E_OUT_OF_RANGE);
        assert!(equal(multiply(new(7, true), new(5,true)), new(35, false)), E_OUT_OF_RANGE);
        assert!(equal(multiply(new(7, true), new(5,false)), new(35, true)), E_OUT_OF_RANGE);
        //
        assert!(equal(divide(new(7, true), new(31,false)), new(0, true)), E_OUT_OF_RANGE);
        assert!(equal(divide(new(7, false), new(31,false)), new(0, true)), E_OUT_OF_RANGE);
        assert!(equal(divide(new(22, true), new(7,false)), new(3, true)), E_OUT_OF_RANGE);
        assert!(equal(divide(new(22, true), new(7,true)), new(3, false)), E_OUT_OF_RANGE);
        //
        assert!(equal(mod(new(22, true), new(7,true)), new(1, true)), E_OUT_OF_RANGE);
        assert!(equal(mod(new(22, true), new(7,false)), new(1, true)), E_OUT_OF_RANGE);
        assert!(equal(mod(new(22, false), new(7,true)), new(1, false)), E_OUT_OF_RANGE);
    }

    #[test,expected_failure]
    fun test_int{{ .BasedWidth }}_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int{{ .BasedWidth }}_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int{{ .BasedWidth }}_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }
    
    #[test,expected_failure]
    fun test_int{{ .BasedWidth }}_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int{{ .BasedWidth }}_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}
