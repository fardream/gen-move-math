// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: more-math -t
// Version: v1.4.0
module more_math::more_math_u8 {
    const E_WIDTH_OVERFLOW_U8: u64 = 1;
    const HALF_SIZE: u8 = 4;
    const MAX_SHIFT_SIZE: u8 = 7;

    const ALL_ONES: u8 = 255;
    const LOWER_ONES: u8 = (1 << 4) - 1;
    const UPPER_ONES: u8 = ((1 << 4) - 1) << 4;
    /// add two u8 with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun add_with_carry(x: u8, y: u8):(u8, u8) {
        let r = ALL_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun sub_with_borrow(x: u8, y:u8): (u8, u8) {
        if (x < y) {
            ((ALL_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun mul_with_carry(x: u8, y: u8):(u8, u8) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UPPER_ONES) >> HALF_SIZE;
        let xl = x & LOWER_ONES;
        let yh = (y & UPPER_ONES) >> HALF_SIZE;
        let yl = y & LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = add_with_carry(xl * yl, (xhyl & LOWER_ONES) << HALF_SIZE);
        let (lo, lo_carry_2) = add_with_carry(lo, (xlyh & LOWER_ONES)<< HALF_SIZE);
        let hi = xh * yh + (xhyl >> HALF_SIZE) + (xlyh >> HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    /// count leading zeros u8
    public fun leading_zeros(x: u8): u8 {
        if (x == 0) {
            8
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

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: u8): u8 {
        if (x == 0) {
            0
        } else if (x <= 3) {
            1
        } else {
            // reproduced from golang's big.Int.Sqrt
            let n = (MAX_SHIFT_SIZE - leading_zeros(x)) >> 1;
            let z = x >> ((n - 1) / 2);
            let z_next = (z + x / z) >> 1;
            while (z_next < z) {
                z = z_next;
                z_next = (z + x / z) >> 1;
            };
            z
        }
    }


    #[test]
    fun test_sqrt_u8_0() {
        let r = sqrt(31);
        assert!(r == 5, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_1() {
        let r = sqrt(24);
        assert!(r == 4, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_2() {
        let r = sqrt(16);
        assert!(r == 4, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_3() {
        let r = sqrt(15);
        assert!(r == 3, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_4() {
        let r = sqrt(30);
        assert!(r == 5, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_5() {
        let r = sqrt(24);
        assert!(r == 4, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_6() {
        let r = sqrt(45);
        assert!(r == 6, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_7() {
        let r = sqrt(35);
        assert!(r == 5, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_8() {
        let r = sqrt(81);
        assert!(r == 9, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_9() {
        let r = sqrt(80);
        assert!(r == 8, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_10() {
        let r = sqrt(251);
        assert!(r == 15, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_11() {
        let r = sqrt(224);
        assert!(r == 14, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_12() {
        let r = sqrt(159);
        assert!(r == 12, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_13() {
        let r = sqrt(143);
        assert!(r == 11, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_14() {
        let r = sqrt(190);
        assert!(r == 13, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_15() {
        let r = sqrt(168);
        assert!(r == 12, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_16() {
        let r = sqrt(104);
        assert!(r == 10, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_17() {
        let r = sqrt(99);
        assert!(r == 9, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_18() {
        let r = sqrt(92);
        assert!(r == 9, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_19() {
        let r = sqrt(80);
        assert!(r == 8, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_20() {
        let r = sqrt(21);
        assert!(r == 4, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_21() {
        let r = sqrt(15);
        assert!(r == 3, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_22() {
        let r = sqrt(185);
        assert!(r == 13, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_23() {
        let r = sqrt(168);
        assert!(r == 12, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_24() {
        let r = sqrt(204);
        assert!(r == 14, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_25() {
        let r = sqrt(195);
        assert!(r == 13, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_26() {
        let r = sqrt(79);
        assert!(r == 8, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_27() {
        let r = sqrt(63);
        assert!(r == 7, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_28() {
        let r = sqrt(242);
        assert!(r == 15, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_29() {
        let r = sqrt(224);
        assert!(r == 14, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_30() {
        let r = sqrt(223);
        assert!(r == 14, (r as u64));
    }
    #[test]
    fun test_sqrt_u8_31() {
        let r = sqrt(195);
        assert!(r == 13, (r as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: more-math -t
// Version: v1.4.0
module more_math::more_math_u16 {
    const E_WIDTH_OVERFLOW_U8: u64 = 1;
    const HALF_SIZE: u8 = 8;
    const MAX_SHIFT_SIZE: u8 = 15;

    const ALL_ONES: u16 = 65535;
    const LOWER_ONES: u16 = (1 << 8) - 1;
    const UPPER_ONES: u16 = ((1 << 8) - 1) << 8;
    /// add two u16 with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun add_with_carry(x: u16, y: u16):(u16, u16) {
        let r = ALL_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun sub_with_borrow(x: u16, y:u16): (u16, u16) {
        if (x < y) {
            ((ALL_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun mul_with_carry(x: u16, y: u16):(u16, u16) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UPPER_ONES) >> HALF_SIZE;
        let xl = x & LOWER_ONES;
        let yh = (y & UPPER_ONES) >> HALF_SIZE;
        let yl = y & LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = add_with_carry(xl * yl, (xhyl & LOWER_ONES) << HALF_SIZE);
        let (lo, lo_carry_2) = add_with_carry(lo, (xlyh & LOWER_ONES)<< HALF_SIZE);
        let hi = xh * yh + (xhyl >> HALF_SIZE) + (xlyh >> HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    /// count leading zeros u16
    public fun leading_zeros(x: u16): u8 {
        if (x == 0) {
            16
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

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: u16): u16 {
        if (x == 0) {
            0
        } else if (x <= 3) {
            1
        } else {
            // reproduced from golang's big.Int.Sqrt
            let n = (MAX_SHIFT_SIZE - leading_zeros(x)) >> 1;
            let z = x >> ((n - 1) / 2);
            let z_next = (z + x / z) >> 1;
            while (z_next < z) {
                z = z_next;
                z_next = (z + x / z) >> 1;
            };
            z
        }
    }


    #[test]
    fun test_sqrt_u16_0() {
        let r = sqrt(24565);
        assert!(r == 156, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_1() {
        let r = sqrt(24335);
        assert!(r == 155, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_2() {
        let r = sqrt(49138);
        assert!(r == 221, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_3() {
        let r = sqrt(48840);
        assert!(r == 220, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_4() {
        let r = sqrt(12790);
        assert!(r == 113, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_5() {
        let r = sqrt(12768);
        assert!(r == 112, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_6() {
        let r = sqrt(59920);
        assert!(r == 244, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_7() {
        let r = sqrt(59535);
        assert!(r == 243, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_8() {
        let r = sqrt(49104);
        assert!(r == 221, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_9() {
        let r = sqrt(48840);
        assert!(r == 220, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_10() {
        let r = sqrt(44529);
        assert!(r == 211, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_11() {
        let r = sqrt(44520);
        assert!(r == 210, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_12() {
        let r = sqrt(16643);
        assert!(r == 129, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_13() {
        let r = sqrt(16640);
        assert!(r == 128, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_14() {
        let r = sqrt(51136);
        assert!(r == 226, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_15() {
        let r = sqrt(51075);
        assert!(r == 225, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_16() {
        let r = sqrt(46939);
        assert!(r == 216, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_17() {
        let r = sqrt(46655);
        assert!(r == 215, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_18() {
        let r = sqrt(5201);
        assert!(r == 72, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_19() {
        let r = sqrt(5183);
        assert!(r == 71, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_20() {
        let r = sqrt(41631);
        assert!(r == 204, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_21() {
        let r = sqrt(41615);
        assert!(r == 203, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_22() {
        let r = sqrt(16168);
        assert!(r == 127, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_23() {
        let r = sqrt(16128);
        assert!(r == 126, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_24() {
        let r = sqrt(2140);
        assert!(r == 46, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_25() {
        let r = sqrt(2115);
        assert!(r == 45, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_26() {
        let r = sqrt(24597);
        assert!(r == 156, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_27() {
        let r = sqrt(24335);
        assert!(r == 155, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_28() {
        let r = sqrt(3378);
        assert!(r == 58, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_29() {
        let r = sqrt(3363);
        assert!(r == 57, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_30() {
        let r = sqrt(53626);
        assert!(r == 231, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_31() {
        let r = sqrt(53360);
        assert!(r == 230, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_32() {
        let r = sqrt(53757);
        assert!(r == 231, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_33() {
        let r = sqrt(53360);
        assert!(r == 230, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_34() {
        let r = sqrt(4175);
        assert!(r == 64, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_35() {
        let r = sqrt(4095);
        assert!(r == 63, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_36() {
        let r = sqrt(44786);
        assert!(r == 211, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_37() {
        let r = sqrt(44520);
        assert!(r == 210, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_38() {
        let r = sqrt(21288);
        assert!(r == 145, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_39() {
        let r = sqrt(21024);
        assert!(r == 144, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_40() {
        let r = sqrt(25413);
        assert!(r == 159, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_41() {
        let r = sqrt(25280);
        assert!(r == 158, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_42() {
        let r = sqrt(52574);
        assert!(r == 229, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_43() {
        let r = sqrt(52440);
        assert!(r == 228, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_44() {
        let r = sqrt(9609);
        assert!(r == 98, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_45() {
        let r = sqrt(9603);
        assert!(r == 97, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_46() {
        let r = sqrt(64372);
        assert!(r == 253, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_47() {
        let r = sqrt(64008);
        assert!(r == 252, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_48() {
        let r = sqrt(3465);
        assert!(r == 58, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_49() {
        let r = sqrt(3363);
        assert!(r == 57, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_50() {
        let r = sqrt(31913);
        assert!(r == 178, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_51() {
        let r = sqrt(31683);
        assert!(r == 177, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_52() {
        let r = sqrt(44099);
        assert!(r == 209, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_53() {
        let r = sqrt(43680);
        assert!(r == 208, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_54() {
        let r = sqrt(20516);
        assert!(r == 143, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_55() {
        let r = sqrt(20448);
        assert!(r == 142, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_56() {
        let r = sqrt(18745);
        assert!(r == 136, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_57() {
        let r = sqrt(18495);
        assert!(r == 135, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_58() {
        let r = sqrt(52536);
        assert!(r == 229, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_59() {
        let r = sqrt(52440);
        assert!(r == 228, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_60() {
        let r = sqrt(12493);
        assert!(r == 111, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_61() {
        let r = sqrt(12320);
        assert!(r == 110, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_62() {
        let r = sqrt(24574);
        assert!(r == 156, (r as u64));
    }
    #[test]
    fun test_sqrt_u16_63() {
        let r = sqrt(24335);
        assert!(r == 155, (r as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: more-math -t
// Version: v1.4.0
module more_math::more_math_u32 {
    const E_WIDTH_OVERFLOW_U8: u64 = 1;
    const HALF_SIZE: u8 = 16;
    const MAX_SHIFT_SIZE: u8 = 31;

    const ALL_ONES: u32 = 4294967295;
    const LOWER_ONES: u32 = (1 << 16) - 1;
    const UPPER_ONES: u32 = ((1 << 16) - 1) << 16;
    /// add two u32 with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun add_with_carry(x: u32, y: u32):(u32, u32) {
        let r = ALL_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun sub_with_borrow(x: u32, y:u32): (u32, u32) {
        if (x < y) {
            ((ALL_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun mul_with_carry(x: u32, y: u32):(u32, u32) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UPPER_ONES) >> HALF_SIZE;
        let xl = x & LOWER_ONES;
        let yh = (y & UPPER_ONES) >> HALF_SIZE;
        let yl = y & LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = add_with_carry(xl * yl, (xhyl & LOWER_ONES) << HALF_SIZE);
        let (lo, lo_carry_2) = add_with_carry(lo, (xlyh & LOWER_ONES)<< HALF_SIZE);
        let hi = xh * yh + (xhyl >> HALF_SIZE) + (xlyh >> HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    /// count leading zeros u32
    public fun leading_zeros(x: u32): u8 {
        if (x == 0) {
            32
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

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: u32): u32 {
        if (x == 0) {
            0
        } else if (x <= 3) {
            1
        } else {
            // reproduced from golang's big.Int.Sqrt
            let n = (MAX_SHIFT_SIZE - leading_zeros(x)) >> 1;
            let z = x >> ((n - 1) / 2);
            let z_next = (z + x / z) >> 1;
            while (z_next < z) {
                z = z_next;
                z_next = (z + x / z) >> 1;
            };
            z
        }
    }


    #[test]
    fun test_sqrt_u32_0() {
        let r = sqrt(3649778518);
        assert!(r == 60413, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_1() {
        let r = sqrt(3649730568);
        assert!(r == 60412, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_2() {
        let r = sqrt(2615979505);
        assert!(r == 51146, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_3() {
        let r = sqrt(2615913315);
        assert!(r == 51145, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_4() {
        let r = sqrt(1530763030);
        assert!(r == 39124, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_5() {
        let r = sqrt(1530687375);
        assert!(r == 39123, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_6() {
        let r = sqrt(898515203);
        assert!(r == 29975, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_7() {
        let r = sqrt(898500624);
        assert!(r == 29974, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_8() {
        let r = sqrt(2935165982);
        assert!(r == 54177, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_9() {
        let r = sqrt(2935147328);
        assert!(r == 54176, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_10() {
        let r = sqrt(649801091);
        assert!(r == 25491, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_11() {
        let r = sqrt(649791080);
        assert!(r == 25490, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_12() {
        let r = sqrt(2329218299);
        assert!(r == 48261, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_13() {
        let r = sqrt(2329124120);
        assert!(r == 48260, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_14() {
        let r = sqrt(2225250975);
        assert!(r == 47172, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_15() {
        let r = sqrt(2225197583);
        assert!(r == 47171, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_16() {
        let r = sqrt(3653467838);
        assert!(r == 60443, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_17() {
        let r = sqrt(3653356248);
        assert!(r == 60442, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_18() {
        let r = sqrt(2023694845);
        assert!(r == 44985, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_19() {
        let r = sqrt(2023650224);
        assert!(r == 44984, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_20() {
        let r = sqrt(1843683349);
        assert!(r == 42938, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_21() {
        let r = sqrt(1843671843);
        assert!(r == 42937, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_22() {
        let r = sqrt(141136839);
        assert!(r == 11880, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_23() {
        let r = sqrt(141134399);
        assert!(r == 11879, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_24() {
        let r = sqrt(2511080754);
        assert!(r == 50110, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_25() {
        let r = sqrt(2511012099);
        assert!(r == 50109, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_26() {
        let r = sqrt(1054396794);
        assert!(r == 32471, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_27() {
        let r = sqrt(1054365840);
        assert!(r == 32470, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_28() {
        let r = sqrt(1633988338);
        assert!(r == 40422, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_29() {
        let r = sqrt(1633938083);
        assert!(r == 40421, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_30() {
        let r = sqrt(3266335528);
        assert!(r == 57151, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_31() {
        let r = sqrt(3266236800);
        assert!(r == 57150, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_32() {
        let r = sqrt(3953202579);
        assert!(r == 62874, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_33() {
        let r = sqrt(3953139875);
        assert!(r == 62873, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_34() {
        let r = sqrt(3770469726);
        assert!(r == 61404, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_35() {
        let r = sqrt(3770451215);
        assert!(r == 61403, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_36() {
        let r = sqrt(2006390345);
        assert!(r == 44792, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_37() {
        let r = sqrt(2006323263);
        assert!(r == 44791, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_38() {
        let r = sqrt(3321111945);
        assert!(r == 57629, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_39() {
        let r = sqrt(3321101640);
        assert!(r == 57628, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_40() {
        let r = sqrt(16579444);
        assert!(r == 4071, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_41() {
        let r = sqrt(16573040);
        assert!(r == 4070, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_42() {
        let r = sqrt(1981840553);
        assert!(r == 44517, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_43() {
        let r = sqrt(1981763288);
        assert!(r == 44516, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_44() {
        let r = sqrt(2748687057);
        assert!(r == 52427, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_45() {
        let r = sqrt(2748590328);
        assert!(r == 52426, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_46() {
        let r = sqrt(1551519780);
        assert!(r == 39389, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_47() {
        let r = sqrt(1551493320);
        assert!(r == 39388, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_48() {
        let r = sqrt(2606041019);
        assert!(r == 51049, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_49() {
        let r = sqrt(2606000400);
        assert!(r == 51048, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_50() {
        let r = sqrt(112448948);
        assert!(r == 10604, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_51() {
        let r = sqrt(112444815);
        assert!(r == 10603, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_52() {
        let r = sqrt(2498251065);
        assert!(r == 49982, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_53() {
        let r = sqrt(2498200323);
        assert!(r == 49981, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_54() {
        let r = sqrt(896585016);
        assert!(r == 29943, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_55() {
        let r = sqrt(896583248);
        assert!(r == 29942, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_56() {
        let r = sqrt(902032960);
        assert!(r == 30033, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_57() {
        let r = sqrt(901981088);
        assert!(r == 30032, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_58() {
        let r = sqrt(855232614);
        assert!(r == 29244, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_59() {
        let r = sqrt(855211535);
        assert!(r == 29243, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_60() {
        let r = sqrt(3036890095);
        assert!(r == 55107, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_61() {
        let r = sqrt(3036781448);
        assert!(r == 55106, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_62() {
        let r = sqrt(519577885);
        assert!(r == 22794, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_63() {
        let r = sqrt(519566435);
        assert!(r == 22793, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_64() {
        let r = sqrt(3907830031);
        assert!(r == 62512, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_65() {
        let r = sqrt(3907750143);
        assert!(r == 62511, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_66() {
        let r = sqrt(2802740532);
        assert!(r == 52940, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_67() {
        let r = sqrt(2802643599);
        assert!(r == 52939, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_68() {
        let r = sqrt(2977604189);
        assert!(r == 54567, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_69() {
        let r = sqrt(2977557488);
        assert!(r == 54566, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_70() {
        let r = sqrt(2340697395);
        assert!(r == 48380, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_71() {
        let r = sqrt(2340624399);
        assert!(r == 48379, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_72() {
        let r = sqrt(1973774989);
        assert!(r == 44427, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_73() {
        let r = sqrt(1973758328);
        assert!(r == 44426, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_74() {
        let r = sqrt(1335327469);
        assert!(r == 36542, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_75() {
        let r = sqrt(1335317763);
        assert!(r == 36541, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_76() {
        let r = sqrt(443727549);
        assert!(r == 21064, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_77() {
        let r = sqrt(443692095);
        assert!(r == 21063, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_78() {
        let r = sqrt(1705066515);
        assert!(r == 41292, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_79() {
        let r = sqrt(1705029263);
        assert!(r == 41291, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_80() {
        let r = sqrt(1970127545);
        assert!(r == 44386, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_81() {
        let r = sqrt(1970116995);
        assert!(r == 44385, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_82() {
        let r = sqrt(2801949593);
        assert!(r == 52933, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_83() {
        let r = sqrt(2801902488);
        assert!(r == 52932, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_84() {
        let r = sqrt(3973131384);
        assert!(r == 63032, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_85() {
        let r = sqrt(3973033023);
        assert!(r == 63031, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_86() {
        let r = sqrt(1575426699);
        assert!(r == 39691, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_87() {
        let r = sqrt(1575375480);
        assert!(r == 39690, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_88() {
        let r = sqrt(2314410109);
        assert!(r == 48108, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_89() {
        let r = sqrt(2314379663);
        assert!(r == 48107, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_90() {
        let r = sqrt(641368140);
        assert!(r == 25325, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_91() {
        let r = sqrt(641355624);
        assert!(r == 25324, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_92() {
        let r = sqrt(1994434903);
        assert!(r == 44659, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_93() {
        let r = sqrt(1994426280);
        assert!(r == 44658, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_94() {
        let r = sqrt(3010272557);
        assert!(r == 54865, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_95() {
        let r = sqrt(3010168224);
        assert!(r == 54864, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_96() {
        let r = sqrt(1540628825);
        assert!(r == 39250, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_97() {
        let r = sqrt(1540562499);
        assert!(r == 39249, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_98() {
        let r = sqrt(18791896);
        assert!(r == 4334, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_99() {
        let r = sqrt(18783555);
        assert!(r == 4333, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_100() {
        let r = sqrt(2226169836);
        assert!(r == 47182, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_101() {
        let r = sqrt(2226141123);
        assert!(r == 47181, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_102() {
        let r = sqrt(3133715466);
        assert!(r == 55979, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_103() {
        let r = sqrt(3133648440);
        assert!(r == 55978, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_104() {
        let r = sqrt(751269456);
        assert!(r == 27409, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_105() {
        let r = sqrt(751253280);
        assert!(r == 27408, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_106() {
        let r = sqrt(3701850186);
        assert!(r == 60842, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_107() {
        let r = sqrt(3701748963);
        assert!(r == 60841, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_108() {
        let r = sqrt(3560607040);
        assert!(r == 59670, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_109() {
        let r = sqrt(3560508899);
        assert!(r == 59669, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_110() {
        let r = sqrt(2348312091);
        assert!(r == 48459, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_111() {
        let r = sqrt(2348274680);
        assert!(r == 48458, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_112() {
        let r = sqrt(3475347114);
        assert!(r == 58952, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_113() {
        let r = sqrt(3475338303);
        assert!(r == 58951, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_114() {
        let r = sqrt(2503525895);
        assert!(r == 50035, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_115() {
        let r = sqrt(2503501224);
        assert!(r == 50034, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_116() {
        let r = sqrt(1246233319);
        assert!(r == 35302, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_117() {
        let r = sqrt(1246231203);
        assert!(r == 35301, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_118() {
        let r = sqrt(3026688176);
        assert!(r == 55015, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_119() {
        let r = sqrt(3026650224);
        assert!(r == 55014, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_120() {
        let r = sqrt(3894358020);
        assert!(r == 62404, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_121() {
        let r = sqrt(3894259215);
        assert!(r == 62403, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_122() {
        let r = sqrt(1392988974);
        assert!(r == 37322, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_123() {
        let r = sqrt(1392931683);
        assert!(r == 37321, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_124() {
        let r = sqrt(1563658126);
        assert!(r == 39543, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_125() {
        let r = sqrt(1563648848);
        assert!(r == 39542, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_126() {
        let r = sqrt(2523919847);
        assert!(r == 50238, (r as u64));
    }
    #[test]
    fun test_sqrt_u32_127() {
        let r = sqrt(2523856643);
        assert!(r == 50237, (r as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: more-math -t
// Version: v1.4.0
module more_math::more_math_u64 {
    const E_WIDTH_OVERFLOW_U8: u64 = 1;
    const HALF_SIZE: u8 = 32;
    const MAX_SHIFT_SIZE: u8 = 63;

    const ALL_ONES: u64 = 18446744073709551615;
    const LOWER_ONES: u64 = (1 << 32) - 1;
    const UPPER_ONES: u64 = ((1 << 32) - 1) << 32;
    /// add two u64 with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun add_with_carry(x: u64, y: u64):(u64, u64) {
        let r = ALL_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun sub_with_borrow(x: u64, y:u64): (u64, u64) {
        if (x < y) {
            ((ALL_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun mul_with_carry(x: u64, y: u64):(u64, u64) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UPPER_ONES) >> HALF_SIZE;
        let xl = x & LOWER_ONES;
        let yh = (y & UPPER_ONES) >> HALF_SIZE;
        let yl = y & LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = add_with_carry(xl * yl, (xhyl & LOWER_ONES) << HALF_SIZE);
        let (lo, lo_carry_2) = add_with_carry(lo, (xlyh & LOWER_ONES)<< HALF_SIZE);
        let hi = xh * yh + (xhyl >> HALF_SIZE) + (xlyh >> HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    /// count leading zeros u64
    public fun leading_zeros(x: u64): u8 {
        if (x == 0) {
            64
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

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: u64): u64 {
        if (x == 0) {
            0
        } else if (x <= 3) {
            1
        } else {
            // reproduced from golang's big.Int.Sqrt
            let n = (MAX_SHIFT_SIZE - leading_zeros(x)) >> 1;
            let z = x >> ((n - 1) / 2);
            let z_next = (z + x / z) >> 1;
            while (z_next < z) {
                z = z_next;
                z_next = (z + x / z) >> 1;
            };
            z
        }
    }


    #[test]
    fun test_sqrt_u64_0() {
        let r = sqrt(4518808235179270133);
        assert!(r == 2125748864, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_1() {
        let r = sqrt(4518808232797290495);
        assert!(r == 2125748863, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_2() {
        let r = sqrt(3087144572626463248);
        assert!(r == 1757027197, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_3() {
        let r = sqrt(3087144570997676808);
        assert!(r == 1757027196, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_4() {
        let r = sqrt(7861855757602232086);
        assert!(r == 2803900097, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_5() {
        let r = sqrt(7861855753956609408);
        assert!(r == 2803900096, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_6() {
        let r = sqrt(12784885724210938115);
        assert!(r == 3575595855, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_7() {
        let r = sqrt(12784885718293181024);
        assert!(r == 3575595854, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_8() {
        let r = sqrt(2119085704421221023);
        assert!(r == 1455707973, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_9() {
        let r = sqrt(2119085702655768728);
        assert!(r == 1455707972, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_10() {
        let r = sqrt(1543285579645681342);
        assert!(r == 1242290457, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_11() {
        let r = sqrt(1543285579553268848);
        assert!(r == 1242290456, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_12() {
        let r = sqrt(15398783846516204029);
        assert!(r == 3924128418, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_13() {
        let r = sqrt(15398783840955182723);
        assert!(r == 3924128417, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_14() {
        let r = sqrt(9472434474353809100);
        assert!(r == 3077732034, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_15() {
        let r = sqrt(9472434473109777155);
        assert!(r == 3077732033, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_16() {
        let r = sqrt(3877601997538530707);
        assert!(r == 1969162765, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_17() {
        let r = sqrt(3877601995062445224);
        assert!(r == 1969162764, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_18() {
        let r = sqrt(16172318933975836041);
        assert!(r == 4021482181, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_19() {
        let r = sqrt(16172318932100516760);
        assert!(r == 4021482180, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_20() {
        let r = sqrt(4132390935710051395);
        assert!(r == 2032828309, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_21() {
        let r = sqrt(4132390933871799480);
        assert!(r == 2032828308, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_22() {
        let r = sqrt(300681375570251064);
        assert!(r == 548344212, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_23() {
        let r = sqrt(300681374833900943);
        assert!(r == 548344211, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_24() {
        let r = sqrt(12861939829342011422);
        assert!(r == 3586354671, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_25() {
        let r = sqrt(12861939826203518240);
        assert!(r == 3586354670, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_26() {
        let r = sqrt(868800358632342511);
        assert!(r == 932094608, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_27() {
        let r = sqrt(868800358262673663);
        assert!(r == 932094607, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_28() {
        let r = sqrt(8468275846115330281);
        assert!(r == 2910030213, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_29() {
        let r = sqrt(8468275840572825368);
        assert!(r == 2910030212, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_30() {
        let r = sqrt(13765699568629760271);
        assert!(r == 3710215569, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_31() {
        let r = sqrt(13765699568449993760);
        assert!(r == 3710215568, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_32() {
        let r = sqrt(9080975376737548076);
        assert!(r == 3013465675, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_33() {
        let r = sqrt(9080975374403205624);
        assert!(r == 3013465674, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_34() {
        let r = sqrt(2023352169218621252);
        assert!(r == 1422445840, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_35() {
        let r = sqrt(2023352167733305599);
        assert!(r == 1422445839, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_36() {
        let r = sqrt(17671690107166572221);
        assert!(r == 4203770938, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_37() {
        let r = sqrt(17671690099173399843);
        assert!(r == 4203770937, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_38() {
        let r = sqrt(3798025803302780947);
        assert!(r == 1948852432, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_39() {
        let r = sqrt(3798025801712314623);
        assert!(r == 1948852431, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_40() {
        let r = sqrt(10732944964382368089);
        assert!(r == 3276117361, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_41() {
        let r = sqrt(10732944963045604320);
        assert!(r == 3276117360, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_42() {
        let r = sqrt(5972778420317109720);
        assert!(r == 2443926844, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_43() {
        let r = sqrt(5972778418823800335);
        assert!(r == 2443926843, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_44() {
        let r = sqrt(8901768139528370850);
        assert!(r == 2983583104, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_45() {
        let r = sqrt(8901768138474274815);
        assert!(r == 2983583103, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_46() {
        let r = sqrt(8502318506928285676);
        assert!(r == 2915873540, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_47() {
        let r = sqrt(8502318501272131599);
        assert!(r == 2915873539, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_48() {
        let r = sqrt(12057322060872382032);
        assert!(r == 3472365484, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_49() {
        let r = sqrt(12057322054474554255);
        assert!(r == 3472365483, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_50() {
        let r = sqrt(567568505901704731);
        assert!(r == 753371426, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_51() {
        let r = sqrt(567568505513273475);
        assert!(r == 753371425, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_52() {
        let r = sqrt(2247583555303968036);
        assert!(r == 1499194302, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_53() {
        let r = sqrt(2247583555149267203);
        assert!(r == 1499194301, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_54() {
        let r = sqrt(3029607914297333936);
        assert!(r == 1740576891, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_55() {
        let r = sqrt(3029607913483225880);
        assert!(r == 1740576890, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_56() {
        let r = sqrt(16963619037247328371);
        assert!(r == 4118691422, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_57() {
        let r = sqrt(16963619029656382083);
        assert!(r == 4118691421, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_58() {
        let r = sqrt(10620786042238096174);
        assert!(r == 3258954746, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_59() {
        let r = sqrt(10620786036475924515);
        assert!(r == 3258954745, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_60() {
        let r = sqrt(710940327224637099);
        assert!(r == 843172774, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_61() {
        let r = sqrt(710940326814855075);
        assert!(r == 843172773, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_62() {
        let r = sqrt(16460321369281478014);
        assert!(r == 4057132160, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_63() {
        let r = sqrt(16460321363706265599);
        assert!(r == 4057132159, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_64() {
        let r = sqrt(16536373503259581585);
        assert!(r == 4066494006, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_65() {
        let r = sqrt(16536373500833928035);
        assert!(r == 4066494005, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_66() {
        let r = sqrt(14220942032815928813);
        assert!(r == 3771066431, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_67() {
        let r = sqrt(14220942027015077760);
        assert!(r == 3771066430, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_68() {
        let r = sqrt(14868134686227846942);
        assert!(r == 3855922028, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_69() {
        let r = sqrt(14868134686015632783);
        assert!(r == 3855922027, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_70() {
        let r = sqrt(2353700405777826677);
        assert!(r == 1534177436, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_71() {
        let r = sqrt(2353700405131534095);
        assert!(r == 1534177435, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_72() {
        let r = sqrt(10589461183115162653);
        assert!(r == 3254145230, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_73() {
        let r = sqrt(10589461177931752899);
        assert!(r == 3254145229, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_74() {
        let r = sqrt(9050008079631751930);
        assert!(r == 3008323134, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_75() {
        let r = sqrt(9050008078559581955);
        assert!(r == 3008323133, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_76() {
        let r = sqrt(10336011462021595458);
        assert!(r == 3214966790, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_77() {
        let r = sqrt(10336011460802904099);
        assert!(r == 3214966789, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_78() {
        let r = sqrt(9682783406937473894);
        assert!(r == 3111717115, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_79() {
        let r = sqrt(9682783403783923224);
        assert!(r == 3111717114, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_80() {
        let r = sqrt(2430368660537815426);
        assert!(r == 1558963970, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_81() {
        let r = sqrt(2430368659758160899);
        assert!(r == 1558963969, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_82() {
        let r = sqrt(11700348982127230681);
        assert!(r == 3420577287, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_83() {
        let r = sqrt(11700348976340280368);
        assert!(r == 3420577286, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_84() {
        let r = sqrt(4321960713473928958);
        assert!(r == 2078932589, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_85() {
        let r = sqrt(4321960709606242920);
        assert!(r == 2078932588, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_86() {
        let r = sqrt(10413123530250971146);
        assert!(r == 3226937174, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_87() {
        let r = sqrt(10413123524943106275);
        assert!(r == 3226937173, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_88() {
        let r = sqrt(10803309030052501148);
        assert!(r == 3286838759, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_89() {
        let r = sqrt(10803309027664660080);
        assert!(r == 3286838758, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_90() {
        let r = sqrt(9301751449745155624);
        assert!(r == 3049877284, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_91() {
        let r = sqrt(9301751447459216655);
        assert!(r == 3049877283, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_92() {
        let r = sqrt(18411942655047748318);
        assert!(r == 4290913965, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_93() {
        let r = sqrt(18411942655032021224);
        assert!(r == 4290913964, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_94() {
        let r = sqrt(11116133554876932735);
        assert!(r == 3334086614, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_95() {
        let r = sqrt(11116133549653984995);
        assert!(r == 3334086613, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_96() {
        let r = sqrt(8746914360817110192);
        assert!(r == 2957518277, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_97() {
        let r = sqrt(8746914358789048728);
        assert!(r == 2957518276, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_98() {
        let r = sqrt(14272414364311572581);
        assert!(r == 3777884906, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_99() {
        let r = sqrt(14272414362982628835);
        assert!(r == 3777884905, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_100() {
        let r = sqrt(7811778195032818482);
        assert!(r == 2794955848, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_101() {
        let r = sqrt(7811778192269399103);
        assert!(r == 2794955847, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_102() {
        let r = sqrt(694998616376515535);
        assert!(r == 833665770, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_103() {
        let r = sqrt(694998616069692899);
        assert!(r == 833665769, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_104() {
        let r = sqrt(3094703518683447370);
        assert!(r == 1759176943, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_105() {
        let r = sqrt(3094703516782825248);
        assert!(r == 1759176942, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_106() {
        let r = sqrt(13062722355039356560);
        assert!(r == 3614238834, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_107() {
        let r = sqrt(13062722349193679555);
        assert!(r == 3614238833, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_108() {
        let r = sqrt(1409060768037052268);
        assert!(r == 1187038654, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_109() {
        let r = sqrt(1409060766090131715);
        assert!(r == 1187038653, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_110() {
        let r = sqrt(15415297367869156288);
        assert!(r == 3926231955, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_111() {
        let r = sqrt(15415297364463122024);
        assert!(r == 3926231954, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_112() {
        let r = sqrt(13825183633482395562);
        assert!(r == 3718223182, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_113() {
        let r = sqrt(13825183631162205123);
        assert!(r == 3718223181, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_114() {
        let r = sqrt(17712515365620532216);
        assert!(r == 4208623927, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_115() {
        let r = sqrt(17712515358916901328);
        assert!(r == 4208623926, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_116() {
        let r = sqrt(11691509092519593124);
        assert!(r == 3419284880, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_117() {
        let r = sqrt(11691509090596614399);
        assert!(r == 3419284879, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_118() {
        let r = sqrt(12730131254225935905);
        assert!(r == 3567930948, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_119() {
        let r = sqrt(12730131249696178703);
        assert!(r == 3567930947, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_120() {
        let r = sqrt(18410609840987260525);
        assert!(r == 4290758655, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_121() {
        let r = sqrt(18410609835457409024);
        assert!(r == 4290758654, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_122() {
        let r = sqrt(16223653421047273325);
        assert!(r == 4027859657, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_123() {
        let r = sqrt(16223653416488157648);
        assert!(r == 4027859656, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_124() {
        let r = sqrt(11499311541250663146);
        assert!(r == 3391063482, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_125() {
        let r = sqrt(11499311538953964323);
        assert!(r == 3391063481, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_126() {
        let r = sqrt(6691450097593444516);
        assert!(r == 2586783736, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_127() {
        let r = sqrt(6691450096834117695);
        assert!(r == 2586783735, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_128() {
        let r = sqrt(11452572414278503431);
        assert!(r == 3384164950, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_129() {
        let r = sqrt(11452572408808502499);
        assert!(r == 3384164949, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_130() {
        let r = sqrt(2983335422402563632);
        assert!(r == 1727233459, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_131() {
        let r = sqrt(2983335421889104680);
        assert!(r == 1727233458, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_132() {
        let r = sqrt(10265589400766033600);
        assert!(r == 3203995849, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_133() {
        let r = sqrt(10265589400409230800);
        assert!(r == 3203995848, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_134() {
        let r = sqrt(16458280031924443335);
        assert!(r == 4056880578, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_135() {
        let r = sqrt(16458280024153614083);
        assert!(r == 4056880577, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_136() {
        let r = sqrt(11397677413748061585);
        assert!(r == 3376044640, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_137() {
        let r = sqrt(11397677411272729599);
        assert!(r == 3376044639, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_138() {
        let r = sqrt(260101872073892018);
        assert!(r == 510001835, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_139() {
        let r = sqrt(260101871703367224);
        assert!(r == 510001834, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_140() {
        let r = sqrt(8318806587974000740);
        assert!(r == 2884234142, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_141() {
        let r = sqrt(8318806585878476163);
        assert!(r == 2884234141, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_142() {
        let r = sqrt(16635052120249071359);
        assert!(r == 4078609091, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_143() {
        let r = sqrt(16635052117187846280);
        assert!(r == 4078609090, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_144() {
        let r = sqrt(8405140618506968395);
        assert!(r == 2899162054, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_145() {
        let r = sqrt(8405140615353498915);
        assert!(r == 2899162053, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_146() {
        let r = sqrt(15657569568496248374);
        assert!(r == 3956964691, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_147() {
        let r = sqrt(15657569565820725480);
        assert!(r == 3956964690, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_148() {
        let r = sqrt(17854692405062959884);
        assert!(r == 4225481322, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_149() {
        let r = sqrt(17854692402570867683);
        assert!(r == 4225481321, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_150() {
        let r = sqrt(1073273973791335576);
        assert!(r == 1035989369, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_151() {
        let r = sqrt(1073273972681018160);
        assert!(r == 1035989368, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_152() {
        let r = sqrt(9043412245169829692);
        assert!(r == 3007226670, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_153() {
        let r = sqrt(9043412244759288899);
        assert!(r == 3007226669, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_154() {
        let r = sqrt(10319247900760022565);
        assert!(r == 3212358619, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_155() {
        let r = sqrt(10319247897063587160);
        assert!(r == 3212358618, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_156() {
        let r = sqrt(1135614103155420740);
        assert!(r == 1065651961, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_157() {
        let r = sqrt(1135614101983145520);
        assert!(r == 1065651960, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_158() {
        let r = sqrt(7918383928991315088);
        assert!(r == 2813962318, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_159() {
        let r = sqrt(7918383927123933123);
        assert!(r == 2813962317, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_160() {
        let r = sqrt(266751914043672893);
        assert!(r == 516480313, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_161() {
        let r = sqrt(266751913716577968);
        assert!(r == 516480312, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_162() {
        let r = sqrt(2574016966663937194);
        assert!(r == 1604374322, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_163() {
        let r = sqrt(2574016965092959683);
        assert!(r == 1604374321, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_164() {
        let r = sqrt(986128679626921844);
        assert!(r == 993040119, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_165() {
        let r = sqrt(986128677943534160);
        assert!(r == 993040118, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_166() {
        let r = sqrt(5790223617635911539);
        assert!(r == 2406288348, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_167() {
        let r = sqrt(5790223613720569103);
        assert!(r == 2406288347, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_168() {
        let r = sqrt(6879770467356506482);
        assert!(r == 2622931655, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_169() {
        let r = sqrt(6879770466801039024);
        assert!(r == 2622931654, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_170() {
        let r = sqrt(8164215293865182704);
        assert!(r == 2857309100, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_171() {
        let r = sqrt(8164215292942809999);
        assert!(r == 2857309099, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_172() {
        let r = sqrt(13706783587682672777);
        assert!(r == 3702267357, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_173() {
        let r = sqrt(13706783582707765448);
        assert!(r == 3702267356, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_174() {
        let r = sqrt(6009313349121124750);
        assert!(r == 2451390085, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_175() {
        let r = sqrt(6009313348836307224);
        assert!(r == 2451390084, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_176() {
        let r = sqrt(10486402175272827125);
        assert!(r == 3238271479, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_177() {
        let r = sqrt(10486402171704847440);
        assert!(r == 3238271478, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_178() {
        let r = sqrt(15860866628472408611);
        assert!(r == 3982570354, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_179() {
        let r = sqrt(15860866624559685315);
        assert!(r == 3982570353, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_180() {
        let r = sqrt(7071039217554376382);
        assert!(r == 2659142571, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_181() {
        let r = sqrt(7071039212904490040);
        assert!(r == 2659142570, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_182() {
        let r = sqrt(1242827666987958501);
        assert!(r == 1114821809, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_183() {
        let r = sqrt(1242827665822032480);
        assert!(r == 1114821808, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_184() {
        let r = sqrt(11807970463115510425);
        assert!(r == 3436272757, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_185() {
        let r = sqrt(11807970460500381048);
        assert!(r == 3436272756, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_186() {
        let r = sqrt(14747531781802156884);
        assert!(r == 3840251525, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_187() {
        let r = sqrt(14747531775264825624);
        assert!(r == 3840251524, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_188() {
        let r = sqrt(16911173356855887142);
        assert!(r == 4112319705, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_189() {
        let r = sqrt(16911173356131287024);
        assert!(r == 4112319704, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_190() {
        let r = sqrt(14272393660513998954);
        assert!(r == 3777882166, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_191() {
        let r = sqrt(14272393660180851555);
        assert!(r == 3777882165, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_192() {
        let r = sqrt(4536460161120089228);
        assert!(r == 2129896748, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_193() {
        let r = sqrt(4536460157140975503);
        assert!(r == 2129896747, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_194() {
        let r = sqrt(10105601398949542007);
        assert!(r == 3178930857, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_195() {
        let r = sqrt(10105601393586754448);
        assert!(r == 3178930856, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_196() {
        let r = sqrt(16972922289390777616);
        assert!(r == 4119820662, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_197() {
        let r = sqrt(16972922287042118243);
        assert!(r == 4119820661, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_198() {
        let r = sqrt(17418948224970869271);
        assert!(r == 4173601349, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_199() {
        let r = sqrt(17418948220374619800);
        assert!(r == 4173601348, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_200() {
        let r = sqrt(861108109478428228);
        assert!(r == 927959109, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_201() {
        let r = sqrt(861108107976073880);
        assert!(r == 927959108, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_202() {
        let r = sqrt(7666151108370003652);
        assert!(r == 2768781520, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_203() {
        let r = sqrt(7666151105493510399);
        assert!(r == 2768781519, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_204() {
        let r = sqrt(15984083116374969782);
        assert!(r == 3998009894, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_205() {
        let r = sqrt(15984083112521891235);
        assert!(r == 3998009893, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_206() {
        let r = sqrt(16574394254472016675);
        assert!(r == 4071166203, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_207() {
        let r = sqrt(16574394252449437208);
        assert!(r == 4071166202, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_208() {
        let r = sqrt(6583819485477488980);
        assert!(r == 2565895454, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_209() {
        let r = sqrt(6583819480857866115);
        assert!(r == 2565895453, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_210() {
        let r = sqrt(5306535835565780460);
        assert!(r == 2303591942, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_211() {
        let r = sqrt(5306535835247331363);
        assert!(r == 2303591941, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_212() {
        let r = sqrt(6551497938745735900);
        assert!(r == 2559589408, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_213() {
        let r = sqrt(6551497937545790463);
        assert!(r == 2559589407, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_214() {
        let r = sqrt(1897892353744124021);
        assert!(r == 1377640139, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_215() {
        let r = sqrt(1897892352583939320);
        assert!(r == 1377640138, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_216() {
        let r = sqrt(1484550548572020781);
        assert!(r == 1218421334, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_217() {
        let r = sqrt(1484550547146339555);
        assert!(r == 1218421333, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_218() {
        let r = sqrt(16469004365867928669);
        assert!(r == 4058202110, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_219() {
        let r = sqrt(16469004365608452099);
        assert!(r == 4058202109, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_220() {
        let r = sqrt(13315483524349927670);
        assert!(r == 3649038712, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_221() {
        let r = sqrt(13315483521674618943);
        assert!(r == 3649038711, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_222() {
        let r = sqrt(17416604835416710962);
        assert!(r == 4173320600, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_223() {
        let r = sqrt(17416604830384359999);
        assert!(r == 4173320599, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_224() {
        let r = sqrt(803154501943945800);
        assert!(r == 896188876, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_225() {
        let r = sqrt(803154501466143375);
        assert!(r == 896188875, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_226() {
        let r = sqrt(12437813085337348224);
        assert!(r == 3526728382, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_227() {
        let r = sqrt(12437813080404337923);
        assert!(r == 3526728381, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_228() {
        let r = sqrt(3218160962163258138);
        assert!(r == 1793923343, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_229() {
        let r = sqrt(3218160960560295648);
        assert!(r == 1793923342, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_230() {
        let r = sqrt(156265679028242547);
        assert!(r == 395304539, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_231() {
        let r = sqrt(156265678554002520);
        assert!(r == 395304538, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_232() {
        let r = sqrt(8981421763771673833);
        assert!(r == 2996902027, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_233() {
        let r = sqrt(8981421759436708728);
        assert!(r == 2996902026, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_234() {
        let r = sqrt(16200993827966093735);
        assert!(r == 4025045816, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_235() {
        let r = sqrt(16200993820899105855);
        assert!(r == 4025045815, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_236() {
        let r = sqrt(2450283149329224687);
        assert!(r == 1565338030, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_237() {
        let r = sqrt(2450283148164280899);
        assert!(r == 1565338029, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_238() {
        let r = sqrt(15494756743591720788);
        assert!(r == 3936337986, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_239() {
        let r = sqrt(15494756740026536195);
        assert!(r == 3936337985, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_240() {
        let r = sqrt(7431693154175257823);
        assert!(r == 2726113195, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_241() {
        let r = sqrt(7431693151953108024);
        assert!(r == 2726113194, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_242() {
        let r = sqrt(7946439096103771021);
        assert!(r == 2818942904, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_243() {
        let r = sqrt(7946439096011953215);
        assert!(r == 2818942903, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_244() {
        let r = sqrt(6902587352849850500);
        assert!(r == 2627277555, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_245() {
        let r = sqrt(6902587351006778024);
        assert!(r == 2627277554, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_246() {
        let r = sqrt(8180448404704891824);
        assert!(r == 2860148318, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_247() {
        let r = sqrt(8180448400958229123);
        assert!(r == 2860148317, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_248() {
        let r = sqrt(7889410492249049875);
        assert!(r == 2808809443, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_249() {
        let r = sqrt(7889410487085970248);
        assert!(r == 2808809442, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_250() {
        let r = sqrt(8867633024253966075);
        assert!(r == 2977857119, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_251() {
        let r = sqrt(8867633021178980160);
        assert!(r == 2977857118, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_252() {
        let r = sqrt(3217564335414712003);
        assert!(r == 1793757044, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_253() {
        let r = sqrt(3217564332899617935);
        assert!(r == 1793757043, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_254() {
        let r = sqrt(362687131563071384);
        assert!(r == 602235113, (r as u64));
    }
    #[test]
    fun test_sqrt_u64_255() {
        let r = sqrt(362687131330122768);
        assert!(r == 602235112, (r as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: more-math -t
// Version: v1.4.0
module more_math::more_math_u128 {
    const E_WIDTH_OVERFLOW_U8: u64 = 1;
    const HALF_SIZE: u8 = 64;
    const MAX_SHIFT_SIZE: u8 = 127;

    const ALL_ONES: u128 = 340282366920938463463374607431768211455;
    const LOWER_ONES: u128 = (1 << 64) - 1;
    const UPPER_ONES: u128 = ((1 << 64) - 1) << 64;
    /// add two u128 with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun add_with_carry(x: u128, y: u128):(u128, u128) {
        let r = ALL_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun sub_with_borrow(x: u128, y:u128): (u128, u128) {
        if (x < y) {
            ((ALL_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun mul_with_carry(x: u128, y: u128):(u128, u128) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UPPER_ONES) >> HALF_SIZE;
        let xl = x & LOWER_ONES;
        let yh = (y & UPPER_ONES) >> HALF_SIZE;
        let yl = y & LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = add_with_carry(xl * yl, (xhyl & LOWER_ONES) << HALF_SIZE);
        let (lo, lo_carry_2) = add_with_carry(lo, (xlyh & LOWER_ONES)<< HALF_SIZE);
        let hi = xh * yh + (xhyl >> HALF_SIZE) + (xlyh >> HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    /// count leading zeros u128
    public fun leading_zeros(x: u128): u8 {
        if (x == 0) {
            128
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

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: u128): u128 {
        if (x == 0) {
            0
        } else if (x <= 3) {
            1
        } else {
            // reproduced from golang's big.Int.Sqrt
            let n = (MAX_SHIFT_SIZE - leading_zeros(x)) >> 1;
            let z = x >> ((n - 1) / 2);
            let z_next = (z + x / z) >> 1;
            while (z_next < z) {
                z = z_next;
                z_next = (z + x / z) >> 1;
            };
            z
        }
    }


    #[test]
    fun test_sqrt_u128_0() {
        let r = sqrt(18492250353578189975680295581641105397);
        assert!(r == 4300261661059497664, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_1() {
        let r = sqrt(18492250353578189967840059780021456895);
        assert!(r == 4300261661059497663, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_2() {
        let r = sqrt(56947765849781817395417809932869937183);
        assert!(r == 7546374351288293821, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_3() {
        let r = sqrt(56947765849781817393775483669226780040);
        assert!(r == 7546374351288293820, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_4() {
        let r = sqrt(145025641104908291896302705302038228421);
        assert!(r == 12042659220658379648, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_5() {
        let r = sqrt(145025641104908291876928572880900603903);
        assert!(r == 12042659220658379647, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_6() {
        let r = sqrt(96920622611153504301763552068877828355);
        assert!(r == 9844827200675159859, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_7() {
        let r = sqrt(96920622611153504288918570435204899880);
        assert!(r == 9844827200675159858, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_8() {
        let r = sqrt(28468594120370382523688750561876262696);
        assert!(r == 5335596885107642998, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_9() {
        let r = sqrt(28468594120370382514653309475018428003);
        assert!(r == 5335596885107642997, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_10() {
        let r = sqrt(293133462129890163636492390750133409204);
        assert!(r == 17121140795224194512, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_11() {
        let r = sqrt(293133462129890163635886897259210918143);
        assert!(r == 17121140795224194511, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_12() {
        let r = sqrt(237260912323323590885087760303408487182);
        assert!(r == 15403276025681146991, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_13() {
        let r = sqrt(237260912323323590857406342773348354080);
        assert!(r == 15403276025681146990, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_14() {
        let r = sqrt(156212117278865707750073837053894483966);
        assert!(r == 12498484599297056690, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_15() {
        let r = sqrt(156212117278865707731078077297073756099);
        assert!(r == 12498484599297056689, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_16() {
        let r = sqrt(167514428714335727810876388948289234303);
        assert!(r == 12942736523407085405, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_17() {
        let r = sqrt(167514428714335727807713212156964014024);
        assert!(r == 12942736523407085404, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_18() {
        let r = sqrt(175092996854991945012855171849132883780);
        assert!(r == 13232271039205323994, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_19() {
        let r = sqrt(175092996854991944999878177474512112035);
        assert!(r == 13232271039205323993, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_20() {
        let r = sqrt(325985144756806677229463319415862295277);
        assert!(r == 18055058702668531540, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_21() {
        let r = sqrt(325985144756806677202123856579974771599);
        assert!(r == 18055058702668531539, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_22() {
        let r = sqrt(12180447255442901099403453713660062840);
        assert!(r == 3490049749708863548, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_23() {
        let r = sqrt(12180447255442901097047786433683148303);
        assert!(r == 3490049749708863547, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_24() {
        let r = sqrt(199897201075713498937460414977318231213);
        assert!(r == 14138500665760620140, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_25() {
        let r = sqrt(199897201075713498935983329197373619599);
        assert!(r == 14138500665760620139, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_26() {
        let r = sqrt(197987888915171223107097375777913380141);
        assert!(r == 14070816924229069902, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_27() {
        let r = sqrt(197987888915171223083733715916002289603);
        assert!(r == 14070816924229069901, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_28() {
        let r = sqrt(334866646453968763707538295936532790744);
        assert!(r == 18299361913847399605, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_29() {
        let r = sqrt(334866646453968763683374574820554156024);
        assert!(r == 18299361913847399604, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_30() {
        let r = sqrt(156840093530470397084497981180189273832);
        assert!(r == 12523581497737394334, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_31() {
        let r = sqrt(156840093530470397084093826399815303555);
        assert!(r == 12523581497737394333, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_32() {
        let r = sqrt(181995338916745901704671467512615368272);
        assert!(r == 13490564810887122442, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_33() {
        let r = sqrt(181995338916745901697199918267100043363);
        assert!(r == 13490564810887122441, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_34() {
        let r = sqrt(10469790972666456419007575997106475499);
        assert!(r == 3235705637518106562, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_35() {
        let r = sqrt(10469790972666456415728614397587459843);
        assert!(r == 3235705637518106561, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_36() {
        let r = sqrt(55886401838727899950215427426682929895);
        assert!(r == 7475720824022784490, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_37() {
        let r = sqrt(55886401838727899948714958652984560099);
        assert!(r == 7475720824022784489, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_38() {
        let r = sqrt(195918921982792724159504324536571053878);
        assert!(r == 13997104057010961728, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_39() {
        let r = sqrt(195918921982792724143921181151480745983);
        assert!(r == 13997104057010961727, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_40() {
        let r = sqrt(274268675410288959300781318004185004280);
        assert!(r == 16561059006304184993, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_41() {
        let r = sqrt(274268675410288959271717922425966410048);
        assert!(r == 16561059006304184992, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_42() {
        let r = sqrt(209672121543924582384277802400781468533);
        assert!(r == 14480059445455484123, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_43() {
        let r = sqrt(209672121543924582379794849256305079128);
        assert!(r == 14480059445455484122, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_44() {
        let r = sqrt(336359527326501543040809817853712838840);
        assert!(r == 18340107069657514489, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_45() {
        let r = sqrt(336359527326501543016789970785244931120);
        assert!(r == 18340107069657514488, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_46() {
        let r = sqrt(195341080323406963643766236852278611379);
        assert!(r == 13976447342705046790, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_47() {
        let r = sqrt(195341080323406963632659355336089304099);
        assert!(r == 13976447342705046789, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_48() {
        let r = sqrt(264419542433176401553751028149204232510);
        assert!(r == 16260982209976628639, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_49() {
        let r = sqrt(264419542433176401529111570600514992320);
        assert!(r == 16260982209976628638, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_50() {
        let r = sqrt(190665758182840864265465701837816405068);
        assert!(r == 13808177221590142390, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_51() {
        let r = sqrt(190665758182840864254837264420474912099);
        assert!(r == 13808177221590142389, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_52() {
        let r = sqrt(275436444315612769578570099725167362918);
        assert!(r == 16596278025979583160, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_53() {
        let r = sqrt(275436444315612769569895701167355585599);
        assert!(r == 16596278025979583159, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_54() {
        let r = sqrt(92485862235122804581995425952405651161);
        assert!(r == 9616957015351727388, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_55() {
        let r = sqrt(92485862235122804567912165795469302543);
        assert!(r == 9616957015351727387, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_56() {
        let r = sqrt(79726103178080704455202466513427543303);
        assert!(r == 8928947484338829084, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_57() {
        let r = sqrt(79726103178080704450290454460164279055);
        assert!(r == 8928947484338829083, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_58() {
        let r = sqrt(171278963327241351241006694949980137482);
        assert!(r == 13087358913365268872, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_59() {
        let r = sqrt(171278963327241351224354733620852152383);
        assert!(r == 13087358913365268871, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_60() {
        let r = sqrt(163476784497793050376201809790624086514);
        assert!(r == 12785804022344197121, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_61() {
        let r = sqrt(163476784497793050352203712982104688640);
        assert!(r == 12785804022344197120, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_62() {
        let r = sqrt(199285876826573859818017818619290222815);
        assert!(r == 14116864978690341636, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_63() {
        let r = sqrt(199285876826573859812683819590395156495);
        assert!(r == 14116864978690341635, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_64() {
        let r = sqrt(171587028430705679644212200059219022533);
        assert!(r == 13099123193202882449, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_65() {
        let r = sqrt(171587028430705679635338240602112237600);
        assert!(r == 13099123193202882448, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_66() {
        let r = sqrt(9698463801407140267012496975067102897);
        assert!(r == 3114235668893274407, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_67() {
        let r = sqrt(9698463801407140263979836918201201648);
        assert!(r == 3114235668893274406, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_68() {
        let r = sqrt(205056470775989949705581193102768149150);
        assert!(r == 14319792972525473969, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_69() {
        let r = sqrt(205056470775989949680786414628096612960);
        assert!(r == 14319792972525473968, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_70() {
        let r = sqrt(144101873124355142229653355983090558342);
        assert!(r == 12004243963047199842, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_71() {
        let r = sqrt(144101873124355142205768335517084824963);
        assert!(r == 12004243963047199841, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_72() {
        let r = sqrt(57087203793161979424003407354208355222);
        assert!(r == 7555607440382406435, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_73() {
        let r = sqrt(57087203793161979410925987481529409224);
        assert!(r == 7555607440382406434, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_74() {
        let r = sqrt(19937755547436261741528440164500424336);
        assert!(r == 4465171390600394606, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_75() {
        let r = sqrt(19937755547436261735203518362913895235);
        assert!(r == 4465171390600394605, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_76() {
        let r = sqrt(284362045365210808558158514019807738854);
        assert!(r == 16863037845098101082, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_77() {
        let r = sqrt(284362045365210808541812520402289570723);
        assert!(r == 16863037845098101081, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_78() {
        let r = sqrt(256155421973807908877864428202528041542);
        assert!(r == 16004856199722880011, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_79() {
        let r = sqrt(256155421973807908851895631888303360120);
        assert!(r == 16004856199722880010, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_80() {
        let r = sqrt(227533812236243622713555921651632440451);
        assert!(r == 15084223952071370075, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_81() {
        let r = sqrt(227533812236243622693547166487605505624);
        assert!(r == 15084223952071370074, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_82() {
        let r = sqrt(215670276065157142284043872287313038004);
        assert!(r == 14685716736515012268, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_83() {
        let r = sqrt(215670276065157142263091072132190503823);
        assert!(r == 14685716736515012267, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_84() {
        let r = sqrt(299273582598621482168731750315835970482);
        assert!(r == 17299525502123504259, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_85() {
        let r = sqrt(299273582598621482160367479337991139080);
        assert!(r == 17299525502123504258, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_86() {
        let r = sqrt(197270249810920402317279111408756957930);
        assert!(r == 14045292799045536534, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_87() {
        let r = sqrt(197270249810920402307165310907928733155);
        assert!(r == 14045292799045536533, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_88() {
        let r = sqrt(277414029805458593025594695957361418833);
        assert!(r == 16655750652716274169, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_89() {
        let r = sqrt(277414029805458593019178065061176640560);
        assert!(r == 16655750652716274168, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_90() {
        let r = sqrt(211262672311821475004991939429410166028);
        assert!(r == 14534877787990564147, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_91() {
        let r = sqrt(211262672311821475003639022707321837608);
        assert!(r == 14534877787990564146, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_92() {
        let r = sqrt(332224176852299617725778644295082793461);
        assert!(r == 18227017771766713722, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_93() {
        let r = sqrt(332224176852299617713914957255503093283);
        assert!(r == 18227017771766713721, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_94() {
        let r = sqrt(189366700441716417529360535257777619670);
        assert!(r == 13761057388213901985, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_95() {
        let r = sqrt(189366700441716417526029984419186940224);
        assert!(r == 13761057388213901984, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_96() {
        let r = sqrt(210250038286110264202783028868594751141);
        assert!(r == 14500001320210638663, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_97() {
        let r = sqrt(210250038286110264183130438966350427568);
        assert!(r == 14500001320210638662, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_98() {
        let r = sqrt(317919365250331590549895251557026422962);
        assert!(r == 17830293470673206800, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_99() {
        let r = sqrt(317919365250331590520452399395566239999);
        assert!(r == 17830293470673206799, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_100() {
        let r = sqrt(153454896127045373903403269625877069621);
        assert!(r == 12387691315456862557, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_101() {
        let r = sqrt(153454896127045373884203908305988578248);
        assert!(r == 12387691315456862556, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_102() {
        let r = sqrt(306862549115054068505180320159273216905);
        assert!(r == 17517492660625094964, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_103() {
        let r = sqrt(306862549115054068487736672194018161295);
        assert!(r == 17517492660625094963, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_104() {
        let r = sqrt(288831178646353191020770086347790502618);
        assert!(r == 16995033940723778119, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_105() {
        let r = sqrt(288831178646353190995392572485543178160);
        assert!(r == 16995033940723778118, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_106() {
        let r = sqrt(167575068997512776825502250104504222476);
        assert!(r == 12945078949064496795, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_107() {
        let r = sqrt(167575068997512776807469096746565272024);
        assert!(r == 12945078949064496794, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_108() {
        let r = sqrt(166821511239698946530409422382924857950);
        assert!(r == 12915940199602154651, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_109() {
        let r = sqrt(166821511239698946527094021321720931800);
        assert!(r == 12915940199602154650, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_110() {
        let r = sqrt(135629019871321736997568496074026327589);
        assert!(r == 11645987286242490871, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_111() {
        let r = sqrt(135629019871321736997332934034518338640);
        assert!(r == 11645987286242490870, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_112() {
        let r = sqrt(20948382727403244965044145266138577401);
        assert!(r == 4576940323775616474, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_113() {
        let r = sqrt(20948382727403244959668943118740192675);
        assert!(r == 4576940323775616473, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_114() {
        let r = sqrt(205044570136778365155168174708204394632);
        assert!(r == 14319377435376803599, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_115() {
        let r = sqrt(205044570136778365131036758082219352800);
        assert!(r == 14319377435376803598, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_116() {
        let r = sqrt(146068401815477496587994817568113186861);
        assert!(r == 12085876129411450185, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_117() {
        let r = sqrt(146068401815477496579497558984736534224);
        assert!(r == 12085876129411450184, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_118() {
        let r = sqrt(47482232225435819923815045332423623476);
        assert!(r == 6890735245634954731, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_119() {
        let r = sqrt(47482232225435819913165555700419282360);
        assert!(r == 6890735245634954730, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_120() {
        let r = sqrt(218219886920344015629593310233873056977);
        assert!(r == 14772267494204944014, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_121() {
        let r = sqrt(218219886920344015628246163880874432195);
        assert!(r == 14772267494204944013, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_122() {
        let r = sqrt(207922394730217842975776072261793267557);
        assert!(r == 14419514372204697898, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_123() {
        let r = sqrt(207922394730217842948300281341445618403);
        assert!(r == 14419514372204697897, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_124() {
        let r = sqrt(106810773204078331990462003585855607427);
        assert!(r == 10334929762900100715, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_125() {
        let r = sqrt(106810773204078331981312140957143511224);
        assert!(r == 10334929762900100714, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_126() {
        let r = sqrt(187845260454285267618155545929828985883);
        assert!(r == 13705665268577270620, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_127() {
        let r = sqrt(187845260454285267597874893688715184399);
        assert!(r == 13705665268577270619, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_128() {
        let r = sqrt(292121572598097518885292632179537692144);
        assert!(r == 17091564369539071507, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_129() {
        let r = sqrt(292121572598097518884059266255659251048);
        assert!(r == 17091564369539071506, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_130() {
        let r = sqrt(252845528915704690311283791884275292539);
        assert!(r == 15901117222249029452, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_131() {
        let r = sqrt(252845528915704690300026860355963420303);
        assert!(r == 15901117222249029451, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_132() {
        let r = sqrt(292581347482671000153535008311460928420);
        assert!(r == 17105009426558963465, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_133() {
        let r = sqrt(292581347482671000151541682335204806224);
        assert!(r == 17105009426558963464, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_134() {
        let r = sqrt(272043944497802201772619770685517557898);
        assert!(r == 16493754711944827566, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_135() {
        let r = sqrt(272043944497802201757483025981473484355);
        assert!(r == 16493754711944827565, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_136() {
        let r = sqrt(118304877045221261160189666285523260587);
        assert!(r == 10876804542016063145, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_137() {
        let r = sqrt(118304877045221261140989867204627291024);
        assert!(r == 10876804542016063144, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_138() {
        let r = sqrt(263279193174736384326000975356588257420);
        assert!(r == 16225880351301016059, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_139() {
        let r = sqrt(263279193174736384315217724085775891480);
        assert!(r == 16225880351301016058, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_140() {
        let r = sqrt(80334740475142659063911726948684152491);
        assert!(r == 8962964937739222187, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_141() {
        let r = sqrt(80334740475142659055013363879753062968);
        assert!(r == 8962964937739222186, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_142() {
        let r = sqrt(281588862714997483312275218901856003887);
        assert!(r == 16780609724172643522, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_143() {
        let r = sqrt(281588862714997483304147421641688564483);
        assert!(r == 16780609724172643521, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_144() {
        let r = sqrt(186415442717343418264106860406503337237);
        assert!(r == 13653404070683011110, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_145() {
        let r = sqrt(186415442717343418238724939576383432099);
        assert!(r == 13653404070683011109, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_146() {
        let r = sqrt(312744302659142367055933762072146754511);
        assert!(r == 17684578102378986837, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_147() {
        let r = sqrt(312744302659142367041256517770619264568);
        assert!(r == 17684578102378986836, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_148() {
        let r = sqrt(221508824179123254738976452640815469441);
        assert!(r == 14883172517280153288, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_149() {
        let r = sqrt(221508824179123254722096057656777210943);
        assert!(r == 14883172517280153287, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_150() {
        let r = sqrt(52638672929115306643158157283580212932);
        assert!(r == 7255251403577639406, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_151() {
        let r = sqrt(52638672929115306630952840519364032835);
        assert!(r == 7255251403577639405, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_152() {
        let r = sqrt(43592588597017312417130412299921945379);
        assert!(r == 6602468371527220910, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_153() {
        let r = sqrt(43592588597017312406887637107941228099);
        assert!(r == 6602468371527220909, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_154() {
        let r = sqrt(97888308476650424394694329229799558076);
        assert!(r == 9893852054515997481, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_155() {
        let r = sqrt(97888308476650424390767605348398345360);
        assert!(r == 9893852054515997480, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_156() {
        let r = sqrt(27385124033993188204054875381602631744);
        assert!(r == 5233079784791474799, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_157() {
        let r = sqrt(27385124033993188197011159189452090400);
        assert!(r == 5233079784791474798, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_158() {
        let r = sqrt(245627316791379202289857812257618285710);
        assert!(r == 15672501931452399801, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_159() {
        let r = sqrt(245627316791379202270717697041944839600);
        assert!(r == 15672501931452399800, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_160() {
        let r = sqrt(6894339006499970768427263855965770905);
        assert!(r == 2625707334510068882, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_161() {
        let r = sqrt(6894339006499970764885331440384729923);
        assert!(r == 2625707334510068881, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_162() {
        let r = sqrt(148465833590867583037725128344815528520);
        assert!(r == 12184655661563341160, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_163() {
        let r = sqrt(148465833590867583029853966782550145599);
        assert!(r == 12184655661563341159, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_164() {
        let r = sqrt(59364591657028510642829200753750126368);
        assert!(r == 7704842091634877278, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_165() {
        let r = sqrt(59364591657028510629710885754120689283);
        assert!(r == 7704842091634877277, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_166() {
        let r = sqrt(45199746163799251793732497495504023826);
        assert!(r == 6723075647633250585, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_167() {
        let r = sqrt(45199746163799251782325013293402842224);
        assert!(r == 6723075647633250584, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_168() {
        let r = sqrt(146585928303146124186982846965858876159);
        assert!(r == 12107267582041214809, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_169() {
        let r = sqrt(146585928303146124165809742336480906480);
        assert!(r == 12107267582041214808, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_170() {
        let r = sqrt(327342407549098643829534667581775718377);
        assert!(r == 18092606433267116304, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_171() {
        let r = sqrt(327342407549098643809290518383862620415);
        assert!(r == 18092606433267116303, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_172() {
        let r = sqrt(59353585836090550622231084124394799012);
        assert!(r == 7704127843960700437, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_173() {
        let r = sqrt(59353585836090550620870880111651990968);
        assert!(r == 7704127843960700436, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_174() {
        let r = sqrt(231459205265503583112981115494471532570);
        assert!(r == 15213783397482152371, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_175() {
        let r = sqrt(231459205265503583082720439482860921640);
        assert!(r == 15213783397482152370, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_176() {
        let r = sqrt(233488612633338160270109398678717999578);
        assert!(r == 15280334179373766571, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_177() {
        let r = sqrt(233488612633338160260777561867597098040);
        assert!(r == 15280334179373766570, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_178() {
        let r = sqrt(34690663782046849162854187498108266180);
        assert!(r == 5889878078708153459, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_179() {
        let r = sqrt(34690663782046849152549424925493664680);
        assert!(r == 5889878078708153458, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_180() {
        let r = sqrt(249613643435605190449621219208617159896);
        assert!(r == 15799165909490449757, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_181() {
        let r = sqrt(249613643435605190442984009190141359048);
        assert!(r == 15799165909490449756, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_182() {
        let r = sqrt(275820400141735638491496533236944060394);
        assert!(r == 16607841525669000629, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_183() {
        let r = sqrt(275820400141735638478562200291602395640);
        assert!(r == 16607841525669000628, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_184() {
        let r = sqrt(294685589056450997574224658349809474024);
        assert!(r == 17166408740806884258, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_185() {
        let r = sqrt(294685589056450997558050292045808210563);
        assert!(r == 17166408740806884257, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_186() {
        let r = sqrt(76178554693383818599803567503036625910);
        assert!(r == 8728032693189446262, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_187() {
        let r = sqrt(76178554693383818585641177018185772643);
        assert!(r == 8728032693189446261, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_188() {
        let r = sqrt(254754052129766864575140561424511041196);
        assert!(r == 15961016638352547766, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_189() {
        let r = sqrt(254754052129766864561755751343311590755);
        assert!(r == 15961016638352547765, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_190() {
        let r = sqrt(195567928239636814174494341766255059127);
        assert!(r == 13984560352032408965, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_191() {
        let r = sqrt(195567928239636814157977761701012371224);
        assert!(r == 13984560352032408964, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_192() {
        let r = sqrt(25767894314431537300690199714869399422);
        assert!(r == 5076208655525453999, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_193() {
        let r = sqrt(25767894314431537300332424595065092000);
        assert!(r == 5076208655525453998, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_194() {
        let r = sqrt(3510456662949394108742886524685180106);
        assert!(r == 1873621269880707270, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_195() {
        let r = sqrt(3510456662949394107445496555430852899);
        assert!(r == 1873621269880707269, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_196() {
        let r = sqrt(41535317611361882150070362481323615128);
        assert!(r == 6444789958669086226, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_197() {
        let r = sqrt(41535317611361882145169513393822923075);
        assert!(r == 6444789958669086225, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_198() {
        let r = sqrt(234490510422535680539846474166449213544);
        assert!(r == 15313082982291178080, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_199() {
        let r = sqrt(234490510422535680527243653794272486399);
        assert!(r == 15313082982291178079, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_200() {
        let r = sqrt(109414945632972826465005592535117995820);
        assert!(r == 10460159923871758207, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_201() {
        let r = sqrt(109414945632972826448575438493471854848);
        assert!(r == 10460159923871758206, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_202() {
        let r = sqrt(280376698140451382654795368384434102162);
        assert!(r == 16744452757270133689, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_203() {
        let r = sqrt(280376698140451382636142233355932748720);
        assert!(r == 16744452757270133688, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_204() {
        let r = sqrt(257282340033174402558922234361303756274);
        assert!(r == 16040023068349197438, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_205() {
        let r = sqrt(257282340033174402545734938418705763843);
        assert!(r == 16040023068349197437, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_206() {
        let r = sqrt(288927200013323473999272704635730306934);
        assert!(r == 16997858689062086505, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_207() {
        let r = sqrt(288927200013323473997971638624103115024);
        assert!(r == 16997858689062086504, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_208() {
        let r = sqrt(282432005169813731099846527204195568693);
        assert!(r == 16805713468038592353, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_209() {
        let r = sqrt(282432005169813731077149309777710076608);
        assert!(r == 16805713468038592352, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_210() {
        let r = sqrt(180589731233861041411206664764717438279);
        assert!(r == 13438367878349700894, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_211() {
        let r = sqrt(180589731233861041405797256579264399235);
        assert!(r == 13438367878349700893, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_212() {
        let r = sqrt(338475610822272246876655886196628543443);
        assert!(r == 18397706672905518603, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_213() {
        let r = sqrt(338475610822272246872886402372379071608);
        assert!(r == 18397706672905518602, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_214() {
        let r = sqrt(111345328149917943331027299516612809782);
        assert!(r == 10552029574916758322, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_215() {
        let r = sqrt(111345328149917943328749675476956255683);
        assert!(r == 10552029574916758321, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_216() {
        let r = sqrt(33611495743719437258229754174756271769);
        assert!(r == 5797542215777254455, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_217() {
        let r = sqrt(33611495743719437254922760137817347024);
        assert!(r == 5797542215777254454, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_218() {
        let r = sqrt(83099576673115612779873092278421291580);
        assert!(r == 9115896920935186440, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_219() {
        let r = sqrt(83099576673115612776918103277559873599);
        assert!(r == 9115896920935186439, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_220() {
        let r = sqrt(221673218756985729909762753933774822065);
        assert!(r == 14888694326803332216, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_221() {
        let r = sqrt(221673218756985729889149755481263470655);
        assert!(r == 14888694326803332215, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_222() {
        let r = sqrt(62912421535409243264924413214283283573);
        assert!(r == 7931735089840636077, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_223() {
        let r = sqrt(62912421535409243259747080719953949928);
        assert!(r == 7931735089840636076, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_224() {
        let r = sqrt(78351321492748854956593737276075026640);
        assert!(r == 8851628183150761724, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_225() {
        let r = sqrt(78351321492748854939174864081423452175);
        assert!(r == 8851628183150761723, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_226() {
        let r = sqrt(8375040562428547176432765349438079466);
        assert!(r == 2893966233809328186, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_227() {
        let r = sqrt(8375040562428547173053298788654050595);
        assert!(r == 2893966233809328185, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_228() {
        let r = sqrt(309034942279857987393653906613633629005);
        assert!(r == 17579389701575478396, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_229() {
        let r = sqrt(309034942279857987376911974576262732815);
        assert!(r == 17579389701575478395, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_230() {
        let r = sqrt(338150314451379734369184998045282593929);
        assert!(r == 18388863870597871560, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_231() {
        let r = sqrt(338150314451379734357526524802256833599);
        assert!(r == 18388863870597871559, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_232() {
        let r = sqrt(318655825896642228659292195682730090261);
        assert!(r == 17850933474097152341, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_233() {
        let r = sqrt(318655825896642228628078163845361780280);
        assert!(r == 17850933474097152340, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_234() {
        let r = sqrt(330950294037836182087478705054932747340);
        assert!(r == 18192039303987779755, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_235() {
        let r = sqrt(330950294037836182061311130374387860024);
        assert!(r == 18192039303987779754, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_236() {
        let r = sqrt(69601290501568839350871706912786322742);
        assert!(r == 8342738789005013511, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_237() {
        let r = sqrt(69601290501568839346377581493292547120);
        assert!(r == 8342738789005013510, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_238() {
        let r = sqrt(188447004314279829297311918655051659812);
        assert!(r == 13727600093034464168, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_239() {
        let r = sqrt(188447004314279829280685123026875932223);
        assert!(r == 13727600093034464167, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_240() {
        let r = sqrt(1178389982280207367983151925642534667);
        assert!(r == 1085536725440557063, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_241() {
        let r = sqrt(1178389982280207367883367875759185968);
        assert!(r == 1085536725440557062, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_242() {
        let r = sqrt(242602905879027008904960522604865127138);
        assert!(r == 15575715260591630656, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_243() {
        let r = sqrt(242602905879027008874236047953118990335);
        assert!(r == 15575715260591630655, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_244() {
        let r = sqrt(300366749151172677307833041413329223967);
        assert!(r == 17331091978036833363, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_245() {
        let r = sqrt(300366749151172677288025480724629889768);
        assert!(r == 17331091978036833362, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_246() {
        let r = sqrt(139597120354200033200509054941012075511);
        assert!(r == 11815122528107782310, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_247() {
        let r = sqrt(139597120354200033182013376386348936099);
        assert!(r == 11815122528107782309, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_248() {
        let r = sqrt(58947808744724738181719729685682431515);
        assert!(r == 7677747634868232511, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_249() {
        let r = sqrt(58947808744724738170938085641157365120);
        assert!(r == 7677747634868232510, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_250() {
        let r = sqrt(292898198572262452558490761252609632764);
        assert!(r == 17114268858828368089, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_251() {
        let r = sqrt(292898198572262452541753538414873511920);
        assert!(r == 17114268858828368088, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_252() {
        let r = sqrt(60757250549530392815976426290441252707);
        assert!(r == 7794693743151836803, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_253() {
        let r = sqrt(60757250549530392805625501672745260808);
        assert!(r == 7794693743151836802, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_254() {
        let r = sqrt(148311383473048526289932699272927445634);
        assert!(r == 12178316118127683348, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_255() {
        let r = sqrt(148311383473048526273913509165356489103);
        assert!(r == 12178316118127683347, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_256() {
        let r = sqrt(95578147657910008640300061095838970410);
        assert!(r == 9776407707226106097, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_257() {
        let r = sqrt(95578147657910008627672103125100573408);
        assert!(r == 9776407707226106096, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_258() {
        let r = sqrt(86188500665957398711380428523474531403);
        assert!(r == 9283776207231484030, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_259() {
        let r = sqrt(86188500665957398709082533276145040899);
        assert!(r == 9283776207231484029, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_260() {
        let r = sqrt(178967926327480348508070867715970597474);
        assert!(r == 13377889457140851577, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_261() {
        let r = sqrt(178967926327480348502920086544743386928);
        assert!(r == 13377889457140851576, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_262() {
        let r = sqrt(309122618996359877653924663494168066322);
        assert!(r == 17581883260798880576, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_263() {
        let r = sqrt(309122618996359877652465325694710091775);
        assert!(r == 17581883260798880575, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_264() {
        let r = sqrt(25375143240147889463984996460814820094);
        assert!(r == 5037374637660761624, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_265() {
        let r = sqrt(25375143240147889461117666899751117375);
        assert!(r == 5037374637660761623, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_266() {
        let r = sqrt(202349374570826504093255329192065250583);
        assert!(r == 14224956048115807942, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_267() {
        let r = sqrt(202349374570826504073932077911430275363);
        assert!(r == 14224956048115807941, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_268() {
        let r = sqrt(253176612504005007393924084782850171032);
        assert!(r == 15911524518537028210, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_269() {
        let r = sqrt(253176612504005007384833704858335804099);
        assert!(r == 15911524518537028209, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_270() {
        let r = sqrt(184831506404784995859941038062364770059);
        assert!(r == 13595275150021238016, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_271() {
        let r = sqrt(184831506404784995842320655853323616255);
        assert!(r == 13595275150021238015, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_272() {
        let r = sqrt(259686416450474572977900395346942959639);
        assert!(r == 16114788749793606058, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_273() {
        let r = sqrt(259686416450474572950823093459294299363);
        assert!(r == 16114788749793606057, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_274() {
        let r = sqrt(70815966334312333124835696301034998978);
        assert!(r == 8415222298567776582, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_275() {
        let r = sqrt(70815966334312333110579621119067602723);
        assert!(r == 8415222298567776581, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_276() {
        let r = sqrt(305389287221009010472141166749673965812);
        assert!(r == 17475390903239017688, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_277() {
        let r = sqrt(305389287221009010470119713983176865343);
        assert!(r == 17475390903239017687, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_278() {
        let r = sqrt(264558209637481844156632611070004338574);
        assert!(r == 16265245452727783663, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_279() {
        let r = sqrt(264558209637481844133830970412129697568);
        assert!(r == 16265245452727783662, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_280() {
        let r = sqrt(321169484298481656731391523552123026679);
        assert!(r == 17921202088545334428, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_281() {
        let r = sqrt(321169484298481656723761160966362087183);
        assert!(r == 17921202088545334427, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_282() {
        let r = sqrt(121714559610392002720670257840359680607);
        assert!(r == 11032432171121289188, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_283() {
        let r = sqrt(121714559610392002720386045363125699343);
        assert!(r == 11032432171121289187, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_284() {
        let r = sqrt(232890439755066997064140210687413155041);
        assert!(r == 15260748335355871304, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_285() {
        let r = sqrt(232890439755066997045111202065010660415);
        assert!(r == 15260748335355871303, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_286() {
        let r = sqrt(265775028079260380905974466300317217144);
        assert!(r == 16302608014647852070, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_287() {
        let r = sqrt(265775028079260380892956690264603284899);
        assert!(r == 16302608014647852069, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_288() {
        let r = sqrt(324677276003099525044948782173831374921);
        assert!(r == 18018803400978088396, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_289() {
        let r = sqrt(324677276003099525031647349710389852815);
        assert!(r == 18018803400978088395, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_290() {
        let r = sqrt(163061230977606513099181831702068716647);
        assert!(r == 12769543099798305355, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_291() {
        let r = sqrt(163061230977606513075307281729821676024);
        assert!(r == 12769543099798305354, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_292() {
        let r = sqrt(37610863929783033054582933149432500009);
        assert!(r == 6132769678520711660, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_293() {
        let r = sqrt(37610863929783033043129231592859955599);
        assert!(r == 6132769678520711659, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_294() {
        let r = sqrt(241209067956865933364473970213079089477);
        assert!(r == 15530906862024056751, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_295() {
        let r = sqrt(241209067956865933362367229451268676000);
        assert!(r == 15530906862024056750, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_296() {
        let r = sqrt(252351432720070277872338875645335180054);
        assert!(r == 15885573100145624833, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_297() {
        let r = sqrt(252351432720070277859614791191986277888);
        assert!(r == 15885573100145624832, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_298() {
        let r = sqrt(236230402145135878676186230266231872142);
        assert!(r == 15369788617451310890, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_299() {
        let r = sqrt(236230402145135878648903959779432592099);
        assert!(r == 15369788617451310889, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_300() {
        let r = sqrt(330304945203672146316223447480330894884);
        assert!(r == 18174293526948224853, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_301() {
        let r = sqrt(330304945203672146291039533727846871608);
        assert!(r == 18174293526948224852, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_302() {
        let r = sqrt(80638674088743679022580578942528617616);
        assert!(r == 8979903901977107406, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_303() {
        let r = sqrt(80638674088743679015625520494860048835);
        assert!(r == 8979903901977107405, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_304() {
        let r = sqrt(6320022651506812952592955089132703172);
        assert!(r == 2513965523134080880, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_305() {
        let r = sqrt(6320022651506812948244978162381574399);
        assert!(r == 2513965523134080879, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_306() {
        let r = sqrt(148068507505515820412559026994337413901);
        assert!(r == 12168340375972222959, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_307() {
        let r = sqrt(148068507505515820396948556732006715680);
        assert!(r == 12168340375972222958, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_308() {
        let r = sqrt(241713038036618318617330941601736394232);
        assert!(r == 15547123143418473567, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_309() {
        let r = sqrt(241713038036618318605654042288277703488);
        assert!(r == 15547123143418473566, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_310() {
        let r = sqrt(320211771861280005267067917481699211809);
        assert!(r == 17894462044478453816, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_311() {
        let r = sqrt(320211771861280005236666837862044961855);
        assert!(r == 17894462044478453815, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_312() {
        let r = sqrt(74287996061232407817670507222200987904);
        assert!(r == 8619048442910180547, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_313() {
        let r = sqrt(74287996061232407815946544176137219208);
        assert!(r == 8619048442910180546, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_314() {
        let r = sqrt(171676262754066858213556411697727315418);
        assert!(r == 13102528868659929734, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_315() {
        let r = sqrt(171676262754066858205608629477817310755);
        assert!(r == 13102528868659929733, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_316() {
        let r = sqrt(64006830426609916537324547523936959022);
        assert!(r == 8000426890273413187, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_317() {
        let r = sqrt(64006830426609916526785551630825496968);
        assert!(r == 8000426890273413186, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_318() {
        let r = sqrt(100852752221159301834263221553064567016);
        assert!(r == 10042547098279365392, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_319() {
        let r = sqrt(100852752221159301817500509854247313663);
        assert!(r == 10042547098279365391, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_320() {
        let r = sqrt(18074964531148282157296590535634862654);
        assert!(r == 4251466162531260480, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_321() {
        let r = sqrt(18074964531148282152137993217609830399);
        assert!(r == 4251466162531260479, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_322() {
        let r = sqrt(105593960822772179281616895227366848387);
        assert!(r == 10275892215412352177, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_323() {
        let r = sqrt(105593960822772179276115238427876639328);
        assert!(r == 10275892215412352176, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_324() {
        let r = sqrt(174114808313921417118035651512727609339);
        assert!(r == 13195257038569632089, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_325() {
        let r = sqrt(174114808313921417107220265480818503920);
        assert!(r == 13195257038569632088, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_326() {
        let r = sqrt(331054671527652381032794964475461447460);
        assert!(r == 18194907846088486881, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_327() {
        let r = sqrt(331054671527652381006757766580109108160);
        assert!(r == 18194907846088486880, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_328() {
        let r = sqrt(220387597270721870718251605880031244888);
        assert!(r == 14845457125690736732, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_329() {
        let r = sqrt(220387597270721870704614348232934039823);
        assert!(r == 14845457125690736731, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_330() {
        let r = sqrt(192698996274994556769598602734546078201);
        assert!(r == 13881606401097625011, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_331() {
        let r = sqrt(192698996274994556756200121464772750120);
        assert!(r == 13881606401097625010, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_332() {
        let r = sqrt(326669455275982904406979756484216449250);
        assert!(r == 18073999426689791294, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_333() {
        let r = sqrt(326669455275982904380107406517278194435);
        assert!(r == 18073999426689791293, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_334() {
        let r = sqrt(32406632669087657085699617333014667417);
        assert!(r == 5692682379079976132, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_335() {
        let r = sqrt(32406632669087657075760352237689681423);
        assert!(r == 5692682379079976131, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_336() {
        let r = sqrt(205631575115454255573497320126142159506);
        assert!(r == 14339859661637357027, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_337() {
        let r = sqrt(205631575115454255563670599673866278728);
        assert!(r == 14339859661637357026, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_338() {
        let r = sqrt(214906251408543481419081365337175302475);
        assert!(r == 14659681149620665655, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_339() {
        let r = sqrt(214906251408543481406255701045296579024);
        assert!(r == 14659681149620665654, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_340() {
        let r = sqrt(339819803641613464316918544143815346749);
        assert!(r == 18434202007182558384, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_341() {
        let r = sqrt(339819803641613464306488280939568691455);
        assert!(r == 18434202007182558383, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_342() {
        let r = sqrt(212897650211660144418908234349710526846);
        assert!(r == 14591012652028650215, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_343() {
        let r = sqrt(212897650211660144403095861194819546224);
        assert!(r == 14591012652028650214, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_344() {
        let r = sqrt(243158009255641560451884493311391056409);
        assert!(r == 15593524593742158857, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_345() {
        let r = sqrt(243158009255641560426635340171023546448);
        assert!(r == 15593524593742158856, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_346() {
        let r = sqrt(170238942484001453339704379908949540964);
        assert!(r == 13047564618885834563, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_347() {
        let r = sqrt(170238942484001453327985286741005400968);
        assert!(r == 13047564618885834562, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_348() {
        let r = sqrt(20429407868898495082620422258287776212);
        assert!(r == 4519890249651919931, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_349() {
        let r = sqrt(20429407868898495079936305234435044760);
        assert!(r == 4519890249651919930, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_350() {
        let r = sqrt(24607834979226441219788371741519402709);
        assert!(r == 4960628486313648666, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_351() {
        let r = sqrt(24607834979226441210409374837683579555);
        assert!(r == 4960628486313648665, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_352() {
        let r = sqrt(229664170405458746524333706465547961860);
        assert!(r == 15154674869671693043, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_353() {
        let r = sqrt(229664170405458746518319644278014599848);
        assert!(r == 15154674869671693042, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_354() {
        let r = sqrt(128906344115288335238780743221682232134);
        assert!(r == 11353692972565725288, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_355() {
        let r = sqrt(128906344115288335237216596973482682943);
        assert!(r == 11353692972565725287, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_356() {
        let r = sqrt(209025143840562382789093283978277651118);
        assert!(r == 14457701886557295548, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_357() {
        let r = sqrt(209025143840562382787068585383820620303);
        assert!(r == 14457701886557295547, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_358() {
        let r = sqrt(145117336605408996279117799736048328511);
        assert!(r == 12046465730885926372, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_359() {
        let r = sqrt(145117336605408996259987328656605082383);
        assert!(r == 12046465730885926371, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_360() {
        let r = sqrt(295000184862447016815005851306364737599);
        assert!(r == 17175569418870718092, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_361() {
        let r = sqrt(295000184862447016790067170907736120463);
        assert!(r == 17175569418870718091, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_362() {
        let r = sqrt(164289949225634092407646489022356145088);
        assert!(r == 12817564090950904716, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_363() {
        let r = sqrt(164289949225634092382530716658911040655);
        assert!(r == 12817564090950904715, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_364() {
        let r = sqrt(286077055054181366569798861201666559718);
        assert!(r == 16913812552295279784, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_365() {
        let r = sqrt(286077055054181366538029287686839086655);
        assert!(r == 16913812552295279783, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_366() {
        let r = sqrt(51192005240436672714830256624401287103);
        assert!(r == 7154858855381891648, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_367() {
        let r = sqrt(51192005240436672703832527310812155903);
        assert!(r == 7154858855381891647, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_368() {
        let r = sqrt(29699670587172549189313967546299297485);
        assert!(r == 5449740414659449556, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_369() {
        let r = sqrt(29699670587172549189089986084908597135);
        assert!(r == 5449740414659449555, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_370() {
        let r = sqrt(153573704462789964556932071716180314036);
        assert!(r == 12392485806438914963, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_371() {
        let r = sqrt(153573704462789964534229676700745291368);
        assert!(r == 12392485806438914962, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_372() {
        let r = sqrt(314896828851527668576900261168674348142);
        assert!(r == 17745332593432214072, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_373() {
        let r = sqrt(314896828851527668567216506396034821183);
        assert!(r == 17745332593432214071, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_374() {
        let r = sqrt(127752641419912118480968712424472871035);
        assert!(r == 11302771404390700074, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_375() {
        let r = sqrt(127752641419912118464048414339823605475);
        assert!(r == 11302771404390700073, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_376() {
        let r = sqrt(317192911912111735314312658064892112666);
        assert!(r == 17809910497026977909, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_377() {
        let r = sqrt(317192911912111735298373149353574012280);
        assert!(r == 17809910497026977908, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_378() {
        let r = sqrt(318053929610954142318114071400750533046);
        assert!(r == 17834066547227924435, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_379() {
        let r = sqrt(318053929610954142292006701438070069224);
        assert!(r == 17834066547227924434, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_380() {
        let r = sqrt(324819320739467923962616649127709018862);
        assert!(r == 18022744539594071601, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_381() {
        let r = sqrt(324819320739467923926748394945114703200);
        assert!(r == 18022744539594071600, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_382() {
        let r = sqrt(5467600455567108078261871105091478906);
        assert!(r == 2338290070878099605, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_383() {
        let r = sqrt(5467600455567108074455903616301156024);
        assert!(r == 2338290070878099604, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_384() {
        let r = sqrt(319901315915823827269817955298343023179);
        assert!(r == 17885785303302279862, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_385() {
        let r = sqrt(319901315915823827235396309486970739043);
        assert!(r == 17885785303302279861, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_386() {
        let r = sqrt(118192152422087589243273914833755388619);
        assert!(r == 10871621425624035646, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_387() {
        let r = sqrt(118192152422087589223424051587478637315);
        assert!(r == 10871621425624035645, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_388() {
        let r = sqrt(320232575357025191914864514126517607450);
        assert!(r == 17895043318109771815, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_389() {
        let r = sqrt(320232575357025191893053014191368394224);
        assert!(r == 17895043318109771814, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_390() {
        let r = sqrt(71147872953592345442068802102995966714);
        assert!(r == 8434919854603975159, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_391() {
        let r = sqrt(71147872953592345436308599564689075280);
        assert!(r == 8434919854603975158, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_392() {
        let r = sqrt(294482011495357138434023625695276765397);
        assert!(r == 17160478183761580087, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_393() {
        let r = sqrt(294482011495357138424721488070914927568);
        assert!(r == 17160478183761580086, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_394() {
        let r = sqrt(36008877923550345898106695147250723987);
        assert!(r == 6000739781356157581, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_395() {
        let r = sqrt(36008877923550345890349707744503771560);
        assert!(r == 6000739781356157580, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_396() {
        let r = sqrt(239125180570709578605078911296660543692);
        assert!(r == 15463672932738508311, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_397() {
        let r = sqrt(239125180570709578582280870229416072720);
        assert!(r == 15463672932738508310, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_398() {
        let r = sqrt(241475309013861381155286332098357535615);
        assert!(r == 15539475828156539886, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_399() {
        let r = sqrt(241475309013861381133254255951908892995);
        assert!(r == 15539475828156539885, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_400() {
        let r = sqrt(238196697323737976227731734969722464167);
        assert!(r == 15433622300799575295, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_401() {
        let r = sqrt(238196697323737976207521477652374337024);
        assert!(r == 15433622300799575294, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_402() {
        let r = sqrt(34606609190168687760095997690735845769);
        assert!(r == 5882738239133939891, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_403() {
        let r = sqrt(34606609190168687758044323792401091880);
        assert!(r == 5882738239133939890, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_404() {
        let r = sqrt(114722108999843207977713732782662696815);
        assert!(r == 10710840723297271027, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_405() {
        let r = sqrt(114722108999843207972607635105493634728);
        assert!(r == 10710840723297271026, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_406() {
        let r = sqrt(317538261870936445098240848918453202934);
        assert!(r == 17819603302849826491, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_407() {
        let r = sqrt(317538261870936445095023551628805373080);
        assert!(r == 17819603302849826490, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_408() {
        let r = sqrt(54558409527363342968538799599118519963);
        assert!(r == 7386366463110488195, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_409() {
        let r = sqrt(54558409527363342965223016211234358024);
        assert!(r == 7386366463110488194, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_410() {
        let r = sqrt(80983226944547579156643575991399896450);
        assert!(r == 8999068115341031196, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_411() {
        let r = sqrt(80983226944547579149404133356645190415);
        assert!(r == 8999068115341031195, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_412() {
        let r = sqrt(156260619825325973380623682097820480804);
        assert!(r == 12500424785795320058, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_413() {
        let r = sqrt(156260619825325973355694209054657123363);
        assert!(r == 12500424785795320057, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_414() {
        let r = sqrt(53967935748077371361614959545377204728);
        assert!(r == 7346287208384747828, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_415() {
        let r = sqrt(53967935748077371358432399339150717583);
        assert!(r == 7346287208384747827, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_416() {
        let r = sqrt(135322582018570884456707622895185237577);
        assert!(r == 11632823475776243569, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_417() {
        let r = sqrt(135322582018570884449164518628413857760);
        assert!(r == 11632823475776243568, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_418() {
        let r = sqrt(233390889674157806754996160576744071013);
        assert!(r == 15277136173843506287, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_419() {
        let r = sqrt(233390889674157806748272742158208526368);
        assert!(r == 15277136173843506286, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_420() {
        let r = sqrt(82398083836191322832235424655139682642);
        assert!(r == 9077339028382234156, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_421() {
        let r = sqrt(82398083836191322828332983686013032335);
        assert!(r == 9077339028382234155, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_422() {
        let r = sqrt(474396557452276984106770481654604822);
        assert!(r == 688764515238900053, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_423() {
        let r = sqrt(474396557452276983333111825323402808);
        assert!(r == 688764515238900052, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_424() {
        let r = sqrt(60967792616032001368661046953545677791);
        assert!(r == 7808187537196580511, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_425() {
        let r = sqrt(60967792616032001361053226711305021120);
        assert!(r == 7808187537196580510, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_426() {
        let r = sqrt(4456295652750105757512451621740967255);
        assert!(r == 2110993996379455778, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_427() {
        let r = sqrt(4456295652750105754355004463457585283);
        assert!(r == 2110993996379455777, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_428() {
        let r = sqrt(169350641940001034316501626139380672132);
        assert!(r == 13013479240387677135, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_429() {
        let r = sqrt(169350641940001034296440648361001808224);
        assert!(r == 13013479240387677134, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_430() {
        let r = sqrt(267147126805992146161126535851577846924);
        assert!(r == 16344636025497543827, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_431() {
        let r = sqrt(267147126805992146142848685209785805928);
        assert!(r == 16344636025497543826, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_432() {
        let r = sqrt(37371691237828904066295993641448940936);
        assert!(r == 6113239013634989886, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_433() {
        let r = sqrt(37371691237828904057314457191322292995);
        assert!(r == 6113239013634989885, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_434() {
        let r = sqrt(88789230359154059546218969407426580122);
        assert!(r == 9422803741941888685, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_435() {
        let r = sqrt(88789230359154059531134295464931029224);
        assert!(r == 9422803741941888684, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_436() {
        let r = sqrt(264715664386541201941899332695568644396);
        assert!(r == 16270084953267490604, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_437() {
        let r = sqrt(264715664386541201911490114447228284815);
        assert!(r == 16270084953267490603, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_438() {
        let r = sqrt(238087932007804428169343445628847007902);
        assert!(r == 15430098250102117485, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_439() {
        let r = sqrt(238087932007804428153196230480742725224);
        assert!(r == 15430098250102117484, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_440() {
        let r = sqrt(196605512439592094773682648386552640669);
        assert!(r == 14021608767883665879, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_441() {
        let r = sqrt(196605512439592094761951187771708842640);
        assert!(r == 14021608767883665878, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_442() {
        let r = sqrt(176625467826763336867332720873909139685);
        assert!(r == 13290051460651434846, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_443() {
        let r = sqrt(176625467826763336852778717678583043715);
        assert!(r == 13290051460651434845, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_444() {
        let r = sqrt(80420586799984169043983474809048469857);
        assert!(r == 8967752605864201082, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_445() {
        let r = sqrt(80420586799984169034445480730129970723);
        assert!(r == 8967752605864201081, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_446() {
        let r = sqrt(260427973335880753516501335418111062283);
        assert!(r == 16137780929727629485, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_447() {
        let r = sqrt(260427973335880753494351627797441365224);
        assert!(r == 16137780929727629484, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_448() {
        let r = sqrt(94691630178706212633193979537195482033);
        assert!(r == 9730962448735798745, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_449() {
        let r = sqrt(94691630178706212618302455313143575024);
        assert!(r == 9730962448735798744, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_450() {
        let r = sqrt(315223180048031921156633954408879637651);
        assert!(r == 17754525621599466467, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_451() {
        let r = sqrt(315223180048031921135923062059057462088);
        assert!(r == 17754525621599466466, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_452() {
        let r = sqrt(131671829766577829714204681612527503674);
        assert!(r == 11474834629160362314, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_453() {
        let r = sqrt(131671829766577829708773259083751434595);
        assert!(r == 11474834629160362313, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_454() {
        let r = sqrt(232940826869351788121038987571213197324);
        assert!(r == 15262399119055686263, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_455() {
        let r = sqrt(232940826869351788103706305553886905168);
        assert!(r == 15262399119055686262, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_456() {
        let r = sqrt(26953863515777577053805832699505795360);
        assert!(r == 5191711039318114539, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_457() {
        let r = sqrt(26953863515777577048686588901923182520);
        assert!(r == 5191711039318114538, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_458() {
        let r = sqrt(77123544310473628185973120120412390055);
        assert!(r == 8782001156369408505, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_459() {
        let r = sqrt(77123544310473628172028926203566335024);
        assert!(r == 8782001156369408504, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_460() {
        let r = sqrt(306132050582567565086297024031923215376);
        assert!(r == 17496629692102635487, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_461() {
        let r = sqrt(306132050582567565082604694051191727168);
        assert!(r == 17496629692102635486, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_462() {
        let r = sqrt(63971136737377478268762401749117640334);
        assert!(r == 7998195842649608331, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_463() {
        let r = sqrt(63971136737377478268287510387704605560);
        assert!(r == 7998195842649608330, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_464() {
        let r = sqrt(196609138898484598978597534905749494718);
        assert!(r == 14021738084078043389, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_465() {
        let r = sqrt(196609138898484598975497544122566605320);
        assert!(r == 14021738084078043388, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_466() {
        let r = sqrt(111568495961956044796676493069509428258);
        assert!(r == 10562598920812815033, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_467() {
        let r = sqrt(111568495961956044780111796997870791088);
        assert!(r == 10562598920812815032, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_468() {
        let r = sqrt(54970944576397895040172366930827224226);
        assert!(r == 7414239312053387924, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_469() {
        let r = sqrt(54970944576397895033816586846429029775);
        assert!(r == 7414239312053387923, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_470() {
        let r = sqrt(310800297633306635378156251618556503476);
        assert!(r == 17629529138162103374, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_471() {
        let r = sqrt(310800297633306635354628500727862183875);
        assert!(r == 17629529138162103373, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_472() {
        let r = sqrt(77011810998161732989524003601875181544);
        assert!(r == 8775637355666067687, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_473() {
        let r = sqrt(77011810998161732975434941933665529968);
        assert!(r == 8775637355666067686, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_474() {
        let r = sqrt(241076783930285517599206643490219867647);
        assert!(r == 15526647543184765601, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_475() {
        let r = sqrt(241076783930285517578629275013312891200);
        assert!(r == 15526647543184765600, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_476() {
        let r = sqrt(271579718145489909186748201160236054619);
        assert!(r == 16479675911421617188, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_477() {
        let r = sqrt(271579718145489909154672077589217027343);
        assert!(r == 16479675911421617187, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_478() {
        let r = sqrt(239229546420119944897689686769847668854);
        assert!(r == 15467047113787426001, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_479() {
        let r = sqrt(239229546420119944880556409933050852000);
        assert!(r == 15467047113787426000, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_480() {
        let r = sqrt(26756483913188654963721090454365858941);
        assert!(r == 5172667001962203923, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_481() {
        let r = sqrt(26756483913188654963395526235436589928);
        assert!(r == 5172667001962203922, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_482() {
        let r = sqrt(51549703772353669373279712315906322776);
        assert!(r == 7179812237959546346, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_483() {
        let r = sqrt(51549703772353669363879601194121951715);
        assert!(r == 7179812237959546345, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_484() {
        let r = sqrt(211697486407349018464357153530904641848);
        assert!(r == 14549827710572693185, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_485() {
        let r = sqrt(211697486407349018445210290184145444224);
        assert!(r == 14549827710572693184, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_486() {
        let r = sqrt(180157568873811726379324187826679800299);
        assert!(r == 13422278825661897505, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_487() {
        let r = sqrt(180157568873811726356801771557125225024);
        assert!(r == 13422278825661897504, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_488() {
        let r = sqrt(238462569932737948142147390088284975953);
        assert!(r == 15442233320758301123, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_489() {
        let r = sqrt(238462569932737948136943057313143061128);
        assert!(r == 15442233320758301122, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_490() {
        let r = sqrt(122357442991650421381912607128333861304);
        assert!(r == 11061529866688894014, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_491() {
        let r = sqrt(122357442991650421377213819210525032195);
        assert!(r == 11061529866688894013, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_492() {
        let r = sqrt(73688072883536047078204444253502959955);
        assert!(r == 8584175725341137672, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_493() {
        let r = sqrt(73688072883536047070847199311257579583);
        assert!(r == 8584175725341137671, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_494() {
        let r = sqrt(253347750496218365419273988696128236722);
        assert!(r == 15916901410017540390, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_495() {
        let r = sqrt(253347750496218365416646207465281352099);
        assert!(r == 15916901410017540389, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_496() {
        let r = sqrt(155847331180417827571500801858803011596);
        assert!(r == 12483882856724418477, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_497() {
        let r = sqrt(155847331180417827547704642753818999528);
        assert!(r == 12483882856724418476, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_498() {
        let r = sqrt(15075480498468880510938801786401462675);
        assert!(r == 3882715608754893151, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_499() {
        let r = sqrt(15075480498468880504089865285426708800);
        assert!(r == 3882715608754893150, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_500() {
        let r = sqrt(60814606595039931504594884196022537031);
        assert!(r == 7798372047744319533, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_501() {
        let r = sqrt(60814606595039931489920599669205338088);
        assert!(r == 7798372047744319532, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_502() {
        let r = sqrt(227009948030077734546445517879238702470);
        assert!(r == 15066849306675823209, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_503() {
        let r = sqrt(227009948030077734531457422917823057680);
        assert!(r == 15066849306675823208, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_504() {
        let r = sqrt(151810158560655318800125317394686518987);
        assert!(r == 12321126513458715346, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_505() {
        let r = sqrt(151810158560655318792251556764655899715);
        assert!(r == 12321126513458715345, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_506() {
        let r = sqrt(170592142545594852897501710365622697962);
        assert!(r == 13061092701056632991, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_507() {
        let r = sqrt(170592142545594852891775004677669606080);
        assert!(r == 13061092701056632990, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_508() {
        let r = sqrt(240066486516425068869187524406278070840);
        assert!(r == 15494079079326562830, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_509() {
        let r = sqrt(240066486516425068865670710421937608899);
        assert!(r == 15494079079326562829, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_510() {
        let r = sqrt(41683965225363334173668930825588257025);
        assert!(r == 6456312045228555569, (r as u64));
    }
    #[test]
    fun test_sqrt_u128_511() {
        let r = sqrt(41683965225363334171225294858120913760);
        assert!(r == 6456312045228555568, (r as u64));
    }
}

// Auto generated from gen-move-math
// https://github.com/fardream/gen-move-math
// Manual edit with caution.
// Arguments: more-math -t
// Version: v1.4.0
module more_math::more_math_u256 {
    const E_WIDTH_OVERFLOW_U8: u64 = 1;
    const HALF_SIZE: u8 = 128;
    const MAX_SHIFT_SIZE: u8 = 255;

    const ALL_ONES: u256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    const LOWER_ONES: u256 = (1 << 128) - 1;
    const UPPER_ONES: u256 = ((1 << 128) - 1) << 128;
    /// add two u256 with carry - will never abort.
    /// First return value is the value of the result, the second return value indicate if carry happens.
    public fun add_with_carry(x: u256, y: u256):(u256, u256) {
        let r = ALL_ONES - x;
        if (r < y) {
            (y - r - 1, 1)
        } else {
            (x + y, 0)
        }
    }

    /// subtract y from x with borrow - will never abort.
    /// First return value is the value of the result, the second return value indicate if borrow happens.
    public fun sub_with_borrow(x: u256, y:u256): (u256, u256) {
        if (x < y) {
            ((ALL_ONES - y) + 1 + x, 1)
        } else {
            (x-y, 0)
        }
    }

    /// x * y, first return value is the lower part of the result, second return value is the upper part of the result.
    public fun mul_with_carry(x: u256, y: u256):(u256, u256) {
        // split x and y into lower part and upper part.
        // xh, xl, yh, yl
        // result is
        // upper = xh * xl + (xh * yl) >> half_size + (xl * yh) >> half_size
        // lower = xl * yl + (xh * yl) << half_size + (xl * yh) << half_size
        let xh = (x & UPPER_ONES) >> HALF_SIZE;
        let xl = x & LOWER_ONES;
        let yh = (y & UPPER_ONES) >> HALF_SIZE;
        let yl = y & LOWER_ONES;
        let xhyl = xh * yl;
        let xlyh = xl * yh;

        let (lo, lo_carry_1) = add_with_carry(xl * yl, (xhyl & LOWER_ONES) << HALF_SIZE);
        let (lo, lo_carry_2) = add_with_carry(lo, (xlyh & LOWER_ONES)<< HALF_SIZE);
        let hi = xh * yh + (xhyl >> HALF_SIZE) + (xlyh >> HALF_SIZE) + lo_carry_1 + lo_carry_2;

        (lo, hi)
    }

    /// count leading zeros u256
    public fun leading_zeros(x: u256): u8 {
        if (x == 0) {
            abort(E_WIDTH_OVERFLOW_U8)
        } else {
            let n: u8 = 0;
            if (x & 115792089237316195423570985008687907852929702298719625575994209400481361428480 == 0) {
                // x's higher 128 is all zero, shift the lower part over
                x = x << 128;
                n = n + 128;
            };
            if (x & 115792089237316195417293883273301227089434195242432897623355228563449095127040 == 0) {
                // x's higher 64 is all zero, shift the lower part over
                x = x << 64;
                n = n + 64;
            };
            if (x & 115792089210356248756420345214020892766250353992003419616917011526809519390720 == 0) {
                // x's higher 32 is all zero, shift the lower part over
                x = x << 32;
                n = n + 32;
            };
            if (x & 115790322390251417039241401711187164934754157181743688420499462401711837020160 == 0) {
                // x's higher 16 is all zero, shift the lower part over
                x = x << 16;
                n = n + 16;
            };
            if (x & 115339776388732929035197660848497720713218148788040405586178452820382218977280 == 0) {
                // x's higher 8 is all zero, shift the lower part over
                x = x << 8;
                n = n + 8;
            };
            if (x & 108555083659983933209597798445644913612440610624038028786991485007418559037440 == 0) {
                // x's higher 4 is all zero, shift the lower part over
                x = x << 4;
                n = n + 4;
            };
            if (x & 86844066927987146567678238756515930889952488499230423029593188005934847229952 == 0) {
                // x's higher 2 is all zero, shift the lower part over
                x = x << 2;
                n = n + 2;
            };
            if (x & 57896044618658097711785492504343953926634992332820282019728792003956564819968 == 0) {
                n = n + 1;
            };

            n
        }
    }

    /// sqrt returns y = floor(sqrt(x))
    public fun sqrt(x: u256): u256 {
        if (x == 0) {
            0
        } else if (x <= 3) {
            1
        } else {
            // reproduced from golang's big.Int.Sqrt
            let n = (MAX_SHIFT_SIZE - leading_zeros(x)) >> 1;
            let z = x >> ((n - 1) / 2);
            let z_next = (z + x / z) >> 1;
            while (z_next < z) {
                z = z_next;
                z_next = (z + x / z) >> 1;
            };
            z
        }
    }


    #[test]
    fun test_sqrt_u256_0() {
        let r = sqrt(75882278871742073348705908634037840808905895098001936781526057361623699972085);
        assert!(r == 275467382591373371746393269572910798226, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_1() {
        let r = sqrt(75882278871742073348705908634037840808883819586160768086833864311952484747075);
        assert!(r == 275467382591373371746393269572910798225, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_2() {
        let r = sqrt(32980378865574341698424589833777768979918116503443097246085029326460293060374);
        assert!(r == 181605007820749099788849723261128389845, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_3() {
        let r = sqrt(32980378865574341698424589833777768979624729096367844371516561853042299124024);
        assert!(r == 181605007820749099788849723261128389844, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_4() {
        let r = sqrt(33532656609431459372731069768100234814886588623145077066368255745653136021196);
        assert!(r == 183119241505177329010245668346163129512, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_5() {
        let r = sqrt(33532656609431459372731069768100234814818328834166036013470820265541685358143);
        assert!(r == 183119241505177329010245668346163129511, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_6() {
        let r = sqrt(24340102227887970934280480162706712892472523104749085507630032834159185167583);
        assert!(r == 156013147612270072211945826707429200473, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_7() {
        let r = sqrt(24340102227887970934280480162706712892408669537707897073995225077868023423728);
        assert!(r == 156013147612270072211945826707429200472, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_8() {
        let r = sqrt(25939438313841753158121571080388234356066200149689081728987631181064048770217);
        assert!(r == 161057251664871498756884473401208128458, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_9() {
        let r = sqrt(25939438313841753158121571080388234355879610747117915071467227608771029457763);
        assert!(r == 161057251664871498756884473401208128457, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_10() {
        let r = sqrt(78032309229824941242334127851308491453788232706102641211468526345758311040919);
        assert!(r == 279342637686810964290110906310010406521, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_11() {
        let r = sqrt(78032309229824941242334127851308491453584470019455428394577688203315679323440);
        assert!(r == 279342637686810964290110906310010406520, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_12() {
        let r = sqrt(80735704823201808524953766141761495099177184572017071427005097600202299689273);
        assert!(r == 284140290742446113456362585459639445192, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_13() {
        let r = sqrt(80735704823201808524953766141761495099134029695960593354842302216409571916863);
        assert!(r == 284140290742446113456362585459639445191, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_14() {
        let r = sqrt(86408696651057550995449747946019314590570097982970217886304238227922872001772);
        assert!(r == 293953562065605102262965125258603266714, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_15() {
        let r = sqrt(86408696651057550995449747946019314590050215018883255436586348055152220357795);
        assert!(r == 293953562065605102262965125258603266713, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_16() {
        let r = sqrt(12700787412700612418467338488520114582715681777767934293411009135641274590591);
        assert!(r == 112697770220624207425720569210432200345, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_17() {
        let r = sqrt(12700787412700612418467338488520114582667905005615896007872503552038218119024);
        assert!(r == 112697770220624207425720569210432200344, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_18() {
        let r = sqrt(49082224890667343605588721827833380431430461985374428952870683914176044280952);
        assert!(r == 221545085458168860743784988217128670683, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_19() {
        let r = sqrt(49082224890667343605588721827833380431131145847445298243967073240566663686488);
        assert!(r == 221545085458168860743784988217128670682, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_20() {
        let r = sqrt(113949215058233575854947157718322556133520613218794016644473782711206104277337);
        assert!(r == 337563645936930797119914733600183356935, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_21() {
        let r = sqrt(113949215058233575854947157718322556133133743402892997746028508651765612594224);
        assert!(r == 337563645936930797119914733600183356934, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_22() {
        let r = sqrt(75685037232418139376029773393880818236163402399177724872153518693030646968040);
        assert!(r == 275109136948263024018269990629476458226, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_23() {
        let r = sqrt(75685037232418139376029773393880818235641717657994028438289486940749123067075);
        assert!(r == 275109136948263024018269990629476458225, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_24() {
        let r = sqrt(6857961592601699031281427085304272443818000353168731415042504588272386870592);
        assert!(r == 82812810558522278855978266567872319434, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_25() {
        let r = sqrt(6857961592601699031281427085304272443751670843382184223505814067350934080355);
        assert!(r == 82812810558522278855978266567872319433, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_26() {
        let r = sqrt(19017157096377017263125373422616720955810604009506501379107269647643351291562);
        assert!(r == 137902708807249385601165289912790815041, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_27() {
        let r = sqrt(19017157096377017263125373422616720955655946002921829644523695721213071831680);
        assert!(r == 137902708807249385601165289912790815040, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_28() {
        let r = sqrt(47113179001772684986247456876450875016245635501651251396750642452903122043524);
        assert!(r == 217055704835815557023232643345770393894, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_29() {
        let r = sqrt(47113179001772684986247456876450875015833549202077787278174528977611912483235);
        assert!(r == 217055704835815557023232643345770393893, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_30() {
        let r = sqrt(4462644761778144223778117570065581897329338720827205110030300959566982252430);
        assert!(r == 66803029585327522208385261358866231566, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_31() {
        let r = sqrt(4462644761778144223778117570065581897287892083612906690719669610381934812355);
        assert!(r == 66803029585327522208385261358866231565, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_32() {
        let r = sqrt(56807821421919952242722349805571453429208888169662512584846503055644855550122);
        assert!(r == 238343914170091517868149184952296579248, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_33() {
        let r = sqrt(56807821421919952242722349805571453428941396273742931739153842111442344245503);
        assert!(r == 238343914170091517868149184952296579247, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_34() {
        let r = sqrt(93726165208003979781844421607346557378144544653207330846291036376475271545154);
        assert!(r == 306147293321374931573480505939811265939, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_35() {
        let r = sqrt(93726165208003979781844421607346557377639668435319455092019253975865781551720);
        assert!(r == 306147293321374931573480505939811265938, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_36() {
        let r = sqrt(73444280900340623585524551218753281204306454128524470727060531188852973949930);
        assert!(r == 271006053254056713856829864540003749472, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_37() {
        let r = sqrt(73444280900340623585524551218753281203909743996704785802771713059818540278783);
        assert!(r == 271006053254056713856829864540003749471, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_38() {
        let r = sqrt(72017068440557573242518565703318691171974087925699538079896924397346731082368);
        assert!(r == 268359960576382506746352495394822706235, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_39() {
        let r = sqrt(72017068440557573242518565703318691171717490272941098738173582008729107875224);
        assert!(r == 268359960576382506746352495394822706234, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_40() {
        let r = sqrt(43324418463581828206858497462604047627725633122578217725926162063204269177330);
        assert!(r == 208145186020676029966964980029394515409, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_41() {
        let r = sqrt(43324418463581828206858497462604047627537978457322195732010791176129938437280);
        assert!(r == 208145186020676029966964980029394515408, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_42() {
        let r = sqrt(3300216217839864170575935073639823386297551723380856986574792840349584254504);
        assert!(r == 57447508369291911097339674609683621710, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_43() {
        let r = sqrt(3300216217839864170575935073639823386239897146493061952495563661422383324099);
        assert!(r == 57447508369291911097339674609683621709, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_44() {
        let r = sqrt(54905271313563761933286920986432550800568229676804445486466837371294438855326);
        assert!(r == 234318738716227648469805424937559576516, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_45() {
        let r = sqrt(54905271313563761933286920986432550800141935612622354355737605084861258698255);
        assert!(r == 234318738716227648469805424937559576515, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_46() {
        let r = sqrt(2043173992362447766254572961341640994716930073210421450086321816552424951909);
        assert!(r == 45201482192096840202643985716015930092, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_47() {
        let r = sqrt(2043173992362447766254572961341640994701772755541086867327405385511831128463);
        assert!(r == 45201482192096840202643985716015930091, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_48() {
        let r = sqrt(19425768827635134724338320534364923829208367021734414277768224643849961311849);
        assert!(r == 139376356774149950243462295256197458523, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_49() {
        let r = sqrt(19425768827635134724338320534364923829008652998830915215990918323644305341528);
        assert!(r == 139376356774149950243462295256197458522, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_50() {
        let r = sqrt(28195025307157735708284506714984522907256490495792048805485537803722761750160);
        assert!(r == 167913743651786096756414365648506131050, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_51() {
        let r = sqrt(28195025307157735708284506714984522906983371637719693654145268509439774102499);
        assert!(r == 167913743651786096756414365648506131049, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_52() {
        let r = sqrt(86782084177771881846476760899994205508485917260317219654588432879782914191338);
        assert!(r == 294587990552520456691391094792307763620, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_53() {
        let r = sqrt(86782084177771881846476760899994205508413715253431121015601992852525795504399);
        assert!(r == 294587990552520456691391094792307763619, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_54() {
        let r = sqrt(77425744182293370316190335010725241335809667053781402147514349728406518849419);
        assert!(r == 278254818794380217497528479559524803944, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_55() {
        let r = sqrt(77425744182293370316190335010725241335732148704646842347131048580571637955135);
        assert!(r == 278254818794380217497528479559524803943, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_56() {
        let r = sqrt(79908328987601845230957760239502272391487882112462744437635731063339534977716);
        assert!(r == 282680613038110282839781033341282169372, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_57() {
        let r = sqrt(79908328987601845230957760239502272391101085464429040403871761683258494874383);
        assert!(r == 282680613038110282839781033341282169371, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_58() {
        let r = sqrt(43893408444785185701520001268197680805598222801339528167306035388913437853293);
        assert!(r == 209507537918770802640337023970236818422, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_59() {
        let r = sqrt(43893408444785185701520001268197680805505809078078270656029559233644998570083);
        assert!(r == 209507537918770802640337023970236818421, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_60() {
        let r = sqrt(18726699957203688468916546675795841694174603390848497724075506221646159836500);
        assert!(r == 136845533201503104337037605817695116531, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_61() {
        let r = sqrt(18726699957203688468916546675795841693946007994600457508233600108645669473960);
        assert!(r == 136845533201503104337037605817695116530, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_62() {
        let r = sqrt(6734680769399256803588873135289812564253763836270286273648995489109888764755);
        assert!(r == 82065100800518467428657592819378062277, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_63() {
        let r = sqrt(6734680769399256803588873135289812564241265896532857615950122908811290424728);
        assert!(r == 82065100800518467428657592819378062276, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_64() {
        let r = sqrt(52217995269717752671377641665642319918077432912861119970157971204628700661392);
        assert!(r == 228512571360347159066202022247956804178, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_65() {
        let r = sqrt(52217995269717752671377641665642319917911406906242228275965872570167038255683);
        assert!(r == 228512571360347159066202022247956804177, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_66() {
        let r = sqrt(52759922762599170619909401437313818425087728038385997362519747824508502347470);
        assert!(r == 229695282412589333135887927423335388164, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_67() {
        let r = sqrt(52759922762599170619909401437313818424977126191171375049905442927964551290895);
        assert!(r == 229695282412589333135887927423335388163, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_68() {
        let r = sqrt(57022841115413222370750274128498460260216299153372182775691760568472804746806);
        assert!(r == 238794558387357776848298667768723005989, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_69() {
        let r = sqrt(57022841115413222370750274128498460260070697382057733064338493262764129868120);
        assert!(r == 238794558387357776848298667768723005988, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_70() {
        let r = sqrt(64774968905746100121990323697029144179953113809839100692077968948293604770398);
        assert!(r == 254509270765813362192112330495941701348, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_71() {
        let r = sqrt(64774968905746100121990323697029144179686622779205555778215012815948825017103);
        assert!(r == 254509270765813362192112330495941701347, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_72() {
        let r = sqrt(88661518651688742640512279806259168411657229162718594069104181538449438990032);
        assert!(r == 297760841367176323070792622429609691034, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_73() {
        let r = sqrt(88661518651688742640512279806259168411542419936521653078377988926328939989155);
        assert!(r == 297760841367176323070792622429609691033, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_74() {
        let r = sqrt(49704501502129387487216447386084277025227606030166783381498623772454235706075);
        assert!(r == 222945063865808402623367931078286062129, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_75() {
        let r = sqrt(49704501502129387487216447386084277025205200452387217873113077721665648012640);
        assert!(r == 222945063865808402623367931078286062128, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_76() {
        let r = sqrt(58022260617265163668905669370150810398141227253796552963952589827265116655338);
        assert!(r == 240878103233285120595797206769672966681, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_77() {
        let r = sqrt(58022260617265163668905669370150810397833224666410616196938262211531736155760);
        assert!(r == 240878103233285120595797206769672966680, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_78() {
        let r = sqrt(6190030046200727254785762360146634110820613846280591433531122994308444682174);
        assert!(r == 78676743998469631984156718114076492586, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_79() {
        let r = sqrt(6190030046200727254785762360146634110690643521305128633791631656723712967395);
        assert!(r == 78676743998469631984156718114076492585, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_80() {
        let r = sqrt(70752324614668190025685640555104391215948645101357301896536003072684678093973);
        assert!(r == 265993091291236716634994883079072316888, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_81() {
        let r = sqrt(70752324614668190025685640555104391215865722946549641843921399506036290004543);
        assert!(r == 265993091291236716634994883079072316887, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_82() {
        let r = sqrt(97220788701772993235123022199397953197224528106023492643934394776413498636658);
        assert!(r == 311802483475954683158488769601781073665, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_83() {
        let r = sqrt(97220788701772993235123022199397953197176004783135890897468797391400156532224);
        assert!(r == 311802483475954683158488769601781073664, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_84() {
        let r = sqrt(86038875044812579469634256959189940390883155168034809196936856499938808302782);
        assert!(r == 293323839884883171201465200862225807326, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_85() {
        let r = sqrt(86038875044812579469634256959189940390298129195788811671621453218972475270275);
        assert!(r == 293323839884883171201465200862225807325, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_86() {
        let r = sqrt(97912785113529256090201091617528666027143108978898955568368486196684069240388);
        assert!(r == 312910186976277996806857486844992365871, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_87() {
        let r = sqrt(97912785113529256090201091617528666026819347265494377777746618992269925588640);
        assert!(r == 312910186976277996806857486844992365870, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_88() {
        let r = sqrt(100333715868362267198790402615647231954594179087614344716488723739859026534891);
        assert!(r == 316754977653646774067162167063975585579, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_89() {
        let r = sqrt(100333715868362267198790402615647231954219496307677911221252054936175952765240);
        assert!(r == 316754977653646774067162167063975585578, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_90() {
        let r = sqrt(14833789228003763173190464337873310488029345554699407481222271972000604746051);
        assert!(r == 121794044304324516396618922752237912901, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_91() {
        let r = sqrt(14833789228003763173190464337873310488004074694039626602510903049652462235800);
        assert!(r == 121794044304324516396618922752237912900, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_92() {
        let r = sqrt(41124419080683120773402232809870251033013922589716848024833306174685138357180);
        assert!(r == 202791565605384882272868146969859976791, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_93() {
        let r = sqrt(41124419080683120773402232809870251032892840673049651757754773553039058657680);
        assert!(r == 202791565605384882272868146969859976790, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_94() {
        let r = sqrt(83582644738209687068869749858317792000426612144069817859255946426599916094457);
        assert!(r == 289106632124221057394212386587834457142, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_95() {
        let r = sqrt(83582644738209687068869749858317792000014176441677122379474470627429834808163);
        assert!(r == 289106632124221057394212386587834457141, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_96() {
        let r = sqrt(109325800436938291888875934504575708665960170260799316345627045858060350675287);
        assert!(r == 330644522768695341182733108986056706217, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_97() {
        let r = sqrt(109325800436938291888875934504575708665474223729337348148858492747519046451088);
        assert!(r == 330644522768695341182733108986056706216, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_98() {
        let r = sqrt(50520305261190593812761234047313435103788349269793840294892088960208608350411);
        assert!(r == 224767224615135099578330965448214732584, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_99() {
        let r = sqrt(50520305261190593812761234047313435103589057030898874477939773625346631317055);
        assert!(r == 224767224615135099578330965448214732583, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_100() {
        let r = sqrt(980895565009559339222901647811063150490988887374691500045541652549660782368);
        assert!(r == 31319252306042673777151246701920655937, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_101() {
        let r = sqrt(980895565009559339222901647811063150432922052095140403846302235028333347968);
        assert!(r == 31319252306042673777151246701920655936, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_102() {
        let r = sqrt(45882907666479638132088117486231646002713498228919693676171251359846413544681);
        assert!(r == 214202959051642510525312511189153629998, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_103() {
        let r = sqrt(45882907666479638132088117486231646002700719033270687673807705697420285480003);
        assert!(r == 214202959051642510525312511189153629997, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_104() {
        let r = sqrt(15380676608843217730424882040995232353214974266434599582032847243049760069961);
        assert!(r == 124018855860079670912490853604706586864, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_105() {
        let r = sqrt(15380676608843217730424882040995232353010902705876977650169966180708377354495);
        assert!(r == 124018855860079670912490853604706586863, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_106() {
        let r = sqrt(111388849234405761524374019041339693828694009207914780008966042700128048552845);
        assert!(r == 333749680500829485849310544874911853874, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_107() {
        let r = sqrt(111388849234405761524374019041339693828179908667941011677021646961239528807875);
        assert!(r == 333749680500829485849310544874911853873, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_108() {
        let r = sqrt(108012436486244172169222822645188954475398343106101136756272439075093771444737);
        assert!(r == 328652455469671140823566709889141590008, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_109() {
        let r = sqrt(108012436486244172169222822645188954475092273318565446266404454425954365440063);
        assert!(r == 328652455469671140823566709889141590007, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_110() {
        let r = sqrt(24093758782208277150581262352568330125159574872248434167866449038892373284824);
        assert!(r == 155221644052008021342295627498403678296, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_111() {
        let r = sqrt(24093758782208277150581262352568330124961085787117152803277449722982661463615);
        assert!(r == 155221644052008021342295627498403678295, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_112() {
        let r = sqrt(12954839216506352390883912684155841796816270571829786037709488092162727667239);
        assert!(r == 113819327078077352297065680868222556982, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_113() {
        let r = sqrt(12954839216506352390883912684155841796604557369347992644203563972362236948323);
        assert!(r == 113819327078077352297065680868222556981, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_114() {
        let r = sqrt(10479684219927301591189635320469512976170835045637145576574446306827143671138);
        assert!(r == 102370328806384624170264811607569943362, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_115() {
        let r = sqrt(10479684219927301591189635320469512976011080207096616296764505240903887863043);
        assert!(r == 102370328806384624170264811607569943361, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_116() {
        let r = sqrt(84939121404026908093158619880196260621079167047685530134767245502787979172763);
        assert!(r == 291443170110446932211449825784690146481, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_117() {
        let r = sqrt(84939121404026908093158619880196260620792036863289906505002257634373236683360);
        assert!(r == 291443170110446932211449825784690146480, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_118() {
        let r = sqrt(18670891281082153101800916003220670864894933414786446211878851498430250435003);
        assert!(r == 136641469843829450449456067240427716074, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_119() {
        let r = sqrt(18670891281082153101800916003220670864649576630191038986630928572559957973475);
        assert!(r == 136641469843829450449456067240427716073, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_120() {
        let r = sqrt(100276309741620146608064848444470360291993085005743091979293659558793413398785);
        assert!(r == 316664348706355238495504908393458838393, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_121() {
        let r = sqrt(100276309741620146608064848444470360291498170642592140262230523197568890822448);
        assert!(r == 316664348706355238495504908393458838392, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_122() {
        let r = sqrt(79387237306682506070347406169711578834506521134365023077366987293392910653524);
        assert!(r == 281757408610106481562531777913536971796, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_123() {
        let r = sqrt(79387237306682506070347406169711578834265258950272501785755321822205699465615);
        assert!(r == 281757408610106481562531777913536971795, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_124() {
        let r = sqrt(66548317515207857443725906768195248572692758951606824571319033292942280356675);
        assert!(r == 257969605797287400986753278542220770191, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_125() {
        let r = sqrt(66548317515207857443725906768195248572424098006981315865311235822521234176480);
        assert!(r == 257969605797287400986753278542220770190, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_126() {
        let r = sqrt(57427085243644691305260422653144904581801611243718587922038093905899295853721);
        assert!(r == 239639490158956671289847093451910629065, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_127() {
        let r = sqrt(57427085243644691305260422653144904581726115653897098694806332751924022774224);
        assert!(r == 239639490158956671289847093451910629064, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_128() {
        let r = sqrt(38701204156336150377349804255168361387811403976379566153975221299410949423827);
        assert!(r == 196726216240581800036936108571711790603, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_129() {
        let r = sqrt(38701204156336150377349804255168361387545075941406932012025957762488519103608);
        assert!(r == 196726216240581800036936108571711790602, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_130() {
        let r = sqrt(79792985907079431458791553918659861580794317368281488814604512184022444466500);
        assert!(r == 282476522753802375991045252017289256684, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_131() {
        let r = sqrt(79792985907079431458791553918659861580506203142780024494873847132685238675855);
        assert!(r == 282476522753802375991045252017289256683, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_132() {
        let r = sqrt(73491663667631809016583212952822378136841990263240097122748400697713029610762);
        assert!(r == 271093459285966191339951419416845228917, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_133() {
        let r = sqrt(73491663667631809016583212952822378136437018069362905615187911316866132992888);
        assert!(r == 271093459285966191339951419416845228916, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_134() {
        let r = sqrt(45901420260940544806393137638469468684180407351945826294345610319242103483215);
        assert!(r == 214246167435827296775973838130361260567, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_135() {
        let r = sqrt(45901420260940544806393137638469468683865478232898173058380150548617269161488);
        assert!(r == 214246167435827296775973838130361260566, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_136() {
        let r = sqrt(68195118166916164203152410551412807977582148449484666814074636903852066571671);
        assert!(r == 261141950224233724518162722113634975296, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_137() {
        let r = sqrt(68195118166916164203152410551412807977526184362752264848469139034522530287615);
        assert!(r == 261141950224233724518162722113634975295, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_138() {
        let r = sqrt(93681714024217686542509780613372338882261480897053244113666379285932758706038);
        assert!(r == 306074687003381066175031895082673716942, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_139() {
        let r = sqrt(93681714024217686542509780613372338881693849191124540036938673653005937831363);
        assert!(r == 306074687003381066175031895082673716941, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_140() {
        let r = sqrt(46352069920023608201870470422130082148402565355290080749612568175634049570119);
        assert!(r == 215295308634497672841256655674910756253, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_141() {
        let r = sqrt(46352069920023608201870470422130082148190809865911241945342756335996378600008);
        assert!(r == 215295308634497672841256655674910756252, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_142() {
        let r = sqrt(95393317222359662518245662381661011087874365464676947409110142736979866784309);
        assert!(r == 308858085894411484676325954783976843051, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_143() {
        let r = sqrt(95393317222359662518245662381661011087678887014217884563371381748212286988600);
        assert!(r == 308858085894411484676325954783976843050, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_144() {
        let r = sqrt(11437399327425898995345707819444027901201462087409632821597908923731782074371);
        assert!(r == 106945777510970011159278199060310444160, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_145() {
        let r = sqrt(11437399327425898995345707819444027900996203967596050377027085354776478105599);
        assert!(r == 106945777510970011159278199060310444159, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_146() {
        let r = sqrt(61055667224838429499328041124483317758309364435644307318447031903181960906631);
        assert!(r == 247094450008166774889645123377690554444, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_147() {
        let r = sqrt(61055667224838429499328041124483317758194347949863935983191308140216128149135);
        assert!(r == 247094450008166774889645123377690554443, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_148() {
        let r = sqrt(37340347303909660709729429162282495092667491486811850946851938880935864777987);
        assert!(r == 193236506136676101696459654438539458643, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_149() {
        let r = sqrt(37340347303909660709729429162282495092599527660601777342019035830895507401448);
        assert!(r == 193236506136676101696459654438539458642, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_150() {
        let r = sqrt(74335775223091512056078124099419949328817308263473530742710922301026080599628);
        assert!(r == 272645878793521307933366331610448107928, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_151() {
        let r = sqrt(74335775223091512056078124099419949328745745469352226689945636808875136453183);
        assert!(r == 272645878793521307933366331610448107927, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_152() {
        let r = sqrt(22327506687630637777070935443003750989185168867180395013392081272908206473087);
        assert!(r == 149423916049709518302946561891380131392, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_153() {
        let r = sqrt(22327506687630637777070935443003750988906310878353790604427624464419183857663);
        assert!(r == 149423916049709518302946561891380131391, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_154() {
        let r = sqrt(108432958669255895698603265385339957155416610021734230751275402700812852642044);
        assert!(r == 329291601273485102682301884760478223665, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_155() {
        let r = sqrt(108432958669255895698603265385339957155127002413303583733532898388673766032224);
        assert!(r == 329291601273485102682301884760478223664, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_156() {
        let r = sqrt(29900726794153253654038725858529532386913402903513172090849694313094024790806);
        assert!(r == 172918266224691408840383862777842685817, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_157() {
        let r = sqrt(29900726794153253654038725858529532386826432018854645947725414387004172957488);
        assert!(r == 172918266224691408840383862777842685816, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_158() {
        let r = sqrt(64125192667223442496834208710731471446598748524197376829025408073810976779784);
        assert!(r == 253229525662438191316770529415353911456, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_159() {
        let r = sqrt(64125192667223442496834208710731471446172110565457229872791432209798688039935);
        assert!(r == 253229525662438191316770529415353911455, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_160() {
        let r = sqrt(105291150506731667140366319441094714988589359592758719920626589676699187027723);
        assert!(r == 324485978906225880612814912989279997503, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_161() {
        let r = sqrt(105291150506731667140366319441094714988406536057166769484997242931535686235008);
        assert!(r == 324485978906225880612814912989279997502, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_162() {
        let r = sqrt(20058899884457728337105805041524615503208596730278419030180780845760137259327);
        assert!(r == 141629445682943094462788210343956918037, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_163() {
        let r = sqrt(20058899884457728337105805041524615503204010177148885905226249005511535933368);
        assert!(r == 141629445682943094462788210343956918036, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_164() {
        let r = sqrt(63648547584671310289399645464483303612591692360656566112751285290355030403580);
        assert!(r == 252286637744989003786179586083584367498, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_165() {
        let r = sqrt(63648547584671310289399645464483303612487775243997291866285338146040718780003);
        assert!(r == 252286637744989003786179586083584367497, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_166() {
        let r = sqrt(1608550090807255486311048611640826230766160534298420258531929360906502202572);
        assert!(r == 40106733733966114213351556186266841598, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_167() {
        let r = sqrt(1608550090807255486311048611640826230741312984576997350972989254894423193603);
        assert!(r == 40106733733966114213351556186266841597, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_168() {
        let r = sqrt(50467748609527907368548141709710240131070050602761809583102885097383673865512);
        assert!(r == 224650280679833354550848438181004362155, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_169() {
        let r = sqrt(50467748609527907368548141709710240130626017871380420101298706899138396244024);
        assert!(r == 224650280679833354550848438181004362154, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_170() {
        let r = sqrt(10399246160683791053461583288351461318361693258816505850110298845728786174332);
        assert!(r == 101976694203547268418164707358796460050, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_171() {
        let r = sqrt(10399246160683791053461583288351461318270902302965169107625810444411246002499);
        assert!(r == 101976694203547268418164707358796460049, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_172() {
        let r = sqrt(60899629573647150890087104384664440153114104634166985736026944883364877151420);
        assert!(r == 246778503062254494440732307843267187519, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_173() {
        let r = sqrt(60899629573647150890087104384664440152632835422449356428400502212204309375360);
        assert!(r == 246778503062254494440732307843267187518, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_174() {
        let r = sqrt(115718828269109077358315459331840225462604752660055143456474013437252186496028);
        assert!(r == 340174702570765948716171273544570003326, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_175() {
        let r = sqrt(115718828269109077358315459331840225462091047155906400431747796518479651062275);
        assert!(r == 340174702570765948716171273544570003325, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_176() {
        let r = sqrt(62894902480982835620564517706412601691788979563173581655760875960564541252423);
        assert!(r == 250788561304105007660386595587764490797, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_177() {
        let r = sqrt(62894902480982835620564517706412601691711781042343847982146429071856697695208);
        assert!(r == 250788561304105007660386595587764490796, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_178() {
        let r = sqrt(67295203284441368837343359232031807556472933454359071659839839792947080747482);
        assert!(r == 259413190266881704754714891134195987927, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_179() {
        let r = sqrt(67295203284441368837343359232031807556421117015543677035934805089703529757328);
        assert!(r == 259413190266881704754714891134195987926, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_180() {
        let r = sqrt(62402910304565545433249270543506402801236155547998049620029390025144360075366);
        assert!(r == 249805745139229224719920859961399568563, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_181() {
        let r = sqrt(62402910304565545433249270543506402801080297247483658632497841667122537884968);
        assert!(r == 249805745139229224719920859961399568562, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_182() {
        let r = sqrt(90438555623289603930995511597996334088652011857372571546404691724495415955104);
        assert!(r == 300730037780215104223626159995638384938, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_183() {
        let r = sqrt(90438555623289603930995511597996334088293908947982264648592579845949065263843);
        assert!(r == 300730037780215104223626159995638384937, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_184() {
        let r = sqrt(64256943600539711926748474879956671909714738212937083681118910880112602205550);
        assert!(r == 253489533512805439315277479896225020542, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_185() {
        let r = sqrt(64256943600539711926748474879956671909608555305363227865629234681508321973763);
        assert!(r == 253489533512805439315277479896225020541, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_186() {
        let r = sqrt(90091301897244629463122899483676889244323624267301978425427975478597564541109);
        assert!(r == 300152131255542860693234168363101184674, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_187() {
        let r = sqrt(90091301897244629463122899483676889244081683176044774726431952775662252486275);
        assert!(r == 300152131255542860693234168363101184673, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_188() {
        let r = sqrt(12562600116142032139944131264137286284056125140009683685872121757544879053454);
        assert!(r == 112083005474255695210106415441466496555, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_189() {
        let r = sqrt(12562600116142032139944131264137286283860651645475372512454468230545826868024);
        assert!(r == 112083005474255695210106415441466496554, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_190() {
        let r = sqrt(12204054742544775885774290365901388301283872479555485264757952846756477426245);
        assert!(r == 110471963604096292381633337576637231875, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_191() {
        let r = sqrt(12204054742544775885774290365901388301140480809546966410308530934462516015624);
        assert!(r == 110471963604096292381633337576637231874, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_192() {
        let r = sqrt(58588772933760292566842513276234620256234258844367141741125240813159637667557);
        assert!(r == 242051178335822799536355820973941289494, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_193() {
        let r = sqrt(58588772933760292566842513276234620256224754355719306277385145541235514776035);
        assert!(r == 242051178335822799536355820973941289493, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_194() {
        let r = sqrt(2150592266848683726360183562353117334278067364784288720011206347799563908054);
        assert!(r == 46374478615383739172902788511494052277, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_195() {
        let r = sqrt(2150592266848683726360183562353117334255455820013887035848262066746408884728);
        assert!(r == 46374478615383739172902788511494052276, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_196() {
        let r = sqrt(77456358142848517974729949751487929350984810693061654929023764130817450630237);
        assert!(r == 278309824014260261927596552756334375031, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_197() {
        let r = sqrt(77456358142848517974729949751487929350501768955862907629702673077533356250960);
        assert!(r == 278309824014260261927596552756334375030, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_198() {
        let r = sqrt(56239298091693738211248504400710740265355535470792555904896086364332722479093);
        assert!(r == 237148261835700027572316813903053788944, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_199() {
        let r = sqrt(56239298091693738211248504400710740265279841850048905703515576670114496635135);
        assert!(r == 237148261835700027572316813903053788943, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_200() {
        let r = sqrt(25278895133529517554478415359151611153431824579445951652271709471823268329344);
        assert!(r == 158993380785268911629626188798470560621, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_201() {
        let r = sqrt(25278895133529517554478415359151611153395266789711602727601521674414035905640);
        assert!(r == 158993380785268911629626188798470560620, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_202() {
        let r = sqrt(93542651158205274271725673925380535662678884577660383549373708394868352332709);
        assert!(r == 305847431178038953742311807869531348076, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_203() {
        let r = sqrt(93542651158205274271725673925380535662306649238791231078967831950865868901775);
        assert!(r == 305847431178038953742311807869531348075, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_204() {
        let r = sqrt(59248199089046674589840865103088981162629452510828142704265643801074902046961);
        assert!(r == 243409529577308609098363677791763247175, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_205() {
        let r = sqrt(59248199089046674589840865103088981162604138026566677388074764527100145480624);
        assert!(r == 243409529577308609098363677791763247174, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_206() {
        let r = sqrt(96693291031745261334506188162133257100301840870589238785046410507859530192972);
        assert!(r == 310955448628489642894931618847106654989, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_207() {
        let r = sqrt(96693291031745261334506188162133257100071491216011231329336769330652678590120);
        assert!(r == 310955448628489642894931618847106654988, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_208() {
        let r = sqrt(65572070555744251955108363604987159396930212390439171803804423750831339057131);
        assert!(r == 256070440613016191129517942442020029520, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_209() {
        let r = sqrt(65572070555744251955108363604987159396702388698530329927801002176861671430399);
        assert!(r == 256070440613016191129517942442020029519, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_210() {
        let r = sqrt(16737341006521264611902653119033354922872045052503824228740072089884001608083);
        assert!(r == 129372875853175902923984381536227488826, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_211() {
        let r = sqrt(16737341006521264611902653119033354922813193735519752067691973184637954858275);
        assert!(r == 129372875853175902923984381536227488825, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_212() {
        let r = sqrt(53476303181512153837131564278996963035927571734300452272830181884093826521457);
        assert!(r == 231249439310697905607888578985630580790, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_213() {
        let r = sqrt(53476303181512153837131564278996963035916771191941719250962075028432717024099);
        assert!(r == 231249439310697905607888578985630580789, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_214() {
        let r = sqrt(69972799093967524077698295056548650729998181367814956168107340750291032924906);
        assert!(r == 264523721231135571815645679840567396935, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_215() {
        let r = sqrt(69972799093967524077698295056548650729603733821691121913174736520081847394224);
        assert!(r == 264523721231135571815645679840567396934, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_216() {
        let r = sqrt(101822516006929123964250306818452932264009385193039353832118000613875095270615);
        assert!(r == 319096405506124628242189327556289112024, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_217() {
        let r = sqrt(101822516006929123964250306818452932263650969589362154770497911852450421376575);
        assert!(r == 319096405506124628242189327556289112023, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_218() {
        let r = sqrt(31478846428638108368165831810165018068179423810121113960545476038878116302015);
        assert!(r == 177422790048623991218381638819228813106, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_219() {
        let r = sqrt(31478846428638108368165831810165018068023576524185756968904143479065477367235);
        assert!(r == 177422790048623991218381638819228813105, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_220() {
        let r = sqrt(16048961822937293335229790615190080210188111497375374211017268520846197143075);
        assert!(r == 126684497168901030986854817550278424939, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_221() {
        let r = sqrt(16048961822937293335229790615190080209989577806142892327256507279346657153720);
        assert!(r == 126684497168901030986854817550278424938, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_222() {
        let r = sqrt(96710760932368118786666403553851916532668448072549398667481737527628487510132);
        assert!(r == 310983538040791025383797800580026650845, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_223() {
        let r = sqrt(96710760932368118786666403553851916532248094180635237657789197690467539214024);
        assert!(r == 310983538040791025383797800580026650844, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_224() {
        let r = sqrt(72977848780687124034572767581844086596636863801476388563676856785447164389983);
        assert!(r == 270144125941481696387409837155128080950, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_225() {
        let r = sqrt(72977848780687124034572767581844086596207820924625440533989331799229752902499);
        assert!(r == 270144125941481696387409837155128080949, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_226() {
        let r = sqrt(8373612331531036002958594734648297306894397474085200567976143374569862011346);
        assert!(r == 91507444131781082124817851587354522879, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_227() {
        let r = sqrt(8373612331531036002958594734648297306767111712059610142759561604417734448640);
        assert!(r == 91507444131781082124817851587354522878, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_228() {
        let r = sqrt(93711529218953334825148515503004763005615054422909149171026504933170445473444);
        assert!(r == 306123388879310126497035595566406089871, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_229() {
        let r = sqrt(93711529218953334825148515503004763005293549659324668594127775132955328796640);
        assert!(r == 306123388879310126497035595566406089870, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_230() {
        let r = sqrt(75110411318532720926026199150843277999602211012650873909952620438148306191873);
        assert!(r == 274062787183033517594136066688908700547, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_231() {
        let r = sqrt(75110411318532720926026199150843277999151163424601834424928453893356118099208);
        assert!(r == 274062787183033517594136066688908700546, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_232() {
        let r = sqrt(71117705182572875909963044513393934264323550375413170688746901333324005635493);
        assert!(r == 266679030264047712788369317761176723402, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_233() {
        let r = sqrt(71117705182572875909963044513393934264052853791133149116855317117004814453603);
        assert!(r == 266679030264047712788369317761176723401, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_234() {
        let r = sqrt(78179078293942733007834369653205117799283121649183857444158631178106131858368);
        assert!(r == 279605218645759065538665302962684494197, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_235() {
        let r = sqrt(78179078293942733007834369653205117798753886233185964131449940355333726674808);
        assert!(r == 279605218645759065538665302962684494196, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_236() {
        let r = sqrt(102131212871783694243436120502613040180487761239326911905171323382370866978540);
        assert!(r == 319579744151258269705224271580232997387, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_237() {
        let r = sqrt(102131212871783694243436120502613040179945406684748512727454291010702348827768);
        assert!(r == 319579744151258269705224271580232997386, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_238() {
        let r = sqrt(40925233945597192852006650808843816329567879656291393823410150075154362262643);
        assert!(r == 202299861457187342414897617612418859152, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_239() {
        let r = sqrt(40925233945597192852006650808843816329304717657211447879103740613037214159103);
        assert!(r == 202299861457187342414897617612418859151, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_240() {
        let r = sqrt(15412829479953438202637116575238149158246196068387692913239729807139393680021);
        assert!(r == 124148417146387485477192273305035256427, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_241() {
        let r = sqrt(15412829479953438202637116575238149158028215869384696002122484805485644806328);
        assert!(r == 124148417146387485477192273305035256426, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_242() {
        let r = sqrt(112130305704902293938443726695656639450742932609949251865518404455456679249844);
        assert!(r == 334858635404408070251641919598399625136, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_243() {
        let r = sqrt(112130305704902293938443726695656639450196889399113916394289463330905323018495);
        assert!(r == 334858635404408070251641919598399625135, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_244() {
        let r = sqrt(77777231405586007703247373967001065122125876891994805185690524389579844373631);
        assert!(r == 278885695950125788632701938588293789649, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_245() {
        let r = sqrt(77777231405586007703247373967001065121862574134909822818662862463581859543200);
        assert!(r == 278885695950125788632701938588293789648, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_246() {
        let r = sqrt(43471971202769616481417693491033675000311860035911312081474817733802345681324);
        assert!(r == 208499331420437932495451600297901575243, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_247() {
        let r = sqrt(43471971202769616481417693491033675000176257573170259234074826132260790509048);
        assert!(r == 208499331420437932495451600297901575242, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_248() {
        let r = sqrt(26688567191206896582987854312125138231958933439963579427251903932664026378010);
        assert!(r == 163366358811130073442219536624990681946, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_249() {
        let r = sqrt(26688567191206896582987854312125138231776594851178999255580746631326130346915);
        assert!(r == 163366358811130073442219536624990681945, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_250() {
        let r = sqrt(108214624291842453975065998555412638942799036736451426360320445932392885710349);
        assert!(r == 328959912894933831898276156942917458401, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_251() {
        let r = sqrt(108214624291842453975065998555412638942378034283317005266573706469401565476800);
        assert!(r == 328959912894933831898276156942917458400, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_252() {
        let r = sqrt(19235204703234100103041890344281451371775023805902941356167831554121283258866);
        assert!(r == 138691040457680971653143629649456045265, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_253() {
        let r = sqrt(19235204703234100103041890344281451371631316989076102612533888101253728920224);
        assert!(r == 138691040457680971653143629649456045264, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_254() {
        let r = sqrt(1860528024398376971030282188869100113166467812499592106900181824088613698618);
        assert!(r == 43133838507584471307518318638098154413, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_255() {
        let r = sqrt(1860528024398376971030282188869100113123154793600707781149329333276791374568);
        assert!(r == 43133838507584471307518318638098154412, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_256() {
        let r = sqrt(71947407620630628147222794306851276524221719338665356888318528651774292621031);
        assert!(r == 268230139284590142695022137291734793738, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_257() {
        let r = sqrt(71947407620630628147222794306851276524012511242047310239187146089353404012643);
        assert!(r == 268230139284590142695022137291734793737, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_258() {
        let r = sqrt(40568673064144852137518192111625833744694659491848918482105776199569284826629);
        assert!(r == 201416665308868749867639520957283661582, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_259() {
        let r = sqrt(40568673064144852137518192111625833744539440368928076030089850011841102742723);
        assert!(r == 201416665308868749867639520957283661581, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_260() {
        let r = sqrt(76492158126366589996942695324796993788290280345415013933089691142033797034173);
        assert!(r == 276572157178495807452306093933284582381, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_261() {
        let r = sqrt(76492158126366589996942695324796993787774405628694409032793606576077575629160);
        assert!(r == 276572157178495807452306093933284582380, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_262() {
        let r = sqrt(192830207753856948555860425402666808197378240542815047050285721127205182490);
        assert!(r == 13886331688169375876852227224971905314, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_263() {
        let r = sqrt(192830207753856948555860425402666808185355202382878924640426736611381438595);
        assert!(r == 13886331688169375876852227224971905313, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_264() {
        let r = sqrt(96507234477018650642150331560292489570763618357024220861892292055367775104147);
        assert!(r == 310656135424714653489408465523567057690, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_265() {
        let r = sqrt(96507234477018650642150331560292489570323994884211188471381155598163788136099);
        assert!(r == 310656135424714653489408465523567057689, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_266() {
        let r = sqrt(108052671337403039151909380066288795727945293782478558507392527435127561225101);
        assert!(r == 328713661622700189153613932848294711835, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_267() {
        let r = sqrt(108052671337403039151909380066288795727375847009830470709166488567225689067224);
        assert!(r == 328713661622700189153613932848294711834, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_268() {
        let r = sqrt(27557164145586169623612365429932051868924466759457021533184905151023072171623);
        assert!(r == 166003506425575750919675291855241138243, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_269() {
        let r = sqrt(27557164145586169623612365429932051868866280042259781609041911969182237127048);
        assert!(r == 166003506425575750919675291855241138242, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_270() {
        let r = sqrt(22367931844254011810327757413675339418095678340850287433167622801941281292636);
        assert!(r == 149559124911367450172204566336887498708, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_271() {
        let r = sqrt(22367931844254011810327757413675339417903637520051996325166588241732701669263);
        assert!(r == 149559124911367450172204566336887498707, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_272() {
        let r = sqrt(60060089502898128450402302249474015910530750487662438454226394411631933039063);
        assert!(r == 245071600767812606317635547793366559794, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_273() {
        let r = sqrt(60060089502898128450402302249474015910239497599363978340781292835366577322435);
        assert!(r == 245071600767812606317635547793366559793, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_274() {
        let r = sqrt(161428783429005780931610736286384280880519220768378343908445885162941617951);
        assert!(r == 12705462739664611716908559089046970687, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_275() {
        let r = sqrt(161428783429005780931610736286384280856350750990067398994183054531437251968);
        assert!(r == 12705462739664611716908559089046970686, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_276() {
        let r = sqrt(82114063651112539038632597136178587756784396129076258906660565841341414751199);
        assert!(r == 286555515827409155524413282519716747662, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_277() {
        let r = sqrt(82114063651112539038632597136178587756658412787831546193695991168366982466243);
        assert!(r == 286555515827409155524413282519716747661, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_278() {
        let r = sqrt(19484749153967402406952046054402592163689508743098001230308218313605969280220);
        assert!(r == 139587782968164525565745780996996485638, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_279() {
        let r = sqrt(19484749153967402406952046054402592163497096436668693743060207654522740267043);
        assert!(r == 139587782968164525565745780996996485637, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_280() {
        let r = sqrt(112511736339647088026949983938280558321771022119806141438469111837803663750406);
        assert!(r == 335427691670868295391995102420031507104, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_281() {
        let r = sqrt(112511736339647088026949983938280558321703616083572726477318876176057602466815);
        assert!(r == 335427691670868295391995102420031507103, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_282() {
        let r = sqrt(21956443357962079869397843729202440451038878240251670056174468904031765340681);
        assert!(r == 148177067584569508747518714120205530941, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_283() {
        let r = sqrt(21956443357962079869397843729202440450896888216043857879856429416807708345480);
        assert!(r == 148177067584569508747518714120205530940, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_284() {
        let r = sqrt(48063931686384487202767642669287544398890476181919520423245823310832703499626);
        assert!(r == 219234877896708048415768989565630203358, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_285() {
        let r = sqrt(48063931686384487202767642669287544398873341702415567283977657074812434476163);
        assert!(r == 219234877896708048415768989565630203357, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_286() {
        let r = sqrt(81017125038927155555181052456403372645899957761278641061388322196688114434269);
        assert!(r == 284635073451827358519224176125940447540, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_287() {
        let r = sqrt(81017125038927155555181052456403372645415581268333224853916450406575492051599);
        assert!(r == 284635073451827358519224176125940447539, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_288() {
        let r = sqrt(55769140345575365791241145937747388174027041927543033825214504345860826764614);
        assert!(r == 236154907519567261249606401308719447018, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_289() {
        let r = sqrt(55769140345575365791241145937747388173634147235443256669054021403099709092323);
        assert!(r == 236154907519567261249606401308719447017, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_290() {
        let r = sqrt(21061209865532874783459224738051309625531884205122659458158124659537684839885);
        assert!(r == 145124807891458980506207015361906149520, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_291() {
        let r = sqrt(21061209865532874783459224738051309625390201495262467648301826660392596230399);
        assert!(r == 145124807891458980506207015361906149519, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_292() {
        let r = sqrt(60102532250609093340150140904222888236412519201990277517992829433406212953960);
        assert!(r == 245158178021066825965125115565139373974, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_293() {
        let r = sqrt(60102532250609093340150140904222888235950542022863257014752026035724628552675);
        assert!(r == 245158178021066825965125115565139373973, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_294() {
        let r = sqrt(30437960851141503241621925834695357047782446780679933435770973229772901781857);
        assert!(r == 174464783985598375089308908996290961713, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_295() {
        let r = sqrt(30437960851141503241621925834695357047750293567147813424311359199014431894368);
        assert!(r == 174464783985598375089308908996290961712, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_296() {
        let r = sqrt(25173812971252542238356595229025592916888934209743776229830745080602272678637);
        assert!(r == 158662575837065440724373858088258519382, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_297() {
        let r = sqrt(25173812971252542238356595229025592916679896302153208540003797755502869661923);
        assert!(r == 158662575837065440724373858088258519381, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_298() {
        let r = sqrt(32221892044812317253342149245969476776340701280371166403597593977831277768969);
        assert!(r == 179504573882707281987100138036359544334, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_299() {
        let r = sqrt(32221892044812317253342149245969476776264386310328258168739052648176111503555);
        assert!(r == 179504573882707281987100138036359544333, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_300() {
        let r = sqrt(28331916965311780655489727286729052023419687994783847255625132429404832040014);
        assert!(r == 168320875013504432101209542786516744392, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_301() {
        let r = sqrt(28331916965311780655489727286729052023292149334062054257099366136990663449663);
        assert!(r == 168320875013504432101209542786516744391, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_302() {
        let r = sqrt(44805601889781984204937890562173556958354892841994806528435208298251596095570);
        assert!(r == 211673337692261053941131290802316945351, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_303() {
        let r = sqrt(44805601889781984204937890562173556958036005958088693383804746377359520513200);
        assert!(r == 211673337692261053941131290802316945350, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_304() {
        let r = sqrt(47581277558991361030137858430775851448797969817835793437899273156084125331913);
        assert!(r == 218131330988905307761622667206187682451, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_305() {
        let r = sqrt(47581277558991361030137858430775851448765391689916649178272794028514413367400);
        assert!(r == 218131330988905307761622667206187682450, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_306() {
        let r = sqrt(79265655919623566523106642832885692810645314169357235002705315625897987598484);
        assert!(r == 281541570500030361898380193043358795147, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_307() {
        let r = sqrt(79265655919623566523106642832885692810517266812381530640698631858599510751608);
        assert!(r == 281541570500030361898380193043358795146, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_308() {
        let r = sqrt(6804922034769263044980995779190073812113657978639160501906354695658345164540);
        assert!(r == 82491951333261980516847323208409442060, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_309() {
        let r = sqrt(6804922034769263044980995779190073812101840250919811076703706299760497043599);
        assert!(r == 82491951333261980516847323208409442059, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_310() {
        let r = sqrt(104171338762596549682825992261547989404284409181438994341823873971934709880719);
        assert!(r == 322755850082684867952028142748309068249, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_311() {
        let r = sqrt(104171338762596549682825992261547989403987497450919724099659788339686539926000);
        assert!(r == 322755850082684867952028142748309068248, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_312() {
        let r = sqrt(48889598006738915570489970097754869894929024529770106410943574992891093857352);
        assert!(r == 221109922904285133691916292841774749985, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_313() {
        let r = sqrt(48889598006738915570489970097754869894836314132359538136281240952309257500224);
        assert!(r == 221109922904285133691916292841774749984, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_314() {
        let r = sqrt(105759860918393730836355230316824559555188687037590272378385914085232900528225);
        assert!(r == 325207412151681639429158998652999885741, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_315() {
        let r = sqrt(105759860918393730836355230316824559555001700580860776741852945813759055119080);
        assert!(r == 325207412151681639429158998652999885740, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_316() {
        let r = sqrt(92413789298268646863915646367599182792217630731593747885836050208153207218458);
        assert!(r == 303996363955670770558871825494523016508, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_317() {
        let r = sqrt(92413789298268646863915646367599182792092522077426729045215188056171640514063);
        assert!(r == 303996363955670770558871825494523016507, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_318() {
        let r = sqrt(64585738096945708636443561680112638453975194509959599754591989402341208923861);
        assert!(r == 254137242640557719254168521243357282068, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_319() {
        let r = sqrt(64585738096945708636443561680112638453852759110070327758829529591524114356623);
        assert!(r == 254137242640557719254168521243357282067, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_320() {
        let r = sqrt(9104759676461849298107117384766465628552277577749830654758215703186518812583);
        assert!(r == 95418864363719238817470268241751939402, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_321() {
        let r = sqrt(9104759676461849298107117384766465628420228483877100795389399676628280117603);
        assert!(r == 95418864363719238817470268241751939401, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_322() {
        let r = sqrt(81144607718761882599178417293522503920622754921151823191483192425969032878884);
        assert!(r == 284858925994538360716751048534568609235, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_323() {
        let r = sqrt(81144607718761882599178417293522503920286946197519035279941054539442127285224);
        assert!(r == 284858925994538360716751048534568609234, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_324() {
        let r = sqrt(66362338131949877672251359686459154477094619376243705568666851646745570323634);
        assert!(r == 257608885972417259068249982823090808815, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_325() {
        let r = sqrt(66362338131949877672251359686459154477072795137302866619456862215730881704224);
        assert!(r == 257608885972417259068249982823090808814, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_326() {
        let r = sqrt(71954358352421695206286955792965509711533604755552253398929748013520902280049);
        assert!(r == 268243095628613888106106767581638197015, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_327() {
        let r = sqrt(71954358352421695206286955792965509711517257846442075276244393236859954910224);
        assert!(r == 268243095628613888106106767581638197014, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_328() {
        let r = sqrt(85004644927359700633342555178301468999255712806039309907909844228647043340691);
        assert!(r == 291555560618143074087219765481926335231, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_329() {
        let r = sqrt(85004644927359700633342555178301468998765228813211908832571074019182191823360);
        assert!(r == 291555560618143074087219765481926335230, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_330() {
        let r = sqrt(81690392250202681518007516428782096830938396564228459362418025408197762667706);
        assert!(r == 285815311434154418567026063322950587982, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_331() {
        let r = sqrt(81690392250202681518007516428782096830548458427688778950234232009919522832323);
        assert!(r == 285815311434154418567026063322950587981, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_332() {
        let r = sqrt(45616893056204641995707752307818129749614578284744946936178037456971258351117);
        assert!(r == 213581115869836774283839979043330095599, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_333() {
        let r = sqrt(45616893056204641995707752307818129749302872619209583103653802026618479168800);
        assert!(r == 213581115869836774283839979043330095598, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_334() {
        let r = sqrt(97993057875050972286442540814421025637855439300990714852794505371589555826173);
        assert!(r == 313038428751249280682669188282841033210, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_335() {
        let r = sqrt(97993057875050972286442540814421025637283133497690238629102517027300322904099);
        assert!(r == 313038428751249280682669188282841033209, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_336() {
        let r = sqrt(72760175669328693129471948063910980449366785264536639965449391583178392991834);
        assert!(r == 269740941774378575942258926844831657310, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_337() {
        let r = sqrt(72760175669328693129471948063910980448889712443986083349181827313161276436099);
        assert!(r == 269740941774378575942258926844831657309, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_338() {
        let r = sqrt(4879853265405056344657586590595633520498026341099116179385696539272044318970);
        assert!(r == 69855946528588790890123202511016310592, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_339() {
        let r = sqrt(4879853265405056344657586590595633520433422284646680937892780859059411390463);
        assert!(r == 69855946528588790890123202511016310591, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_340() {
        let r = sqrt(31423068117377349945608277390165033942735261096024092589407035371392186477025);
        assert!(r == 177265529975168466043544033381826709997, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_341() {
        let r = sqrt(31423068117377349945608277390165033942609159800360348070573232269133139740008);
        assert!(r == 177265529975168466043544033381826709996, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_342() {
        let r = sqrt(73337429491496743142458384555123513127151018924632295318778504756096467321869);
        assert!(r == 270808843082157756819832666153846298441, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_343() {
        let r = sqrt(73337429491496743142458384555123513126799753316561714825902030955997239030480);
        assert!(r == 270808843082157756819832666153846298440, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_344() {
        let r = sqrt(5775148473011118996661345065671943760878475020724917682942973865234184170981);
        assert!(r == 75994397642267808139548812350545133653, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_345() {
        let r = sqrt(5775148473011118996661345065671943760738056703206343278196631199799633124408);
        assert!(r == 75994397642267808139548812350545133652, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_346() {
        let r = sqrt(24551785109558192726752186437999600872907204938121937752597577726858933559798);
        assert!(r == 156690092569882007606411654428300961485, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_347() {
        let r = sqrt(24551785109558192726752186437999600872862486928672105901260005988975453405224);
        assert!(r == 156690092569882007606411654428300961484, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_348() {
        let r = sqrt(79365090616291206657795482156476406728419896689516631817264240417392740831389);
        assert!(r == 281718104878424891511702762505333414266, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_349() {
        let r = sqrt(79365090616291206657795482156476406727860643174127441888966664957732772318755);
        assert!(r == 281718104878424891511702762505333414265, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_350() {
        let r = sqrt(95973484985321496670049049397961626269612670373304145712212986838089021432178);
        assert!(r == 309795876320717827385134598427192481576, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_351() {
        let r = sqrt(95973484985321496670049049397961626269403800861259324207283749211061099443775);
        assert!(r == 309795876320717827385134598427192481575, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_352() {
        let r = sqrt(105455220841977041284158684128596838389851342850446269341848566894826739989035);
        assert!(r == 324738696249734058828935471227954052637, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_353() {
        let r = sqrt(105455220841977041284158684128596838389441915369077462921983824167632166653768);
        assert!(r == 324738696249734058828935471227954052636, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_354() {
        let r = sqrt(56135824686180171298908523589289357019542221988984358170527533906845277350881);
        assert!(r == 236929999548770039875279716952544423126, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_355() {
        let r = sqrt(56135824686180171298908523589289357019425625112701325037559102460444123611875);
        assert!(r == 236929999548770039875279716952544423125, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_356() {
        let r = sqrt(60390850236192695763967831801765092697014962753995732785240113454977589063035);
        assert!(r == 245745498913393520091424236908629108562, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_357() {
        let r = sqrt(60390850236192695763967831801765092696661218534139777420890674190174781707843);
        assert!(r == 245745498913393520091424236908629108561, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_358() {
        let r = sqrt(81887563863395269055264023403952254199130641058210478591698109662339893109042);
        assert!(r == 286160031911158531474044594868692091377, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_359() {
        let r = sqrt(81887563863395269055264023403952254198607831038992590664267681496946117756128);
        assert!(r == 286160031911158531474044594868692091376, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_360() {
        let r = sqrt(24765742244074188792285770357102605099548823236400551388673131638324112018102);
        assert!(r == 157371351408298546110778662632587284981, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_361() {
        let r = sqrt(24765742244074188792285770357102605099455712108324465708982423963632908170360);
        assert!(r == 157371351408298546110778662632587284980, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_362() {
        let r = sqrt(43567582523071376287745899412731655750727316195133320417426358456199555896605);
        assert!(r == 208728489965005439091044255912360220391, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_363() {
        let r = sqrt(43567582523071376287745899412731655750400934941742752244669979161914092192880);
        assert!(r == 208728489965005439091044255912360220390, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_364() {
        let r = sqrt(42033173515900144508331092395305848548990734925327145696755540828337818451291);
        assert!(r == 205019934435410803319126336145193888532, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_365() {
        let r = sqrt(42033173515900144508331092395305848548763203390276505726700422771042841115023);
        assert!(r == 205019934435410803319126336145193888531, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_366() {
        let r = sqrt(7526287442429658666919931297116157273228965199580487238239777312083052320662);
        assert!(r == 86754178241913274818867506090180704966, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_367() {
        let r = sqrt(7526287442429658666919931297116157273096795606258371305793029140164737061155);
        assert!(r == 86754178241913274818867506090180704965, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_368() {
        let r = sqrt(39080620915512167765017951412839447293349861794937990064072053815850729324714);
        assert!(r == 197688191138247222733465290345347651818, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_369() {
        let r = sqrt(39080620915512167765017951412839447293303361593508630494281795056206558705123);
        assert!(r == 197688191138247222733465290345347651817, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_370() {
        let r = sqrt(78846450832050927830205698733747933082207612347428201712921990657065871914613);
        assert!(r == 280796101881865389670277389705346638007, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_371() {
        let r = sqrt(78846450832050927830205698733747933081740017175983606670034127193777896932048);
        assert!(r == 280796101881865389670277389705346638006, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_372() {
        let r = sqrt(81109202065374699964490387422380718857781776226084494936647849954605552103444);
        assert!(r == 284796773270651189736686940825162728239, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_373() {
        let r = sqrt(81109202065374699964490387422380718857599861309075263559774525394829768041120);
        assert!(r == 284796773270651189736686940825162728238, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_374() {
        let r = sqrt(19684962623228365043241225292036405367342396002986287607072022921766419585411);
        assert!(r == 140303109813105586213704398240043737727, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_375() {
        let r = sqrt(19684962623228365043241225292036405367323220373424495030857842713948763126528);
        assert!(r == 140303109813105586213704398240043737726, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_376() {
        let r = sqrt(47373143081607244402940230061340735428176429568055862139859767946898032126977);
        assert!(r == 217653722875597155274628962550702518592, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_377() {
        let r = sqrt(47373143081607244402940230061340735428060402980654777926686586991572105662463);
        assert!(r == 217653722875597155274628962550702518591, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_378() {
        let r = sqrt(111735191404267210201211662532242443530738886337314480794061936464499745843464);
        assert!(r == 334268142969483722533918554335367180522, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_379() {
        let r = sqrt(111735191404267210201211662532242443530626103729797362047197556147275736192483);
        assert!(r == 334268142969483722533918554335367180521, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_380() {
        let r = sqrt(47885282008135720791708239887486336416248480925331187143670730482128231112567);
        assert!(r == 218827059588469818637491975890064943825, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_381() {
        let r = sqrt(47885282008135720791708239887486336415819751675975091326742212976200405630624);
        assert!(r == 218827059588469818637491975890064943824, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_382() {
        let r = sqrt(31570030500183483157502371383529425232349936602380287233876510498278402633417);
        assert!(r == 177679572546152539300409208547745714311, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_383() {
        let r = sqrt(31570030500183483157502371383529425232134851558925548001148918922067630204720);
        assert!(r == 177679572546152539300409208547745714310, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_384() {
        let r = sqrt(66248725451882498742624433248691700434899488647571745324771884477986235209630);
        assert!(r == 257388277611631914705522571570631521608, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_385() {
        let r = sqrt(66248725451882498742624433248691700434799565327303673186656761788661370905663);
        assert!(r == 257388277611631914705522571570631521607, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_386() {
        let r = sqrt(58683227149738068171035710586938771493309707367148383261231828505692707106215);
        assert!(r == 242246211837745913122285111063816594533, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_387() {
        let r = sqrt(58683227149738068171035710586938771492965645817087746954292354063789325488088);
        assert!(r == 242246211837745913122285111063816594532, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_388() {
        let r = sqrt(6559599603891428200141090829337152881768640946770040305497542542005476619916);
        assert!(r == 80991355118255850801339504571744007346, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_389() {
        let r = sqrt(6559599603891428200141090829337152881730936389503083050123202704062901963715);
        assert!(r == 80991355118255850801339504571744007345, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_390() {
        let r = sqrt(11064278052362641781706947658494986713511632217847766702236970369814088726494);
        assert!(r == 105186872053325370198589765801184491896, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_391() {
        let r = sqrt(11064278052362641781706947658494986713460092642201708616438678934651689674815);
        assert!(r == 105186872053325370198589765801184491895, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_392() {
        let r = sqrt(56408390500219704523575719441233878858293079318700472914117919589525141331165);
        assert!(r == 237504506273501481375626319962476434220, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_393() {
        let r = sqrt(56408390500219704523575719441233878857854661262090881786969358788845987008399);
        assert!(r == 237504506273501481375626319962476434219, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_394() {
        let r = sqrt(401625025153845429068242266449615866440523589604433971253878829997468212353);
        assert!(r == 20040584451403742158983586289588175318, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_395() {
        let r = sqrt(401625025153845429068242266449615866409988088493409146365971980008704401123);
        assert!(r == 20040584451403742158983586289588175317, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_396() {
        let r = sqrt(31302065160079489300784769607591300740431170762426860244424757211420402772826);
        assert!(r == 176923896520734273875645903758515200161, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_397() {
        let r = sqrt(31302065160079489300784769607591300740400403911642500249754489641281894425920);
        assert!(r == 176923896520734273875645903758515200160, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_398() {
        let r = sqrt(60960958831614655430105736606228882265270376853058262190876106436117621198057);
        assert!(r == 246902731519144306590506942470576828577, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_399() {
        let r = sqrt(60960958831614655430105736606228882264797802862524397383567514661587243844928);
        assert!(r == 246902731519144306590506942470576828576, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_400() {
        let r = sqrt(80059537494850331845951837997232298084197286048611530136834536469077643530506);
        assert!(r == 282947941315801645551153098273325414686, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_401() {
        let r = sqrt(80059537494850331845951837997232298083645111944577819147353976769273864478595);
        assert!(r == 282947941315801645551153098273325414685, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_402() {
        let r = sqrt(91946370648157969245123616626436027177823784045527099074505983576467507064109);
        assert!(r == 303226599506306453657743580092317659284, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_403() {
        let r = sqrt(91946370648157969245123616626436027177408340627348214741879343655676711392655);
        assert!(r == 303226599506306453657743580092317659283, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_404() {
        let r = sqrt(104830338383238872669635877122682376661519523881006274456006518401094763117293);
        assert!(r == 323775135523466150968663893712428469147, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_405() {
        let r = sqrt(104830338383238872669635877122682376661444534461670666423481142193137930907608);
        assert!(r == 323775135523466150968663893712428469146, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_406() {
        let r = sqrt(56314200593454591177464450236630834631500210894466363537331624631039528846616);
        assert!(r == 237306132650326993561504874391288869603, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_407() {
        let r = sqrt(56314200593454591177464450236630834631027527083753278559176869519193537377608);
        assert!(r == 237306132650326993561504874391288869602, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_408() {
        let r = sqrt(25819857435894553252779638597924854823176904918831374430785826938307731029268);
        assert!(r == 160685585650656771201428568367401126928, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_409() {
        let r = sqrt(25819857435894553252779638597924854822915251732008048868370146275964366717183);
        assert!(r == 160685585650656771201428568367401126927, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_410() {
        let r = sqrt(45859305718564912489319232299177289532114174101438849270306828753319666961353);
        assert!(r == 214147859476962581404621767054455687278, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_411() {
        let r = sqrt(45859305718564912489319232299177289531781154286757690858212982328919331049283);
        assert!(r == 214147859476962581404621767054455687277, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_412() {
        let r = sqrt(45586821385057682070163543845133696694918896206621159414174569727216124842477);
        assert!(r == 213510705551402461918991061443053426798, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_413() {
        let r = sqrt(45586821385057682070163543845133696694562057974031098497856044353450744532803);
        assert!(r == 213510705551402461918991061443053426797, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_414() {
        let r = sqrt(86349383352601367052738778463866418321569898395438341038135909619645058976564);
        assert!(r == 293852655854258644222528714663057113085, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_415() {
        let r = sqrt(86349383352601367052738778463866418321096182836685803286359980592614478217224);
        assert!(r == 293852655854258644222528714663057113084, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_416() {
        let r = sqrt(75010855527125229129763323874378465362513717453954713606979190196611290061612);
        assert!(r == 273881097425735515343931521585105074467, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_417() {
        let r = sqrt(75010855527125229129763323874378465362402842552488788764855096781033615334088);
        assert!(r == 273881097425735515343931521585105074466, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_418() {
        let r = sqrt(56424697581742236549262233330147436552575968722383294243395071029811540460563);
        assert!(r == 237538833839316127407283068541868293223, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_419() {
        let r = sqrt(56424697581742236549262233330147436552138821862937600767195343528407107727728);
        assert!(r == 237538833839316127407283068541868293222, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_420() {
        let r = sqrt(5418466193241240656754703734190417323488393712635654056987156615048413575233);
        assert!(r == 73610231579864226485800476405343073879, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_421() {
        let r = sqrt(5418466193241240656754703734190417323399662572272597939745740349676452106640);
        assert!(r == 73610231579864226485800476405343073878, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_422() {
        let r = sqrt(58867416831001431926246136478199050928541698602335118349704930328678409479413);
        assert!(r == 242626084399434332391686193527747413679, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_423() {
        let r = sqrt(58867416831001431926246136478199050928302703567454054793564600738873556315040);
        assert!(r == 242626084399434332391686193527747413678, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_424() {
        let r = sqrt(104858891048865951410975226806676802727737292990405870122582830334605416895391);
        assert!(r == 323819225878986301135082867954399898347, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_425() {
        let r = sqrt(104858891048865951410975226806676802727274830010396927871321807662763933332408);
        assert!(r == 323819225878986301135082867954399898346, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_426() {
        let r = sqrt(97370528056256318982086338268910686866114830942523840780594918388248172919132);
        assert!(r == 312042510014671428873378642294160623129, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_427() {
        let r = sqrt(97370528056256318982086338268910686865777745200935891627090093835641569750640);
        assert!(r == 312042510014671428873378642294160623128, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_428() {
        let r = sqrt(36848973575682369825145887858864672368038247706248913281624519710451074530495);
        assert!(r == 191960864698204487498181872884948739184, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_429() {
        let r = sqrt(36848973575682369825145887858864672367797457349678261020584015879351256985855);
        assert!(r == 191960864698204487498181872884948739183, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_430() {
        let r = sqrt(28791208135192296758028185097998864286035031450004588465269433910172794371040);
        assert!(r == 169679722227472710929725447335069388253, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_431() {
        let r = sqrt(28791208135192296758028185097998864285888642322299033911345443126239654392008);
        assert!(r == 169679722227472710929725447335069388252, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_432() {
        let r = sqrt(93221535301231234517234772178750125493871656992187355236623990536812164679825);
        assert!(r == 305322019024555833813989981515957798857, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_433() {
        let r = sqrt(93221535301231234517234772178750125493767847661909484805034953635360470506448);
        assert!(r == 305322019024555833813989981515957798856, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_434() {
        let r = sqrt(37092927178446084467443650293534324580904900916118347414197844480558146462407);
        assert!(r == 192595241837502528855407087795934539350, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_435() {
        let r = sqrt(37092927178446084467443650293534324580822002207802614729652537830296698422499);
        assert!(r == 192595241837502528855407087795934539349, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_436() {
        let r = sqrt(98309675834938780052525816147170209566191515523284615043505301964672574678185);
        assert!(r == 313543738312438285651407482113994110522, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_437() {
        let r = sqrt(98309675834938780052525816147170209566166719009281826548926108441701951112483);
        assert!(r == 313543738312438285651407482113994110521, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_438() {
        let r = sqrt(115772305846311918390443043583435963032697550111324479651507480449148476015593);
        assert!(r == 340253296598742623248461220914943301125, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_439() {
        let r = sqrt(115772305846311918390443043583435963032327718322266960243810989273512426265624);
        assert!(r == 340253296598742623248461220914943301124, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_440() {
        let r = sqrt(71220406245032898485710478395706252559353888174795305251581457676407021446256);
        assert!(r == 266871516361399832485495828402986639234, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_441() {
        let r = sqrt(71220406245032898485710478395706252559031916319526665714094462905114068106755);
        assert!(r == 266871516361399832485495828402986639233, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_442() {
        let r = sqrt(53924246624977171032783508515974860885271364081724074760673450493034543930999);
        assert!(r == 232215948257171111621167655254039200316, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_443() {
        let r = sqrt(53924246624977171032783508515974860884825431835435435893265873257192774499855);
        assert!(r == 232215948257171111621167655254039200315, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_444() {
        let r = sqrt(90746931764099674133347448903118623034280853798978227696081004263975635752758);
        assert!(r == 301242314033237492214063124635337113038, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_445() {
        let r = sqrt(90746931764099674133347448903118623034240441616451112215764068627460389589443);
        assert!(r == 301242314033237492214063124635337113037, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_446() {
        let r = sqrt(3036980832201144034358110738979195445061017895618153594516224124150687706019);
        assert!(r == 55108809025428448596226283360326957930, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_447() {
        let r = sqrt(3036980832201144034358110738979195445039270335111279992438064991087989884899);
        assert!(r == 55108809025428448596226283360326957929, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_448() {
        let r = sqrt(101958622612622832240712203770417822517957206903163806370058346506672893896386);
        assert!(r == 319309603069846354160281378353870501520, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_449() {
        let r = sqrt(101958622612622832240712203770417822517439066005663503519577720966016322310399);
        assert!(r == 319309603069846354160281378353870501519, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_450() {
        let r = sqrt(70719061948511750247326647469591867786661466759401823406286982645128078214469);
        assert!(r == 265930558508253711085366903636445300204, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_451() {
        let r = sqrt(70719061948511750247326647469591867786347413254858251907704116575759682441615);
        assert!(r == 265930558508253711085366903636445300203, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_452() {
        let r = sqrt(5311757430798015094544676446061818305255181551020481401400842146663033155874);
        assert!(r == 72881804524847044257303623963765971979, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_453() {
        let r = sqrt(5311757430798015094544676446061818305231362138817042709471208578626613176440);
        assert!(r == 72881804524847044257303623963765971978, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_454() {
        let r = sqrt(107231749418594945344108922685267424826677475977952861939458912556958826931324);
        assert!(r == 327462592395826099714361604806120402150, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_455() {
        let r = sqrt(107231749418594945344108922685267424826127828235867169343828199962477724622499);
        assert!(r == 327462592395826099714361604806120402149, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_456() {
        let r = sqrt(94426465731150133437712616484981913321199152234120624622943243689438274574338);
        assert!(r == 307288896205427724592287360838800449184, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_457() {
        let r = sqrt(94426465731150133437712616484981913321078253869484962363597222031280166265855);
        assert!(r == 307288896205427724592287360838800449183, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_458() {
        let r = sqrt(85284692165030929833373549119593428855521142933438958129218265234985045315822);
        assert!(r == 292035429640019756684638869917610385966, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_459() {
        let r = sqrt(85284692165030929833373549119593428855172639688112924094840245340671489753155);
        assert!(r == 292035429640019756684638869917610385965, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_460() {
        let r = sqrt(109059174000694017039386216209366068317954942138865795987652667719174104638909);
        assert!(r == 330241084664967173795379247822405947090, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_461() {
        let r = sqrt(109059174000694017039386216209366068317388016376186008665883624268999879468099);
        assert!(r == 330241084664967173795379247822405947089, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_462() {
        let r = sqrt(102515631244270730965890976866139165854231149292552691893799665963207918435267);
        assert!(r == 320180622843217560891107148063119158540, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_463() {
        let r = sqrt(102515631244270730965890976866139165853663698795889695505462516014797654931599);
        assert!(r == 320180622843217560891107148063119158539, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_464() {
        let r = sqrt(6639057420873076984581076397743660358724131373383960852415669643747481750397);
        assert!(r == 81480411270888151946120433369925127315, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_465() {
        let r = sqrt(6639057420873076984581076397743660358646360863694821532540454609018959109224);
        assert!(r == 81480411270888151946120433369925127314, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_466() {
        let r = sqrt(68050852547524060535769545275257306000897026218117382685790599062965386051611);
        assert!(r == 260865583294393322573913701945014531023, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_467() {
        let r = sqrt(68050852547524060535769545275257306000771278350497032701430956090620629426528);
        assert!(r == 260865583294393322573913701945014531022, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_468() {
        let r = sqrt(63153986894023728029213976854754454412538842541307284631426160877224309914422);
        assert!(r == 251304569982369656128623422625643992010, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_469() {
        let r = sqrt(63153986894023728029213976854754454412161982646595923923564121178208943840099);
        assert!(r == 251304569982369656128623422625643992009, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_470() {
        let r = sqrt(31199587917148472974166858869340295896106917747276045539151403685494196107883);
        assert!(r == 176634050842832886025654694276120770211, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_471() {
        let r = sqrt(31199587917148472974166858869340295896015831721361141701857720609915864984520);
        assert!(r == 176634050842832886025654694276120770210, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_472() {
        let r = sqrt(107899795372029220161963417045540728815503224571044681280168233745422397560537);
        assert!(r == 328481042637210983634065522998504444924, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_473() {
        let r = sqrt(107899795372029220161963417045540728815145598831149769761123747188985349365775);
        assert!(r == 328481042637210983634065522998504444923, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_474() {
        let r = sqrt(113568213338642647411652720297248167775894549763800863779727173713618676519722);
        assert!(r == 336998832844629667289549308336465401950, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_475() {
        let r = sqrt(113568213338642647411652720297248167775578039570224814014337667909375063802499);
        assert!(r == 336998832844629667289549308336465401949, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_476() {
        let r = sqrt(94264072176976128016107745271722834844665665722954844946961871631280891467424);
        assert!(r == 307024546538181744801713923605811150700, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_477() {
        let r = sqrt(94264072176976128016107745271722834844071806940170039416689542512458110489999);
        assert!(r == 307024546538181744801713923605811150699, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_478() {
        let r = sqrt(89751502785010395095295043822210324903186488116479355224401229403961074313045);
        assert!(r == 299585551696022875967818621452302451333, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_479() {
        let r = sqrt(89751502785010395095295043822210324902704318088519595402624851067840833476888);
        assert!(r == 299585551696022875967818621452302451332, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_480() {
        let r = sqrt(88957940836880411941194662359892559412649219702991927615978215718180688670714);
        assert!(r == 298258178155906417286717032464257559907, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_481() {
        let r = sqrt(88957940836880411941194662359892559412132149057636569973729553978801693848648);
        assert!(r == 298258178155906417286717032464257559906, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_482() {
        let r = sqrt(21807713218263364272201177629949493653732173004031063837236853091139606963846);
        assert!(r == 147674348545247912572147911110685389820, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_483() {
        let r = sqrt(21807713218263364272201177629949493653467526284842861819718587559605359632399);
        assert!(r == 147674348545247912572147911110685389819, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_484() {
        let r = sqrt(112370973941784713804108371828881921336243855896906243953074794074793620509650);
        assert!(r == 335217800753159159860931686423658692629, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_485() {
        let r = sqrt(112370973941784713804108371828881921335731558375279259268768172828113498931640);
        assert!(r == 335217800753159159860931686423658692628, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_486() {
        let r = sqrt(61346567133220560176321114833027604977943624854702847089004881094836936607900);
        assert!(r == 247682391649508585280210155271651057731, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_487() {
        let r = sqrt(61346567133220560176321114833027604977744699000593036329229213776371094868360);
        assert!(r == 247682391649508585280210155271651057730, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_488() {
        let r = sqrt(17010266308093587632300023540769108704233266302843264015756430650173630877709);
        assert!(r == 130423411656395446525490125853906479148, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_489() {
        let r = sqrt(17010266308093587632300023540769108704047088471236790676741102130933758805903);
        assert!(r == 130423411656395446525490125853906479147, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_490() {
        let r = sqrt(14745725407056984975224116455173949571401941580662974904357739393532960980943);
        assert!(r == 121431978519074558374507081254512670834, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_491() {
        let r = sqrt(14745725407056984975224116455173949571239113450890238671887050723056034255555);
        assert!(r == 121431978519074558374507081254512670833, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_492() {
        let r = sqrt(46802533574764752979913500154665383775400017783256632576610364187450738895646);
        assert!(r == 216338932175336284245802525228192688342, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_493() {
        let r = sqrt(46802533574764752979913500154665383775308258916269105270075230112749142708963);
        assert!(r == 216338932175336284245802525228192688341, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_494() {
        let r = sqrt(48308666404115775168409318643493708901919563053972257346686437269817385014660);
        assert!(r == 219792325626068607665093440227689961792, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_495() {
        let r = sqrt(48308666404115775168409318643493708901574211447905127423262407660842419851263);
        assert!(r == 219792325626068607665093440227689961791, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_496() {
        let r = sqrt(69031455663872036688592273957610092171089423148551732052072559975621612993098);
        assert!(r == 262738378741804747189080216909451420532, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_497() {
        let r = sqrt(69031455663872036688592273957610092170939948451586929706496676131672711163023);
        assert!(r == 262738378741804747189080216909451420531, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_498() {
        let r = sqrt(67859424899287550406638329740324888660476520020876341523030731341215269297321);
        assert!(r == 260498416308597834835597821975059487595, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_499() {
        let r = sqrt(67859424899287550406638329740324888660003938915396946770258065339023958884024);
        assert!(r == 260498416308597834835597821975059487594, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_500() {
        let r = sqrt(29410180859205911275107392548145463783616801877722587195623421737954632668039);
        assert!(r == 171493967413451343463777297588967434307, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_501() {
        let r = sqrt(29410180859205911275107392548145463783466528891912507356733695032170360570248);
        assert!(r == 171493967413451343463777297588967434306, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_502() {
        let r = sqrt(53834703422479345936015194810811815425750947771333741461686666418217006174815);
        assert!(r == 232023066574164875500675201301119694353, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_503() {
        let r = sqrt(53834703422479345936015194810811815425522003130373629831166750233244140088608);
        assert!(r == 232023066574164875500675201301119694352, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_504() {
        let r = sqrt(18292336582197618703830816037391643220156749650501348431449267871990883691277);
        assert!(r == 135249164811460550119787031129760783138, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_505() {
        let r = sqrt(18292336582197618703830816037391643219994138998066690721509627396587065127043);
        assert!(r == 135249164811460550119787031129760783137, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_506() {
        let r = sqrt(44716643562271876580590054733405362061954452147783515037543028542520370036973);
        assert!(r == 211463102129595830301862722844612772550, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_507() {
        let r = sqrt(44716643562271876580590054733405362061823110217600438829190497754598033502499);
        assert!(r == 211463102129595830301862722844612772549, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_508() {
        let r = sqrt(32209482019253771111694923853506331280856411088656216739484208846078536968170);
        assert!(r == 179470003118219650605675417702473541289, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_509() {
        let r = sqrt(32209482019253771111694923853506331280738071713958057296832661237108387781520);
        assert!(r == 179470003118219650605675417702473541288, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_510() {
        let r = sqrt(108793233362167483439992517055429476729077581377039596693774937771481502396565);
        assert!(r == 329838192697824918578611569739297518917, (r as u64));
    }
    #[test]
    fun test_sqrt_u256_511() {
        let r = sqrt(108793233362167483439992517055429476728482649795891903915305923022831972852888);
        assert!(r == 329838192697824918578611569739297518916, (r as u64));
    }
}
