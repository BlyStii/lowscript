# LowScript Documentation

Welcome to the official LowScript documentation. LowScript is a modern programming language designed with simplicity and flexibility in mind. This guide will walk you through the core features, syntax, and functionality of LowScript, enabling you to harness its full potential.

*All code blocks in this documentation will be using [Swift](https://www.swift.org/)'s syntax highlighting as it is the language that has a syntax that is most similar to LowScript's. However some code blocks' highlighting might look off or non-sensical, mainly comments.*

## Table of Contents

- [LowScript Documentation](#lowscript-documentation)
  - [Table of Contents](#table-of-contents)
  - [Comments](#comments)
  - [Data Types](#data-types)
  - [Arithmetic Operations](#arithmetic-operations)
  - [Logical Operations](#logical-operations)
  - [Variables](#variables)
  - [Functions\*](#functions)
  - [Classes](#classes)
  - [Variadic Parameters](#variadic-parameters)
  - [Instances](#instances)
  - [If Statement](#if-statement)
  - [Loops](#loops)
  - [String Formatting](#string-formatting)
  - [Escape Sequences \& ANSI Escape Codes](#escape-sequences--ansi-escape-codes)
  - [Built-in Values](#built-in-values)
    - [Output Functions](#output-functions)
    - [Input Functions](#input-functions)
    - [Files Methods](#files-methods)
    - [System Methods](#system-methods)
    - [Mathematical Operations](#mathematical-operations)
    - [Type Manipulation Methods](#type-manipulation-methods)
    - [Value Methods \& Attributes](#value-methods--attributes)

## Comments

You may write comments in two forms:

- **Single-line Comment:**
    ```swift
    # This a single-line comment.
    ```

- **Multi-line Comment:**
    ```swift
    #*

    This is a multi-line comment.

    #
    ```

## Data Types

LowScript supports the following data types:

- **Number:**
    A `number` represents numeric values. It includes both integer and floating-point numbers. Numbers are the fundemental data type for arithmetic operations like addition, subtraction, multiplication, division and modulo.

    You may write numeric values in various forms:

    *Using two forms simultaneously is allowed - except when using binary and hexadecimal form.*

    - **Base Form:**
        ```swift
        115

        9070
        ```

    -  **Decimal Form:**
        ```swift
        0.4

        17.9
        ```

    - **Negative Form:**
        ```swift
        -1.5

        -920
        ```

    - **Binary Form:**
        ```swift
        0b101

        0b100110
        ```

    - **Hexadecimal Form:**
        ```swift
        0xF10

        0x84C0
        ```

- **String:**
    A `string` is a sequence of characters enclosed within single (`'`) or double-quotes (`"`). Strings are used to represent text, and they include letters, numbers, symbols and even whitespace.

    You may write strings in two forms:

    - **Single-Quotes:**
        ```lua
        'abc'

        'def'
        ```

    - **Double-Quotes:**
        ```swift
        "Hello"

        "World"
        ```

- **Bool:**
    A `bool` may only have two possible values: `true` or `false`. It represents truth values and is used for conditions in control flow statements like `if`, `elif`, and `while` loops.

- **Set:**
    A `set` represents a flexible collection of elements. It includes both lists (indexed elements) and maps (key-value pairs). It is versatile and may be used to store related data in different forms, supporting both ordered and unordered data.

    You may write sets in two forms:

    *Both of these forms will return a data type of `set`.*

    - **Lists:**
        ```swift
        ["A", "B", "C"]

        [1, 2, 3]
        ```

    - **Maps:**
        ```swift
        ["Fruit A": "Apple", "Fruit B": "Banana", "Fruit C": "Cherry"]

        ["1 + 1": 2, "2 + 2": 4, "3 + 3": 6]
        ```

- **Null:**
    `null` represents the absence of a value. It isused to indicate that a variable does not hold any meaningful data or that an operation or function has no result.

- **Function:**
    Documentation in [Functions\*](#functions).

    *Usable data type: `function`.*

- **File:**
    A `file` represents a reference to a file stored in the filesystem. It allows for operations such as reading from and writing to files, enabling interaction with persistent data storage outside of the program's runtime memory.

## Arithmetic Operations

LowScript supports five different arithmetic operations:

- **Addition:**
You may write an addition as follows:
    ```swift
    [number] + [number]
    ```

- **Subtraction:**
You may write a subtraction as follows:
    ```swift
    [number] - [number]
    ```

- **Multiplication:**
You may write a multiplication as follows:
    ```swift
    [number] * [number]
    ```

- **Division:**
You may write a division as follows:
    ```swift
    [number] / [number]
    ```

- **Modulo:**
You may write a modulo as follows:
    ```swift
    [number] % [number]
    ```


## Logical Operations

LowScript supports nine different logical operations:

- **Equal:**
You may write an equality as follows:
    ```swift
    [any] == [any]
    ```

- **Unequal:**
You may write an unequality as follows:
    ```swift
    [any] != [any]
    ```

- **Inferior:**
You may write an inferiority as follows:
    ```swift
    [number] < [number]
    ```

- **Inferior or Equal:**
You may write an inferior-or-equality as follows:
    ```swift
    [number] <= [number]
    ```

- **Superior:**
You may write a superiority as follows:
    ```swift
    [number] > [number]
    ```

- **Superior or Equal:**
    You may write a superior-or-equality as follows:
    ```swift
    [number] >= [number]
    ```

- **Logical AND:**
You may write a logical AND as follows:
    ```swift
    [bool] & [bool]
    ```

- **Logical OR:**
You may write a logical OR as follows:
    ```swift
    [bool] | [bool]
    ```

- **Logical NOT:**
You may write a logical NOT as follows:
    ```swift
    ![bool]
    ```

## Variables

You may declare/assign to a variable as follows:
```swift
[variable-name] = [value]
```

****

You may also add static types to variables:
```swift
[variable-name] <[data-types]> = [value]
```

*You may separate data types with a bar (`|`).*

**Examples:**

```swift
x <string|number> = 10

y <set> = ["A", "B", "C"]
```

When you declare a variable with static types, you cannot change its data type later.

****

You may also declare a global variable as follows:
```swift
[variable-name] := [value]
```

*Using static types with global variables is allowed.*

## Functions*

**Function Declarations:**

You may declare a function in two forms:

- **Direct Function Declaration:**
    ```swift
    func [function-name]([parameters]) {
        [...]
    }
    ```

- **Indirect Function Declaration:**
    ```swift
    [function-name] = func([parameters]) {
        [...]
    }
    ```

    ****

    *You may also declare a global function as follows:*
    ```swift
    [function-name] := func([parameters]) {
        [...]
    }
    ```


*Parameters may also have static types, using the same syntax as variables'.*

You may also add static types to functions:
- **Direct Function Declaration:**
    ```swift
    func [function-name]([parameters]) <[data-types]> {
        [...]
    }
    ```

- **Indirect Function Declaration:**
    ```swift
    [function-name] = func([parameters]) <[data-types]> {
        [...]
    }
    ```

    ****

    *Global function declaration:*
    ```swift
    [function-name] := func([parameters]) <[data-types]> {
        [...]
    }
    ```

You may use `return` to finally return a value to the function call.

**Examples:**
```swift
func add(a <number>, b <number>) {
    return a + b
}

sayHello = func() <string> {
    return "Hello, World!"
}
```

**Function Calls:**

You may call a function as follows:
```swift
[function-name]([arguments])
```

## Classes

You may declare a class in two forms:

- **Direct Class Declaration:**
    ```swift
    class [class-name]([attributes]) {
        [...]
    }
    ```

- **Indirect Class Declaration:**
    ```swift
    [class-name] = class([attributes]) {
        [...]
    }
    ```

    ****

    *You may also declare a global class as follows:*
    ```swift
    [class-name] := class([attributes]) {
        [...]
    }
    ```

*Classes cannot have static types as they return an [instance](#instances) of themselves.*

*On the other hand, attributes may have static types, using the same syntax as variables'.*

****

When you create a class, it also creates a custom [data type](#data-types) with its name.

## Variadic Parameters

LowScript's variadic parameters are function or class parameters that accept a variable number of parameters and returns it as a set.

*These examples will be using the function variadic parameters, but they work with both functions and classes in the same way.*

You may write variadic parameters as follows:
```swift
func [function-name]([variadic-parameter] ...) {
    [...]
}
```

Variadic parameters are simply a normal parameter followed by three periods (`...`).

You may also add a limit to the variadic parameter as follows:
```swift
func [function-name]([variadic-parameter] ... [number-limit]) {
    [...]
}
```

*Variadic parameters may strictly be added at the end of the parameter list - meaning you may add other parameters before the variadic one.*

**Examples:**
```swift
func add(args ... 2) <number> {
    return args[0] + args[1]
}

add(1, 5)
```

In the example above, calling `add(1, 5)` returns the addition of the first argument (`1 -> args[0]`) with the second argument (`5 -> args[1]`).

****

```swift
func mul(multiplier <number>, args ... 2) <number> {
    return (args[0] * args[1]) * multiplier
}

mul(10, 3, 9)
```

In the example above, calling `mul(10, 3, 9)` returns the multiplication of the first argument (`3 -> args[0]`) with the second argument (`9 -> args[1]`) multiplied by the `multiplier` argument (`10`).

## Instances

You may create an instance as follows:
```swift
[class-name]([attributes])
```

To be able to reutilize the instance later, you may assign it to a variable as follows:
```swift
[instance-name] = [class-name]([attributes])
```

****

*Global instance assignment:*
```swift
[instance-name] := [class-name]([attributes])
```

****

You may call methods inside that instance as follows:
```swift
[instance].[method-name]([arguments])
```

You may also call attributes inside that instance as follows:
```swift
[instance].[attribute-name]
```

****

When calling a method inside an instance, the method gains a new parameter `self`. The `self` parameter refers to the instance which called that method.

*The `self` parameter also comes with the instance's attributes and methods.*

**Examples:**

```swift
class person(name <string>, age <number>) {
    func sayName() {
        return self.name
    }
}

john = person("John", 26)

john.sayName()
```

In the example above, calling `john.sayName()` returns its name, which, in this case, is `"John"`.

****

```swift
class button(x <number>, y <number>) {
    func getPosition() {
        return self.getPosition()
    }
}

button1 = button(150, -80)

button1.getPosition()
```

In the example above, calling `button1.getPosition()` returns the same function call, which creates an infinite loop therefore creating a stack overflow.

****

Using anonymous instances is also fairly simple and straight-forward.

**Examples:**

```swift
class person(name <string>, age <number>) {
    func sayName() {
        return self.name
    }
}

person("Sarah", 30).sayName()
```
In the example above, calling `person("Sarah", 30).sayName()` returns the anonymous instance's (`person("Sarah", 30)`) name, which, in this case, is `"Sarah"`.

****

When you get the type of an instance, it returns the class's name.

## If Statement

You may write an `if` statement as follows:
```swift
if([condition]) {
    [...]
}
```

****

You may also add an `else` block as follows:
```swift
if([condition]) {
    [...]
} else {
    [...]
}
```

The `else` block runs strictly if the preceding block's condition evaluates to `false`.

****

LowScript also supports `elif` (combination of both `if` and `else`), you may add an `elif` block as follows:
```swift
if([condition-one]) {
    [...]
} elif([condition-two]) {
    [...]
}
```

The `elif` block runs strictly if the preceding block's condition evaluates to `false` and if its own condition evaluates to `true`.

You may stack `elif` blocks as follows:
```swift
if([condition-one]) {
    [...]
} elif([condition-two]) {
    [...]
} elif([condition-three]) {
    [...]
}
```

You may also finally add an `else` block, which runs if all of the preceding blocks' conditions evaluate to `false`:
```swift
if([condition-one]) {
    [...]
} elif([condition-two]) {
    [...]
} elif([condition-three]) {
    [...]
} else {
    [...]
}
```

## Loops

LowScript supports four types of loops:

- **While Loop:**
You may create a `while` loop as follows:
```swift
while([condition]) {
    [...]
}
```

A `while` loop runs strictly if its condition evaluates to `true`.

*It checks the condition every iteration before running its block.*

**Examples:**
```swift
while("ABC" == "ABC") {

}
```
In the example above, the `while` loop will run an infinite number of times, as `"ABC"` will always be equivalent to `"ABC"`, possibly crashing the program or the computer running it.

****

- **For Loop:**
You may create a `for` loop as follows:
```swift
for([parameter-one], [parameter-two], [parameter-three]) {
    [...]
}
```

A `for` loop, in LowScript, has three special parameters:
  - Pre-loop statement (ran before the loop starts);
  - Pre-iteration condition (ran before an iteration starts);
  - Post-iteration statement (ran after an iteration ends);
  
****

By convention,
  - the pre-loop statement is usually an index variable assignment;
  - the pre-iteration condition is usually a comparison of the index variable and some other value;
  - the post-iteration statement is usually a change to the index variable;
  
**Examples:**
```swift
for(i = 0, i < 10, i++) {
    
}
```
In the example above, the `for` loop runs its block 10 times, each time incrementing to the `i` variable.

- **Foreach Loop:**
You may create a `foreach` loop in two forms:

    - **Value-Only:**
    ```swift
    foreach([value-name]) in [set] {
        [...]
    }
    ```

    - **Key-Value Pair:**

    ```swift
    foreach([key-name], [value-name]) in [set] {
        [...]
    }
    ```

A `foreach` loop cycles through a `set` while assigning a variable for the key-value pair (sometimes value-only).

**Examples:**
```swift
foreach(key, value) in ["A", "B", "C"] {

}
```
In the example above, the `foreach` loop will cycle through the `set` `["A", "B", "C"]` and in each iteration, it will assign to the variable `key`, `0`, `1` and `2` respectively. However for the `value` variable, it will be assigned `"A"`, `"B"` and `"C"` respectively in each iteration.

****
```swift
foreach(value) in [2, 4, 8, 16] {

}
```
In the example above, the `foreach` loop will cycle through the `set` `[2, 4, 8, 16]` and in each iteration, it will only assign to the variable `value`, `2`, `4`, `8` and `16` respectively.

- **Repeat Loop:**
You may create a `repeat` loop as follows:
```swift
repeat([number]) {
    [...]
}
```

A `repeat` loop runs its block a precise amount of times (`[number]`) without any index variable.

*The wanted amount of iterations must strictly be a natural number.*

**Examples:**
```swift
repeat(15) {

}
```
In the example above, the `repeat` loop will run its block exactly `15` times before moving on.

## String Formatting

You may write a formatted string as follows:
```swift
$[string]
```

In LowScript, formatted strings allow you to insert actual functional code inside a `string`, making it possible to join two or more strings together.

To insert functional code inside a formatted strings, you may place it inside curly braces (`{}`).

**Examples:**

```swift
x = "World"

$"Hello, {x}!"
```
In the example above, the expression `$"Hello, {x}!"` will return `"Hello, World!"` as, in this case, the expression `x` returns `"World"`.

****

*You cannot place actual string literals inside a formatted string as the LowScript interpreter will think you meant to close the string - `$"Hello, {"World"}!"` <-- this will not work.*

## Escape Sequences & ANSI Escape Codes

You may write an escape sequence as follows:
```swift
\[escape-sequence]
```

LowScript supports eleven different escape sequences:
- **\n**:
    New line.

- **\t**:
    Horizontal [tab].

- **\\\\**:
    Backslash.

- **\\'**:
    Single-quote.

- **\\"**:
    Double-quote.

- **\r**:
    Carriage return.

- **\b**:
    Backspace.

- **\f**:
    Form feed.

- **\a**:
    Alert (bell).

- **\v**:
    Verical [tab].

- **\0**:
    Null character.

LowScript also supports ANSI escape codes. You may write an ANSI escape code as follows:
```swift
\27[[escape-code]
```

**Examples:**
```swift
"\27[1mHello, World!\27[0m"
```
In the example above, `\27[1m` makes the string following it (`"Hello, World!"`) bold. (The ANSI escape code `27[0m` resets the formatting, color, etc).

## Built-in Values

LowScript has many built-in values (attributes & methods). The following dictionary documents all of them:

### Output Functions
****

- **line()**
    ```swift
    line(v <any>) <null>
    ```

    Prints `v` to the output followed by `\n`.

- **write()**
    ```swift
    write(v <any>) <null>
    ```

    Prints `v` to the output.

- **error()**
    ```swift
    error(v <any>) <null>
    ```

    Errors `v` to the output followed by `\n`.

### Input Functions
****

- **input()**
    ```swift
    input(v <any>) <string>
    ```

    Prints `v` to the output and returns the user input.

### Files Methods
****

- **files.open()**
    ```swift
    files.open(file <string>) <file>
    ```

    Opens `file` with [mode](https://www.family-historian.co.uk/help/fh7-plugins/lua/readingandwritingfiles.html) `"r"` and returns the opened file.

    ****

    ```swift
    files.open(file <string>, mode <string>) <file>
    ```

    Opens `file` with [mode](https://www.family-historian.co.uk/help/fh7-plugins/lua/readingandwritingfiles.html) `mode` and returns the opened file.

- **files.read()**
    ```swift
    files.read(file <file>) <string>
    ```

    Reads `file` and returns its contents.

- **files.write()**
    ```swift
    files.write(file <file>, v <string>) <string>
    ```

    Resets `file`'s contents to null then writes `v` to `file` and returns its contents.

### System Methods
****

- **sys.exit()**
    ```swift
    sys.exit() <null>
    ```

    Stops running the file and exits.

- **sys.traceback()**
    ```swift
    sys.traceback(msg <string>) <string>
    ```

    Returns `msg` followed by the stack traceback.

- **sys.args**
    ```swift
    sys.args <set>
    ```
    
    Returns the arguments passed to the file when it is executed.

### Mathematical Operations
****

- **math.random()**
    ```swift
    math.random(min <number>, max <number>) <number>
    ```

    Returns a random integer between `min` and `max`.

- **math.clamp()**
    ```swift
    math.clamp(x <number>, min <number>, max <number>) <number>
    ```

    Returns `x` clamped between `min` and `max`.

- **math.min()**
    ```swift
    math.min(x <number>, min <number>) <number>
    ```

    Returns `x` clamped between `min` and positive infinity.

- **math.max()**
    ```swift
    math.max(x <number>, max <number>) <number>
    ```

    Returns `x` clamped between negative infinity and `max`.

- **math.pow()**
    ```swift
    math.pow(x <number>, y <number>) <number>
    ```

Returns `x` to the power of `y`.

- **math.abs()**
    ```swift
    math.abs(x <number>) <number>
    ```

    Returns positive `x`.

- **math.floor()**
    ```swift
    math.floor(x <number>) <number>
    ```

    Returns the biggest integer smaller than `x`.

- **math.ceil()**
    ```swift
    math.ceil(x <number>) <number>
    ```

    Returns the smallest integer bigger than `x`.

- **math.round()**
    ```swift
    math.round(x <number>) <number>
    ```

    Returns `x` rounded to the nearest integer.

    ****

    ```swift
    math.round(x <number>, dec <number>) <number>
    ```

    Returns `x` rounded to the nearest number with `dec` amount of decimal places.

- **math.sqrt()**
    ```swift
    math.sqrt(x <number>) <number>
    ```

    Returns the square root of `x`.

- **math.sin()**
    ```swift
    math.sin(x <number>) <number>
    ```

    Returns sine of `x`.

- **math.cos()**
    ```swift
    math.cos(x <number>) <number>
    ```

    Returns cosine of `x`.

- **math.tan()**
    ```swift
    math.tan(x <number>) <number>
    ```

    Returns tangent of `x`.

- **math.ln()**
    ```swift
    math.ln(x <number>) <number>
    ```

    Returns the natural logarithm of `x`.

- **math.log()**
    ```swift
    math.log(x <number>, y <number>) <number>
    ```

    Returns log of `x` with base `y`.

- **math.rad()**
    ```swift
    math.rad(x <number>) <number>
    ```

    Returns converts `x` from degrees to radians.

- **math.deg()**
    ```swift
    math.deg(x <number>) <number>
    ```

    Returns converts `x` from radians to degrees.

- **math.pi**
    ```swift
    math.pi <number>
    ```

    Returns the value of Pi.

- **math.euler**
    ```swift
    math.euler <number>
    ```

    Returns the value of E (Euler's number).

### Type Manipulation Methods
****

- **num()**
    ```swift
    num(v <any>) <number|null>
    ```

    Returns `v` as a number if possible - else returns `null`.

- **str()**
    ```swift
    str(v <any>) <string>
    ```

    Returns `v` as a string.

- **type()**
    ```swift
    type(v <any>) <string>
    ```

    Returns the type of `v`.

### Value Methods & Attributes

*Where `x` is the desired value.*

- **x.has()**
    ```swift
    x <string|set>.has(v <string>) <bool>
    ```

    Returns `true` if `v` is in `x`. Else returns `false`.

- **x.split()**
    ```swift
    x <string>.split(v <string>) <set>
    ```

    Returns a `set` consisting of `x` splitted at `v`.

- **x.upper()**
    ```swift
    x <string>.upper() <string>
    ```

    Returns `x` all in uppercase.

- **x.lower()**
    ```swift
    x <string>.lower() <string>
    ```

    Returns `x` all in lowercase.

- **x.reverse()**
    ```swift
    x <string|set>.split(v <string>) <string|set>
    ```

    Returns reversed `x`.

- **x.push()**
    ```swift
    x <set>.push(v <any>) <null>
    ```

    Inserts `v` in `x` at length of `x`.

    ****
    ```swift
    x <set>.push(v <any>, pos <any>) <null>
    ```

    Inserts `v` in `x` at `pos`.

- **x.pop()**
    ```swift
    x <set>.pop() <any>
    ```

    Removes the element in `x` at length of `x` and returns it.

    ****
    ```swift
    x <set>.pop(pos <any>) <any>
    ```

    Removes the element in `x` at `pos` and returns it.

- **x.clear()**
    ```swift
    x <set>.clear() <set>
    ```

    Returns an empty `set`.

- **x.join()**
    ```swift
    x <set>.split(v <string>) <string>
    ```

    Returns the elements of `x` all joined by `v`.

- **x.length**
    ```swift
    x <string|set>.length <number>
    ```

    Returns length of `x`.

- **x.isnum**
    ```swift
    x <any>.isnum <bool>
    ```

    Returns `true` if `x` is a `number`. Else returns `false`.
