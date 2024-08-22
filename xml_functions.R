#' unzip and reformat
#' 
#' Given a word docx file, unzips it into a directory named with `_zip` 
#' and reformats the `word/document.xml` so
#' it is easier to read. This overwrites the `document.xml`, but upon rezipping,
#' Word seems fine with the file, at least when it is reformatted and rezipped on
#' Linux.
#' 
#' @param word_file the word file to unzip
#' @param reformat should the `word/document.xml` file be reformatted (default is "yes")
#' 
#' @return NULL 
unzip_reformat = function(word_file, reformat = "yes")
{
  # word_file = "gt_bad_xml.docx"
  unzip_dir = glue::glue(fs::path_ext_remove(word_file), "_zip")
  message(glue::glue("unzipping docx file to {unzip_dir}"))
  unzip(word_file, exdir = unzip_dir)
  document_path = fs::path(unzip_dir, "word", "document.xml")
  if (reformat %in% "yes") {
    reformat(document_path)
  }
  return(NULL)
}


#' reformat
#'
#' Given an XML file, replaces non-breaking adjacent tags `><`, inserts a newline in between
#' to make it easier to read and manipulate.
#'
#' @param document_path the path to the XML file
#' 
#' @return NULL
reformat = function(document_path)
{
  doc_xml = readLines(document_path)
  doc_split = gsub("><", ">\n<", doc_xml)
  message(glue::glue("Writing split xml over the original at {document_path}"))
  cat(doc_split, file = document_path, sep = "\n")
  return(NULL)
}

#' Create docx file
#' 
#' Given a zip directory, creates a docx file. Note that because of *how* docx works,
#' we actually switch to the zip directory, run zip, and then come back to the 
#' working directory.
#' 
#' @param zip_dir the zip directory we want to use to create a docx
#' @param docx_file the docx file to write
#'
#' @return NULL
create_docx = function(zip_dir, docx_file = "tmp.docx")
{
  # zip_dir = "gt_bad_xml_zip"
  curr_dir = getwd()
  full_file = fs::path(curr_dir, docx_file)
  setwd(zip_dir)
  all_files = fs::dir_ls()
  has_docx = grepl("docx$", all_files)
  if (any(has_docx)) {
    fs::file_delete(all_files[has_docx])
  }
  zip(full_file, all_files[!has_docx], flags = "-r")
  setwd(curr_dir)
  message(glue::glue("zipped {zip_dir} to {docx_file}."))
  return(NULL)
}
