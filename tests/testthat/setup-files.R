CLOCKIFY_API_KEY <- Sys.getenv("CLOCKIFY_API_KEY")
# This is the workspace that was specifically created for testing {clockify}.
CLOCKIFY_WORKSPACE <- "630c61ba9c3a3c3112812332"

NO_API_KEY_IN_ENVIRONMENT <- CLOCKIFY_API_KEY == ""
