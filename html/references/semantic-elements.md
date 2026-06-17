# Semantic HTML — Full Element Reference

The core principle: **choose the element whose meaning matches the content.**
Appearance is CSS's job. Semantic markup is what makes a page accessible to
screen readers, parseable by search engines, and maintainable by humans.

`<div>` and `<span>` have **no semantic meaning** — they exist only as styling
and scripting hooks when nothing else fits. `<div>` is block-level, `<span>` is
inline. Reaching for them first is "div soup"; reach for them last.

---

## Document metadata & root

| Element | Meaning |
|---------|---------|
| `<!DOCTYPE html>` | Standards mode. Always first line. |
| `<html lang="…">` | Root. `lang` is required for accessibility/i18n. |
| `<head>` | Metadata container (not rendered). |
| `<meta charset="utf-8">` | Character encoding; first thing in `<head>`. |
| `<meta name="viewport" …>` | Responsive scaling on mobile. |
| `<title>` | Page title — tab label, bookmark name, primary SEO signal. |
| `<link>` | External resources (stylesheets, icons, preload). |
| `<base>` | Base URL for relative links (rarely needed). |

---

## Sectioning & landmarks

These create the document outline and the "landmarks" screen-reader users
navigate by.

### `<main>`
The dominant, unique content of the page. **Exactly one per page**, and it must
*not* be nested inside `<article>`, `<aside>`, `<header>`, `<footer>`, or `<nav>`.
Repeated content (site nav, footer) lives outside it.

### `<header>`
Introductory content for its nearest sectioning ancestor — site banner when a
direct child of `<body>`, or a section/article intro otherwise. Can contain a
logo, `<nav>`, search, headings. Multiple per page allowed (one per section).

### `<nav>`
A block of **major** navigation links. Reserve for primary navigation (main
menu, table of contents, pagination, breadcrumbs). Do **not** wrap every cluster
of links — a footer's link list usually doesn't need `<nav>`. Multiple `<nav>`s
should be distinguished with `aria-label`.

### `<footer>`
Footer for its nearest sectioning ancestor. Authorship, copyright, related docs,
back-to-top. One per section allowed.

### `<article>`
A **self-contained, independently distributable** composition — it would still
make sense syndicated on its own (RSS item). Examples: blog post, news story,
forum post, a single comment, a product card. Articles can nest (a post and its
comments, each comment an `<article>`). Should have a heading.

### `<section>`
A **thematic grouping** of content, typically with a heading. Use when the
content forms a distinct part of the outline (chapters, tabbed panels, grouped
settings). **Not** a generic wrapper — if there's no natural heading and it's
only there for styling, use `<div>`.

### `<aside>`
Content **tangential** to the surrounding content: sidebars, pull quotes,
advertising, related-links boxes, author bios. Removing it shouldn't break the
main flow.

### Decision guide

- Standalone & syndicatable? → `<article>`
- Thematic chunk with a heading, part of this page's outline? → `<section>`
- Related but not essential to the main content? → `<aside>`
- Just a styling/JS container, no meaning? → `<div>`

---

## Headings & outline

| Element | Meaning |
|---------|---------|
| `<h1>`–`<h6>` | Section headings; level = depth, **not** size. |
| `<hgroup>` | Groups a heading with adjacent subheading/tagline. |

Rules:
- One `<h1>` per page expressing the page topic.
- Never skip levels going down (`h2` → `h4` is wrong). You *may* jump back up.
- Start each `<section>`/`<article>` with a heading.
- Style size with CSS; don't pick a level for its default font size.

---

## Grouping content

| Element | Meaning |
|---------|---------|
| `<p>` | Paragraph of text. |
| `<ul>` | Unordered list (order doesn't matter). |
| `<ol>` | Ordered list (sequence matters; supports `start`, `reversed`, `type`). |
| `<li>` | List item (child of `ul`/`ol`/`menu`). |
| `<dl>` | Description list — name/value groups. |
| `<dt>` / `<dd>` | Term / its description. |
| `<figure>` | Self-contained referenced content (image, diagram, code, chart). |
| `<figcaption>` | Caption for a `<figure>` (first or last child). |
| `<blockquote>` | Block-level quotation (use `cite` attr for source URL). |
| `<pre>` | Preformatted text; whitespace preserved. |
| `<hr>` | Thematic break (paragraph-level), not a decorative line. |

Never fake a list with `<br>` or stacked `<div>`s — assistive tech announces
list length and position only for real lists.

---

## Text-level (inline) semantics

| Element | Means | Prefer over |
|---------|-------|-------------|
| `<a href>` | Hyperlink / navigation | — |
| `<strong>` | Strong importance / seriousness | `<b>` |
| `<em>` | Stress emphasis (changes sentence meaning) | `<i>` |
| `<mark>` | Highlighted/relevant in current context | styled `<span>` |
| `<code>` | Inline code fragment | — |
| `<kbd>` | Keyboard / user input | — |
| `<samp>` | Sample program output | — |
| `<var>` | Variable / placeholder | — |
| `<q>` | Short inline quotation (UA adds quote marks) | literal quotes |
| `<cite>` | Title of a referenced work | — |
| `<abbr title="…">` | Abbreviation/acronym with expansion | — |
| `<time datetime="…">` | Machine-readable date/time | plain text |
| `<data value="…">` | Machine-readable value for content | — |
| `<sub>` / `<sup>` | Subscript / superscript | — |
| `<del>` / `<ins>` | Removed / added content (edits) | CSS strikethrough |
| `<s>` | No-longer-accurate content | — |
| `<small>` | Side comments, fine print | — |
| `<bdi>` / `<bdo>` | Bidirectional text isolation / override | — |
| `<wbr>` | Optional line-break opportunity | — |
| `<b>` | Stylistically offset, **no** added importance | last resort |
| `<i>` | Alternate voice/mood (term, foreign word), **no** emphasis | last resort |
| `<span>` | No meaning — inline styling/scripting hook only | last resort |

`<strong>` vs `<b>` and `<em>` vs `<i>`: the first of each pair carries meaning
(importance / emphasis); the second is pure presentation. Default to the
semantic one; if you only need visual styling, use CSS.

---

## Tables (tabular data only — never layout)

| Element | Meaning |
|---------|---------|
| `<table>` | Tabular data grid. |
| `<caption>` | Table title; first child of `<table>`. |
| `<thead>` / `<tbody>` / `<tfoot>` | Header / body / footer row groups. |
| `<tr>` | Table row. |
| `<th scope="col\|row">` | Header cell; `scope` ties it to its column/row. |
| `<td>` | Data cell. |
| `<colgroup>` / `<col>` | Column-level grouping for styling/spanning. |

Always give data tables a `<caption>` and proper `<th scope>` so screen readers
can associate cells with headers.

---

## Forms & interactive

| Element | Meaning |
|---------|---------|
| `<form>` | Submittable form. |
| `<label for="id">` | Caption bound to a control. **Required** for each input. |
| `<input>` | Control; behavior set by `type`. |
| `<textarea>` | Multi-line text. |
| `<select>` / `<option>` / `<optgroup>` | Dropdown + its options/groups. |
| `<button>` | Clickable action button (`type=submit\|button\|reset`). |
| `<fieldset>` / `<legend>` | Group related controls + the group's caption. |
| `<datalist>` | Autocomplete suggestions for an input. |
| `<output>` | Result of a calculation. |
| `<progress>` / `<meter>` | Task progress / scalar measurement in a range. |
| `<details>` / `<summary>` | Native disclosure widget (expand/collapse, no JS). |
| `<dialog>` | Native modal/non-modal dialog. |

Guidance:
- A label is mandatory; a `placeholder` is **not** a label (it disappears on
  input and fails contrast/AT expectations).
- Use the most specific `type` (`email`, `url`, `tel`, `number`, `date`,
  `search`) for built-in validation and better mobile keyboards.
- **Action vs navigation**: `<button>` does something on the page; `<a href>`
  goes somewhere. Never simulate either with a clickable `<div>`/`<span>` — you
  lose keyboard focus, Enter/Space activation, and AT role announcement.
- Reach for `<details>`/`<dialog>` before building custom JS widgets.

---

## Embedded content

| Element | Meaning |
|---------|---------|
| `<img alt="…">` | Image. `alt` required: describe it, or `alt=""` if purely decorative. |
| `<picture>` / `<source>` | Art-direction / responsive image sources. |
| `<svg>` | Inline vector graphics. |
| `<audio>` / `<video>` | Media; provide `<track>` captions for video. |
| `<iframe>` | Embedded nested browsing context (give a `title`). |
| `<canvas>` | Scriptable bitmap surface. |

---

## Accessibility & ARIA notes

- **Native over ARIA**: semantic elements come with correct roles, keyboard
  behavior, and focus management. ARIA only *describes* — it adds no behavior.
- The first rule of ARIA: **don't use ARIA if a native HTML element or attribute
  already provides the semantics/behavior you need.**
- A bad ARIA role is worse than none — `<div role="button">` still needs manual
  `tabindex="0"`, key handlers, and `aria-pressed`; a real `<button>` is free.
- Maintain logical DOM order; sighted-only CSS reordering (`order`,
  `flex-direction: row-reverse`) can desync visual and reading/tab order.
- Decorative images: `alt=""` (empty, present) so AT skips them. Informative
  images: concise descriptive `alt`.
- Use `aria-label`/`aria-labelledby` to disambiguate repeated landmarks
  (multiple `<nav>`s, `<section>`s).

---

## Common antipatterns → fix

| Antipattern | Fix |
|-------------|-----|
| `<div class="header">` | `<header>` |
| `<div class="nav">` of links | `<nav>` |
| `<div onclick="…">` | `<button>` (or `<a href>` if navigating) |
| `<span class="bold">` for importance | `<strong>` |
| `<br>`-separated "list" | `<ul>`/`<ol>` + `<li>` |
| `<table>` for page layout | CSS grid/flex; keep `<table>` for data |
| `<div>` stack with no headings as "sections" | `<section>` + heading, or keep `<div>` if purely visual |
| `placeholder` used as the label | add `<label>` |
| Image with no `alt` | add descriptive `alt`, or `alt=""` if decorative |