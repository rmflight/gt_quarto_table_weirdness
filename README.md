
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

When creating a Word document with a cross-referenced table included, the table XML becomes malformed, and Word complains bitterly, and the tables don't look right.

## Resources

This repo has an R file with 3 functions:

* `unzip_reformat`: unzips the docx and then prettifies the XML to make it legible by human eyes.
* `reformat`: actually does the reformatting of the docx.
* `create_docx`: given a zip directory, create a docx file from it, so one can test if modified XML results in a nicer docx file.

qmd files to provide reproducible examples of things not working, as well as the corresponding docx files:

* `gt_good_xml.qmd`: no cross-reference, just works when opened in Word.
* `gt_bad_xml.qmd`: has a single table cross reference, Word complains when opened, table looks weird.
* `kable_okish_xml.qmd`: uses kable to generate the table, and has a cross-reference. Word does not complain, but table looks malformed.

## Issue

Examining the XML from the files above, we can discover some weird XML created when cross-references are auto generated (whether gt or kable are used to generate the table):

1. [The creation of a nested table](https://github.com/rmflight/gt_quarto_table_weirdness/blob/main/gt_bad_xml_zip/word/document.xml#L40-L67), where the first starts before the caption, and then the next table is within the first one.
2. The bookmark that defines where to link to the caption, is actually wrapped around the entire second table ([start loc](https://github.com/rmflight/gt_quarto_table_weirdness/blob/main/gt_bad_xml_zip/word/document.xml#L53), [end loc](https://github.com/rmflight/gt_quarto_table_weirdness/blob/main/gt_bad_xml_zip/word/document.xml#L1933)), instead of just the caption text.

## Solution

1. Make sure only a single table is defined, after the table caption (see [modified example](https://github.com/rmflight/gt_quarto_table_weirdness/blob/main/gt_bad_xml_modified_to_work/word/document.xml#L52)).
2. Create the bookmark only around the table caption (see [modified example](https://github.com/rmflight/gt_quarto_table_weirdness/blob/main/gt_bad_xml_modified_to_work/word/document.xml#L42-L51)).

I've hand crafted the XML in the `_modified_to_work` directories, and then created corresponding docx files, and verified that the links do work between text and caption, Word no longer complains, and the tables look *better*.
