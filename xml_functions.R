unzip_reformat = function(word_file, reformat = TRUE)
{
  # word_file = "gt_bad_xml.docx"
  unzip_dir = glue::glue(fs::path_ext_remove(word_file), "_zip")
  message(glue::glue("unzipping docx file to {unzip_dir}"))
  unzip(word_file, exdir = unzip_dir)
  document_path = fs::path(unzip_dir, "word", "document.xml")
  if (reformat) {
    reformat(document_path)
  }
  return(NULL)
}

reformat = function(document_path)
{
  doc_xml = readLines(document_path)
  doc_split = gsub("><", ">\n<", doc_xml)
  message(glue::glue("Writing split xml over the original at {document_path}"))
  cat(doc_split, file = document_path, sep = "\n")
}

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
