# Example Use of gen-move-math

## Prerequisite

1. golang and this package.
1. A move toolchain - this can be either from
   - [move](https://github.com/move-language/move)
   - [aptos](https://aptos.dev)
   - [sui](https://sui.io)

Note the chain specific stuff is unnecessary.

## Generate the code

First, create a new move package (let's call it `example`)

```shell
move new example
```

Above will create a new folder and move package called `example` in the your current folder.

Now, change to the newly created `example` folder

```shell
gen-move-math --out ./sources/smath.move --address example
```

Use `--out/-o` to define the output file name, and use `--address/-p` to define the address of the package.

If a named address is used instead of a literal address, the named address must be defined in `Move.toml` file (or provided as a command line parameter if the cli you use support it).

Now the code is ready, and test can run like

```shell
move test
```

A possible output will be

```shell
INCLUDING DEPENDENCY MoveStdlib
BUILDING example
Running Move unit tests
[ PASS    ] 0x0::int64::test_int64
[ PASS    ] 0x0::int128::test_int128
[ PASS    ] 0x0::int8::test_int8
[ PASS    ] 0x0::int64::test_int64_failure_overflow
[ PASS    ] 0x0::int128::test_int128_failure_overflow
[ PASS    ] 0x0::int8::test_int8_failure_overflow
[ PASS    ] 0x0::int64::test_int64_failure_overflow_multiply
[ PASS    ] 0x0::int128::test_int128_failure_overflow_multiply
[ PASS    ] 0x0::int8::test_int8_failure_overflow_multiply
[ PASS    ] 0x0::int64::test_int64_failure_overflow_multiply_1
[ PASS    ] 0x0::int128::test_int128_failure_overflow_multiply_1
[ PASS    ] 0x0::int8::test_int8_failure_overflow_multiply_1
[ PASS    ] 0x0::int64::test_int64_failure_overflow_positive
[ PASS    ] 0x0::int128::test_int128_failure_overflow_positive
[ PASS    ] 0x0::int8::test_int8_failure_overflow_positive
[ PASS    ] 0x0::int64::test_int64_failures
[ PASS    ] 0x0::int128::test_int128_failures
[ PASS    ] 0x0::int8::test_int8_failures
Test result: OK. Total tests: 18; passed: 18; failed: 0
```
