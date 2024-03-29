# https://www.ddrive.no/post/making-hex-and-twittercard-with-bunny-and-magick/

library(magick)

hex <- image_read(here::here("man/figures/clockify-hex.png")) %>%
  image_scale("400x400")

gh_logo <- bunny::github %>% image_scale("50x50")

gh_card <- image_canvas_ghcard("#ffffff") %>%
  image_compose(hex, gravity = "East", offset = "+80+0") %>%
  image_annotate(
    "clockify: Clockify from R",
    gravity = "West",
    location = "+80-30",
    color = "#0d4448",
    size = 50,
    font = "Roboto Slab"
  ) %>%
  image_compose(gh_logo, gravity = "West", offset = "+80+45") %>%
  image_annotate(
    "datawookie/clockify",
    gravity = "West",
    location = "+140+45",
    size = 50,
    font = "Ubuntu Mono"
  ) %>%
  image_border_ghcard("#8b9196")

gh_card

gh_card %>%
  image_write(here::here("man/figures/clockify-github-card.png"))
