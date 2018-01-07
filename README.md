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
│   └── file2.md
├── file1.md
└── Makefile
```

## Root makefile

In the "root" Makefile, you can either specify entire folders or
markdown-formatted files.  Folders will be recursively scanned in order to find
markdown-formatted files.

You can also specify which dependencies are global to all files.

Eg:

```mk
## Source directories
src := directory
src += file1.md

## Extra dependencies (optional)
dep :=

## Include common rules
include common/pandoc.mk
```

