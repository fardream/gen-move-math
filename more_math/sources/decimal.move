// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
module more_math::decimal128n9 {
    use more_math::uint256;

    const E_OVERFLOW: u64 = 1001;
    // Decimal128N9 is a decimal with 9 digits.
    // It represents a value of v*10^(-9)
    struct Decimal128N9 has copy, drop, store {
        value: u128
    }

    const MULTIPLIER: u128 = 1000000000;
    const SQUARED_MULTIPLIER: u128 = 1000000000*1000000000;

    const DECIMAL: u8 = 9;
    const SQUARED_DECIMAL: u8 = 18;

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