# Overview

My build system and common files for pandoc documents.

# Dependencies

This build system depends on:
- Pandoc
- Chromium for optional PDF generation

# Usage

The typical use-case is to have this repo as submodule (and subfolder) of your
document repo. Eg:

```
$ tree
.
├── common      <= the submodule
├── directory
│   └── file.md
└── Makefile
```

## Root makefile

In the "root" Makefile, you need to specify which folders contain the
markdown-formatted documents and which dependencies are global to all documents.
Eg:

```mk
## Source directories
src := directory

## Extra dependencies (optional)
dep :=

## Include common rules
include common/pandoc.mk
```

