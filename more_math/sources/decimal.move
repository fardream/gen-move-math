// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal64n5 {
    use more_math::uint128;

    const E_OVERFLOW: u64 = 1001;
    // Decimal64N5 is a decimal with 5 digits.
    // It represents a value of v*10^(-5)
    struct Decimal64N5 has copy, drop, store {
        value: u64
    }

    const MULTIPLIER: u64 = 100000;
    const SQUARED_MULTIPLIER: u64 = 10000000000;

    const DECIMAL: u8 = 5;

    fun pow(x: u64, p: u8): u64 {
        if (p == 0) {
            1
        } else {
            let r: u64 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal64N5 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u64, decimal: u8): Decimal64N5 {
        if (decimal > DECIMAL) {
            Decimal64N5 {
                value: digits / pow(10u64, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal64N5 {
                value: digits,
            }
        } else {
            Decimal64N5 {
                value: digits * pow(10u64, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u64) : Decimal64N5 {
        Decimal64N5 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal64N5, y: Decimal64N5): Decimal64N5 {
        Decimal64N5 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal64N5, y: Decimal64N5): Decimal64N5 {
        Decimal64N5 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal64N5, y: Decimal64N5): Decimal64N5 {
        let (v, carry) = uint128::underlying_mul_with_carry(x.value, y.value);
        let result = uint128::divide(uint128::new(carry, v), uint128::new(0, MULTIPLIER));
        assert!(uint128::hi(result) == 0, E_OVERFLOW);
        Decimal64N5 {
            value: uint128::lo(result),
        }
    }

    public fun divide(x: Decimal64N5, y: Decimal64N5): Decimal64N5 {
        let y = uint128::new(0, y.value);
        let (x,carry) = uint128::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint128::new(carry, x);
        let d = uint128::divide(x, y);

        Decimal64N5 {
            value: uint128::lo(d),
        }
    }

    public fun divide_mod(x: Decimal64N5, y: Decimal64N5):(Decimal64N5, Decimal64N5) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal64N5, y: Decimal64N5): Decimal64N5 {
        Decimal64N5 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal64N5, y: Decimal64N5): Decimal64N5 {
        Decimal64N5 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal64N5, y: Decimal64N5): Decimal64N5 {
        Decimal64N5 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal64n5() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 100000u64/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal64n6 {
    use more_math::uint128;

    const E_OVERFLOW: u64 = 1001;
    // Decimal64N6 is a decimal with 6 digits.
    // It represents a value of v*10^(-6)
    struct Decimal64N6 has copy, drop, store {
        value: u64
    }

    const MULTIPLIER: u64 = 1000000;
    const SQUARED_MULTIPLIER: u64 = 1000000000000;

    const DECIMAL: u8 = 6;

    fun pow(x: u64, p: u8): u64 {
        if (p == 0) {
            1
        } else {
            let r: u64 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal64N6 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u64, decimal: u8): Decimal64N6 {
        if (decimal > DECIMAL) {
            Decimal64N6 {
                value: digits / pow(10u64, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal64N6 {
                value: digits,
            }
        } else {
            Decimal64N6 {
                value: digits * pow(10u64, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u64) : Decimal64N6 {
        Decimal64N6 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal64N6, y: Decimal64N6): Decimal64N6 {
        Decimal64N6 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal64N6, y: Decimal64N6): Decimal64N6 {
        Decimal64N6 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal64N6, y: Decimal64N6): Decimal64N6 {
        let (v, carry) = uint128::underlying_mul_with_carry(x.value, y.value);
        let result = uint128::divide(uint128::new(carry, v), uint128::new(0, MULTIPLIER));
        assert!(uint128::hi(result) == 0, E_OVERFLOW);
        Decimal64N6 {
            value: uint128::lo(result),
        }
    }

    public fun divide(x: Decimal64N6, y: Decimal64N6): Decimal64N6 {
        let y = uint128::new(0, y.value);
        let (x,carry) = uint128::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint128::new(carry, x);
        let d = uint128::divide(x, y);

        Decimal64N6 {
            value: uint128::lo(d),
        }
    }

    public fun divide_mod(x: Decimal64N6, y: Decimal64N6):(Decimal64N6, Decimal64N6) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal64N6, y: Decimal64N6): Decimal64N6 {
        Decimal64N6 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal64N6, y: Decimal64N6): Decimal64N6 {
        Decimal64N6 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal64N6, y: Decimal64N6): Decimal64N6 {
        Decimal64N6 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal64n6() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 1000000u64/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal64n7 {
    use more_math::uint128;

    const E_OVERFLOW: u64 = 1001;
    // Decimal64N7 is a decimal with 7 digits.
    // It represents a value of v*10^(-7)
    struct Decimal64N7 has copy, drop, store {
        value: u64
    }

    const MULTIPLIER: u64 = 10000000;
    const SQUARED_MULTIPLIER: u64 = 100000000000000;

    const DECIMAL: u8 = 7;

    fun pow(x: u64, p: u8): u64 {
        if (p == 0) {
            1
        } else {
            let r: u64 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal64N7 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u64, decimal: u8): Decimal64N7 {
        if (decimal > DECIMAL) {
            Decimal64N7 {
                value: digits / pow(10u64, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal64N7 {
                value: digits,
            }
        } else {
            Decimal64N7 {
                value: digits * pow(10u64, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u64) : Decimal64N7 {
        Decimal64N7 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal64N7, y: Decimal64N7): Decimal64N7 {
        Decimal64N7 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal64N7, y: Decimal64N7): Decimal64N7 {
        Decimal64N7 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal64N7, y: Decimal64N7): Decimal64N7 {
        let (v, carry) = uint128::underlying_mul_with_carry(x.value, y.value);
        let result = uint128::divide(uint128::new(carry, v), uint128::new(0, MULTIPLIER));
        assert!(uint128::hi(result) == 0, E_OVERFLOW);
        Decimal64N7 {
            value: uint128::lo(result),
        }
    }

    public fun divide(x: Decimal64N7, y: Decimal64N7): Decimal64N7 {
        let y = uint128::new(0, y.value);
        let (x,carry) = uint128::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint128::new(carry, x);
        let d = uint128::divide(x, y);

        Decimal64N7 {
            value: uint128::lo(d),
        }
    }

    public fun divide_mod(x: Decimal64N7, y: Decimal64N7):(Decimal64N7, Decimal64N7) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal64N7, y: Decimal64N7): Decimal64N7 {
        Decimal64N7 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal64N7, y: Decimal64N7): Decimal64N7 {
        Decimal64N7 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal64N7, y: Decimal64N7): Decimal64N7 {
        Decimal64N7 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal64n7() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 10000000u64/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal64n8 {
    use more_math::uint128;

    const E_OVERFLOW: u64 = 1001;
    // Decimal64N8 is a decimal with 8 digits.
    // It represents a value of v*10^(-8)
    struct Decimal64N8 has copy, drop, store {
        value: u64
    }

    const MULTIPLIER: u64 = 100000000;
    const SQUARED_MULTIPLIER: u64 = 10000000000000000;

    const DECIMAL: u8 = 8;

    fun pow(x: u64, p: u8): u64 {
        if (p == 0) {
            1
        } else {
            let r: u64 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal64N8 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u64, decimal: u8): Decimal64N8 {
        if (decimal > DECIMAL) {
            Decimal64N8 {
                value: digits / pow(10u64, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal64N8 {
                value: digits,
            }
        } else {
            Decimal64N8 {
                value: digits * pow(10u64, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u64) : Decimal64N8 {
        Decimal64N8 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal64N8, y: Decimal64N8): Decimal64N8 {
        Decimal64N8 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal64N8, y: Decimal64N8): Decimal64N8 {
        Decimal64N8 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal64N8, y: Decimal64N8): Decimal64N8 {
        let (v, carry) = uint128::underlying_mul_with_carry(x.value, y.value);
        let result = uint128::divide(uint128::new(carry, v), uint128::new(0, MULTIPLIER));
        assert!(uint128::hi(result) == 0, E_OVERFLOW);
        Decimal64N8 {
            value: uint128::lo(result),
        }
    }

    public fun divide(x: Decimal64N8, y: Decimal64N8): Decimal64N8 {
        let y = uint128::new(0, y.value);
        let (x,carry) = uint128::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint128::new(carry, x);
        let d = uint128::divide(x, y);

        Decimal64N8 {
            value: uint128::lo(d),
        }
    }

    public fun divide_mod(x: Decimal64N8, y: Decimal64N8):(Decimal64N8, Decimal64N8) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal64N8, y: Decimal64N8): Decimal64N8 {
        Decimal64N8 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal64N8, y: Decimal64N8): Decimal64N8 {
        Decimal64N8 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal64N8, y: Decimal64N8): Decimal64N8 {
        Decimal64N8 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal64n8() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 100000000u64/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal64n9 {
    use more_math::uint128;

    const E_OVERFLOW: u64 = 1001;
    // Decimal64N9 is a decimal with 9 digits.
    // It represents a value of v*10^(-9)
    struct Decimal64N9 has copy, drop, store {
        value: u64
    }

    const MULTIPLIER: u64 = 1000000000;
    const SQUARED_MULTIPLIER: u64 = 1000000000000000000;

    const DECIMAL: u8 = 9;

    fun pow(x: u64, p: u8): u64 {
        if (p == 0) {
            1
        } else {
            let r: u64 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal64N9 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u64, decimal: u8): Decimal64N9 {
        if (decimal > DECIMAL) {
            Decimal64N9 {
                value: digits / pow(10u64, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal64N9 {
                value: digits,
            }
        } else {
            Decimal64N9 {
                value: digits * pow(10u64, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u64) : Decimal64N9 {
        Decimal64N9 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal64N9, y: Decimal64N9): Decimal64N9 {
        Decimal64N9 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal64N9, y: Decimal64N9): Decimal64N9 {
        Decimal64N9 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal64N9, y: Decimal64N9): Decimal64N9 {
        let (v, carry) = uint128::underlying_mul_with_carry(x.value, y.value);
        let result = uint128::divide(uint128::new(carry, v), uint128::new(0, MULTIPLIER));
        assert!(uint128::hi(result) == 0, E_OVERFLOW);
        Decimal64N9 {
            value: uint128::lo(result),
        }
    }

    public fun divide(x: Decimal64N9, y: Decimal64N9): Decimal64N9 {
        let y = uint128::new(0, y.value);
        let (x,carry) = uint128::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint128::new(carry, x);
        let d = uint128::divide(x, y);

        Decimal64N9 {
            value: uint128::lo(d),
        }
    }

    public fun divide_mod(x: Decimal64N9, y: Decimal64N9):(Decimal64N9, Decimal64N9) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal64N9, y: Decimal64N9): Decimal64N9 {
        Decimal64N9 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal64N9, y: Decimal64N9): Decimal64N9 {
        Decimal64N9 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal64N9, y: Decimal64N9): Decimal64N9 {
        Decimal64N9 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal64n9() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 1000000000u64/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n5 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N5 is a decimal with 5 digits.
    // It represents a value of v*10^(-5)
    struct Decimal128N5 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 100000;
    const SQUARED_MULTIPLIER: u128 = 10000000000;

    const DECIMAL: u8 = 5;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N5 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N5 {
        if (decimal > DECIMAL) {
            Decimal128N5 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N5 {
                value: digits,
            }
        } else {
            Decimal128N5 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N5 {
        Decimal128N5 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N5, y: Decimal128N5): Decimal128N5 {
        Decimal128N5 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N5, y: Decimal128N5): Decimal128N5 {
        Decimal128N5 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N5, y: Decimal128N5): Decimal128N5 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N5 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N5, y: Decimal128N5): Decimal128N5 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N5 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N5, y: Decimal128N5):(Decimal128N5, Decimal128N5) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N5, y: Decimal128N5): Decimal128N5 {
        Decimal128N5 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N5, y: Decimal128N5): Decimal128N5 {
        Decimal128N5 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N5, y: Decimal128N5): Decimal128N5 {
        Decimal128N5 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n5() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 100000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n6 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N6 is a decimal with 6 digits.
    // It represents a value of v*10^(-6)
    struct Decimal128N6 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 1000000;
    const SQUARED_MULTIPLIER: u128 = 1000000000000;

    const DECIMAL: u8 = 6;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N6 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N6 {
        if (decimal > DECIMAL) {
            Decimal128N6 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N6 {
                value: digits,
            }
        } else {
            Decimal128N6 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N6 {
        Decimal128N6 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N6, y: Decimal128N6): Decimal128N6 {
        Decimal128N6 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N6, y: Decimal128N6): Decimal128N6 {
        Decimal128N6 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N6, y: Decimal128N6): Decimal128N6 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N6 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N6, y: Decimal128N6): Decimal128N6 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N6 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N6, y: Decimal128N6):(Decimal128N6, Decimal128N6) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N6, y: Decimal128N6): Decimal128N6 {
        Decimal128N6 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N6, y: Decimal128N6): Decimal128N6 {
        Decimal128N6 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N6, y: Decimal128N6): Decimal128N6 {
        Decimal128N6 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n6() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 1000000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n7 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N7 is a decimal with 7 digits.
    // It represents a value of v*10^(-7)
    struct Decimal128N7 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 10000000;
    const SQUARED_MULTIPLIER: u128 = 100000000000000;

    const DECIMAL: u8 = 7;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N7 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N7 {
        if (decimal > DECIMAL) {
            Decimal128N7 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N7 {
                value: digits,
            }
        } else {
            Decimal128N7 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N7 {
        Decimal128N7 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N7, y: Decimal128N7): Decimal128N7 {
        Decimal128N7 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N7, y: Decimal128N7): Decimal128N7 {
        Decimal128N7 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N7, y: Decimal128N7): Decimal128N7 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N7 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N7, y: Decimal128N7): Decimal128N7 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N7 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N7, y: Decimal128N7):(Decimal128N7, Decimal128N7) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N7, y: Decimal128N7): Decimal128N7 {
        Decimal128N7 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N7, y: Decimal128N7): Decimal128N7 {
        Decimal128N7 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N7, y: Decimal128N7): Decimal128N7 {
        Decimal128N7 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n7() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 10000000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n8 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N8 is a decimal with 8 digits.
    // It represents a value of v*10^(-8)
    struct Decimal128N8 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 100000000;
    const SQUARED_MULTIPLIER: u128 = 10000000000000000;

    const DECIMAL: u8 = 8;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N8 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N8 {
        if (decimal > DECIMAL) {
            Decimal128N8 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N8 {
                value: digits,
            }
        } else {
            Decimal128N8 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N8 {
        Decimal128N8 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N8, y: Decimal128N8): Decimal128N8 {
        Decimal128N8 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N8, y: Decimal128N8): Decimal128N8 {
        Decimal128N8 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N8, y: Decimal128N8): Decimal128N8 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N8 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N8, y: Decimal128N8): Decimal128N8 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N8 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N8, y: Decimal128N8):(Decimal128N8, Decimal128N8) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N8, y: Decimal128N8): Decimal128N8 {
        Decimal128N8 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N8, y: Decimal128N8): Decimal128N8 {
        Decimal128N8 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N8, y: Decimal128N8): Decimal128N8 {
        Decimal128N8 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n8() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 100000000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n9 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N9 is a decimal with 9 digits.
    // It represents a value of v*10^(-9)
    struct Decimal128N9 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 1000000000;
    const SQUARED_MULTIPLIER: u128 = 1000000000000000000;

    const DECIMAL: u8 = 9;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N9 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N9 {
        if (decimal > DECIMAL) {
            Decimal128N9 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N9 {
                value: digits,
            }
        } else {
            Decimal128N9 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N9 {
        Decimal128N9 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N9, y: Decimal128N9): Decimal128N9 {
        Decimal128N9 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N9, y: Decimal128N9): Decimal128N9 {
        Decimal128N9 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N9, y: Decimal128N9): Decimal128N9 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N9 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N9, y: Decimal128N9): Decimal128N9 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N9 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N9, y: Decimal128N9):(Decimal128N9, Decimal128N9) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N9, y: Decimal128N9): Decimal128N9 {
        Decimal128N9 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N9, y: Decimal128N9): Decimal128N9 {
        Decimal128N9 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N9, y: Decimal128N9): Decimal128N9 {
        Decimal128N9 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n9() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 1000000000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n10 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N10 is a decimal with 10 digits.
    // It represents a value of v*10^(-10)
    struct Decimal128N10 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 10000000000;
    const SQUARED_MULTIPLIER: u128 = 100000000000000000000;

    const DECIMAL: u8 = 10;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N10 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N10 {
        if (decimal > DECIMAL) {
            Decimal128N10 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N10 {
                value: digits,
            }
        } else {
            Decimal128N10 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N10 {
        Decimal128N10 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N10, y: Decimal128N10): Decimal128N10 {
        Decimal128N10 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N10, y: Decimal128N10): Decimal128N10 {
        Decimal128N10 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N10, y: Decimal128N10): Decimal128N10 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N10 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N10, y: Decimal128N10): Decimal128N10 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N10 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N10, y: Decimal128N10):(Decimal128N10, Decimal128N10) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N10, y: Decimal128N10): Decimal128N10 {
        Decimal128N10 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N10, y: Decimal128N10): Decimal128N10 {
        Decimal128N10 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N10, y: Decimal128N10): Decimal128N10 {
        Decimal128N10 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n10() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 10000000000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: decimal -t
// Version: v1.2.7
module more_math::decimal128n18 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N18 is a decimal with 18 digits.
    // It represents a value of v*10^(-18)
    struct Decimal128N18 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 1000000000000000000;
    const SQUARED_MULTIPLIER: u128 = 1000000000000000000000000000000000000;

    const DECIMAL: u8 = 18;

    fun pow(x: u128, p: u8): u128 {
        if (p == 0) {
            1
        } else {
            let r: u128 = 1;
            while (p > 0) {
                r = r * x;
            };

            r
        }
    }

    // get decimal
    public fun get_decimal(): u8 {
        DECIMAL
    }

    // new creates a new Decimal128N18 equals digits / 10^decimal.
    // For example, 1.23 = new(123, 2), 1.230 = new(1230, 3).
    public fun new(digits: u128, decimal: u8): Decimal128N18 {
        if (decimal > DECIMAL) {
            Decimal128N18 {
                value: digits / pow(10u128, decimal - DECIMAL),
            }
        } else if (decimal == DECIMAL) {
            Decimal128N18 {
                value: digits,
            }
        } else {
            Decimal128N18 {
                value: digits * pow(10u128, DECIMAL - decimal),
            }
        }
    }

	// from_integer converts an integer to a decimal number.
    public fun from_integer(v: u128) : Decimal128N18 {
        Decimal128N18 {
            value: v * MULTIPLIER,
        }
    }

    public fun add(x:Decimal128N18, y: Decimal128N18): Decimal128N18 {
        Decimal128N18 {
            value: x.value + y.value,
        }
    }

    public fun subtract(x: Decimal128N18, y: Decimal128N18): Decimal128N18 {
        Decimal128N18 {
            value: x.value - y.value,
        }
    }

    public fun multiply(x: Decimal128N18, y: Decimal128N18): Decimal128N18 {
        let (v, carry) = uint256::underlying_mul_with_carry(x.value, y.value);
        let result = uint256::divide(uint256::new(carry, v), uint256::new(0, MULTIPLIER));
        assert!(uint256::hi(result) == 0, E_OVERFLOW);
        Decimal128N18 {
            value: uint256::lo(result),
        }
    }

    public fun divide(x: Decimal128N18, y: Decimal128N18): Decimal128N18 {
        let y = uint256::new(0, y.value);
        let (x,carry) = uint256::underlying_mul_with_carry(x.value, MULTIPLIER);
        let x = uint256::new(carry, x);
        let d = uint256::divide(x, y);

        Decimal128N18 {
            value: uint256::lo(d),
        }
    }

    public fun divide_mod(x: Decimal128N18, y: Decimal128N18):(Decimal128N18, Decimal128N18) {
        let d = divide(x, y);

        (d, subtract(x, multiply(d, y)))
    }

    public fun bitwise_and(x: Decimal128N18, y: Decimal128N18): Decimal128N18 {
        Decimal128N18 {
            value: x.value & y.value,
        }
    }

    public fun bitwise_or(x: Decimal128N18, y: Decimal128N18): Decimal128N18 {
        Decimal128N18 {
            value: x.value | y.value,
        }
    }

    public fun bitwise_xor(x: Decimal128N18, y: Decimal128N18): Decimal128N18 {
        Decimal128N18 {
            value: x.value ^ y.value,
        }
    }


    #[test]
    fun test_decimal128n18() {
        let x = from_integer(1);
        let y = from_integer(3);
        assert!(x.value == MULTIPLIER, (x.value as u64));
        assert!(y.value == MULTIPLIER * 3, (y.value as u64));
        let (d, m) = divide_mod(from_integer(1), from_integer(3));
        assert!(d.value == 1000000000000000000u128/3, (d.value as u64));
        assert!(m.value == 1, (m.value as u64));
    }
}
