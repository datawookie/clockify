library(rvest)

html <- read_html("https://clockify.me/developers-api")

operations <- html %>%
  html_elements(".swagger-operation-path")

for (operation in operations) {
  method <- operation %>%
    html_element(".operation-method") %>%
    html_text()
  path <- operation %>%
    html_element(".operation-path") %>%
    html_text()
  cat(paste("- [ ]", method, path), "\n", sep = "")
}
