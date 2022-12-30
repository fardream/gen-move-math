// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-math -t
// Version: v1.4.5
module more_math::int8 {
    /// Int8 defines a signed integer with 8 bit width from u8.
    /// Negative numbers are represented by two's complements.
    struct Int8 has store, copy, drop {
        value: u8,
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    /// BREAK_POINT is the value of 2^(8-1), where positive and negative breaks.
    /// It is the minimal value of the negative value -2^(8-1).
    /// BREAK_POINT has the sign bit 1, and all lower bits 0.
    const BREAK_POINT: u8 = 128;
    /// Max Positive, this is BREAK_POINT-1, and the max value for the positive numbers.
    /// MAX_POSITIVE has the sign bit 0, and all lower bits 1.
    const MAX_POSITIVE: u8 = 127;
    /// Max U is the max value of the unsigned, which is 2^8 - 1.
    /// MAX_U has all its bits 1.
    const MAX_U: u8 = 255;

    /// swap_half shifts the value of negative numbers to lower half of the total range,
    /// and non negative numbers to the upper half of the total range - this is essentially
    /// x + BREAK_POINT.
    fun swap_half(x: Int8): u8 {
        // Flip the sign bit - that's it.
        x.value^BREAK_POINT
    }

    /// new creates a Int8.
    public fun new(absolute_value: u8, negative: bool): Int8 {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) {
            Int8 {
                value: absolute_value,
            }
        } else {
            Int8 {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    /// is_negative checks if x is negative.
    public fun is_negative(x: Int8): bool {
        x.value >= BREAK_POINT
    }

    public fun is_zero(x: Int8): bool {
        x.value == 0
    }

    /// negative returns -x.
    public fun negative(x: Int8): Int8 {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            Int8 {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    /// abs returns the absolute value of x (as the unsigned underlying u8)
    public fun abs(x: Int8): u8 {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    /// zero obtains the zero value of the type.
    public fun zero(): Int8 {
        Int8 {
            value: 0
        }
    }

    /// equal checks if x == y
    public fun equal(x: Int8, y: Int8): bool {
        x.value == y.value
    }

    /// greater checks if x > y
    public fun greater(x: Int8, y:Int8): bool {
        swap_half(x) > swap_half(y)
    }

    /// less checks if x < y
    public fun less(x: Int8, y: Int8): bool {
        swap_half(x) < swap_half(y)
    }

    /// add x and y, abort if overflow
    public fun add(x: Int8, y: Int8): Int8 {
        // get the lower bits of x, and y, and the sign bits.
        let xl = x.value & MAX_POSITIVE;
        let xs = x.value & BREAK_POINT;
        let yl = y.value & MAX_POSITIVE;
        let ys = y.value & BREAK_POINT;
        // add the lower bits up, and if x and have don't have the same sign, flip the sign bit.
        let r = (xl + yl) ^ (xs ^ ys);
        // get the sign bit of the result
        let rs = r & BREAK_POINT;
        // make sure:
        // - x and y's sign bits are different (never overflow)
        // - or r's sign bits are same as x and y's sign bits (in this case, the result may overflow).
        assert!((xs != ys)||(xs == rs), E_OUT_OF_RANGE);
        // return the result
        Int8 {
            value: r,
        }
    }

    /// subtract y from x, abort if overflows
    public fun subtract(x: Int8, y: Int8): Int8 {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            // technically speaking, should check overflow
            // however, the minus will abort with underflow
            // assert!(x.value >= BREAK_POINT, E_OUT_OF_RANGE);
            Int8 {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    /// calculate x - y for the unsigned type.
    public fun unsigned_subtract(x: u8, y: u8): Int8 {
        if (x > y) {
            new(x - y, false)
        } else {
            new(y - x, true)
        }
    }

    /// multiply x and y, abort if overflows
    public fun multiply(x: Int8, y: Int8): Int8 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// divide x with y, abort if y is 0
    public fun divide(x: Int8, y: Int8): Int8 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// mod remainder of the integer division (x - y*(x/y))
    public fun mod(x: Int8, y: Int8): Int8 {
        subtract(x, multiply(y, divide(x, y)))
    }

    /// raw value returns the underlying unsigned integer u8
    public fun raw_value(x: Int8): u8 {
        x.value
    }

    /// bitwise and
    public fun bitwise_and(x: Int8, y: Int8): Int8 {
        Int8 {
            value: x.value & y.value,
        }
    }

    /// bitwise or
    public fun bitwise_or(x: Int8, y: Int8): Int8 {
        Int8 {
            value: x.value | y.value,
        }
    }

    /// bitwise xor
    public fun bitwise_xor(x: Int8, y: Int8): Int8 {
        Int8 {
            value: x.value ^ y.value,
        }
    }

    /// left shift the integer
    public fun lsh(x: Int8, n: u8): Int8 {
        Int8 {
            value: (x.value << n),
        }
    }

    /// right shift the integer
    public fun rsh(x: Int8, n: u8): Int8 {
        Int8 {
            value: (x.value >> n),
        }
    }


    #[test]
    fun test_int8() {
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
    fun test_int8_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int8_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int8_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }

    #[test,expected_failure]
    fun test_int8_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int8_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-math -t
// Version: v1.4.5
module more_math::int16 {
    /// Int16 defines a signed integer with 16 bit width from u16.
    /// Negative numbers are represented by two's complements.
    struct Int16 has store, copy, drop {
        value: u16,
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    /// BREAK_POINT is the value of 2^(16-1), where positive and negative breaks.
    /// It is the minimal value of the negative value -2^(16-1).
    /// BREAK_POINT has the sign bit 1, and all lower bits 0.
    const BREAK_POINT: u16 = 32768;
    /// Max Positive, this is BREAK_POINT-1, and the max value for the positive numbers.
    /// MAX_POSITIVE has the sign bit 0, and all lower bits 1.
    const MAX_POSITIVE: u16 = 32767;
    /// Max U is the max value of the unsigned, which is 2^16 - 1.
    /// MAX_U has all its bits 1.
    const MAX_U: u16 = 65535;

    /// swap_half shifts the value of negative numbers to lower half of the total range,
    /// and non negative numbers to the upper half of the total range - this is essentially
    /// x + BREAK_POINT.
    fun swap_half(x: Int16): u16 {
        // Flip the sign bit - that's it.
        x.value^BREAK_POINT
    }

    /// new creates a Int16.
    public fun new(absolute_value: u16, negative: bool): Int16 {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) {
            Int16 {
                value: absolute_value,
            }
        } else {
            Int16 {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    /// is_negative checks if x is negative.
    public fun is_negative(x: Int16): bool {
        x.value >= BREAK_POINT
    }

    public fun is_zero(x: Int16): bool {
        x.value == 0
    }

    /// negative returns -x.
    public fun negative(x: Int16): Int16 {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            Int16 {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    /// abs returns the absolute value of x (as the unsigned underlying u16)
    public fun abs(x: Int16): u16 {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    /// zero obtains the zero value of the type.
    public fun zero(): Int16 {
        Int16 {
            value: 0
        }
    }

    /// equal checks if x == y
    public fun equal(x: Int16, y: Int16): bool {
        x.value == y.value
    }

    /// greater checks if x > y
    public fun greater(x: Int16, y:Int16): bool {
        swap_half(x) > swap_half(y)
    }

    /// less checks if x < y
    public fun less(x: Int16, y: Int16): bool {
        swap_half(x) < swap_half(y)
    }

    /// add x and y, abort if overflow
    public fun add(x: Int16, y: Int16): Int16 {
        // get the lower bits of x, and y, and the sign bits.
        let xl = x.value & MAX_POSITIVE;
        let xs = x.value & BREAK_POINT;
        let yl = y.value & MAX_POSITIVE;
        let ys = y.value & BREAK_POINT;
        // add the lower bits up, and if x and have don't have the same sign, flip the sign bit.
        let r = (xl + yl) ^ (xs ^ ys);
        // get the sign bit of the result
        let rs = r & BREAK_POINT;
        // make sure:
        // - x and y's sign bits are different (never overflow)
        // - or r's sign bits are same as x and y's sign bits (in this case, the result may overflow).
        assert!((xs != ys)||(xs == rs), E_OUT_OF_RANGE);
        // return the result
        Int16 {
            value: r,
        }
    }

    /// subtract y from x, abort if overflows
    public fun subtract(x: Int16, y: Int16): Int16 {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            // technically speaking, should check overflow
            // however, the minus will abort with underflow
            // assert!(x.value >= BREAK_POINT, E_OUT_OF_RANGE);
            Int16 {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    /// calculate x - y for the unsigned type.
    public fun unsigned_subtract(x: u16, y: u16): Int16 {
        if (x > y) {
            new(x - y, false)
        } else {
            new(y - x, true)
        }
    }

    /// multiply x and y, abort if overflows
    public fun multiply(x: Int16, y: Int16): Int16 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// divide x with y, abort if y is 0
    public fun divide(x: Int16, y: Int16): Int16 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// mod remainder of the integer division (x - y*(x/y))
    public fun mod(x: Int16, y: Int16): Int16 {
        subtract(x, multiply(y, divide(x, y)))
    }

    /// raw value returns the underlying unsigned integer u16
    public fun raw_value(x: Int16): u16 {
        x.value
    }

    /// bitwise and
    public fun bitwise_and(x: Int16, y: Int16): Int16 {
        Int16 {
            value: x.value & y.value,
        }
    }

    /// bitwise or
    public fun bitwise_or(x: Int16, y: Int16): Int16 {
        Int16 {
            value: x.value | y.value,
        }
    }

    /// bitwise xor
    public fun bitwise_xor(x: Int16, y: Int16): Int16 {
        Int16 {
            value: x.value ^ y.value,
        }
    }

    /// left shift the integer
    public fun lsh(x: Int16, n: u8): Int16 {
        Int16 {
            value: (x.value << n),
        }
    }

    /// right shift the integer
    public fun rsh(x: Int16, n: u8): Int16 {
        Int16 {
            value: (x.value >> n),
        }
    }


    #[test]
    fun test_int16() {
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
    fun test_int16_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int16_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int16_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }

    #[test,expected_failure]
    fun test_int16_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int16_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-math -t
// Version: v1.4.5
module more_math::int32 {
    /// Int32 defines a signed integer with 32 bit width from u32.
    /// Negative numbers are represented by two's complements.
    struct Int32 has store, copy, drop {
        value: u32,
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    /// BREAK_POINT is the value of 2^(32-1), where positive and negative breaks.
    /// It is the minimal value of the negative value -2^(32-1).
    /// BREAK_POINT has the sign bit 1, and all lower bits 0.
    const BREAK_POINT: u32 = 2147483648;
    /// Max Positive, this is BREAK_POINT-1, and the max value for the positive numbers.
    /// MAX_POSITIVE has the sign bit 0, and all lower bits 1.
    const MAX_POSITIVE: u32 = 2147483647;
    /// Max U is the max value of the unsigned, which is 2^32 - 1.
    /// MAX_U has all its bits 1.
    const MAX_U: u32 = 4294967295;

    /// swap_half shifts the value of negative numbers to lower half of the total range,
    /// and non negative numbers to the upper half of the total range - this is essentially
    /// x + BREAK_POINT.
    fun swap_half(x: Int32): u32 {
        // Flip the sign bit - that's it.
        x.value^BREAK_POINT
    }

    /// new creates a Int32.
    public fun new(absolute_value: u32, negative: bool): Int32 {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) {
            Int32 {
                value: absolute_value,
            }
        } else {
            Int32 {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    /// is_negative checks if x is negative.
    public fun is_negative(x: Int32): bool {
        x.value >= BREAK_POINT
    }

    public fun is_zero(x: Int32): bool {
        x.value == 0
    }

    /// negative returns -x.
    public fun negative(x: Int32): Int32 {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            Int32 {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    /// abs returns the absolute value of x (as the unsigned underlying u32)
    public fun abs(x: Int32): u32 {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    /// zero obtains the zero value of the type.
    public fun zero(): Int32 {
        Int32 {
            value: 0
        }
    }

    /// equal checks if x == y
    public fun equal(x: Int32, y: Int32): bool {
        x.value == y.value
    }

    /// greater checks if x > y
    public fun greater(x: Int32, y:Int32): bool {
        swap_half(x) > swap_half(y)
    }

    /// less checks if x < y
    public fun less(x: Int32, y: Int32): bool {
        swap_half(x) < swap_half(y)
    }

    /// add x and y, abort if overflow
    public fun add(x: Int32, y: Int32): Int32 {
        // get the lower bits of x, and y, and the sign bits.
        let xl = x.value & MAX_POSITIVE;
        let xs = x.value & BREAK_POINT;
        let yl = y.value & MAX_POSITIVE;
        let ys = y.value & BREAK_POINT;
        // add the lower bits up, and if x and have don't have the same sign, flip the sign bit.
        let r = (xl + yl) ^ (xs ^ ys);
        // get the sign bit of the result
        let rs = r & BREAK_POINT;
        // make sure:
        // - x and y's sign bits are different (never overflow)
        // - or r's sign bits are same as x and y's sign bits (in this case, the result may overflow).
        assert!((xs != ys)||(xs == rs), E_OUT_OF_RANGE);
        // return the result
        Int32 {
            value: r,
        }
    }

    /// subtract y from x, abort if overflows
    public fun subtract(x: Int32, y: Int32): Int32 {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            // technically speaking, should check overflow
            // however, the minus will abort with underflow
            // assert!(x.value >= BREAK_POINT, E_OUT_OF_RANGE);
            Int32 {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    /// calculate x - y for the unsigned type.
    public fun unsigned_subtract(x: u32, y: u32): Int32 {
        if (x > y) {
            new(x - y, false)
        } else {
            new(y - x, true)
        }
    }

    /// multiply x and y, abort if overflows
    public fun multiply(x: Int32, y: Int32): Int32 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// divide x with y, abort if y is 0
    public fun divide(x: Int32, y: Int32): Int32 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// mod remainder of the integer division (x - y*(x/y))
    public fun mod(x: Int32, y: Int32): Int32 {
        subtract(x, multiply(y, divide(x, y)))
    }

    /// raw value returns the underlying unsigned integer u32
    public fun raw_value(x: Int32): u32 {
        x.value
    }

    /// bitwise and
    public fun bitwise_and(x: Int32, y: Int32): Int32 {
        Int32 {
            value: x.value & y.value,
        }
    }

    /// bitwise or
    public fun bitwise_or(x: Int32, y: Int32): Int32 {
        Int32 {
            value: x.value | y.value,
        }
    }

    /// bitwise xor
    public fun bitwise_xor(x: Int32, y: Int32): Int32 {
        Int32 {
            value: x.value ^ y.value,
        }
    }

    /// left shift the integer
    public fun lsh(x: Int32, n: u8): Int32 {
        Int32 {
            value: (x.value << n),
        }
    }

    /// right shift the integer
    public fun rsh(x: Int32, n: u8): Int32 {
        Int32 {
            value: (x.value >> n),
        }
    }


    #[test]
    fun test_int32() {
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
    fun test_int32_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int32_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int32_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }

    #[test,expected_failure]
    fun test_int32_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int32_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-math -t
// Version: v1.4.5
module more_math::int64 {
    /// Int64 defines a signed integer with 64 bit width from u64.
    /// Negative numbers are represented by two's complements.
    struct Int64 has store, copy, drop {
        value: u64,
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    /// BREAK_POINT is the value of 2^(64-1), where positive and negative breaks.
    /// It is the minimal value of the negative value -2^(64-1).
    /// BREAK_POINT has the sign bit 1, and all lower bits 0.
    const BREAK_POINT: u64 = 9223372036854775808;
    /// Max Positive, this is BREAK_POINT-1, and the max value for the positive numbers.
    /// MAX_POSITIVE has the sign bit 0, and all lower bits 1.
    const MAX_POSITIVE: u64 = 9223372036854775807;
    /// Max U is the max value of the unsigned, which is 2^64 - 1.
    /// MAX_U has all its bits 1.
    const MAX_U: u64 = 18446744073709551615;

    /// swap_half shifts the value of negative numbers to lower half of the total range,
    /// and non negative numbers to the upper half of the total range - this is essentially
    /// x + BREAK_POINT.
    fun swap_half(x: Int64): u64 {
        // Flip the sign bit - that's it.
        x.value^BREAK_POINT
    }

    /// new creates a Int64.
    public fun new(absolute_value: u64, negative: bool): Int64 {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) {
            Int64 {
                value: absolute_value,
            }
        } else {
            Int64 {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    /// is_negative checks if x is negative.
    public fun is_negative(x: Int64): bool {
        x.value >= BREAK_POINT
    }

    public fun is_zero(x: Int64): bool {
        x.value == 0
    }

    /// negative returns -x.
    public fun negative(x: Int64): Int64 {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            Int64 {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    /// abs returns the absolute value of x (as the unsigned underlying u64)
    public fun abs(x: Int64): u64 {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    /// zero obtains the zero value of the type.
    public fun zero(): Int64 {
        Int64 {
            value: 0
        }
    }

    /// equal checks if x == y
    public fun equal(x: Int64, y: Int64): bool {
        x.value == y.value
    }

    /// greater checks if x > y
    public fun greater(x: Int64, y:Int64): bool {
        swap_half(x) > swap_half(y)
    }

    /// less checks if x < y
    public fun less(x: Int64, y: Int64): bool {
        swap_half(x) < swap_half(y)
    }

    /// add x and y, abort if overflow
    public fun add(x: Int64, y: Int64): Int64 {
        // get the lower bits of x, and y, and the sign bits.
        let xl = x.value & MAX_POSITIVE;
        let xs = x.value & BREAK_POINT;
        let yl = y.value & MAX_POSITIVE;
        let ys = y.value & BREAK_POINT;
        // add the lower bits up, and if x and have don't have the same sign, flip the sign bit.
        let r = (xl + yl) ^ (xs ^ ys);
        // get the sign bit of the result
        let rs = r & BREAK_POINT;
        // make sure:
        // - x and y's sign bits are different (never overflow)
        // - or r's sign bits are same as x and y's sign bits (in this case, the result may overflow).
        assert!((xs != ys)||(xs == rs), E_OUT_OF_RANGE);
        // return the result
        Int64 {
            value: r,
        }
    }

    /// subtract y from x, abort if overflows
    public fun subtract(x: Int64, y: Int64): Int64 {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            // technically speaking, should check overflow
            // however, the minus will abort with underflow
            // assert!(x.value >= BREAK_POINT, E_OUT_OF_RANGE);
            Int64 {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    /// calculate x - y for the unsigned type.
    public fun unsigned_subtract(x: u64, y: u64): Int64 {
        if (x > y) {
            new(x - y, false)
        } else {
            new(y - x, true)
        }
    }

    /// multiply x and y, abort if overflows
    public fun multiply(x: Int64, y: Int64): Int64 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// divide x with y, abort if y is 0
    public fun divide(x: Int64, y: Int64): Int64 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// mod remainder of the integer division (x - y*(x/y))
    public fun mod(x: Int64, y: Int64): Int64 {
        subtract(x, multiply(y, divide(x, y)))
    }

    /// raw value returns the underlying unsigned integer u64
    public fun raw_value(x: Int64): u64 {
        x.value
    }

    /// bitwise and
    public fun bitwise_and(x: Int64, y: Int64): Int64 {
        Int64 {
            value: x.value & y.value,
        }
    }

    /// bitwise or
    public fun bitwise_or(x: Int64, y: Int64): Int64 {
        Int64 {
            value: x.value | y.value,
        }
    }

    /// bitwise xor
    public fun bitwise_xor(x: Int64, y: Int64): Int64 {
        Int64 {
            value: x.value ^ y.value,
        }
    }

    /// left shift the integer
    public fun lsh(x: Int64, n: u8): Int64 {
        Int64 {
            value: (x.value << n),
        }
    }

    /// right shift the integer
    public fun rsh(x: Int64, n: u8): Int64 {
        Int64 {
            value: (x.value >> n),
        }
    }


    #[test]
    fun test_int64() {
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
    fun test_int64_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int64_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int64_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }

    #[test,expected_failure]
    fun test_int64_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int64_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-math -t
// Version: v1.4.5
module more_math::int128 {
    /// Int128 defines a signed integer with 128 bit width from u128.
    /// Negative numbers are represented by two's complements.
    struct Int128 has store, copy, drop {
        value: u128,
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    /// BREAK_POINT is the value of 2^(128-1), where positive and negative breaks.
    /// It is the minimal value of the negative value -2^(128-1).
    /// BREAK_POINT has the sign bit 1, and all lower bits 0.
    const BREAK_POINT: u128 = 170141183460469231731687303715884105728;
    /// Max Positive, this is BREAK_POINT-1, and the max value for the positive numbers.
    /// MAX_POSITIVE has the sign bit 0, and all lower bits 1.
    const MAX_POSITIVE: u128 = 170141183460469231731687303715884105727;
    /// Max U is the max value of the unsigned, which is 2^128 - 1.
    /// MAX_U has all its bits 1.
    const MAX_U: u128 = 340282366920938463463374607431768211455;

    /// swap_half shifts the value of negative numbers to lower half of the total range,
    /// and non negative numbers to the upper half of the total range - this is essentially
    /// x + BREAK_POINT.
    fun swap_half(x: Int128): u128 {
        // Flip the sign bit - that's it.
        x.value^BREAK_POINT
    }

    /// new creates a Int128.
    public fun new(absolute_value: u128, negative: bool): Int128 {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) {
            Int128 {
                value: absolute_value,
            }
        } else {
            Int128 {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    /// is_negative checks if x is negative.
    public fun is_negative(x: Int128): bool {
        x.value >= BREAK_POINT
    }

    public fun is_zero(x: Int128): bool {
        x.value == 0
    }

    /// negative returns -x.
    public fun negative(x: Int128): Int128 {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            Int128 {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    /// abs returns the absolute value of x (as the unsigned underlying u128)
    public fun abs(x: Int128): u128 {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    /// zero obtains the zero value of the type.
    public fun zero(): Int128 {
        Int128 {
            value: 0
        }
    }

    /// equal checks if x == y
    public fun equal(x: Int128, y: Int128): bool {
        x.value == y.value
    }

    /// greater checks if x > y
    public fun greater(x: Int128, y:Int128): bool {
        swap_half(x) > swap_half(y)
    }

    /// less checks if x < y
    public fun less(x: Int128, y: Int128): bool {
        swap_half(x) < swap_half(y)
    }

    /// add x and y, abort if overflow
    public fun add(x: Int128, y: Int128): Int128 {
        // get the lower bits of x, and y, and the sign bits.
        let xl = x.value & MAX_POSITIVE;
        let xs = x.value & BREAK_POINT;
        let yl = y.value & MAX_POSITIVE;
        let ys = y.value & BREAK_POINT;
        // add the lower bits up, and if x and have don't have the same sign, flip the sign bit.
        let r = (xl + yl) ^ (xs ^ ys);
        // get the sign bit of the result
        let rs = r & BREAK_POINT;
        // make sure:
        // - x and y's sign bits are different (never overflow)
        // - or r's sign bits are same as x and y's sign bits (in this case, the result may overflow).
        assert!((xs != ys)||(xs == rs), E_OUT_OF_RANGE);
        // return the result
        Int128 {
            value: r,
        }
    }

    /// subtract y from x, abort if overflows
    public fun subtract(x: Int128, y: Int128): Int128 {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            // technically speaking, should check overflow
            // however, the minus will abort with underflow
            // assert!(x.value >= BREAK_POINT, E_OUT_OF_RANGE);
            Int128 {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    /// calculate x - y for the unsigned type.
    public fun unsigned_subtract(x: u128, y: u128): Int128 {
        if (x > y) {
            new(x - y, false)
        } else {
            new(y - x, true)
        }
    }

    /// multiply x and y, abort if overflows
    public fun multiply(x: Int128, y: Int128): Int128 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// divide x with y, abort if y is 0
    public fun divide(x: Int128, y: Int128): Int128 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// mod remainder of the integer division (x - y*(x/y))
    public fun mod(x: Int128, y: Int128): Int128 {
        subtract(x, multiply(y, divide(x, y)))
    }

    /// raw value returns the underlying unsigned integer u128
    public fun raw_value(x: Int128): u128 {
        x.value
    }

    /// bitwise and
    public fun bitwise_and(x: Int128, y: Int128): Int128 {
        Int128 {
            value: x.value & y.value,
        }
    }

    /// bitwise or
    public fun bitwise_or(x: Int128, y: Int128): Int128 {
        Int128 {
            value: x.value | y.value,
        }
    }

    /// bitwise xor
    public fun bitwise_xor(x: Int128, y: Int128): Int128 {
        Int128 {
            value: x.value ^ y.value,
        }
    }

    /// left shift the integer
    public fun lsh(x: Int128, n: u8): Int128 {
        Int128 {
            value: (x.value << n),
        }
    }

    /// right shift the integer
    public fun rsh(x: Int128, n: u8): Int128 {
        Int128 {
            value: (x.value >> n),
        }
    }


    #[test]
    fun test_int128() {
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
    fun test_int128_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int128_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int128_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }

    #[test,expected_failure]
    fun test_int128_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int128_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-math -t
// Version: v1.4.5
module more_math::int256 {
    /// Int256 defines a signed integer with 256 bit width from u256.
    /// Negative numbers are represented by two's complements.
    struct Int256 has store, copy, drop {
        value: u256,
    }

    const E_OUT_OF_RANGE: u64 = 1001;

    /// BREAK_POINT is the value of 2^(256-1), where positive and negative breaks.
    /// It is the minimal value of the negative value -2^(256-1).
    /// BREAK_POINT has the sign bit 1, and all lower bits 0.
    const BREAK_POINT: u256 = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    /// Max Positive, this is BREAK_POINT-1, and the max value for the positive numbers.
    /// MAX_POSITIVE has the sign bit 0, and all lower bits 1.
    const MAX_POSITIVE: u256 = 57896044618658097711785492504343953926634992332820282019728792003956564819967;
    /// Max U is the max value of the unsigned, which is 2^256 - 1.
    /// MAX_U has all its bits 1.
    const MAX_U: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    /// swap_half shifts the value of negative numbers to lower half of the total range,
    /// and non negative numbers to the upper half of the total range - this is essentially
    /// x + BREAK_POINT.
    fun swap_half(x: Int256): u256 {
        // Flip the sign bit - that's it.
        x.value^BREAK_POINT
    }

    /// new creates a Int256.
    public fun new(absolute_value: u256, negative: bool): Int256 {
        assert!((negative && absolute_value <= BREAK_POINT) || (!negative && absolute_value < BREAK_POINT), E_OUT_OF_RANGE);
        if (!negative || absolute_value == 0) {
            Int256 {
                value: absolute_value,
            }
        } else {
            Int256 {
                value: (MAX_U ^ absolute_value) + 1,
            }
        }
    }

    /// is_negative checks if x is negative.
    public fun is_negative(x: Int256): bool {
        x.value >= BREAK_POINT
    }

    public fun is_zero(x: Int256): bool {
        x.value == 0
    }

    /// negative returns -x.
    public fun negative(x: Int256): Int256 {
        assert!(x.value != BREAK_POINT, E_OUT_OF_RANGE);

        if (x.value == 0) {
            copy x
        } else {
            Int256 {
                value: (MAX_U^x.value) + 1
            }
        }
    }

    /// abs returns the absolute value of x (as the unsigned underlying u256)
    public fun abs(x: Int256): u256 {
        if (!is_negative(x)) {
            x.value
        } else {
            (MAX_U^x.value) + 1
        }
    }

    /// zero obtains the zero value of the type.
    public fun zero(): Int256 {
        Int256 {
            value: 0
        }
    }

    /// equal checks if x == y
    public fun equal(x: Int256, y: Int256): bool {
        x.value == y.value
    }

    /// greater checks if x > y
    public fun greater(x: Int256, y:Int256): bool {
        swap_half(x) > swap_half(y)
    }

    /// less checks if x < y
    public fun less(x: Int256, y: Int256): bool {
        swap_half(x) < swap_half(y)
    }

    /// add x and y, abort if overflow
    public fun add(x: Int256, y: Int256): Int256 {
        // get the lower bits of x, and y, and the sign bits.
        let xl = x.value & MAX_POSITIVE;
        let xs = x.value & BREAK_POINT;
        let yl = y.value & MAX_POSITIVE;
        let ys = y.value & BREAK_POINT;
        // add the lower bits up, and if x and have don't have the same sign, flip the sign bit.
        let r = (xl + yl) ^ (xs ^ ys);
        // get the sign bit of the result
        let rs = r & BREAK_POINT;
        // make sure:
        // - x and y's sign bits are different (never overflow)
        // - or r's sign bits are same as x and y's sign bits (in this case, the result may overflow).
        assert!((xs != ys)||(xs == rs), E_OUT_OF_RANGE);
        // return the result
        Int256 {
            value: r,
        }
    }

    /// subtract y from x, abort if overflows
    public fun subtract(x: Int256, y: Int256): Int256 {
        // y is the smallest value of negative
        // x must be at most -1
        if (y.value == BREAK_POINT) {
            // technically speaking, should check overflow
            // however, the minus will abort with underflow
            // assert!(x.value >= BREAK_POINT, E_OUT_OF_RANGE);
            Int256 {
                value: x.value - y.value,
            }
        } else {
            add(x, negative(y))
        }
    }

    /// calculate x - y for the unsigned type.
    public fun unsigned_subtract(x: u256, y: u256): Int256 {
        if (x > y) {
            new(x - y, false)
        } else {
            new(y - x, true)
        }
    }

    /// multiply x and y, abort if overflows
    public fun multiply(x: Int256, y: Int256): Int256 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv * yv; // will fail if overflow
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// divide x with y, abort if y is 0
    public fun divide(x: Int256, y: Int256): Int256 {
        let xv = abs(x);
        let yv = abs(y);
        let r = xv / yv; // will fail if divide by 0
        if ((x.value & BREAK_POINT)^(y.value & BREAK_POINT) == 0) {
            new(r, false)
        } else {
            new(r, true)
        }
    }

    /// mod remainder of the integer division (x - y*(x/y))
    public fun mod(x: Int256, y: Int256): Int256 {
        subtract(x, multiply(y, divide(x, y)))
    }

    /// raw value returns the underlying unsigned integer u256
    public fun raw_value(x: Int256): u256 {
        x.value
    }

    /// bitwise and
    public fun bitwise_and(x: Int256, y: Int256): Int256 {
        Int256 {
            value: x.value & y.value,
        }
    }

    /// bitwise or
    public fun bitwise_or(x: Int256, y: Int256): Int256 {
        Int256 {
            value: x.value | y.value,
        }
    }

    /// bitwise xor
    public fun bitwise_xor(x: Int256, y: Int256): Int256 {
        Int256 {
            value: x.value ^ y.value,
        }
    }

    /// left shift the integer
    public fun lsh(x: Int256, n: u8): Int256 {
        Int256 {
            value: (x.value << n),
        }
    }

    /// right shift the integer
    public fun rsh(x: Int256, n: u8): Int256 {
        Int256 {
            value: (x.value >> n),
        }
    }


    #[test]
    fun test_int256() {
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
    fun test_int256_failures() {
        abs(new(BREAK_POINT, false));
    }

    #[test,expected_failure]
    fun test_int256_failure_overflow() {
        add(new(BREAK_POINT, true), new(25, true));
    }

    #[test,expected_failure]
    fun test_int256_failure_overflow_positive() {
        add(new(MAX_POSITIVE, false), new(3, false));
    }

    #[test,expected_failure]
    fun test_int256_failure_overflow_multiply() {
        multiply(new(MAX_POSITIVE, true), new(31,false));
    }

    #[test,expected_failure]
    fun test_int256_failure_overflow_multiply_1() {
        multiply(new(BREAK_POINT, true), new(1,true));
    }
}
