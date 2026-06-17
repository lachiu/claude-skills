---
name: php
description: >
  PHP coding standards and test authoring. Use this skill whenever writing,
  reviewing, or discussing PHP code — naming, style, error messages, extensions
  in C — OR creating/reviewing PHP tests in the .phpt format. Trigger on:
  "write PHP code", "review my PHP", "is this good PHP?", "how should I name
  this", "PHP style guide", "PHP best practices", "write a PHP test", "create a
  test case", "test this function", ".phpt", "regression test for this bug",
  "phpt", or any time the user shares PHP and asks for feedback, or wants a test
  that runs under run-tests.php / make test.
---

# PHP

Two related concerns, one skill:

1. **Coding standards** — naming, style, error phrasing for all PHP (and C
   extensions). See the *Coding Standards* section below.
2. **Test writing** — `.phpt` files for php-src's `run-tests.php`. See the
   *Test Writing* section below.

**Full references**:
- `references/php-coding-standards.md` — complete rules with good/bad examples.
- `references/phpt-format.md` — every `.phpt` section, all `%` specifiers,
  naming, examples.

---

# Coding Standards

Apply to all PHP code, not just extensions. Pick the rule by meaning, let style
follow.

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Functions | `lowercase_underscore` | `str_word_count`, `array_key_exists` |
| Methods | `camelCase` (lowercase first) | `getData()`, `performHttpRequest()` |
| Classes | `PascalCase` | `CurlResponse`, `HttpStatusCode` |
| Variables | `lowercase_underscore` | `result_count`, `user_id` |
| Acronyms | Treated as regular words | `Url`, `Http`, `Ssl` — NOT `URL`, `HTTP`, `SSL` |

**Acronym rule** is commonly violated — enforce it strictly, on class *and*
method names:
- ✅ `HttpStatusCode`, `performHttpRequest()`, `Ssl\Certificate`
- ❌ `HTTPStatusCode`, `performHTTPRequest()`, `SSL\Certificate`

**Function families** use a `parent_*` prefix:
- ✅ `foo_select_bar`, `foo_insert_baz`
- ❌ `fooselect_bar`, `delete_foo_baz`

**Minimize letter count** in names, but never at the cost of readability. No
unexplained abbreviations.

## Error Message Phrasing

Consistent phrasing for `ValueError` / warnings:

| Situation | Pattern |
|-----------|---------|
| Wrong type | `must be of type int` |
| Out of range | `must be between X and Y` / `must be greater than X` |
| Empty/null | `must not be empty` / `must not contain any null bytes` |
| Invalid value | `must be a valid encoding` |
| Enum-like | `must be one of X, Y, or Z` |
| Structural | `must have key X` / `must have N elements` |

## Code Style

- **K&R style**: opening brace on same line — `if (foo) {` not `if(foo)\n{`
- **Tabs** for indentation (representing 4 spaces)
- Generous whitespace: blank line between declarations and logic, 1–2 between functions
- Always use braces, even for single-line blocks

## PHP Extension / C Code (when applicable)

- Use `emalloc()`/`efree()`/`estrdup()` — not `malloc()`/`free()`
- Never free pointer arguments unless that's the function's explicit purpose
- **Never use `strncat()`**
- Use PHP's string length property — don't recalculate with `strlen()`
- Use `PHP_*` macros in PHP source; `ZEND_*` in Zend source
- `bool` return type for "is"/"has" functions; `zend_result` for ops that may succeed/fail
- External API: `php_module_function()`, defined in `php_modulename.h`
- Internal helpers: `static`, prefixed with `_php_`, not in header

**Reviewing PHP**: check naming first (acronym rule catches most), then style,
then error phrasing. **Writing PHP**: follow the naming table; consult the
reference for edge cases.

---

# Test Writing

Generate `.phpt` files for php-src's `run-tests.php` (`make test`). A `.phpt` is
plain text split into `--SECTION--` blocks.

## Minimum Viable Test

Three sections required: `--TEST--`, one `--FILE--`-type, one `--EXPECT--`-type.

```
--TEST--
strtr() basic — array replacement pairs
--FILE--
<?php
$trans = ["hello" => "hi", "world" => "planet"];
var_dump(strtr("hello world!", $trans));
?>
--EXPECT--
string(11) "hi planet!"
```

## Choosing the Output Section

| Section | When |
|---------|------|
| `--EXPECT--` | Output is byte-for-byte deterministic. Prefer this. |
| `--EXPECTF--` | Variable bits — paths, line numbers, floats, ids. Use `%` specifiers. |
| `--EXPECTREGEX--` | Whole output needs a regex; rare. |

Error/warning tests almost always need `--EXPECTF--` (messages end with
`in %s on line %d`).

## EXPECTF Specifiers (most-used)

| `%s` | 1+ chars, no newline | `%d` | unsigned int |
| `%a` | 1+ chars incl. newlines | `%i` | signed int |
| `%S` | 0+ chars, no newline | `%f` | float |
| `%w` | 0+ whitespace | `%x` | hex |
| `%e` | dir separator `/` or `\` | `%c` | single char |

`%r...%r` embeds a raw regex. Full table in the reference.

## Naming Convention

| Test type | Filename | Example |
|-----------|----------|---------|
| Bug regression | `bug<id>.phpt` | `bug81740.phpt` |
| Basic happy-path | `<func>_basic.phpt` | `array_map_basic.phpt` |
| Error / warning | `<func>_error.phpt` | `array_map_error.phpt` |
| Edge / boundary | `<func>_variation.phpt` | `array_map_variation.phpt` |
| Extension numbered | `<ext><nn>.phpt` | `curl_003.phpt` |

## Test Categories

- **basic** — simplest correct usage, one happy path.
- **error** — wrong arg count/type, warnings, `ValueError`/`TypeError`, edge inputs.
- **variation** — boundaries, alternative valid inputs, type juggling.

One test = one aspect. Keep expected output **under ~10 lines**.

## Authoring Checklist

1. Pick the filename per the naming table.
2. `--TEST--` is one line stating exactly what is verified.
3. Wrap `--FILE--` code in `<?php ... ?>`.
4. Make output deterministic:
   - `date_default_timezone_set('UTC');` in `--FILE--` (not `--INI--`).
   - `sort()` / `ksort()` before dumping when order isn't guaranteed (SQL, `glob`, `scandir`).
5. Gate non-portable tests with `--SKIPIF--` (extension, bitness, OS).
6. Create temp files under `__DIR__`, prefix with the test name, delete in `--CLEAN--`.
7. Choose `--EXPECT--` vs `--EXPECTF--` per the table above.
8. Verify locally: `php run-tests.php path/to/test.phpt` (`--keep-all` to inspect `.out`/`.diff`/`.exp`).

## Common Section Add-ons

| Section | Use |
|---------|-----|
| `--SKIPIF--` | `<?php if (!extension_loaded("curl")) die("skip curl required"); ?>` |
| `--EXTENSIONS--` | Required extensions to auto-load (preferred over a SKIPIF check). |
| `--INI--` | Per-test php.ini lines, e.g. `precision=14`. |
| `--CLEAN--` | Cleanup after the run; reference files via `__DIR__`. |
| `--ARGS--` / `--ENV--` / `--GET--` / `--POST--` | Feed CLI args, env, request data. |
| `--XFAIL--` | Known-broken; one-line reason. `--FLAKY--` for intermittent. |

## Generating a Test From a Function

1. Happy path → `<func>_basic.phpt`.
2. Failure modes (bad types, out-of-range, empties) → `<func>_error.phpt` with `--EXPECTF--`.
3. Boundaries / alt inputs → `<func>_variation.phpt`.
4. Compute expected output by actually running the snippet (`php -r`) rather than
   guessing — guessed `var_dump` output (string lengths, float formatting) is the
   #1 source of false failures.

> `.phpt` / `run-tests.php` is php-src's **internal** harness. For testing your
> own application code (not contributing to PHP itself), commit `.phpt` files to
> your repo — there's no need to email anyone, despite what the upstream docs say.