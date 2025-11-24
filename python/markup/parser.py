#!/usr/bin/env python3
"""
A simple markup parser supporting paragraphs and code blocks.
"""

from dataclasses import dataclass
from typing import List, Union
import re


@dataclass
class Paragraph:
    """A paragraph block with normalized text."""
    text: str

    def __repr__(self):
        return f"Paragraph({self.text!r})"


@dataclass
class CodeBlock:
    """A code block with a language tag and content."""
    language: str
    content: str

    def __repr__(self):
        return f"CodeBlock(language={self.language!r}, content={self.content!r})"


Document = List[Union[Paragraph, CodeBlock]]


def normalize_paragraph_text(text: str) -> str:
    """
    Normalize paragraph text by:
    - Replacing newlines with spaces
    - Collapsing multiple spaces into one
    - Stripping leading/trailing whitespace
    """
    # Replace newlines with spaces
    text = text.replace('\n', ' ')
    # Collapse multiple spaces
    text = re.sub(r' +', ' ', text)
    # Strip leading/trailing whitespace
    return text.strip()


def parse(text: str) -> Document:
    """
    Parse markup text into a document (list of blocks).

    Blocks are separated by blank lines (lines containing only whitespace).
    Code blocks start with ```language and end with ```.
    Everything else is a paragraph.
    """
    lines = text.split('\n')
    document = []
    i = 0

    while i < len(lines):
        line = lines[i]

        # Skip blank lines
        if not line.strip():
            i += 1
            continue

        # Check for code block
        if line.strip().startswith('```'):
            # Extract language tag
            language = line.strip()[3:].strip()
            i += 1

            # Collect code block content until closing ```
            code_lines = []
            while i < len(lines):
                if lines[i].strip() == '```':
                    i += 1
                    break
                code_lines.append(lines[i])
                i += 1

            content = '\n'.join(code_lines)
            document.append(CodeBlock(language=language, content=content))
        else:
            # Collect paragraph lines until blank line or code block
            para_lines = []
            while i < len(lines):
                if not lines[i].strip():
                    # Blank line - end of paragraph
                    break
                if lines[i].strip().startswith('```'):
                    # Code block - end of paragraph
                    break
                para_lines.append(lines[i])
                i += 1

            if para_lines:
                text = '\n'.join(para_lines)
                normalized = normalize_paragraph_text(text)
                document.append(Paragraph(text=normalized))

    return document


def print_document(doc: Document, show_tree: bool = True):
    """
    Print a document, optionally showing the parse tree structure.
    """
    if show_tree:
        print("=== Parse Tree ===")
        for i, block in enumerate(doc):
            print(f"{i}: {block}")
        print()

    print("=== Rendered ===")
    for block in doc:
        if isinstance(block, Paragraph):
            print(block.text)
            print()
        elif isinstance(block, CodeBlock):
            print(f"```{block.language}")
            print(block.content)
            print("```")
            print()


if __name__ == "__main__":
    # Example 1: Basic document
    example1 = """Lorem ipsum blah blah blah
blah blah blah.

```python
def foo():
    return 42
```

more text etc etc"""

    print("=" * 60)
    print("EXAMPLE 1")
    print("=" * 60)
    doc1 = parse(example1)
    print_document(doc1)

    # Example 2: Multiple paragraphs and code blocks
    example2 = """This is the first paragraph.
It spans multiple lines but will be
normalized into one line.

This is a second paragraph.

```javascript
function hello() {
    console.log("Hello!");
}
```

And here's some more text after the code.
With   multiple    spaces    that
will be normalized.

```rust
fn main() {
    println!("Rust!");
}
```

Final paragraph."""

    print("\n" + "=" * 60)
    print("EXAMPLE 2")
    print("=" * 60)
    doc2 = parse(example2)
    print_document(doc2)

    # Example 3: Edge cases
    example3 = """Single line paragraph.

```
Code block with no language tag
```

Paragraph with     lots   of    spaces.
And newlines
everywhere."""

    print("\n" + "=" * 60)
    print("EXAMPLE 3")
    print("=" * 60)
    doc3 = parse(example3)
    print_document(doc3)
