---
name: html
description: >
  HTML authoring and review. Use this skill whenever writing, refactoring, or
  reviewing HTML — currently covers semantic markup and accessibility. Trigger
  on: "write HTML", "is this good HTML?", "semantic HTML", "which element should
  I use", "div vs section", "header/footer/nav/main/article/aside", "fix this
  markup", "make this accessible", "ARIA", "heading structure", or any time the
  user shares HTML and asks for feedback. (Topics are additive — see the Topics
  list below for current coverage.)
---

# HTML

Umbrella skill for HTML guidance. Each concern is a top-level section here, with
a matching deep-dive file under `references/`. Add new topics by following the
pattern in the *Extending This Skill* section below.

## Topics

1. **Semantics & accessibility** — choosing meaningful elements, landmarks,
   headings, forms, tables, ARIA. → see the *Semantics* section below ·
   `references/semantic-elements.md`

_(planned: forms in depth, CSS/styling, responsive/layout, performance,
metadata/SEO — slot them in as new sections + reference files.)_

---

# Semantics

Pick the element that describes the *meaning* of the content, not its
appearance. Semantic markup gives you accessibility, SEO, and maintainability
for free. CSS handles looks — never reach for a `<div>` just to get a box.

**Full reference**: `references/semantic-elements.md` — every element grouped by
role, with do/don't examples and accessibility notes.

## The One Rule

> Use `<div>`/`<span>` **only** when no semantic element fits. They carry zero
> meaning — they're styling/scripting hooks of last resort.

Before writing `<div>`, ask: is this a section? a nav? a list? a button? a
figure? If yes, use that element instead.

## Document Skeleton

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Descriptive page title</title>
</head>
<body>
  <header>…site/page header, often with <nav></header>
  <main>…the unique main content; exactly one per page…</main>
  <footer>…site footer…</footer>
</body>
</html>
```

## Landmarks (sectioning & page regions)

| Element | Use for | Notes |
|---------|---------|-------|
| `<header>` | Intro content for page or section | Multiple allowed (one per section). |
| `<nav>` | Major navigation block | Don't wrap *every* link group; reserve for primary nav. |
| `<main>` | The page's primary, unique content | **Exactly one**, not nested in article/aside. |
| `<article>` | Self-contained, independently distributable unit | Blog post, comment, product card. |
| `<section>` | Thematic grouping, usually with a heading | Not a generic box — needs a heading. |
| `<aside>` | Tangential content | Sidebar, pull quote, related links. |
| `<footer>` | Footer for page or section | Authorship, copyright, links. |

`<section>` vs `<div>`: if it has a heading and belongs in the document outline,
`<section>`. If it's purely a styling wrapper, `<div>`.

`<article>` vs `<section>`: would it make sense standalone in an RSS feed?
→ `<article>`. Just a thematic chunk of a larger thing? → `<section>`.

## Headings

- One `<h1>` per page (the page's title/topic).
- Don't skip levels — `<h2>` follows `<h1>`, `<h3>` follows `<h2>`. Levels
  convey nesting, not font size (that's CSS).
- Every `<section>`/`<article>` should start with a heading.

## Text-Level Semantics (use the meaningful one)

| Want to mean… | Use | Not |
|---------------|-----|-----|
| Importance | `<strong>` | `<b>` |
| Emphasis (stress) | `<em>` | `<i>` |
| Code | `<code>`, `<pre>` | `<span class="code">` |
| Quotation (block) | `<blockquote>` | indented `<div>` |
| Inline quote | `<q>` | `"…"` in a span |
| Abbreviation | `<abbr title="…">` | plain text |
| Time/date | `<time datetime="…">` | plain text |
| Marked/highlighted | `<mark>` | `<span class="hl">` |
| Deleted / inserted | `<del>` / `<ins>` | strikethrough CSS |

`<b>`/`<i>` are *last-resort* visual styling with no semantic weight — prefer
`<strong>`/`<em>` or CSS.

## Lists, Figures, Tables

- Grouped items → `<ul>`/`<ol>` + `<li>`. Never fake a list with `<br>` or divs.
- Name/value pairs, glossaries → `<dl>`/`<dt>`/`<dd>`.
- Image with caption → `<figure>` + `<figcaption>`.
- Tabular data → `<table>` with `<thead>/<tbody>`, `<th scope>`, `<caption>`.
  Never use tables for layout.

## Forms & Interactivity

- Every input needs a `<label for>` (or wrapping label). Placeholders are not labels.
- Group related fields with `<fieldset>` + `<legend>`.
- Clickable action → `<button>`. Navigation → `<a href>`. Never a `<div onclick>`.
- Use real input `type`s (`email`, `tel`, `url`, `number`, `date`) for free
  validation + mobile keyboards.
- Expand/collapse → `<details>`/`<summary>` before reaching for JS.

## Accessibility Tie-In

- **Native first**: a real `<button>`/`<a>`/`<input>` is keyboard- and
  screen-reader-accessible by default. ARIA can't fully replace that.
- ARIA rule #1: *don't use ARIA if a native element does the job.*
- `<img>` always needs `alt` (empty `alt=""` for purely decorative images).
- Keep a logical DOM order; don't rely on CSS to reorder meaning.

## Review Checklist

1. Is there a `<main>`, exactly one, with the unique content?
2. Landmarks present (`header`/`nav`/`main`/`footer`) instead of `<div>`s?
3. Heading levels sequential, one `<h1>`?
4. Any `<div>`/`<span>` that should be a semantic element?
5. `<div onclick>` / `<a>` used as a button → replace with `<button>`?
6. Images have `alt`; inputs have `<label>`?
7. Lists/tables/figures using the right elements (not faked)?

---

# Extending This Skill

To add a new HTML topic later:

1. Add a row to the **Topics** list above (name + anchor + reference path).
2. Add a `# <Topic>` section here with a quick reference: the key rules, a small
   table or checklist, and a pointer to its reference file.
3. Create `references/<topic>.md` for the full deep-dive (mirror the style of
   `references/semantic-elements.md`).
4. If a topic grows large, broaden the frontmatter `description` triggers so the
   skill activates for that topic's vocabulary too.

Keep SKILL.md as the scannable index; push exhaustive detail into `references/`.