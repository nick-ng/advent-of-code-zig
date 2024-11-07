- Guide: https://zig.guide/
- Cheat Sheet: https://exilesprx.github.io/posts/zig/zig-cheatsheet/

- `zig run main.zig`
- `zig test <test_file.zig>`

## while loop

Evaluate the comparison before the colon before performing the loop body.

Perform the operation after the colon **AFTER** performing the loop body.

```zig
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        std.debug.print("before: sum = {}, i = {}\n", .{ sum, i });
        sum += i;
        std.debug.print("after: sum = {}, i = {}\n", .{ sum, i });
    }
    std.debug.print("final: sum = {}, i = {}\n", .{ sum, i });
```
output:
```txt
before: sum = 0, i = 1
after: sum = 1, i = 1
before: sum = 1, i = 2
after: sum = 3, i = 2
before: sum = 3, i = 3
after: sum = 6, i = 3
before: sum = 6, i = 4
after: sum = 10, i = 4
before: sum = 10, i = 5
after: sum = 15, i = 5
before: sum = 15, i = 6
after: sum = 21, i = 6
before: sum = 21, i = 7
after: sum = 28, i = 7
before: sum = 28, i = 8
after: sum = 36, i = 8
before: sum = 36, i = 9
after: sum = 45, i = 9
before: sum = 45, i = 10
after: sum = 55, i = 10
final: sum = 55, i = 11
```

## for loop

Only for iterating over iterables like arrays and strings (character arrays)

## Unreachable

> unreachable is an assertion that the programmer makes to ensure program correctness and enable compiler optimizations.

## Optionals
https://zig.guide/language-basics/optionals/

A variable can be "optional"

```zig
var normal: i32 = 20;
var optional_value: ?i32 = 20;
```

In order to "use" an optional, you need to use the `orelse` operator which unwraps the value to its non-optional type. You can think of `orelse` as JavaScript's nullish coalescing operator (??). The following are _similar_

```zig
var optional_value: ?i32 = 20;
...
var a: i32 = optional_value orelse 3;
```
```JavaScript
let optionalValue = 20;
...
let a = optionalValue ?? 3;
```

If you've already checked that an optional value is not null, you can use the `.?` short hand.

```zig
var optional_value: ?i32 = 20;
...
var a: i32 = optional_value.?;
```

This is the same as

```zig
var optional_value: ?i32 = 20;
...
var a: i32 = optional_value orelse unreachable;
```
