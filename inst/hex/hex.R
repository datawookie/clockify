library(hexSticker)
library(showtext)

# Load Google font.
font_add_google(name = "Roboto", family = "Roboto")
showtext_auto()

SWIDTH <- 851
SHEIGHT <- 960
SFACTOR <- 1350

sticker(
  here::here("inst/hex/clockify-icon.png"),
  # Image
  s_x = 0.925,
  s_y = 1.10,
  s_width = SWIDTH / SFACTOR,
  s_height = SHEIGHT / SFACTOR,
  # Package name
  package = "clockify",
  p_size = 36,
  p_x = 1.370,
  p_y = 0.395,
  p_color = "#000000",
  p_family = "Roboto",
  # Hex
  h_fill = "#E4EAEE",
  h_size = 1.5,
  h_color = "#03a9f4",
  # Output
  filename = here::here("man/figures/clockify-hex.png"),
  asp = 0.85,
  dpi = 600,
  angle = 30
)
