# gen-move-math

A command line to generate missing functionalities for [move](https://github.com/move-language/move).

Right now only signed integer math is supported. Decimal and u16/u32/u256 are the follow ups.

## Installation

[![Go Reference](https://pkg.go.dev/badge/github.com/fardream/gen-move-math.svg)](https://pkg.go.dev/github.com/fardream/gen-move-math)

Please install [go](https://go.dev). After installation, simply run the below

```shell
go install github.com/fardream/gen-move-math@latest
```

Or without downloading

```shell
go run github.com/fardream/gen-move-math@latest
```

## Use

This package doesn't provide a move module - it provides a command line utility to generate move code to do that. That is, you can include the generated file inside your own move module. However, the code will be similar to the [example](./example/sources/signed_math.move). See [example](./example) for how to use.

## Signed Integer Math

Vast majority of application can go without signed integers, but occasionally, signed integer can solve some corner cases.

**NOTE**: there is really nothing wrong with represent the signed integer with a boolean and a unsigned integer.

The implementation contained here is 2's complement.
