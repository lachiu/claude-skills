# PHP Coding Standards Reference
Source: https://raw.githubusercontent.com/php/php-src/master/CODING_STANDARDS.md

## Code Implementation

- Document code in source files and the manual
- PHP is implemented in **C11** (stdint.h fixed-width integers available: int8_t, int16_t, int32_t, int64_t)
- Functions given pointers to resources **must NOT free them** unless: (a) freeing is the function's designated purpose, (b) a boolean argument controls freeing, or (c) it's a low-level parser routine
- Functions tightly integrated with others should be declared `static` and documented as such
- Use `#define` for any numeric constant that specifies behavior or actions
- **String length**: PHP holds length property of each string — do NOT recalculate with `strlen()`. Write binary-safe functions using the length property directly
- **NEVER USE `strncat()`**
- Use `PHP_*` macros in PHP source; `ZEND_*` macros in Zend source
- Do not define functions for missing library functions — let users use `function_exists()`
- Prefer `emalloc()`, `efree()`, `estrdup()` over standard C counterparts (safety-net for request end cleanup)
- Memory returned to the engine **must** use `emalloc()`; use `malloc()` only for third-party library compatibility or cross-request memory
- "is"/"has" style functions return type: `bool`; operations that may succeed/fail: `zend_result`
- **Error message phrasing conventions**:
  - Type errors: `must be of type int`
  - Range: `must be between X and Y` / `must be greater than [or equal to] X`
  - String: `must not contain any null bytes` / `must not be empty`
  - Valid value: `must be a valid X`
  - Enum-like: `must be one of X, Y, or Z`
  - Structural: `must have X` / `must have key X` / `must have N elements`

## User Functions/Methods Naming Conventions

- User-level functions enclosed in `PHP_FUNCTION()` macro
- Function names: **lowercase**, **underscore-delimited**, minimize letter count, no abbreviations that harm readability
  - ✅ `str_word_count`, `array_key_exists`
  - ❌ `hw_GetObjectByQueryCollObj`, `pg_setclientencoding`, `jf_n_s_i`
- Part of a parent set: prefix with `parent_*` form
  - ✅ `foo_select_bar`, `foo_insert_baz`
  - ❌ `fooselect_bar`, `delete_foo_baz`
- Internal helper functions: prefixed with `_php_`, lowercase, underscore-delimited, declared `static`
- Variable names: **meaningful**, **lowercase**, **underscore-separated**; avoid single-letter names except trivial loop counters
- **Method names**: *studlyCaps* (camelCase, lowercase first letter)
  - ✅ `connect()`, `getData()`, `buildSomeWidget()`, `performHttpRequest()`
  - ❌ `get_Data()`, `buildsomewidget()`, `performHTTPRequest()`
- **Class names**: *PascalCase*, descriptive nouns, prefix with extension name if no namespaces
  - ✅ `Curl`, `CurlResponse`, `HttpStatusCode`, `Url`, `BtreeMap`, `UserId`
  - ❌ `curl`, `curl_response`, `HTTPStatusCode`, `URL`, `BTreeMap`, `UserID`
- Abbreviations/acronyms: treat like regular words (uppercase first letter only)
  - ✅ `Ssl`, `Http`, `Url`
  - ❌ `SSL`, `HTTP`, `URL`
- Divergence allowed for internal consistency, language-agnostic standards, or RFC-voted reasons

## Internal Function Naming Conventions

- External API functions: `php_modulename_function()` — lowercase, underscore-delimited
  - Must be defined in `php_modulename.h`
  - Example: `PHPAPI char *php_session_create_id(PS_CREATE_SID_ARGS);`
- Unexposed module functions: `static`, NOT in `php_modulename.h`
  - Example: `static int php_session_destroy()`
- Main module source file: `modulename.c`
- Header file for other sources: `php_modulename.h`

## Syntax and Indentation

- **Style**: K&R (Kernighan & Ritchie)
- **Whitespace**: be generous; one empty line between variable declarations and statements; one empty line between logical groups; 1–2 empty lines between functions
- **Braces**: always use braces, opening on same line
  - ✅ `if (foo) { bar; }`
  - ❌ `if(foo)bar;`
- **Indentation**: tab character (represents 4 spaces)
- **Preprocessor directives**: `#if` etc. MUST start at column one; indent by adding spaces after `#`
- **String literal lengths**: use `strlen()` not `sizeof()-1` for clarity (compiler optimizes away)

## Testing

- Extensions must be tested with `*.phpt` tests
- Reference: https://qa.php.net/write-test.php

## New and Experimental Functions

- Include an `EXPERIMENTAL` file in the function directory
- `EXPERIMENTAL` file should contain: authoring info, known bugs, future directions, ongoing status notes
- New features should go to PECL or experimental branches before core

## Aliases & Legacy Documentation

- Deprecated aliases documented only by current name; aliases listed in parent function docs
- Functions with different names aliasing the same function (e.g. `highlight_file` / `show_source`) documented separately
- Maintain backwards compatibility as long as reasonable