library(stringi)

CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
# This is the "{clockify} sandbox" workspace that was specifically created for testing {clockify}.
CLOCKIFY_WORKSPACE <- "630c61ba9c3a3c3112812332"

USER_ID_AUTHENTICATED <- "5f227e0cd7176a0e6e754409" # Andrew
USER_ID_MISSING_NAME <- "630f16ab90cfd878937a7997" # <NA>
USER_ID_BOB <- "630f17f04a05b20faf7e0afc" # Bob
USER_ID_ALICE <- "630f15d3b59c366b0e3ae2e6" # Alice
USER_ID_CAROL <- "630f1cb9cb18da61cfd58659" # Carol

# These projects are assumed to already exist.
#
PROJECT_ID_CLOCKIFY <- "630ce53290cfd8789366fd49"
PROJECT_ID_EMAYILI <- "630ce53cb59c366b0e27743f"

# The RStudio client is assumed to already exist.
#
CLIENT_ID_RSTUDIO <- "63a55695db26c25e9d4e2d02"
CLIENT_NAME_PSF <- "Python Software Foundation"

NO_API_KEY_IN_ENVIRONMENT <- CLOCKIFY_API_KEY == ""

random_string <- function(length = 24) {
  stri_rand_strings(1, length)
}

random_integer <- function(min = 0, max = 100) {
  round(runif(1) * (max - min) + min)
}

TAG_NAME <- random_string()
TAG_ID <- NULL
TAG_NAME_UPDATED <- random_string()

TASK_NAME <- random_string()
TASK_ID <- NULL
TASK_NAME_UPDATED <- random_string()

TIME_CURRENT <- Sys.time()

options(duration.units = "secs")
