# COMP 825 - Programming Languages

## Project Overview

This project involves the development of a basic interpreter for a custom programming language. The language, referred to as "Brogram," supports a subset of features including variable assignments, print statements, conditional statements (`broswitch`), loops (`broloop`), and basic arithmetic operations.

## Initial and Final Grammar

### Initial Grammar

The initial grammar for Brogram included a broader set of constructs:

```sh
<BROGRAM> ::= startbro { <code> } endbro
<code> ::= <statement> <code> | <statement>
<statement> ::= broprint ( <expr> ) ;
| brogive <var> ;
| broprint ( <string> ) ;
| broloop ( <cond> ) { <code> }
| broswitch { <switch-cases> }
| <var> = <expr> ;
<switch-cases> ::= <case> <switch-cases> | <case>
<case> ::= brocase <cond> : { <code> brobreak ; }
<expr> ::= <expr> + <term> | <expr> - <term> | <term>
<term> ::= <term> * <factor> | <term> / <factor> | <factor>
<factor> ::= ( <expr> ) | <val> | <val>
<cond> ::= <val> == <val> | <val> > <val> | <val> < <val> | <val> ! <val>
<val> ::= <num> | <var>
<num> ::= <dig> | <dig><num>
<var> ::= _ | <char> | _<rest> | <char><rest>
<rest> ::= _ | <dig> | <char> | _<rest> | <dig><rest> | <char><rest>
<string> ::= "<text>"
<text> ::= <dig> | <char>
<dig> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
<char> ::= a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z
```

### Final Grammar

The final grammar refines the initial version:

```sh
<BROGRAM> ::= startbro { <code> } endbro
<code> ::= <statement> <code> | <statement>
<statement> ::= broprint ( <expr> ) ;
| brogive <var> ;
| broloop ( <cond> ) { <statement> }
| broswitch { <switch-cases> }
| <var> = <expr> ;
<switch-cases> ::= <case> <switch-cases> | <case>
<case> ::= brocase <cond> : { <statement> brobreak ; }
<expr> ::= <expr> + <term> | <expr> - <term> | <term>
<term> ::= <term> * <factor> | <term> / <factor> | <factor>
<factor> ::= ( <expr> ) | <val> | <val>
<cond> ::= <val> == <val> | <val> > <val> | <val> < <val> | <val> ! <val>
<val> ::= <num> | <var>
<num> ::= <dig> | <dig><num>
<var> ::= <char>
<dig> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
<char> ::= a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z
```

## Project Path

- **Project Directory:** `~/comp825/brogram`

## Changes Made

1. **Removed Underscores in Variable Names:** Variable names are now restricted to letters only.
2. **Eliminated `print string` Statements:** The `<string>` construct has been removed from the language.

## Code Snippets

### Working Code

**Assign Statements and Print Statements**

Example Code:

```sh
startbro {
broprint(10+20*(-3)+50);
a = 10;
broprint(a+10);
b = 20;
broprint(a+b);
}
endbro
```


**Output:**
0
20
30



### Non-working Code

**`broswitch` Functionality**

Example Code:
```sh
startbro {
x = 1;
broswitch {
brocase x == 1 : { broprint ( x ); brobreak ; }
brocase x == 2 : { broprint ( x ); brobreak ; }
}
}
endbro
```


**Output:**
1
1
Segmentation fault (core dumped)


**Explanation:**
The code prints the first `brocase` match correctly but fails to exit the `broswitch` statement properly, leading to a segmentation fault.

**`broloop` Functionality**

Example Code:

```sh
startbro {
i = 0;
broloop (i < 10) { broprint (i); }
}
endbro
```


**Output:**

0
Segmentation fault (core dumped)


**Explanation:**
The loop starts correctly but results in a segmentation fault due to an infinite loop. The variable `i` is not incremented within the loop.

**`brogive` Functionality**

Example Code:

```sh
startbro {
brogive a;
a = 10;
broprint(a);
}
endbro
```

**Output:**

Segmentation fault (core dumped)


**Explanation:**
The segmentation fault occurs due to accessing uninitialized memory.

## Getting Started

To run the interpreter, navigate to the project directory and execute the provided Brogram scripts. Ensure that the interpreter is properly set up to handle the given constructs and address the identified issues.

## Contributing

Contributions to the project are welcome. Please fork the repository, make your changes, and submit a pull request with a clear description of the modifications.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
