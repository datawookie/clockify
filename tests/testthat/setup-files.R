CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
# This is the workspace that was specifically created for testing {clockify}.
CLOCKIFY_WORKSPACE <- "630c61ba9c3a3c3112812332"

USER_ID_AUTHENTICATED <- "5f227e0cd7176a0e6e754409"   # Andrew
USER_ID_MISSING_NAME <-  "630f16ab90cfd878937a7997"   # <NA>
USER_ID_BOB <-           "630f17f04a05b20faf7e0afc"   # Bob
USER_ID_ALICE <-         "630f15d3b59c366b0e3ae2e6"   # Alice
USER_ID_CAROL <-         "630f1cb9cb18da61cfd58659"   # Carol

NO_API_KEY_IN_ENVIRONMENT <- CLOCKIFY_API_KEY == ""

random_string <- function(length = 24) {
  stringi::stri_rand_strings(1, length)
}
