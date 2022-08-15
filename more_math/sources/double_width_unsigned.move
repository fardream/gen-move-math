// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
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

    // new creates a new Uint16
    public fun new(hi: u8, lo: u8): Uint16 {
        Uint16 {
            hi, lo,
        }
    }

    public fun zero(): Uint16 {
        Uint16 {
            hi: 0,
            lo: 0,
        }
    }

    public fun equal(x: Uint16, y: Uint16): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    public fun greater(x: Uint16, y: Uint16): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    public fun less(x: Uint16, y: Uint16): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    // add two underlying with carry - will never abort.
    // First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u8, y: u8):(u8, u8) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    // subtract y from x with borrow - will never abort.
    // First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u8, y:u8): (u8, u8) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    // add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u8, y: u8, carry: u8): u8 {
        x + y + carry // will abort if overflow
    }

    // subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u8, y: u8, borrow: u8): u8 {
        x - y - borrow // will abort if underflow
    }

    // add x and y, abort if overflows
    public fun add(x: Uint16, y: Uint16): Uint16 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint16 {
            hi,
            lo,
        }
    }

    // subtract y from x, abort if underflows
    public fun subtract(x: Uint16, y: Uint16): Uint16 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint16 {
            hi,
            lo,
        }
    }

    // x * y, first return value is the lower part of the result, second return value is the upper part of the result.
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

    // x * y, abort if overflow
    public fun multiply(x: Uint16, y: Uint16): Uint16 {
        assert!(x.hi * y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint16 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    // left shift, abort if shift is greater than the size of the int.
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

    // right shift, abort if shift is greater than the size of the int
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

    public fun underlying_leading_zeros(x: u8): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            let k: u8 = UNDERLYING_HALF_POINT;
            while ((k & x) == 0) {
                n = n + 1;
                k = k >> 1;
            };

            n
        }
    }

    public fun leading_zeros(x: Uint16): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    public fun add_underlying(x:Uint16, y: u8): Uint16 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint16 {
            lo,
            hi: x.hi + carry,
        }
    }

    // divide_mod returns x/y and x%y
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
            let reminder = copy x;

            let result = new(0,0);

            loop {
                if (!less(reminder, current)) {
                    reminder = subtract(reminder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, reminder)
        }
    }

    public fun divide(x: Uint16, y: Uint16): Uint16 {
        let (r, _) = divide_mod(x, y);
        r
    }

    public fun mod(x: Uint16, y: Uint16): Uint16 {
        let (_, r) = divide_mod(x, y);
        r
    }

    public fun hi(x: Uint16): u8 {
        x.hi
    }

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
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
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

    // new creates a new Uint128
    public fun new(hi: u64, lo: u64): Uint128 {
        Uint128 {
            hi, lo,
        }
    }

    public fun zero(): Uint128 {
        Uint128 {
            hi: 0,
            lo: 0,
        }
    }

    public fun equal(x: Uint128, y: Uint128): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    public fun greater(x: Uint128, y: Uint128): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    public fun less(x: Uint128, y: Uint128): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    // add two underlying with carry - will never abort.
    // First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u64, y: u64):(u64, u64) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    // subtract y from x with borrow - will never abort.
    // First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u64, y:u64): (u64, u64) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    // add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u64, y: u64, carry: u64): u64 {
        x + y + carry // will abort if overflow
    }

    // subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u64, y: u64, borrow: u64): u64 {
        x - y - borrow // will abort if underflow
    }

    // add x and y, abort if overflows
    public fun add(x: Uint128, y: Uint128): Uint128 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint128 {
            hi,
            lo,
        }
    }

    // subtract y from x, abort if underflows
    public fun subtract(x: Uint128, y: Uint128): Uint128 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint128 {
            hi,
            lo,
        }
    }

    // x * y, first return value is the lower part of the result, second return value is the upper part of the result.
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

    // x * y, abort if overflow
    public fun multiply(x: Uint128, y: Uint128): Uint128 {
        assert!(x.hi * y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint128 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    // left shift, abort if shift is greater than the size of the int.
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

    // right shift, abort if shift is greater than the size of the int
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

    public fun underlying_leading_zeros(x: u64): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            let k: u64 = UNDERLYING_HALF_POINT;
            while ((k & x) == 0) {
                n = n + 1;
                k = k >> 1;
            };

            n
        }
    }

    public fun leading_zeros(x: Uint128): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    public fun add_underlying(x:Uint128, y: u64): Uint128 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint128 {
            lo,
            hi: x.hi + carry,
        }
    }

    // divide_mod returns x/y and x%y
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
            let reminder = copy x;

            let result = new(0,0);

            loop {
                if (!less(reminder, current)) {
                    reminder = subtract(reminder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, reminder)
        }
    }

    public fun divide(x: Uint128, y: Uint128): Uint128 {
        let (r, _) = divide_mod(x, y);
        r
    }

    public fun mod(x: Uint128, y: Uint128): Uint128 {
        let (_, r) = divide_mod(x, y);
        r
    }

    public fun hi(x: Uint128): u64 {
        x.hi
    }

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
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
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

    // new creates a new Uint256
    public fun new(hi: u128, lo: u128): Uint256 {
        Uint256 {
            hi, lo,
        }
    }

    public fun zero(): Uint256 {
        Uint256 {
            hi: 0,
            lo: 0,
        }
    }

    public fun equal(x: Uint256, y: Uint256): bool {
        x.hi == y.hi && x.lo == y.lo
    }

    public fun greater(x: Uint256, y: Uint256): bool {
        (x.hi > y.hi) || ((x.hi == y.hi) && (x.lo > y.lo))
    }

    public fun less(x: Uint256, y: Uint256): bool {
        (x.hi < y.hi) || ((x.hi == y.hi) && (x.lo < y.lo))
    }

    // add two underlying with carry - will never abort.
    // First return value is the value of the result, the second return value indicate if carry happens.
    public fun underlying_add_with_carry(x: u128, y: u128):(u128, u128) {
        let r = UNDERLYING_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    // subtract y from x with borrow - will never abort.
    // First return value is the value of the result, the second return value indicate if borrow happens.
    public fun underlying_sub_with_borrow(x: u128, y:u128): (u128, u128) {
        if (x < y) {
            ((UNDERLYING_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    // add x and y, plus possible carry, abort when overflow
    fun underlying_add_plus_carry(x: u128, y: u128, carry: u128): u128 {
        x + y + carry // will abort if overflow
    }

    // subtract y and possible borrow from x, abort when underflow
    fun underlying_sub_minus_borrow(x: u128, y: u128, borrow: u128): u128 {
        x - y - borrow // will abort if underflow
    }

    // add x and y, abort if overflows
    public fun add(x: Uint256, y: Uint256): Uint256 {
        let (lo, c) = underlying_add_with_carry(x.lo, y.lo);
        let hi = underlying_add_plus_carry(x.hi, y.hi, c);
        Uint256 {
            hi,
            lo,
        }
    }

    // subtract y from x, abort if underflows
    public fun subtract(x: Uint256, y: Uint256): Uint256 {
        let (lo, b) = underlying_sub_with_borrow(x.lo, y.lo);
        let hi = underlying_sub_minus_borrow(x.hi, y.hi, b);
        Uint256 {
            hi,
            lo,
        }
    }

    // x * y, first return value is the lower part of the result, second return value is the upper part of the result.
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

    // x * y, abort if overflow
    public fun multiply(x: Uint256, y: Uint256): Uint256 {
        assert!(x.hi * y.hi == 0, E_OVERFLOW); // if hi * hi is not zero, overflow already
        let (xlyl, xlyl_carry) = underlying_mul_with_carry(x.lo, y.lo);
        Uint256 {
            lo: xlyl,
            hi: x.lo * y.hi + x.hi * y.lo + xlyl_carry,
        }
    }

    // left shift, abort if shift is greater than the size of the int.
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

    // right shift, abort if shift is greater than the size of the int
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

    public fun underlying_leading_zeros(x: u128): u8 {
        if (x == 0) {
            UNDERLYING_SIZE
        } else {
            let n: u8 = 0;
            let k: u128 = UNDERLYING_HALF_POINT;
            while ((k & x) == 0) {
                n = n + 1;
                k = k >> 1;
            };

            n
        }
    }

    public fun leading_zeros(x: Uint256): u8 {
        if (x.hi == 0) {
            UNDERLYING_SIZE + underlying_leading_zeros(x.lo)
        } else {
            underlying_leading_zeros(x.hi)
        }
    }

    public fun add_underlying(x:Uint256, y: u128): Uint256 {
        let (lo, carry) = underlying_add_with_carry(x.lo, y);
        Uint256 {
            lo,
            hi: x.hi + carry,
        }
    }

    // divide_mod returns x/y and x%y
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
            let reminder = copy x;

            let result = new(0,0);

            loop {
                if (!less(reminder, current)) {
                    reminder = subtract(reminder, current);
                    result = add(result, lsh(new(0,1), shift));
                };
                if (shift == 0) { break };
                current = rsh(current, 1);
                shift = shift - 1;
            };

            (result, reminder)
        }
    }

    public fun divide(x: Uint256, y: Uint256): Uint256 {
        let (r, _) = divide_mod(x, y);
        r
    }

    public fun mod(x: Uint256, y: Uint256): Uint256 {
        let (_, r) = divide_mod(x, y);
        r
    }

    public fun hi(x: Uint256): u128 {
        x.hi
    }

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
}
