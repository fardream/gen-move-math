// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: double-width
// Version: v1.4.0
module more_math::uint16 {
    struct Uint16 has store, copy, drop {
        hi: u8,
        lo: u8,
    }

    // MAX_SHIFT is desired width - 1.
    // It looks like move's shift size must be in u8, which has a max of 255.
    const MAX_SHIFT: u8 = 15;
    const UNDERLYING_SIZE: u8 = 8;
    const UNDERLYING_HALF_SIZE: u8 = 4;
    const UNDERLYING_HALF_POINT: u8 = 128;
    const UNDERLYING_LOWER_ONES: u8 = 15;
    const UNDERLYING_UPPER_ONES: u8 = 240;
    const UNDERLYING_ONES: u8 = 255;

    const E_OVERFLOW: u64 = 1001;
    const E_DIVISION_BY_ZERO: u64 = 1002;

    /// new creates a new Uint16
    public fun new(hi: u8, lo: u8): Uint16 {
        Uint16 {
            hi, lo,
        }
    }

    /// create a new zero value of the Uint16
    public fun zero(): Uint16 {
        Uint16 {
            hi: 0,
            lo: 0,
        }
    }

    /// checks if the value is zero.
    public fun is_zero(x: &Uint16): bool {
        x.hi == 0 && x.lo == 0
    }

    /// equal
    public fun equal(x: Uint16, y: Uint16): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    /// greater
    public fun greater(x: Uint16, y: Uint16): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    /// greater_or_equal
    public fun greater_or_equal(x: Uint16, y: Uint16): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo >= y.lo))
    }

    /// less
    public fun less(x: Uint16, y: Uint16): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    /// less_or_equal
    public fun less_or_equal(x: Uint16, y: Uint16): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo <= y.lo))
    }

    /// add two underlying with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u8, y: u8):(u8, u8) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u8, y:u8): (u8, u8) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u8, y: u8, carry: u8): u8 {
        x + y + carry // will abort if overflow
    }

    /// subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u8, y: u8, borrow: u8): u8 {
        x - y - borrow // will abort if underflow
    }

    /// add x and y, abort if overflows
    public fun add(x: Uint16, y: Uint16): Uint16 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint16 {
            hi,
            lo,
        }
    }

    /// add u8 to Uint16
    public fun add_underlying(x:Uint16, y: u8): Uint16 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint16 {
            lo,
            hi: x.hi + carry,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract(x: Uint16, y: Uint16): Uint16 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint16 {
            hi,
            lo,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract_underlying(x: Uint16, y: u8): Uint16 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y);
        let hi = x.hi - b;
        Uint16 {
            hi,
            lo,
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun underlying_mul_with_carry(x: u8, y: u8):(u8, u8) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let xl = x & UNDERLYING_LOWER_ONES;
        let yh = (y & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let yl = y & UNDERLYING_LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = underlying_add_with_carry(xl * yl, (xhyl & UNDERLYING_LOWER_ONES) << UNDERLYING_HALF_SIZE);
        let (lo, lo_carry_2) = underlying_add_with_carry(lo, (xlyh & UNDERLYING_LOWER_ONES)<< UNDERLYING_HALF_SIZE);
        let hi = xh * yh + (xhyl >> UNDERLYING_HALF_SIZE) + (xlyh >> UNDERLYING_HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    public fun underlying_mul_to_uint16(x: u8, y: u8): Uint16{
        let (lo, hi) = underlying_mul_with_carry(x, y);
        new(hi, lo)
    }

    /// x * y, abort if overflow
    public fun multiply(x: Uint16, y: Uint16): Uint16 {
        assert!(x.hi == 0 || y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint16 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    /// x * y where y is u8
    public fun multiply_underlying(x: Uint16, y: u8): Uint16 {
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y);
        Uint16 {
            lo: xlyl,
            hi: x.hi * y + xlyl_carry,
        }
    }

    /// left shift, abort if shift is greater than the size of the int.
    public fun lsh(x: Uint16, y: u8): Uint16 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint16 {
                hi: x.lo << (y - UNDERLYING_SIZE),
                lo: 0,
            }
        } else if (y == 0) {
            copy x
        } else {
            Uint16 {
                hi: (x.hi << y) + (x.lo >> (UNDERLYING_SIZE - y)),
                lo: x.lo << y,
            }
        }
    }

    /// right shift, abort if shift is greater than the size of the int
    public fun rsh(x: Uint16, y: u8): Uint16 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint16 {
                hi: 0,
                lo: x.hi >> (y - UNDERLYING_SIZE),
            }
        } else if (y==0) {
            copy x
        } else {
            Uint16 {
                hi: x.hi >> y,
                lo: (x.lo >> y) + (x.hi << (UNDERLYING_SIZE-y)),
            }
        }
    }

    /// count leading zeros of the underlying type u8
    public fun underlying_leading_zeros(x: u8): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            if (x & 240 == 0) {
                // x's higher 4 is all zero, shift the lower part over
                x = x << 4;
                n = n + 4;
            };
            if (x & 192 == 0) {
                // x's higher 2 is all zero, shift the lower part over
                x = x << 2;
                n = n + 2;
            };
            if (x & 128 == 0) {
                n = n + 1;
            };

            n
        }
    }

    /// get number leading zeros
    public fun leading_zeros(x: Uint16): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    /// divide_mod returns x/y and x%y
    public fun divide_mod(x: Uint16, y: Uint16): (Uint16, Uint16) {
        assert!(y.hi != 0 || y.lo != 0, E_DIVISION_BY_ZERO);
        if (greater(y, x)) {
            (zero(), copy x)
        } else if (equal(x, y)){
            (new(0,1), zero())
        } else if (x.hi == 0 && y.hi == 0) {
            (new(0, x.lo/y.lo), new(0,x.lo%y.lo))
        } else {
            let n_x = leading_zeros(x);
            let n_y = leading_zeros(y);
            // x is greater than y, so this cannot happen
            // assert!(n_x <= n_y, 1);

            let shift = n_y - n_x;
            let current = lsh(y, shift);
            let remainder = copy x;

            let result = new(0,0);

            loop {
                if (!less(remainder, current)) {
                    remainder = subtract(remainder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, remainder)
        }
    }

    /// divide returns x/y
    public fun divide(x: Uint16, y: Uint16): Uint16 {
        let (r, _) = divide_mod(x, y);
        r
    }

    /// mod returns x%y
    public fun mod(x: Uint16, y: Uint16): Uint16 {
        let (_, r) = divide_mod(x, y);
        r
    }

    /// divide_mod_underlying returns x/y and x%y, where y is u8.
    public fun divide_mod_underlying(x: Uint16, y: u8): (Uint16, u8) {
        let (result, remainder) = divide_mod(x, new(0, y));
        (result, downcast(remainder))
    }

    /// divide underlying returns x/y, where y is u8
    public fun divide_underlying(x: Uint16, y: u8): Uint16 {
        let (result, _) = divide_mod(x, new(0, y));
        result
    }

    /// hi component of the value.
    public fun hi(x: Uint16): u8 {
        x.hi
    }

    /// lo component of the value
    public fun lo(x: Uint16): u8 {
        x.lo
    }

    public fun bitwise_and(x: Uint16, y: Uint16): Uint16 {
        Uint16 {
            hi: x.hi & y.hi,
            lo: x.lo & y.lo,
        }
    }

    public fun bitwise_or(x: Uint16, y: Uint16): Uint16 {
        Uint16 {
            hi: x.hi | y.hi,
            lo: x.lo | y.lo,
        }
    }

    public fun bitwise_xor(x: Uint16, y: Uint16): Uint16 {
        Uint16 {
            hi: x.hi ^ y.hi,
            lo: x.lo ^ y.lo,
        }
    }

    /// Indicate the value will overflow if converted to underlying type.
    public fun underlying_overflow(x: Uint16): bool {
        x.hi != 0
    }

    /// downcast converts Uint16 to u8. abort if overflow.
    public fun downcast(x: Uint16): u8 {
        assert!(
            !underlying_overflow(x),
            E_OVERFLOW,
        );

        x.lo
    }

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: Uint16): Uint16 {
        if (x.hi == 0 && x.lo == 0) {
            Uint16 { hi: 0, lo: 0}
        } else if (x.hi == 0 && x.lo <= 3) {
            Uint16 { hi: 0, lo: 1}
        } else {
            let n = (255 - leading_zeros(x)) >> 1;
            let z = rsh(x, n);
            let z_next = rsh(add(z, divide(x, z)), 1);
            while (less(z_next, z)) {
                z = z_next;
                z_next = rsh(add(z, divide(x, z)), 1);
            };
            z
        }
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: double-width
// Version: v1.4.0
module more_math::uint32 {
    struct Uint32 has store, copy, drop {
        hi: u16,
        lo: u16,
    }

    // MAX_SHIFT is desired width - 1.
    // It looks like move's shift size must be in u8, which has a max of 255.
    const MAX_SHIFT: u8 = 31;
    const UNDERLYING_SIZE: u8 = 16;
    const UNDERLYING_HALF_SIZE: u8 = 8;
    const UNDERLYING_HALF_POINT: u16 = 32768;
    const UNDERLYING_LOWER_ONES: u16 = 255;
    const UNDERLYING_UPPER_ONES: u16 = 65280;
    const UNDERLYING_ONES: u16 = 65535;

    const E_OVERFLOW: u64 = 1001;
    const E_DIVISION_BY_ZERO: u64 = 1002;

    /// new creates a new Uint32
    public fun new(hi: u16, lo: u16): Uint32 {
        Uint32 {
            hi, lo,
        }
    }

    /// create a new zero value of the Uint32
    public fun zero(): Uint32 {
        Uint32 {
            hi: 0,
            lo: 0,
        }
    }

    /// checks if the value is zero.
    public fun is_zero(x: &Uint32): bool {
        x.hi == 0 && x.lo == 0
    }

    /// equal
    public fun equal(x: Uint32, y: Uint32): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    /// greater
    public fun greater(x: Uint32, y: Uint32): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    /// greater_or_equal
    public fun greater_or_equal(x: Uint32, y: Uint32): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo >= y.lo))
    }

    /// less
    public fun less(x: Uint32, y: Uint32): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    /// less_or_equal
    public fun less_or_equal(x: Uint32, y: Uint32): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo <= y.lo))
    }

    /// add two underlying with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u16, y: u16):(u16, u16) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u16, y:u16): (u16, u16) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u16, y: u16, carry: u16): u16 {
        x + y + carry // will abort if overflow
    }

    /// subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u16, y: u16, borrow: u16): u16 {
        x - y - borrow // will abort if underflow
    }

    /// add x and y, abort if overflows
    public fun add(x: Uint32, y: Uint32): Uint32 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint32 {
            hi,
            lo,
        }
    }

    /// add u16 to Uint32
    public fun add_underlying(x:Uint32, y: u16): Uint32 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint32 {
            lo,
            hi: x.hi + carry,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract(x: Uint32, y: Uint32): Uint32 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint32 {
            hi,
            lo,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract_underlying(x: Uint32, y: u16): Uint32 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y);
        let hi = x.hi - b;
        Uint32 {
            hi,
            lo,
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun underlying_mul_with_carry(x: u16, y: u16):(u16, u16) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let xl = x & UNDERLYING_LOWER_ONES;
        let yh = (y & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let yl = y & UNDERLYING_LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = underlying_add_with_carry(xl * yl, (xhyl & UNDERLYING_LOWER_ONES) << UNDERLYING_HALF_SIZE);
        let (lo, lo_carry_2) = underlying_add_with_carry(lo, (xlyh & UNDERLYING_LOWER_ONES)<< UNDERLYING_HALF_SIZE);
        let hi = xh * yh + (xhyl >> UNDERLYING_HALF_SIZE) + (xlyh >> UNDERLYING_HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    public fun underlying_mul_to_uint32(x: u16, y: u16): Uint32{
        let (lo, hi) = underlying_mul_with_carry(x, y);
        new(hi, lo)
    }

    /// x * y, abort if overflow
    public fun multiply(x: Uint32, y: Uint32): Uint32 {
        assert!(x.hi == 0 || y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint32 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    /// x * y where y is u16
    public fun multiply_underlying(x: Uint32, y: u16): Uint32 {
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y);
        Uint32 {
            lo: xlyl,
            hi: x.hi * y + xlyl_carry,
        }
    }

    /// left shift, abort if shift is greater than the size of the int.
    public fun lsh(x: Uint32, y: u8): Uint32 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint32 {
                hi: x.lo << (y - UNDERLYING_SIZE),
                lo: 0,
            }
        } else if (y == 0) {
            copy x
        } else {
            Uint32 {
                hi: (x.hi << y) + (x.lo >> (UNDERLYING_SIZE - y)),
                lo: x.lo << y,
            }
        }
    }

    /// right shift, abort if shift is greater than the size of the int
    public fun rsh(x: Uint32, y: u8): Uint32 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint32 {
                hi: 0,
                lo: x.hi >> (y - UNDERLYING_SIZE),
            }
        } else if (y==0) {
            copy x
        } else {
            Uint32 {
                hi: x.hi >> y,
                lo: (x.lo >> y) + (x.hi << (UNDERLYING_SIZE-y)),
            }
        }
    }

    /// count leading zeros of the underlying type u16
    public fun underlying_leading_zeros(x: u16): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            if (x & 65280 == 0) {
                // x's higher 8 is all zero, shift the lower part over
                x = x << 8;
                n = n + 8;
            };
            if (x & 61440 == 0) {
                // x's higher 4 is all zero, shift the lower part over
                x = x << 4;
                n = n + 4;
            };
            if (x & 49152 == 0) {
                // x's higher 2 is all zero, shift the lower part over
                x = x << 2;
                n = n + 2;
            };
            if (x & 32768 == 0) {
                n = n + 1;
            };

            n
        }
    }

    /// get number leading zeros
    public fun leading_zeros(x: Uint32): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    /// divide_mod returns x/y and x%y
    public fun divide_mod(x: Uint32, y: Uint32): (Uint32, Uint32) {
        assert!(y.hi != 0 || y.lo != 0, E_DIVISION_BY_ZERO);
        if (greater(y, x)) {
            (zero(), copy x)
        } else if (equal(x, y)){
            (new(0,1), zero())
        } else if (x.hi == 0 && y.hi == 0) {
            (new(0, x.lo/y.lo), new(0,x.lo%y.lo))
        } else {
            let n_x = leading_zeros(x);
            let n_y = leading_zeros(y);
            // x is greater than y, so this cannot happen
            // assert!(n_x <= n_y, 1);

            let shift = n_y - n_x;
            let current = lsh(y, shift);
            let remainder = copy x;

            let result = new(0,0);

            loop {
                if (!less(remainder, current)) {
                    remainder = subtract(remainder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, remainder)
        }
    }

    /// divide returns x/y
    public fun divide(x: Uint32, y: Uint32): Uint32 {
        let (r, _) = divide_mod(x, y);
        r
    }

    /// mod returns x%y
    public fun mod(x: Uint32, y: Uint32): Uint32 {
        let (_, r) = divide_mod(x, y);
        r
    }

    /// divide_mod_underlying returns x/y and x%y, where y is u16.
    public fun divide_mod_underlying(x: Uint32, y: u16): (Uint32, u16) {
        let (result, remainder) = divide_mod(x, new(0, y));
        (result, downcast(remainder))
    }

    /// divide underlying returns x/y, where y is u16
    public fun divide_underlying(x: Uint32, y: u16): Uint32 {
        let (result, _) = divide_mod(x, new(0, y));
        result
    }

    /// hi component of the value.
    public fun hi(x: Uint32): u16 {
        x.hi
    }

    /// lo component of the value
    public fun lo(x: Uint32): u16 {
        x.lo
    }

    public fun bitwise_and(x: Uint32, y: Uint32): Uint32 {
        Uint32 {
            hi: x.hi & y.hi,
            lo: x.lo & y.lo,
        }
    }

    public fun bitwise_or(x: Uint32, y: Uint32): Uint32 {
        Uint32 {
            hi: x.hi | y.hi,
            lo: x.lo | y.lo,
        }
    }

    public fun bitwise_xor(x: Uint32, y: Uint32): Uint32 {
        Uint32 {
            hi: x.hi ^ y.hi,
            lo: x.lo ^ y.lo,
        }
    }

    /// Indicate the value will overflow if converted to underlying type.
    public fun underlying_overflow(x: Uint32): bool {
        x.hi != 0
    }

    /// downcast converts Uint32 to u16. abort if overflow.
    public fun downcast(x: Uint32): u16 {
        assert!(
            !underlying_overflow(x),
            E_OVERFLOW,
        );

        x.lo
    }

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: Uint32): Uint32 {
        if (x.hi == 0 && x.lo == 0) {
            Uint32 { hi: 0, lo: 0}
        } else if (x.hi == 0 && x.lo <= 3) {
            Uint32 { hi: 0, lo: 1}
        } else {
            let n = (255 - leading_zeros(x)) >> 1;
            let z = rsh(x, n);
            let z_next = rsh(add(z, divide(x, z)), 1);
            while (less(z_next, z)) {
                z = z_next;
                z_next = rsh(add(z, divide(x, z)), 1);
            };
            z
        }
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: double-width
// Version: v1.4.0
module more_math::uint64 {
    struct Uint64 has store, copy, drop {
        hi: u32,
        lo: u32,
    }

    // MAX_SHIFT is desired width - 1.
    // It looks like move's shift size must be in u8, which has a max of 255.
    const MAX_SHIFT: u8 = 63;
    const UNDERLYING_SIZE: u8 = 32;
    const UNDERLYING_HALF_SIZE: u8 = 16;
    const UNDERLYING_HALF_POINT: u32 = 2147483648;
    const UNDERLYING_LOWER_ONES: u32 = 65535;
    const UNDERLYING_UPPER_ONES: u32 = 4294901760;
    const UNDERLYING_ONES: u32 = 4294967295;

    const E_OVERFLOW: u64 = 1001;
    const E_DIVISION_BY_ZERO: u64 = 1002;

    /// new creates a new Uint64
    public fun new(hi: u32, lo: u32): Uint64 {
        Uint64 {
            hi, lo,
        }
    }

    /// create a new zero value of the Uint64
    public fun zero(): Uint64 {
        Uint64 {
            hi: 0,
            lo: 0,
        }
    }

    /// checks if the value is zero.
    public fun is_zero(x: &Uint64): bool {
        x.hi == 0 && x.lo == 0
    }

    /// equal
    public fun equal(x: Uint64, y: Uint64): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    /// greater
    public fun greater(x: Uint64, y: Uint64): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    /// greater_or_equal
    public fun greater_or_equal(x: Uint64, y: Uint64): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo >= y.lo))
    }

    /// less
    public fun less(x: Uint64, y: Uint64): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    /// less_or_equal
    public fun less_or_equal(x: Uint64, y: Uint64): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo <= y.lo))
    }

    /// add two underlying with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u32, y: u32):(u32, u32) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u32, y:u32): (u32, u32) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u32, y: u32, carry: u32): u32 {
        x + y + carry // will abort if overflow
    }

    /// subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u32, y: u32, borrow: u32): u32 {
        x - y - borrow // will abort if underflow
    }

    /// add x and y, abort if overflows
    public fun add(x: Uint64, y: Uint64): Uint64 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint64 {
            hi,
            lo,
        }
    }

    /// add u32 to Uint64
    public fun add_underlying(x:Uint64, y: u32): Uint64 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint64 {
            lo,
            hi: x.hi + carry,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract(x: Uint64, y: Uint64): Uint64 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint64 {
            hi,
            lo,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract_underlying(x: Uint64, y: u32): Uint64 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y);
        let hi = x.hi - b;
        Uint64 {
            hi,
            lo,
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun underlying_mul_with_carry(x: u32, y: u32):(u32, u32) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let xl = x & UNDERLYING_LOWER_ONES;
        let yh = (y & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let yl = y & UNDERLYING_LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = underlying_add_with_carry(xl * yl, (xhyl & UNDERLYING_LOWER_ONES) << UNDERLYING_HALF_SIZE);
        let (lo, lo_carry_2) = underlying_add_with_carry(lo, (xlyh & UNDERLYING_LOWER_ONES)<< UNDERLYING_HALF_SIZE);
        let hi = xh * yh + (xhyl >> UNDERLYING_HALF_SIZE) + (xlyh >> UNDERLYING_HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    public fun underlying_mul_to_uint64(x: u32, y: u32): Uint64{
        let (lo, hi) = underlying_mul_with_carry(x, y);
        new(hi, lo)
    }

    /// x * y, abort if overflow
    public fun multiply(x: Uint64, y: Uint64): Uint64 {
        assert!(x.hi == 0 || y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint64 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    /// x * y where y is u32
    public fun multiply_underlying(x: Uint64, y: u32): Uint64 {
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y);
        Uint64 {
            lo: xlyl,
            hi: x.hi * y + xlyl_carry,
        }
    }

    /// left shift, abort if shift is greater than the size of the int.
    public fun lsh(x: Uint64, y: u8): Uint64 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint64 {
                hi: x.lo << (y - UNDERLYING_SIZE),
                lo: 0,
            }
        } else if (y == 0) {
            copy x
        } else {
            Uint64 {
                hi: (x.hi << y) + (x.lo >> (UNDERLYING_SIZE - y)),
                lo: x.lo << y,
            }
        }
    }

    /// right shift, abort if shift is greater than the size of the int
    public fun rsh(x: Uint64, y: u8): Uint64 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint64 {
                hi: 0,
                lo: x.hi >> (y - UNDERLYING_SIZE),
            }
        } else if (y==0) {
            copy x
        } else {
            Uint64 {
                hi: x.hi >> y,
                lo: (x.lo >> y) + (x.hi << (UNDERLYING_SIZE-y)),
            }
        }
    }

    /// count leading zeros of the underlying type u32
    public fun underlying_leading_zeros(x: u32): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            if (x & 4294901760 == 0) {
                // x's higher 16 is all zero, shift the lower part over
                x = x << 16;
                n = n + 16;
            };
            if (x & 4278190080 == 0) {
                // x's higher 8 is all zero, shift the lower part over
                x = x << 8;
                n = n + 8;
            };
            if (x & 4026531840 == 0) {
                // x's higher 4 is all zero, shift the lower part over
                x = x << 4;
                n = n + 4;
            };
            if (x & 3221225472 == 0) {
                // x's higher 2 is all zero, shift the lower part over
                x = x << 2;
                n = n + 2;
            };
            if (x & 2147483648 == 0) {
                n = n + 1;
            };

            n
        }
    }

    /// get number leading zeros
    public fun leading_zeros(x: Uint64): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    /// divide_mod returns x/y and x%y
    public fun divide_mod(x: Uint64, y: Uint64): (Uint64, Uint64) {
        assert!(y.hi != 0 || y.lo != 0, E_DIVISION_BY_ZERO);
        if (greater(y, x)) {
            (zero(), copy x)
        } else if (equal(x, y)){
            (new(0,1), zero())
        } else if (x.hi == 0 && y.hi == 0) {
            (new(0, x.lo/y.lo), new(0,x.lo%y.lo))
        } else {
            let n_x = leading_zeros(x);
            let n_y = leading_zeros(y);
            // x is greater than y, so this cannot happen
            // assert!(n_x <= n_y, 1);

            let shift = n_y - n_x;
            let current = lsh(y, shift);
            let remainder = copy x;

            let result = new(0,0);

            loop {
                if (!less(remainder, current)) {
                    remainder = subtract(remainder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, remainder)
        }
    }

    /// divide returns x/y
    public fun divide(x: Uint64, y: Uint64): Uint64 {
        let (r, _) = divide_mod(x, y);
        r
    }

    /// mod returns x%y
    public fun mod(x: Uint64, y: Uint64): Uint64 {
        let (_, r) = divide_mod(x, y);
        r
    }

    /// divide_mod_underlying returns x/y and x%y, where y is u32.
    public fun divide_mod_underlying(x: Uint64, y: u32): (Uint64, u32) {
        let (result, remainder) = divide_mod(x, new(0, y));
        (result, downcast(remainder))
    }

    /// divide underlying returns x/y, where y is u32
    public fun divide_underlying(x: Uint64, y: u32): Uint64 {
        let (result, _) = divide_mod(x, new(0, y));
        result
    }

    /// hi component of the value.
    public fun hi(x: Uint64): u32 {
        x.hi
    }

    /// lo component of the value
    public fun lo(x: Uint64): u32 {
        x.lo
    }

    public fun bitwise_and(x: Uint64, y: Uint64): Uint64 {
        Uint64 {
            hi: x.hi & y.hi,
            lo: x.lo & y.lo,
        }
    }

    public fun bitwise_or(x: Uint64, y: Uint64): Uint64 {
        Uint64 {
            hi: x.hi | y.hi,
            lo: x.lo | y.lo,
        }
    }

    public fun bitwise_xor(x: Uint64, y: Uint64): Uint64 {
        Uint64 {
            hi: x.hi ^ y.hi,
            lo: x.lo ^ y.lo,
        }
    }

    /// Indicate the value will overflow if converted to underlying type.
    public fun underlying_overflow(x: Uint64): bool {
        x.hi != 0
    }

    /// downcast converts Uint64 to u32. abort if overflow.
    public fun downcast(x: Uint64): u32 {
        assert!(
            !underlying_overflow(x),
            E_OVERFLOW,
        );

        x.lo
    }

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: Uint64): Uint64 {
        if (x.hi == 0 && x.lo == 0) {
            Uint64 { hi: 0, lo: 0}
        } else if (x.hi == 0 && x.lo <= 3) {
            Uint64 { hi: 0, lo: 1}
        } else {
            let n = (255 - leading_zeros(x)) >> 1;
            let z = rsh(x, n);
            let z_next = rsh(add(z, divide(x, z)), 1);
            while (less(z_next, z)) {
                z = z_next;
                z_next = rsh(add(z, divide(x, z)), 1);
            };
            z
        }
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: double-width
// Version: v1.4.0
module more_math::uint128 {
    struct Uint128 has store, copy, drop {
        hi: u64,
        lo: u64,
    }

    // MAX_SHIFT is desired width - 1.
    // It looks like move's shift size must be in u8, which has a max of 255.
    const MAX_SHIFT: u8 = 127;
    const UNDERLYING_SIZE: u8 = 64;
    const UNDERLYING_HALF_SIZE: u8 = 32;
    const UNDERLYING_HALF_POINT: u64 = 9223372036854775808;
    const UNDERLYING_LOWER_ONES: u64 = 4294967295;
    const UNDERLYING_UPPER_ONES: u64 = 18446744069414584320;
    const UNDERLYING_ONES: u64 = 18446744073709551615;

    const E_OVERFLOW: u64 = 1001;
    const E_DIVISION_BY_ZERO: u64 = 1002;

    /// new creates a new Uint128
    public fun new(hi: u64, lo: u64): Uint128 {
        Uint128 {
            hi, lo,
        }
    }

    /// create a new zero value of the Uint128
    public fun zero(): Uint128 {
        Uint128 {
            hi: 0,
            lo: 0,
        }
    }

    /// checks if the value is zero.
    public fun is_zero(x: &Uint128): bool {
        x.hi == 0 && x.lo == 0
    }

    /// equal
    public fun equal(x: Uint128, y: Uint128): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    /// greater
    public fun greater(x: Uint128, y: Uint128): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    /// greater_or_equal
    public fun greater_or_equal(x: Uint128, y: Uint128): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo >= y.lo))
    }

    /// less
    public fun less(x: Uint128, y: Uint128): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    /// less_or_equal
    public fun less_or_equal(x: Uint128, y: Uint128): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo <= y.lo))
    }

    /// add two underlying with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u64, y: u64):(u64, u64) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u64, y:u64): (u64, u64) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u64, y: u64, carry: u64): u64 {
        x + y + carry // will abort if overflow
    }

    /// subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u64, y: u64, borrow: u64): u64 {
        x - y - borrow // will abort if underflow
    }

    /// add x and y, abort if overflows
    public fun add(x: Uint128, y: Uint128): Uint128 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint128 {
            hi,
            lo,
        }
    }

    /// add u64 to Uint128
    public fun add_underlying(x:Uint128, y: u64): Uint128 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint128 {
            lo,
            hi: x.hi + carry,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract(x: Uint128, y: Uint128): Uint128 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint128 {
            hi,
            lo,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract_underlying(x: Uint128, y: u64): Uint128 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y);
        let hi = x.hi - b;
        Uint128 {
            hi,
            lo,
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun underlying_mul_with_carry(x: u64, y: u64):(u64, u64) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let xl = x & UNDERLYING_LOWER_ONES;
        let yh = (y & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let yl = y & UNDERLYING_LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = underlying_add_with_carry(xl * yl, (xhyl & UNDERLYING_LOWER_ONES) << UNDERLYING_HALF_SIZE);
        let (lo, lo_carry_2) = underlying_add_with_carry(lo, (xlyh & UNDERLYING_LOWER_ONES)<< UNDERLYING_HALF_SIZE);
        let hi = xh * yh + (xhyl >> UNDERLYING_HALF_SIZE) + (xlyh >> UNDERLYING_HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    public fun underlying_mul_to_uint128(x: u64, y: u64): Uint128{
        let (lo, hi) = underlying_mul_with_carry(x, y);
        new(hi, lo)
    }

    /// x * y, abort if overflow
    public fun multiply(x: Uint128, y: Uint128): Uint128 {
        assert!(x.hi == 0 || y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint128 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    /// x * y where y is u64
    public fun multiply_underlying(x: Uint128, y: u64): Uint128 {
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y);
        Uint128 {
            lo: xlyl,
            hi: x.hi * y + xlyl_carry,
        }
    }

    /// left shift, abort if shift is greater than the size of the int.
    public fun lsh(x: Uint128, y: u8): Uint128 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint128 {
                hi: x.lo << (y - UNDERLYING_SIZE),
                lo: 0,
            }
        } else if (y == 0) {
            copy x
        } else {
            Uint128 {
                hi: (x.hi << y) + (x.lo >> (UNDERLYING_SIZE - y)),
                lo: x.lo << y,
            }
        }
    }

    /// right shift, abort if shift is greater than the size of the int
    public fun rsh(x: Uint128, y: u8): Uint128 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint128 {
                hi: 0,
                lo: x.hi >> (y - UNDERLYING_SIZE),
            }
        } else if (y==0) {
            copy x
        } else {
            Uint128 {
                hi: x.hi >> y,
                lo: (x.lo >> y) + (x.hi << (UNDERLYING_SIZE-y)),
            }
        }
    }

    /// count leading zeros of the underlying type u64
    public fun underlying_leading_zeros(x: u64): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            if (x & 18446744069414584320 == 0) {
                // x's higher 32 is all zero, shift the lower part over
                x = x << 32;
                n = n + 32;
            };
            if (x & 18446462598732840960 == 0) {
                // x's higher 16 is all zero, shift the lower part over
                x = x << 16;
                n = n + 16;
            };
            if (x & 18374686479671623680 == 0) {
                // x's higher 8 is all zero, shift the lower part over
                x = x << 8;
                n = n + 8;
            };
            if (x & 17293822569102704640 == 0) {
                // x's higher 4 is all zero, shift the lower part over
                x = x << 4;
                n = n + 4;
            };
            if (x & 13835058055282163712 == 0) {
                // x's higher 2 is all zero, shift the lower part over
                x = x << 2;
                n = n + 2;
            };
            if (x & 9223372036854775808 == 0) {
                n = n + 1;
            };

            n
        }
    }

    /// get number leading zeros
    public fun leading_zeros(x: Uint128): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    /// divide_mod returns x/y and x%y
    public fun divide_mod(x: Uint128, y: Uint128): (Uint128, Uint128) {
        assert!(y.hi != 0 || y.lo != 0, E_DIVISION_BY_ZERO);
        if (greater(y, x)) {
            (zero(), copy x)
        } else if (equal(x, y)){
            (new(0,1), zero())
        } else if (x.hi == 0 && y.hi == 0) {
            (new(0, x.lo/y.lo), new(0,x.lo%y.lo))
        } else {
            let n_x = leading_zeros(x);
            let n_y = leading_zeros(y);
            // x is greater than y, so this cannot happen
            // assert!(n_x <= n_y, 1);

            let shift = n_y - n_x;
            let current = lsh(y, shift);
            let remainder = copy x;

            let result = new(0,0);

            loop {
                if (!less(remainder, current)) {
                    remainder = subtract(remainder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, remainder)
        }
    }

    /// divide returns x/y
    public fun divide(x: Uint128, y: Uint128): Uint128 {
        let (r, _) = divide_mod(x, y);
        r
    }

    /// mod returns x%y
    public fun mod(x: Uint128, y: Uint128): Uint128 {
        let (_, r) = divide_mod(x, y);
        r
    }

    /// divide_mod_underlying returns x/y and x%y, where y is u64.
    public fun divide_mod_underlying(x: Uint128, y: u64): (Uint128, u64) {
        let (result, remainder) = divide_mod(x, new(0, y));
        (result, downcast(remainder))
    }

    /// divide underlying returns x/y, where y is u64
    public fun divide_underlying(x: Uint128, y: u64): Uint128 {
        let (result, _) = divide_mod(x, new(0, y));
        result
    }

    /// hi component of the value.
    public fun hi(x: Uint128): u64 {
        x.hi
    }

    /// lo component of the value
    public fun lo(x: Uint128): u64 {
        x.lo
    }

    public fun bitwise_and(x: Uint128, y: Uint128): Uint128 {
        Uint128 {
            hi: x.hi & y.hi,
            lo: x.lo & y.lo,
        }
    }

    public fun bitwise_or(x: Uint128, y: Uint128): Uint128 {
        Uint128 {
            hi: x.hi | y.hi,
            lo: x.lo | y.lo,
        }
    }

    public fun bitwise_xor(x: Uint128, y: Uint128): Uint128 {
        Uint128 {
            hi: x.hi ^ y.hi,
            lo: x.lo ^ y.lo,
        }
    }

    /// Indicate the value will overflow if converted to underlying type.
    public fun underlying_overflow(x: Uint128): bool {
        x.hi != 0
    }

    /// downcast converts Uint128 to u64. abort if overflow.
    public fun downcast(x: Uint128): u64 {
        assert!(
            !underlying_overflow(x),
            E_OVERFLOW,
        );

        x.lo
    }

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: Uint128): Uint128 {
        if (x.hi == 0 && x.lo == 0) {
            Uint128 { hi: 0, lo: 0}
        } else if (x.hi == 0 && x.lo <= 3) {
            Uint128 { hi: 0, lo: 1}
        } else {
            let n = (255 - leading_zeros(x)) >> 1;
            let z = rsh(x, n);
            let z_next = rsh(add(z, divide(x, z)), 1);
            while (less(z_next, z)) {
                z = z_next;
                z_next = rsh(add(z, divide(x, z)), 1);
            };
            z
        }
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: double-width
// Version: v1.4.0
module more_math::uint256 {
    struct Uint256 has store, copy, drop {
        hi: u128,
        lo: u128,
    }

    // MAX_SHIFT is desired width - 1.
    // It looks like move's shift size must be in u8, which has a max of 255.
    const MAX_SHIFT: u8 = 255;
    const UNDERLYING_SIZE: u8 = 128;
    const UNDERLYING_HALF_SIZE: u8 = 64;
    const UNDERLYING_HALF_POINT: u128 = 170141183460469231731687303715884105728;
    const UNDERLYING_LOWER_ONES: u128 = 18446744073709551615;
    const UNDERLYING_UPPER_ONES: u128 = 340282366920938463444927863358058659840;
    const UNDERLYING_ONES: u128 = 340282366920938463463374607431768211455;

    const E_OVERFLOW: u64 = 1001;
    const E_DIVISION_BY_ZERO: u64 = 1002;

    /// new creates a new Uint256
    public fun new(hi: u128, lo: u128): Uint256 {
        Uint256 {
            hi, lo,
        }
    }

    /// create a new zero value of the Uint256
    public fun zero(): Uint256 {
        Uint256 {
            hi: 0,
            lo: 0,
        }
    }

    /// checks if the value is zero.
    public fun is_zero(x: &Uint256): bool {
        x.hi == 0 && x.lo == 0
    }

    /// equal
    public fun equal(x: Uint256, y: Uint256): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    /// greater
    public fun greater(x: Uint256, y: Uint256): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    /// greater_or_equal
    public fun greater_or_equal(x: Uint256, y: Uint256): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo >= y.lo))
    }

    /// less
    public fun less(x: Uint256, y: Uint256): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    /// less_or_equal
    public fun less_or_equal(x: Uint256, y: Uint256): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo <= y.lo))
    }

    /// add two underlying with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u128, y: u128):(u128, u128) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u128, y:u128): (u128, u128) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u128, y: u128, carry: u128): u128 {
        x + y + carry // will abort if overflow
    }

    /// subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u128, y: u128, borrow: u128): u128 {
        x - y - borrow // will abort if underflow
    }

    /// add x and y, abort if overflows
    public fun add(x: Uint256, y: Uint256): Uint256 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint256 {
            hi,
            lo,
        }
    }

    /// add u128 to Uint256
    public fun add_underlying(x:Uint256, y: u128): Uint256 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint256 {
            lo,
            hi: x.hi + carry,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract(x: Uint256, y: Uint256): Uint256 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint256 {
            hi,
            lo,
        }
    }

    /// subtract y from x, abort if underflows
    public fun subtract_underlying(x: Uint256, y: u128): Uint256 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y);
        let hi = x.hi - b;
        Uint256 {
            hi,
            lo,
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun underlying_mul_with_carry(x: u128, y: u128):(u128, u128) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let xl = x & UNDERLYING_LOWER_ONES;
        let yh = (y & UNDERLYING_UPPER_ONES) >> UNDERLYING_HALF_SIZE;
        let yl = y & UNDERLYING_LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = underlying_add_with_carry(xl * yl, (xhyl & UNDERLYING_LOWER_ONES) << UNDERLYING_HALF_SIZE);
        let (lo, lo_carry_2) = underlying_add_with_carry(lo, (xlyh & UNDERLYING_LOWER_ONES)<< UNDERLYING_HALF_SIZE);
        let hi = xh * yh + (xhyl >> UNDERLYING_HALF_SIZE) + (xlyh >> UNDERLYING_HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    public fun underlying_mul_to_uint256(x: u128, y: u128): Uint256{
        let (lo, hi) = underlying_mul_with_carry(x, y);
        new(hi, lo)
    }

    /// x * y, abort if overflow
    public fun multiply(x: Uint256, y: Uint256): Uint256 {
        assert!(x.hi == 0 || y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint256 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    /// x * y where y is u128
    public fun multiply_underlying(x: Uint256, y: u128): Uint256 {
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y);
        Uint256 {
            lo: xlyl,
            hi: x.hi * y + xlyl_carry,
        }
    }

    /// left shift, abort if shift is greater than the size of the int.
    public fun lsh(x: Uint256, y: u8): Uint256 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint256 {
                hi: x.lo << (y - UNDERLYING_SIZE),
                lo: 0,
            }
        } else if (y == 0) {
            copy x
        } else {
            Uint256 {
                hi: (x.hi << y) + (x.lo >> (UNDERLYING_SIZE - y)),
                lo: x.lo << y,
            }
        }
    }

    /// right shift, abort if shift is greater than the size of the int
    public fun rsh(x: Uint256, y: u8): Uint256 {
        assert!(y <= MAX_SHIFT, E_OVERFLOW);
        if (y >= UNDERLYING_SIZE) {
            Uint256 {
                hi: 0,
                lo: x.hi >> (y - UNDERLYING_SIZE),
            }
        } else if (y==0) {
            copy x
        } else {
            Uint256 {
                hi: x.hi >> y,
                lo: (x.lo >> y) + (x.hi << (UNDERLYING_SIZE-y)),
            }
        }
    }

    /// count leading zeros of the underlying type u128
    public fun underlying_leading_zeros(x: u128): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            if (x & 340282366920938463444927863358058659840 == 0) {
                // x's higher 64 is all zero, shift the lower part over
                x = x << 64;
                n = n + 64;
            };
            if (x & 340282366841710300949110269838224261120 == 0) {
                // x's higher 32 is all zero, shift the lower part over
                x = x << 32;
                n = n + 32;
            };
            if (x & 340277174624079928635746076935438991360 == 0) {
                // x's higher 16 is all zero, shift the lower part over
                x = x << 16;
                n = n + 16;
            };
            if (x & 338953138925153547590470800371487866880 == 0) {
                // x's higher 8 is all zero, shift the lower part over
                x = x << 8;
                n = n + 8;
            };
            if (x & 319014718988379809496913694467282698240 == 0) {
                // x's higher 4 is all zero, shift the lower part over
                x = x << 4;
                n = n + 4;
            };
            if (x & 255211775190703847597530955573826158592 == 0) {
                // x's higher 2 is all zero, shift the lower part over
                x = x << 2;
                n = n + 2;
            };
            if (x & 170141183460469231731687303715884105728 == 0) {
                n = n + 1;
            };

            n
        }
    }

    /// get number leading zeros
    public fun leading_zeros(x: Uint256): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    /// divide_mod returns x/y and x%y
    public fun divide_mod(x: Uint256, y: Uint256): (Uint256, Uint256) {
        assert!(y.hi != 0 || y.lo != 0, E_DIVISION_BY_ZERO);
        if (greater(y, x)) {
            (zero(), copy x)
        } else if (equal(x, y)){
            (new(0,1), zero())
        } else if (x.hi == 0 && y.hi == 0) {
            (new(0, x.lo/y.lo), new(0,x.lo%y.lo))
        } else {
            let n_x = leading_zeros(x);
            let n_y = leading_zeros(y);
            // x is greater than y, so this cannot happen
            // assert!(n_x <= n_y, 1);

            let shift = n_y - n_x;
            let current = lsh(y, shift);
            let remainder = copy x;

            let result = new(0,0);

            loop {
                if (!less(remainder, current)) {
                    remainder = subtract(remainder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, remainder)
        }
    }

    /// divide returns x/y
    public fun divide(x: Uint256, y: Uint256): Uint256 {
        let (r, _) = divide_mod(x, y);
        r
    }

    /// mod returns x%y
    public fun mod(x: Uint256, y: Uint256): Uint256 {
        let (_, r) = divide_mod(x, y);
        r
    }

    /// divide_mod_underlying returns x/y and x%y, where y is u128.
    public fun divide_mod_underlying(x: Uint256, y: u128): (Uint256, u128) {
        let (result, remainder) = divide_mod(x, new(0, y));
        (result, downcast(remainder))
    }

    /// divide underlying returns x/y, where y is u128
    public fun divide_underlying(x: Uint256, y: u128): Uint256 {
        let (result, _) = divide_mod(x, new(0, y));
        result
    }

    /// hi component of the value.
    public fun hi(x: Uint256): u128 {
        x.hi
    }

    /// lo component of the value
    public fun lo(x: Uint256): u128 {
        x.lo
    }

    public fun bitwise_and(x: Uint256, y: Uint256): Uint256 {
        Uint256 {
            hi: x.hi & y.hi,
            lo: x.lo & y.lo,
        }
    }

    public fun bitwise_or(x: Uint256, y: Uint256): Uint256 {
        Uint256 {
            hi: x.hi | y.hi,
            lo: x.lo | y.lo,
        }
    }

    public fun bitwise_xor(x: Uint256, y: Uint256): Uint256 {
        Uint256 {
            hi: x.hi ^ y.hi,
            lo: x.lo ^ y.lo,
        }
    }

    /// Indicate the value will overflow if converted to underlying type.
    public fun underlying_overflow(x: Uint256): bool {
        x.hi != 0
    }

    /// downcast converts Uint256 to u128. abort if overflow.
    public fun downcast(x: Uint256): u128 {
        assert!(
            !underlying_overflow(x),
            E_OVERFLOW,
        );

        x.lo
    }

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: Uint256): Uint256 {
        if (x.hi == 0 && x.lo == 0) {
            Uint256 { hi: 0, lo: 0}
        } else if (x.hi == 0 && x.lo <= 3) {
            Uint256 { hi: 0, lo: 1}
        } else {
            let n = (255 - leading_zeros(x)) >> 1;
            let z = rsh(x, n);
            let z_next = rsh(add(z, divide(x, z)), 1);
            while (less(z_next, z)) {
                z = z_next;
                z_next = rsh(add(z, divide(x, z)), 1);
            };
            z
        }
    }
}
