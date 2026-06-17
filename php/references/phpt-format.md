# .phpt Test Format — Full Reference

Source: https://php.github.io/php-src/miscellaneous/writing-tests.html

`.phpt` files are the test format executed by php-src's `run-tests.php` (invoked
via `make test`). Each file is plain text divided into sections delimited by
`--SECTIONNAME--` on its own line. Section bodies run until the next delimiter.

## Required sections

A valid test needs **all three**:

- `--TEST--` — one-line description of what is validated.
- One FILE-type section — the code to run (`--FILE--`, `--FILEEOF--`,
  `--FILE_EXTERNAL--`, or `--REDIRECTTEST--`).
- One EXPECT-type section — expected output (`--EXPECT--`, `--EXPECTF--`,
  or `--EXPECTREGEX--`).

## Section catalogue

### Code / description

| Section | Meaning |
|---------|---------|
| `--TEST--` | Single-line summary. Required. |
| `--DESCRIPTION--` | Optional multi-line explanation / rationale. |
| `--CREDITS--` | Author attribution (`Name user@host`). |
| `--FILE--` | PHP code to execute, wrapped in `<?php ?>`. Required (one FILE type). |
| `--FILEEOF--` | Like `--FILE--` but no trailing-newline normalization. |
| `--FILE_EXTERNAL--` | Path to an external file to use as the test body. |
| `--REDIRECTTEST--` | Returns an array redirecting to another test set (test runners). |

### Expected output

| Section | Meaning |
|---------|---------|
| `--EXPECT--` | Exact expected stdout. |
| `--EXPECTF--` | Expected stdout with `%` format specifiers for variable content. |
| `--EXPECTREGEX--` | Expected stdout as a single regular expression. |
| `--EXPECTHEADERS--` | Expected HTTP headers (CGI tests). |

### Control / environment

| Section | Meaning |
|---------|---------|
| `--SKIPIF--` | PHP snippet; if it prints `skip <reason>`, the test is skipped. |
| `--EXTENSIONS--` | Newline-separated extension names to load before running. |
| `--INI--` | Per-test php.ini directives, one per line. |
| `--ARGS--` | Command-line arguments passed to the script. |
| `--ENV--` | Environment variables (`name=value` lines). |
| `--CLEAN--` | PHP snippet run after the test to clean up resources. |
| `--CONFLICTS--` | Keys; tests sharing a key won't run in parallel. |
| `--XFAIL--` | Marks an expected failure; body is the reason. |
| `--FLAKY--` | Marks an intermittently failing test; body is the reason. |
| `--WHITESPACE_SENSITIVE--` | Disables whitespace normalization. |
| `--CAPTURE_STDIO--` | Which of STDIN/STDOUT/STDERR to capture. |

### Request input (SAPI / CGI tests)

| Section | Meaning |
|---------|---------|
| `--GET--` | Query string. |
| `--POST--` | URL-encoded POST body. |
| `--POST_RAW--` | Raw POST body with explicit `Content-Type`. |
| `--PUT--` | PUT body. |
| `--COOKIE--` | Cookie header value. |
| `--STDIN--` | Data piped to stdin. |
| `--GZIP_POST--` | gzip-compressed POST. |
| `--DEFLATE_POST--` | deflate-compressed POST. |
| `--CGI--` | Force the CGI SAPI. |
| `--PHPDBG--` | phpdbg commands. |

## EXPECTF / EXPECTREGEX format specifiers

Used inside `--EXPECTF--` (and partially via `%r...%r` in EXPECTF):

| Specifier | Matches |
|-----------|---------|
| `%s` | One or more characters, excluding newline. |
| `%S` | Zero or more characters, excluding newline. |
| `%a` | One or more characters, including newlines. |
| `%A` | Zero or more characters, including newlines. |
| `%w` | Zero or more whitespace characters. |
| `%d` | One or more digits (unsigned integer). |
| `%i` | Signed integer (optional leading `+`/`-`). |
| `%f` | Floating-point number. |
| `%x` | One or more hexadecimal digits. |
| `%c` | A single character. |
| `%e` | A directory separator (`/` or `\`). |
| `%r<regex>%r` | Inline regular expression between the `%r` markers. |
| `%%` | A literal `%`. |

Convention for error messages: end the pattern with
`in %s on line %d` (or `in %sfilename.php on line %d`) since the path and line
number vary by environment.

## Naming conventions

| Type | Format | Example |
|------|--------|---------|
| Bug regression | `bug<id>.phpt` | `bug17123.phpt` |
| Basic function test | `<funcname>_basic.phpt` | `strpos_basic.phpt` |
| Error / warning test | `<funcname>_error.phpt` | `strpos_error.phpt` |
| Variation / boundary | `<funcname>_variation.phpt` | `strpos_variation.phpt` |
| Numbered extension test | `<extname><nnn>.phpt` | `dba_003.phpt` |

Tests live under `tests/` (language tests) or `ext/<extname>/tests/`
(extension tests) in the php-src tree.

## Test category semantics

- **basic** — one simple, correct invocation. The happy path.
- **error** — invalid argument counts/types, warnings, notices, `TypeError`,
  `ValueError`, and other failure paths.
- **variation** — boundary values, alternate-but-valid inputs, type juggling,
  locale/encoding variants.

## Best practices

**Scope** — One test verifies one aspect. Aim for **< 10 lines of output**;
smaller diffs are easier to debug.

**Comments** — Add brief comments stating intent so a future maintainer
unfamiliar with the test understands the objective.

**Determinism / portability**
- Set timezone in code: `date_default_timezone_set('UTC');` inside `--FILE--`,
  not via `--INI--`.
- Sort before dumping when ordering is not guaranteed (SQL results, `glob()`,
  `scandir()`, hash iteration) — `sort()`, `ksort()`, etc.
- Guard platform-specific behavior with `--SKIPIF--`:
  ```php
  --SKIPIF--
  <?php
  if (PHP_INT_SIZE != 8) die("skip 64-bit only");
  if (substr(PHP_OS, 0, 3) != 'WIN') die("skip Windows only");
  if (!extension_loaded("curl")) die("skip curl required");
  ?>
  ```
- Prefer `--EXTENSIONS--` over a `extension_loaded()` SKIPIF when you simply
  need an extension present.

**Error reporting** — Tests run with `error_reporting(E_ALL)` and
`display_errors=1`. Match emitted errors with `--EXPECTF--`, using `%s` for
paths and `%d` for line numbers.

**Resource cleanup** — Remove temp files in `--CLEAN--`, referencing them via
`__DIR__` so paths resolve regardless of the working directory. Prefix temp
filenames with the test name for traceability:
```php
--CLEAN--
<?php @unlink(__DIR__ . "/mytest.tmp"); ?>
```

**INI placeholders** — Inside `--INI--` you may use `{PWD}` (the test's
directory) and `{TMP}` (system temp directory).

## Running tests

```sh
make test                       # whole suite
php run-tests.php some_test.phpt # a single file (from the build tree)
php run-tests.php ext/foo/tests  # a directory
```

On failure, run-tests.php writes diagnostics next to the test:

| File | Contents |
|------|----------|
| `<name>.diff` | Diff of expected vs actual. |
| `<name>.exp` | Expected output. |
| `<name>.out` | Actual output. |
| `<name>.php` | The generated runnable script. |
| `<name>.log` | Full log. |
| `<name>.sh` | Shell command that reproduces the run. |

Pass `--keep-all` (or `--keep <type>`) to retain these for inspection;
without it they are cleaned up on success.

> The upstream php-src workflow emails tests to `php-qa@lists.php.net` for the
> core team to commit. That's for contributing to PHP itself — irrelevant for
> testing your own application code. Just commit your `.phpt` files to the repo.

## Complete examples

### Basic

```
--TEST--
array_sum() basic — sums an integer list
--FILE--
<?php
var_dump(array_sum([1, 2, 3, 4]));
?>
--EXPECT--
int(10)
```

### Error (needs EXPECTF for path/line)

```
--TEST--
array_sum() error — non-array argument throws TypeError
--FILE--
<?php
try {
    array_sum("not an array");
} catch (\TypeError $e) {
    echo $e->getMessage(), "\n";
}
?>
--EXPECT--
array_sum(): Argument #1 ($array) must be of type array, string given
```

### SKIPIF + CLEAN + EXPECTF

```
--TEST--
file_put_contents()/file_get_contents() round-trip
--SKIPIF--
<?php if (!function_exists("file_put_contents")) die("skip not available"); ?>
--FILE--
<?php
$file = __DIR__ . "/rttest.tmp";
file_put_contents($file, "payload");
var_dump(file_get_contents($file));
?>
--CLEAN--
<?php @unlink(__DIR__ . "/rttest.tmp"); ?>
--EXPECT--
string(7) "payload"
```

### EXPECTF with format specifiers

```
--TEST--
Division by zero emits DivisionByZeroError with location
--FILE--
<?php
intdiv(1, 0);
?>
--EXPECTF--
Fatal error: Uncaught DivisionByZeroError: Division by zero in %s:%d
Stack trace:
%a
  thrown in %s on line %d
```