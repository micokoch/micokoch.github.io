# publications.R

# Required packages
library(yaml)
library(glue)

# Read publications from YAML file
pubs <- yaml.load_file("publications.yml")

# Helper: flatten YAML list if needed
if (is.list(pubs) && !is.null(names(pubs))) {
  # If pubs is a named list, convert to list of publications
  pubs <- lapply(names(pubs), function(n) {
    pub <- pubs[[n]]
    pub$title <- n
    pub
  })
}

# If pubs is a list of publications, ensure each is a list
pubs <- Filter(function(x) is.list(x) && !is.null(x$title), pubs)

# Sort publications by year (descending)
pubs <- pubs[order(
  sapply(pubs, function(x) as.integer(x$year)),
  decreasing = TRUE
)]

# HTML header (adapted from your quotes.html)
html_header <- '
<!DOCTYPE html>
<html>
<head>
  <title>Publications - Álvaro J. Castro Rivadeneira</title>
  <link rel="shortcut icon" href="images/favicon.ico">
  <link rel="stylesheet" href="css/styles.css">
  <meta property="og:title" content="Publications - Álvaro J. Castro Rivadeneira">
  <meta property="og:description" content="Research publications">
  <meta property="og:image" content="images/cotopaxi.jpg">
  <meta property="og:url" content="https://micokoch.github.io/me/publications.html">
  <meta property="og:type" content="website">
  <style>
    .publist { max-width: 900px; margin: auto; }
    .publication { display: flex; align-items: flex-start; margin-bottom: 2em; }
    .pubimg { width: 120px; height: 120px; object-fit: cover; margin-right: 2em; border-radius: 8px; border: 1px solid #ccc; }
    .pubinfo { flex: 1; }
    .pubtitle { font-size: 1.5em; font-weight: bold; text-decoration: underline; margin-bottom: 0.2em; }
    .pubmeta { font-size: 1em; margin-bottom: 0.5em; }
    .pubabstract { font-size: 1em; color: #333; }
    @media (max-width: 600px) {
      .publication { flex-direction: column; align-items: stretch; }
      .pubimg { margin-bottom: 1em; margin-right: 0; width: 100%; height: auto; }
    }
  </style>
</head>
<body>
  <nav>
    <ul>
      <li><a href="/">Home</a></li>
      <li class="dropdown">
        <a href="javascript:void(0)" class="dropbtn">me</a>
        <div class="dropdown-content">
          <a href="/me/about.html">about</a>
          <a href="/me/quotes.html">quotes</a>
          <a href="/me/blog.html">blog</a>
        </div>
      </li>
      <li><a href="https://github.com/micokoch">GitHub</a></li>
    </ul>
  </nav>
  <div class="container publist">
    <h1>Publications</h1>
'

html_footer <- '
  </div>
</body>
</html>
'

# Function to format one publication as HTML
pub_to_html <- function(pub) {
  img_path <- glue("images/{pub$slug}.jpg")
  title_html <- glue(
    '<a class="pubtitle" href="{pub$url}" target="_blank">{pub$title}</a>'
  )
  meta_html <- glue(
    '{pub$authors} ({pub$year}). <i>{pub$journal}</i>{if (!is.null(pub$volume)) glue(", {pub$volume}") else ""}{if (!is.null(pub$number)) glue("({pub$number})") else ""}{if (!is.null(pub$pages)) glue(": {pub$pages}") else ""}.'
  )
  abstract_html <- glue('<div class="pubabstract">{pub$abstract}</div>')
  glue(
    '
    <div class="publication">
      <img class="pubimg" src="{img_path}" alt="{pub$title}">
      <div class="pubinfo">
        {title_html}
        <div class="pubmeta">{meta_html}</div>
        {abstract_html}
      </div>
    </div>
  '
  )
}

# Build HTML for all publications
pubs_html <- paste(lapply(pubs, pub_to_html), collapse = "\n")

# Write to file
writeLines(paste0(html_header, pubs_html, html_footer), "publications.html")
