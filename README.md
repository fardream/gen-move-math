# gen-move-math and more_math

`gen-move-math` is a command line to generate missing functionalities for [move](https://github.com/move-language/move), and `more_math` is the code generated with default options.

[![Go Reference](https://pkg.go.dev/badge/github.com/fardream/gen-move-math.svg)](https://pkg.go.dev/github.com/fardream/gen-move-math)

[**Movey Link**](https://www.movey.net/packages/more_math)

Following are currently provided:

- signed integer.
- double width unsigned integer (u256 and u16).
- decimal.
- signed decimal.

## Use as a move package

The generated code with default options is provided in folder [more_math](./more_math), and can be included in any move package by

```
[dependencies]
more_math = { git = "https://github.com/fardream/gen-move-math.git", rev = "master", subdir = "more_math"}

[addresses]
more_math = "0x5" // set this here or in the command line.
```

## Install/Use Code Generator

Since the code is not published on chain yet, and another way to include the code in your move code is to generate the code from the command line into your own package.

Please install [go](https://go.dev). After installation, simply run the below

```shell
go install github.com/fardream/gen-move-math@latest
```

Or without downloading

```shell
go run github.com/fardream/gen-move-math@latest
```

See [example-use.MD](./example-use.MD) for a detailed instruction.

## Signed Integer Math

Vast majority of application can go without signed integers, but occasionally, signed integer can solve some corner cases.

**NOTE**: there is really nothing wrong with represent the signed integer with a boolean and a unsigned integer.

The implementation contained here is 2's complement.

## Double Width Unsigned

This is mostly about 256-bit unsigned int (but same methodology can be applied to 16 bit unsigned int too - and once we have 16 bit unsigned int, we can redo the same to get 32 bit unsigned int).

Right now the solution is use two `u128`, one for higher 128 bits, and one for lower 128 bits of the 256-bit unsigned int. The implementation for `add` and `subtract` is straightforward.

In move, the code aborts when overflow or underflow, so the check for those must be done before calculating.

### Multiplication

If we can solve `u128` multiplication with possible overflow, we can replicate the strategy for 256 bit unsigend int too.

Now, consider a `u128` two `u64`s - one for higher bits and one for lower bits.

Below is similar code in rust - however, do note we need to check if the addition needs carry.

```rust
fn mul_with_overflow(x: u128, y: u128) -> (u128, u128) {
    const HIGHER_1S: u128 = ((1u128 << 64) - 1) << 64;
    const LOWER_1S: u128 = (1u128<< 64) - 1;
    let x_hi = (x & HIGHER_1S) >> 64;
    let x_lo = x & LOWER_1S;
    let y_hi = (y & HIGHER_1S) >> 64;
    let y_lo = y & LOWER_1S;


    let x_hi_y_lo = x_hi * y_lo;
    let x_lo_y_hi = x_lo * y_hi;

    let hi = x_hi * x_hi + (x_hi_y_lo >> 64) + (x_lo_y_hi >> 64);
    let lo = x_lo * y_lo + (x_hi_y_lo << 64) + (x_lo_y_hi << 64);

    (lo, hi)
}
```

### Division

It's trivia to calculate x divided by y if x <= y (which is either 0 or 1), and the remainder is either x or 0.

Now assuming x is greater than y:

1. align x and y leading 1 by left shifting y.
1. set remainder to x, if remainder is greater than the shifted y, subtract it from remainder, and add 1 shifted by the same size to the result.
1. left shift the shifted y by 1.
1. repeat until y is not shifted any more.

```rust
fn leading_zeros(x: u128) -> u8 {
    if x == 0 {
        return 128;
    }
    let mut t = (1u128) << 127;
    let mut r = 0;
    loop {
        if x & t > 0 {
            break;
        }
        t = t >> 1;
        r = r + 1;
    }

    r
}

fn div_mod(x: u128, y: u128) -> (u128, u128) {
    let nx = leading_zeros(x);
    let ny = leading_zeros(y);

    let mut shift = ny - nx;

    let mut current = y << shift;
    let mut remainder = x;
    let mut result = 0;

    loop {
        if remainder >= current {
            result += 1u128 << shift;
            remainder -= current;
        }

        if shift == 0 {
            break;
        }
        current = current >> 1;
        shift = shift - 1;
    }
    (result, remainder)
}
```

## Decimal

Fixed decimals are quite straightforward, only two note:

- need to use double size integers to avoid overflow
- need to multiply the numerator by 10^decimal before performing the division.
