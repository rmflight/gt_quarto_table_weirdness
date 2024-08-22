
# gt_quarto_table_weirdness

<!-- badges: start -->
<!-- badges: end -->

This repo documents the issues encountered in trying to create cross-referenced tables in a qmd document output to Word.

These have been confirmed using:

```
R 4.3.0 (running on Pop!OS)
quarto 1.6.5
Word 2019
Windows 10 Education
```

## Problem

When creating a Word document with a cross-referenced table included, the table XML becomes malformed, and Word complains bitterly.

## Resources

This repo has an R file with 3 functions:

* `unzip_reformat`: unzips the docx and then prettifies the XML to make it legible by human eyes.
* `reformat`: actually does the reformatting of the docx.
* `create_docx`: given a zip directory, create a docx file from it.

And then several directories of unzipped examples of things that don't work and modified to work.

