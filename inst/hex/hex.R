library(hexSticker)
library(showtext)

# Load Google font.
font_add_google(name = "Roboto", family = "Roboto")
showtext_auto()

sticker(here::here("inst/hex/clockify-icon.svg"),
        # Image
        s_x = 1,
        s_y = 0.8,
        s_width = 0.5,
        s_height = 0.5,
        # Package name
        package = "clockify",
        p_size = 18,
        p_y = 1.5,
        p_color = "#000000",
        p_family = "roboto",
        # Hex
        h_fill = "#E4EAEE",
        h_size = 1.5,
        h_color = "#03a9f4",
        # Output
        filename = here::here("man/figures/clockify-hex.png"),
        asp = 0.85
)
