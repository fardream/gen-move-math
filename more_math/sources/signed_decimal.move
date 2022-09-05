// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-decimal -t
// Version: v1.2.6
module more_math::signed_decimal128_p12 {
    use more_math::uint256;
    use more_math::int128::{Self, Int128};


    const E_INVALID_DECIMAL: u64 = 1001;
    const E_OVERFLOW: u64 = 1002;


    const PRECISION: u8 = 12;

    struct SDecimal128 has store, copy, drop {
        value: Int128,
        decimal: u8,
    }

    public fun get_decimal(d: &SDecimal128): u8 {
        d.decimal
    }

    public fun is_zero(d: &SDecimal128): bool {
        int128::is_zero(d.value)
    }

    public fun equalize_decimal(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        if (x.decimal > y.decimal) {
            y = raise_decimal(&y, x.decimal);
        } else if (x.decimal < y.decimal) {
            x = raise_decimal(&x, y.decimal);
        };
        (x, y)
    }

    public fun equal(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::equal(x.value, y.value)
    }

    public fun greater(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::greater(x.value, y.value)
    }

    public fun less(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::less(x.value, y.value)
    }

    public fun new(abs: u128, negative: bool, decimal: u8): SDecimal128 {
        SDecimal128 {
            value: int128::new(abs, negative),
            decimal,
        }
    }

    public fun new_with_value(value: Int128, decimal: u8): SDecimal128 {
        SDecimal128 {
            value,
            decimal,
        }
    }

    public fun get_value(d: &SDecimal128): Int128 {
        d.value
    }

    public fun get_value_abs(d: &SDecimal128): u128 {
        int128::abs(d.value)
    }

    public fun is_negative(d: &SDecimal128): bool {
        int128::is_negative(d.value)
    }

    public fun lower_decimal(d: &SDecimal128, decimal: u8): (SDecimal128, SDecimal128) {
        let v = get_value(d);
        let current_decimal = get_decimal(d);

        assert!(
            current_decimal > decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i > decimal) {
            m = m * 10;
            i = i - 1;
        };

        let m = int128::new(m, false);

        (
            new_with_value(int128::divide(v, m), decimal),
            new_with_value(int128::mod(v, m), current_decimal)
        )
    }

    public fun raise_decimal(d: &SDecimal128, decimal: u8): SDecimal128 {
        let v = get_value(d);
        let current_decimal =  get_decimal(d);
        assert!(
            current_decimal < decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i < decimal) {
            m = m * 10;
            i = i + 1;
        };

        let m = int128::new(m, false);
        new_with_value(int128::multiply(v, m), decimal)
    }

    // reduce tries to remove trailing 0s from the value and reduce the decimal.
    public fun reduce(d: &SDecimal128): SDecimal128 {
        if (is_zero(d)) {
            new(0, false, 0)
        } else {
            let v = get_value_abs(d);
            let i = get_decimal(d);
            while (i > 0) {
                if (v%10 == 0) {
                    i = i - 1;
                    v = v/10;
                } else {
                    break
                };
            };

            new(v, is_negative(d), i)
        }
    }

    public fun add(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::add(get_value(&x), get_value(&y)), dx))
    }

    public fun subtract(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::subtract(get_value(&x), get_value(&y)), dx))
    }

    public fun multiply(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let xv = get_value_abs(&x);
        let yv = get_value_abs(&y);
        let (lo, hi) = uint256::underlying_mul_with_carry(xv, yv);
        let vabs = uint256::new(hi, lo);
        let d = get_decimal(&x) + get_decimal(&y);
        let ten= uint256::new(0, 10);
        while (d > 0) {
            let (k, r) = uint256::divide_mod(vabs, ten);
            if (uint256::is_zero(&r)) {
                vabs = k;
                d = d - 1;
            } else {
                break
            };
        };

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        let is_negative = is_negative(&x) != is_negative(&y);

        new(uint256::lo(vabs), is_negative, d)
    }

    public fun divide(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let yv_abs = uint256::new(0, get_value_abs(&y));
        let xv_abs = uint256::new(0, get_value_abs(&x));
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        let ten = uint256::new(0, 10);
        let precision = if (dx > PRECISION) {
            0
        } else {
            PRECISION - dx
        };

        let ed = 0;

        while (ed < dy || ed < precision) {
            xv_abs = uint256::multiply(xv_abs, ten);
            ed = ed + 1;
        };

        let vabs = uint256::divide(xv_abs, yv_abs);

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        new(uint256::lo(vabs), is_negative(&x) != is_negative(&y), dx + ed - dy)
    }

    public fun divide_mod(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        let d = divide(x, y);
        let r = subtract(x, multiply(d, y));
        (d, r)
    }

    public fun mod(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let (_, r) = divide_mod(x, y);
        r
    }


    #[test]
    fun test_decimal128_p12() {
        let c = new(1800, false, 0);
        let d = new(3600, false, 0);
        let r = divide(c, d);
        assert!(equal(r, new(5, false, 1)), (r.decimal as u64));

        let c = new(5, false, 1);
        let d = new(2, true, 2);
        let r = multiply(c, d);
        assert!(equal(r, new(10, true, 3)), (r.decimal as u64))
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-decimal -t
// Version: v1.2.6
module more_math::signed_decimal128_p14 {
    use more_math::uint256;
    use more_math::int128::{Self, Int128};


    const E_INVALID_DECIMAL: u64 = 1001;
    const E_OVERFLOW: u64 = 1002;


    const PRECISION: u8 = 14;

    struct SDecimal128 has store, copy, drop {
        value: Int128,
        decimal: u8,
    }

    public fun get_decimal(d: &SDecimal128): u8 {
        d.decimal
    }

    public fun is_zero(d: &SDecimal128): bool {
        int128::is_zero(d.value)
    }

    public fun equalize_decimal(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        if (x.decimal > y.decimal) {
            y = raise_decimal(&y, x.decimal);
        } else if (x.decimal < y.decimal) {
            x = raise_decimal(&x, y.decimal);
        };
        (x, y)
    }

    public fun equal(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::equal(x.value, y.value)
    }

    public fun greater(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::greater(x.value, y.value)
    }

    public fun less(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::less(x.value, y.value)
    }

    public fun new(abs: u128, negative: bool, decimal: u8): SDecimal128 {
        SDecimal128 {
            value: int128::new(abs, negative),
            decimal,
        }
    }

    public fun new_with_value(value: Int128, decimal: u8): SDecimal128 {
        SDecimal128 {
            value,
            decimal,
        }
    }

    public fun get_value(d: &SDecimal128): Int128 {
        d.value
    }

    public fun get_value_abs(d: &SDecimal128): u128 {
        int128::abs(d.value)
    }

    public fun is_negative(d: &SDecimal128): bool {
        int128::is_negative(d.value)
    }

    public fun lower_decimal(d: &SDecimal128, decimal: u8): (SDecimal128, SDecimal128) {
        let v = get_value(d);
        let current_decimal = get_decimal(d);

        assert!(
            current_decimal > decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i > decimal) {
            m = m * 10;
            i = i - 1;
        };

        let m = int128::new(m, false);

        (
            new_with_value(int128::divide(v, m), decimal),
            new_with_value(int128::mod(v, m), current_decimal)
        )
    }

    public fun raise_decimal(d: &SDecimal128, decimal: u8): SDecimal128 {
        let v = get_value(d);
        let current_decimal =  get_decimal(d);
        assert!(
            current_decimal < decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i < decimal) {
            m = m * 10;
            i = i + 1;
        };

        let m = int128::new(m, false);
        new_with_value(int128::multiply(v, m), decimal)
    }

    // reduce tries to remove trailing 0s from the value and reduce the decimal.
    public fun reduce(d: &SDecimal128): SDecimal128 {
        if (is_zero(d)) {
            new(0, false, 0)
        } else {
            let v = get_value_abs(d);
            let i = get_decimal(d);
            while (i > 0) {
                if (v%10 == 0) {
                    i = i - 1;
                    v = v/10;
                } else {
                    break
                };
            };

            new(v, is_negative(d), i)
        }
    }

    public fun add(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::add(get_value(&x), get_value(&y)), dx))
    }

    public fun subtract(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::subtract(get_value(&x), get_value(&y)), dx))
    }

    public fun multiply(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let xv = get_value_abs(&x);
        let yv = get_value_abs(&y);
        let (lo, hi) = uint256::underlying_mul_with_carry(xv, yv);
        let vabs = uint256::new(hi, lo);
        let d = get_decimal(&x) + get_decimal(&y);
        let ten= uint256::new(0, 10);
        while (d > 0) {
            let (k, r) = uint256::divide_mod(vabs, ten);
            if (uint256::is_zero(&r)) {
                vabs = k;
                d = d - 1;
            } else {
                break
            };
        };

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        let is_negative = is_negative(&x) != is_negative(&y);

        new(uint256::lo(vabs), is_negative, d)
    }

    public fun divide(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let yv_abs = uint256::new(0, get_value_abs(&y));
        let xv_abs = uint256::new(0, get_value_abs(&x));
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        let ten = uint256::new(0, 10);
        let precision = if (dx > PRECISION) {
            0
        } else {
            PRECISION - dx
        };

        let ed = 0;

        while (ed < dy || ed < precision) {
            xv_abs = uint256::multiply(xv_abs, ten);
            ed = ed + 1;
        };

        let vabs = uint256::divide(xv_abs, yv_abs);

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        new(uint256::lo(vabs), is_negative(&x) != is_negative(&y), dx + ed - dy)
    }

    public fun divide_mod(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        let d = divide(x, y);
        let r = subtract(x, multiply(d, y));
        (d, r)
    }

    public fun mod(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let (_, r) = divide_mod(x, y);
        r
    }


    #[test]
    fun test_decimal128_p14() {
        let c = new(1800, false, 0);
        let d = new(3600, false, 0);
        let r = divide(c, d);
        assert!(equal(r, new(5, false, 1)), (r.decimal as u64));

        let c = new(5, false, 1);
        let d = new(2, true, 2);
        let r = multiply(c, d);
        assert!(equal(r, new(10, true, 3)), (r.decimal as u64))
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-decimal -t
// Version: v1.2.6
module more_math::signed_decimal128_p16 {
    use more_math::uint256;
    use more_math::int128::{Self, Int128};


    const E_INVALID_DECIMAL: u64 = 1001;
    const E_OVERFLOW: u64 = 1002;


    const PRECISION: u8 = 16;

    struct SDecimal128 has store, copy, drop {
        value: Int128,
        decimal: u8,
    }

    public fun get_decimal(d: &SDecimal128): u8 {
        d.decimal
    }

    public fun is_zero(d: &SDecimal128): bool {
        int128::is_zero(d.value)
    }

    public fun equalize_decimal(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        if (x.decimal > y.decimal) {
            y = raise_decimal(&y, x.decimal);
        } else if (x.decimal < y.decimal) {
            x = raise_decimal(&x, y.decimal);
        };
        (x, y)
    }

    public fun equal(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::equal(x.value, y.value)
    }

    public fun greater(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::greater(x.value, y.value)
    }

    public fun less(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::less(x.value, y.value)
    }

    public fun new(abs: u128, negative: bool, decimal: u8): SDecimal128 {
        SDecimal128 {
            value: int128::new(abs, negative),
            decimal,
        }
    }

    public fun new_with_value(value: Int128, decimal: u8): SDecimal128 {
        SDecimal128 {
            value,
            decimal,
        }
    }

    public fun get_value(d: &SDecimal128): Int128 {
        d.value
    }

    public fun get_value_abs(d: &SDecimal128): u128 {
        int128::abs(d.value)
    }

    public fun is_negative(d: &SDecimal128): bool {
        int128::is_negative(d.value)
    }

    public fun lower_decimal(d: &SDecimal128, decimal: u8): (SDecimal128, SDecimal128) {
        let v = get_value(d);
        let current_decimal = get_decimal(d);

        assert!(
            current_decimal > decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i > decimal) {
            m = m * 10;
            i = i - 1;
        };

        let m = int128::new(m, false);

        (
            new_with_value(int128::divide(v, m), decimal),
            new_with_value(int128::mod(v, m), current_decimal)
        )
    }

    public fun raise_decimal(d: &SDecimal128, decimal: u8): SDecimal128 {
        let v = get_value(d);
        let current_decimal =  get_decimal(d);
        assert!(
            current_decimal < decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i < decimal) {
            m = m * 10;
            i = i + 1;
        };

        let m = int128::new(m, false);
        new_with_value(int128::multiply(v, m), decimal)
    }

    // reduce tries to remove trailing 0s from the value and reduce the decimal.
    public fun reduce(d: &SDecimal128): SDecimal128 {
        if (is_zero(d)) {
            new(0, false, 0)
        } else {
            let v = get_value_abs(d);
            let i = get_decimal(d);
            while (i > 0) {
                if (v%10 == 0) {
                    i = i - 1;
                    v = v/10;
                } else {
                    break
                };
            };

            new(v, is_negative(d), i)
        }
    }

    public fun add(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::add(get_value(&x), get_value(&y)), dx))
    }

    public fun subtract(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::subtract(get_value(&x), get_value(&y)), dx))
    }

    public fun multiply(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let xv = get_value_abs(&x);
        let yv = get_value_abs(&y);
        let (lo, hi) = uint256::underlying_mul_with_carry(xv, yv);
        let vabs = uint256::new(hi, lo);
        let d = get_decimal(&x) + get_decimal(&y);
        let ten= uint256::new(0, 10);
        while (d > 0) {
            let (k, r) = uint256::divide_mod(vabs, ten);
            if (uint256::is_zero(&r)) {
                vabs = k;
                d = d - 1;
            } else {
                break
            };
        };

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        let is_negative = is_negative(&x) != is_negative(&y);

        new(uint256::lo(vabs), is_negative, d)
    }

    public fun divide(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let yv_abs = uint256::new(0, get_value_abs(&y));
        let xv_abs = uint256::new(0, get_value_abs(&x));
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        let ten = uint256::new(0, 10);
        let precision = if (dx > PRECISION) {
            0
        } else {
            PRECISION - dx
        };

        let ed = 0;

        while (ed < dy || ed < precision) {
            xv_abs = uint256::multiply(xv_abs, ten);
            ed = ed + 1;
        };

        let vabs = uint256::divide(xv_abs, yv_abs);

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        new(uint256::lo(vabs), is_negative(&x) != is_negative(&y), dx + ed - dy)
    }

    public fun divide_mod(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        let d = divide(x, y);
        let r = subtract(x, multiply(d, y));
        (d, r)
    }

    public fun mod(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let (_, r) = divide_mod(x, y);
        r
    }


    #[test]
    fun test_decimal128_p16() {
        let c = new(1800, false, 0);
        let d = new(3600, false, 0);
        let r = divide(c, d);
        assert!(equal(r, new(5, false, 1)), (r.decimal as u64));

        let c = new(5, false, 1);
        let d = new(2, true, 2);
        let r = multiply(c, d);
        assert!(equal(r, new(10, true, 3)), (r.decimal as u64))
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: signed-decimal -t
// Version: v1.2.6
module more_math::signed_decimal128_p18 {
    use more_math::uint256;
    use more_math::int128::{Self, Int128};


    const E_INVALID_DECIMAL: u64 = 1001;
    const E_OVERFLOW: u64 = 1002;


    const PRECISION: u8 = 18;

    struct SDecimal128 has store, copy, drop {
        value: Int128,
        decimal: u8,
    }

    public fun get_decimal(d: &SDecimal128): u8 {
        d.decimal
    }

    public fun is_zero(d: &SDecimal128): bool {
        int128::is_zero(d.value)
    }

    public fun equalize_decimal(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        if (x.decimal > y.decimal) {
            y = raise_decimal(&y, x.decimal);
        } else if (x.decimal < y.decimal) {
            x = raise_decimal(&x, y.decimal);
        };
        (x, y)
    }

    public fun equal(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::equal(x.value, y.value)
    }

    public fun greater(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::greater(x.value, y.value)
    }

    public fun less(x: SDecimal128, y: SDecimal128): bool {
        let (x, y) = equalize_decimal(x, y);
        int128::less(x.value, y.value)
    }

    public fun new(abs: u128, negative: bool, decimal: u8): SDecimal128 {
        SDecimal128 {
            value: int128::new(abs, negative),
            decimal,
        }
    }

    public fun new_with_value(value: Int128, decimal: u8): SDecimal128 {
        SDecimal128 {
            value,
            decimal,
        }
    }

    public fun get_value(d: &SDecimal128): Int128 {
        d.value
    }

    public fun get_value_abs(d: &SDecimal128): u128 {
        int128::abs(d.value)
    }

    public fun is_negative(d: &SDecimal128): bool {
        int128::is_negative(d.value)
    }

    public fun lower_decimal(d: &SDecimal128, decimal: u8): (SDecimal128, SDecimal128) {
        let v = get_value(d);
        let current_decimal = get_decimal(d);

        assert!(
            current_decimal > decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i > decimal) {
            m = m * 10;
            i = i - 1;
        };

        let m = int128::new(m, false);

        (
            new_with_value(int128::divide(v, m), decimal),
            new_with_value(int128::mod(v, m), current_decimal)
        )
    }

    public fun raise_decimal(d: &SDecimal128, decimal: u8): SDecimal128 {
        let v = get_value(d);
        let current_decimal =  get_decimal(d);
        assert!(
            current_decimal < decimal,
            E_INVALID_DECIMAL
        );

        let m: u128 = 1;
        let i = current_decimal;
        while (i < decimal) {
            m = m * 10;
            i = i + 1;
        };

        let m = int128::new(m, false);
        new_with_value(int128::multiply(v, m), decimal)
    }

    // reduce tries to remove trailing 0s from the value and reduce the decimal.
    public fun reduce(d: &SDecimal128): SDecimal128 {
        if (is_zero(d)) {
            new(0, false, 0)
        } else {
            let v = get_value_abs(d);
            let i = get_decimal(d);
            while (i > 0) {
                if (v%10 == 0) {
                    i = i - 1;
                    v = v/10;
                } else {
                    break
                };
            };

            new(v, is_negative(d), i)
        }
    }

    public fun add(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::add(get_value(&x), get_value(&y)), dx))
    }

    public fun subtract(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        if (dx > dy) {
            y = raise_decimal(&y, dx);
        } else if (dy > dx) {
            x = raise_decimal(&x, dy);
            dx = dy;
        };

        reduce(&new_with_value(int128::subtract(get_value(&x), get_value(&y)), dx))
    }

    public fun multiply(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let xv = get_value_abs(&x);
        let yv = get_value_abs(&y);
        let (lo, hi) = uint256::underlying_mul_with_carry(xv, yv);
        let vabs = uint256::new(hi, lo);
        let d = get_decimal(&x) + get_decimal(&y);
        let ten= uint256::new(0, 10);
        while (d > 0) {
            let (k, r) = uint256::divide_mod(vabs, ten);
            if (uint256::is_zero(&r)) {
                vabs = k;
                d = d - 1;
            } else {
                break
            };
        };

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        let is_negative = is_negative(&x) != is_negative(&y);

        new(uint256::lo(vabs), is_negative, d)
    }

    public fun divide(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let yv_abs = uint256::new(0, get_value_abs(&y));
        let xv_abs = uint256::new(0, get_value_abs(&x));
        let dx = get_decimal(&x);
        let dy = get_decimal(&y);
        let ten = uint256::new(0, 10);
        let precision = if (dx > PRECISION) {
            0
        } else {
            PRECISION - dx
        };

        let ed = 0;

        while (ed < dy || ed < precision) {
            xv_abs = uint256::multiply(xv_abs, ten);
            ed = ed + 1;
        };

        let vabs = uint256::divide(xv_abs, yv_abs);

        assert!(
            uint256::hi(vabs) == 0,
            E_OVERFLOW
        );

        new(uint256::lo(vabs), is_negative(&x) != is_negative(&y), dx + ed - dy)
    }

    public fun divide_mod(x: SDecimal128, y: SDecimal128): (SDecimal128, SDecimal128) {
        let d = divide(x, y);
        let r = subtract(x, multiply(d, y));
        (d, r)
    }

    public fun mod(x: SDecimal128, y: SDecimal128): SDecimal128 {
        let (_, r) = divide_mod(x, y);
        r
    }


    #[test]
    fun test_decimal128_p18() {
        let c = new(1800, false, 0);
        let d = new(3600, false, 0);
        let r = divide(c, d);
        assert!(equal(r, new(5, false, 1)), (r.decimal as u64));

        let c = new(5, false, 1);
        let d = new(2, true, 2);
        let r = multiply(c, d);
        assert!(equal(r, new(10, true, 3)), (r.decimal as u64))
    }
}
