#' Linear mixed models in a web browser
#'
#' @description
#' \code{vlm_app()} starts the application of \pkg{VetResearchLMM}: choose a data set of the book (or upload a CSV
#' file), fit a linear mixed model with random effects and a residual covariance structure, and obtain least-squares
#' means, estimates and contrasts, predictions of random effects, the analysis of variance with expected mean
#' squares, and a comparison of covariance structures. Every example of the book can be loaded with one click. Each
#' result page shows an interpretation computed from the results (\code{\link{vlm_interpret}()}), the output as R
#' prints it, formatted tables, plots and the R code that repeats the analysis, each with a Copy button.
#'
#' @details
#' The application needs the suggested packages \pkg{shiny}, \pkg{bslib} and \pkg{DT}. Plots are sent to the browser
#' as WebP images when \pkg{magick} is installed (PNG otherwise) and can be downloaded as PNG, PDF or WebP. Estimates
#' and contrasts are typed as in SAS: \code{label: effect coefficients effect coefficients}, one per line, with rows
#' of a contrast separated by commas.
#'
#' @param launch.browser passed to \code{shiny::runApp()}: \code{TRUE} (default in an interactive session) opens the
#'   application in the web browser.
#' @param ... further arguments to \code{shiny::runApp()}, such as \code{port}.
#' @return \code{vlm_app()} is called for its side effect and returns the value of \code{shiny::runApp()} when the
#'   application is closed; \code{vlm_app_object()} returns the application object (for \code{shiny::runApp()},
#'   \code{shiny::testServer()} or deployment on a server).
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{vlm_fit}}, \code{\link{vlm_lsmeans}}, \code{\link{vlm_ems}}
#' @family VetResearchLMM utilities
#' @examples
#' if (interactive()) {
#'   vlm_app(
#'       launch.browser = TRUE
#'     )
#' }
#' @export
vlm_app <- function(launch.browser = interactive(), ...) {
  .vlm_app_need()
  shiny::runApp(vlm_app_object(), launch.browser = launch.browser, ...)
}

#' @rdname vlm_app
#' @export
vlm_app_object <- function() {
  .vlm_app_need()
  shiny::shinyApp(ui = .vlm_app_ui(), server = .vlm_app_server)
}

.vlm_app_need <- function() {
  miss <- c("shiny", "bslib", "DT")[!vapply(c("shiny", "bslib", "DT"), requireNamespace, NA, quietly = TRUE)]
  if (length(miss)) .vlm_stop("vlm_app", "the application needs the package(s) ", paste(miss, collapse = ", "),
                              ": install.packages(c(", paste0("\"", miss, "\"", collapse = ", "), ")).")
}

# look: theme, fonts, styles, Copy buttons
#-------------------------------------------------------------------------------------------------------------------
.vlm_app_font <- function(family, kind = c("sans", "mono")) {
  fb <- switch(match.arg(kind),
               sans = c("system-ui", "-apple-system", "Segoe UI", "Helvetica Neue", "Arial", "sans-serif"),
               mono = c("SFMono-Regular", "Menlo", "Consolas", "Liberation Mono", "DejaVu Sans Mono", "monospace"))
  do.call(bslib::font_collection, c(list(bslib::font_google(family, local = FALSE)), as.list(fb)))
}

.vlm_app_theme <- function() {
  bslib::bs_theme(version = 5, bootswatch = "flatly", primary = "#1f4e9e",
                  base_font = .vlm_app_font("IBM Plex Sans", "sans"),
                  heading_font = .vlm_app_font("IBM Plex Sans", "sans"),
                  code_font = .vlm_app_font("IBM Plex Mono", "mono"))
}

.vlm_app_head <- function() {
  shiny::tags$head(
      shiny::tags$style(shiny::HTML(paste(
          "pre.shiny-text-output{font-family:var(--bs-font-monospace);font-size:.85em;line-height:1.5;white-space:pre;"
        , "  overflow-x:auto;background:#f6f8fa;border:1px solid #dde3ea;border-radius:6px;padding:10px 12px;}"
        , "table.dataTable thead th{background:#1f4e9e;color:#fff;font-weight:600;}"
        , ".vlm-bar{display:flex;gap:.4rem;justify-content:flex-end;margin-bottom:.4rem}"
        , ".dataTables_wrapper .dt-buttons{float:left;margin:0 1rem .5rem 0}"
        , ".dataTables_wrapper .dataTables_length{float:left;margin-bottom:.5rem}"
        , ".dataTables_wrapper .dataTables_filter{float:right;margin-bottom:.5rem}"
        , ".dataTables_wrapper .dataTables_length label,.dataTables_wrapper .dataTables_filter label{display:inline-flex;"
        , "  align-items:center;gap:.4rem;font-weight:400;margin:0}"
        , ".dataTables_wrapper select,.dataTables_wrapper input[type=search]{display:inline-block;width:auto}"
        , ".dataTables_wrapper .dataTables_info{float:left;padding-top:.6rem;font-size:.9em}"
        , ".dataTables_wrapper .dataTables_paginate{float:right;padding-top:.4rem}"
        , ".dataTables_wrapper table.dataTable{clear:both}"
        , ".dataTables_wrapper::after{content:'';display:table;clear:both}"
        , ".vlm-plot img{max-width:100%;height:auto}")))
    , shiny::tags$script(shiny::HTML(paste(
          "$(document).on('click', '.vlm-copy', function() {"
        , "  var el = document.getElementById($(this).data('target')); if (!el) return;"
        , "  var txt = el.innerText || el.textContent, b = $(this);"
        , "  var done = function() { b.find('.vlm-copy-label').text('Copied'); setTimeout(function() { b.find('.vlm-copy-label').text('Copy'); }, 1500); };"
        , "  if (navigator.clipboard && window.isSecureContext) { navigator.clipboard.writeText(txt).then(done); return; }"
        , "  var ta = document.createElement('textarea'); ta.value = txt; document.body.appendChild(ta); ta.select();"
        , "  document.execCommand('copy'); document.body.removeChild(ta); done();"
        , "});", sep = "\n")))
    )
}

.vlm_copy_bar <- function(target) {
  shiny::div(class = "vlm-bar",
             shiny::tags$button(type = "button", class = "btn btn-outline-secondary btn-sm vlm-copy",
                                `data-target` = target, shiny::icon("copy"),
                                shiny::span(class = "vlm-copy-label", "Copy")))
}

.vlm_btn <- "btn btn-sm btn-outline-secondary me-1"

# a table for the application: Copy, CSV and Excel buttons, all rows on request, numbers rounded
.vlm_dt <- function(d, title = "table") {
  d <- as.data.frame(d, check.names = FALSE)
  num <- which(vapply(d, is.numeric, NA))
  t <- DT::datatable(d, rownames = FALSE, extensions = "Buttons", style = "auto",
                     class = "compact stripe hover cell-border",
                     options = list(pageLength = 15L, scrollX = TRUE, dom = "Blfrtip",
                                    lengthMenu = list(c(15L, 50L, -1L), c("15", "50", "All")),
                                    buttons = list(list(extend = "copy", title = NULL, className = .vlm_btn),
                                                   list(extend = "csv", title = title, className = .vlm_btn),
                                                   list(extend = "excel", title = title, className = .vlm_btn))))
  pcol  <- num[grepl("^p_|^prob|p_value|^Probability", names(d)[num])]
  whole <- setdiff(num[vapply(d[num], function(v) all(is.na(v) | v == round(v)), NA)], pcol)
  dec   <- setdiff(num, c(whole, pcol))
  if (length(pcol)) t <- DT::formatRound(t, pcol, digits = 3L)
  if (length(dec)) t <- DT::formatSignif(t, dec, digits = 5L)
  if (length(whole)) t <- DT::formatRound(t, whole, digits = 0L)
  t
}

# a ggplot as an image for renderImage(): WebP through magick when installed, PNG otherwise
.vlm_plot_file <- function(p, width = 900, height = 600, res = 110) {
  png <- tempfile(fileext = ".png")
  if (requireNamespace("ragg", quietly = TRUE)) ragg::agg_png(png, width = width, height = height, res = res) else
    grDevices::png(png, width = width, height = height, res = res)
  print(p)
  grDevices::dev.off()
  if (.vlm_webp_ok()) {
    webp <- sub("\\.png$", ".webp", png)
    ok <- tryCatch({
      magick::image_write(magick::image_read(png), webp, format = "webp", quality = 100,
                          defines = c(`webp:lossless` = "true"))
      TRUE
    }, error = function(e) FALSE)
    if (ok) return(list(src = webp, contentType = "image/webp", width = "100%", alt = "plot"))
  }
  list(src = png, contentType = "image/png", width = "100%", alt = "plot")
}

# a card with tabs: Interpretation, Output, Table, Plot (each with a Copy button where it is text)
.vlm_result_tabs <- function(id, plot = TRUE, table = TRUE, code = FALSE, extra = NULL, tables = NULL) {
  ns <- shiny::NS(id)
  tabs <- list(
      bslib::nav_panel("Interpretation", .vlm_copy_bar(ns("int_text")), shiny::uiOutput(ns("int")),
                       shiny::tags$pre(id = ns("int_text"), class = "shiny-text-output", style = "display:none"))
    , if (plot) bslib::nav_panel("Plot", extra, shiny::div(class = "vlm-plot", shiny::imageOutput(ns("plot"), height = "auto")),
                                 shiny::div(shiny::downloadButton(ns("png"), "PNG", class = "btn-sm"),
                                            shiny::downloadButton(ns("pdf"), "PDF", class = "btn-sm"),
                                            shiny::downloadButton(ns("webp"), "WebP", class = "btn-sm")))
    , if (table) bslib::nav_panel("Table", if (length(tables) > 1L) shiny::radioButtons(ns("tab_pick"), NULL, tables,
                                                                                         inline = TRUE),
                                 DT::DTOutput(ns("table")))
    , bslib::nav_panel("Output", .vlm_copy_bar(ns("out")), shiny::verbatimTextOutput(ns("out")))
    , if (code) bslib::nav_panel("R code", .vlm_copy_bar(ns("code")), shiny::verbatimTextOutput(ns("code")))
    )
  do.call(bslib::navset_card_tab, c(list(id = ns("tabs")), Filter(Negate(is.null), tabs)))
}

.vlm_int_html <- function(it) {
  li <- function(s) if (length(s)) shiny::tags$ul(lapply(s, shiny::tags$li)) else NULL
  shiny::tagList(
      shiny::div(class = "alert alert-primary", shiny::strong(it$headline))
    , if (length(it$findings)) shiny::tagList(shiny::h6("Findings"), li(it$findings))
    , if (length(it$recommendations)) shiny::tagList(shiny::h6("Recommendations"), li(it$recommendations))
    , if (length(it$cautions)) shiny::tagList(shiny::h6("Cautions"), li(it$cautions))
    , shiny::tags$details(shiny::tags$summary("How this is read"), shiny::p(it$guide))
    )
}

# the first table component of a result
.vlm_app_first_table <- function(x) names(x)[vapply(x, function(v) is.data.frame(v) || is.matrix(v), NA)][1L]

# the server side of a result card: res() a qrs_result, table_fun(res) a data frame, plot_fun(res) a ggplot
.vlm_result_server <- function(id, res, table_fun = NULL, plot_fun = NULL, code_fun = NULL, hb = shiny::reactive(TRUE)) {
  force(res)
  force(table_fun)
  force(plot_fun)
  force(code_fun)
  shiny::moduleServer(id, function(input, output, session) {
    it <- shiny::reactive({
      shiny::req(res())
      vlm_interpret(res())
    })
    output$int <- shiny::renderUI(.vlm_int_html(it()))
    output$int_text <- shiny::renderText(paste(format(it(), style = "text", width = 100L), collapse = "\n"))
    output$out <- shiny::renderPrint({
      shiny::req(res())
      op <- options(width = 120L)
      on.exit(options(op))
      print(res())
    })
    if (!is.null(table_fun)) output$table <- DT::renderDT({
      shiny::req(res())
      w <- if (is.null(input$tab_pick)) NULL else input$tab_pick
      if (is.null(w)) w <- .vlm_app_first_table(res())
      .vlm_dt(table_fun(res(), w), id)
    })
    if (!is.null(plot_fun)) {
      pl <- shiny::reactive({
        shiny::req(res())
        plot_fun(res(), input)
      })
      output$plot <- shiny::renderImage(.vlm_plot_file(pl()), deleteFile = TRUE)
      output$png <- shiny::downloadHandler(paste0(id, ".png"), function(file)
        ggplot2::ggsave(file, pl(), width = 10, height = 7, dpi = 200))
      output$pdf <- shiny::downloadHandler(paste0(id, ".pdf"), function(file)
        ggplot2::ggsave(file, pl(), width = 10, height = 7))
      output$webp <- shiny::downloadHandler(paste0(id, ".webp"), function(file) vlm_save(pl(), file, width = 10, height = 7))
    }
    if (!is.null(code_fun)) output$code <- shiny::renderText(code_fun())
  })
}


#-------------------------------------------------------------------------------------------------------------------
# the examples of the book, ready to load on the Model page
#-------------------------------------------------------------------------------------------------------------------
.vlm_app_examples <- function() {
  e <- function(label, data, fixed, random = "", rc_eff = "", rc_sub = "", rc_type = "vc", rep_type = "none",
                rep_sub = "", rep_ord = "", method = "REML", ddfm = "default", class = "", lsm = "") {
    list(label = label, data = data, fixed = fixed, random = random, rc_eff = rc_eff, rc_sub = rc_sub,
         rc_type = rc_type, rep_type = rep_type, rep_sub = rep_sub, rep_ord = rep_ord, method = method, ddfm = ddfm,
         class = class, lsm = lsm)
  }
  list(
      e("Example 1.2.2 / 2.3.2: randomised blocks, herd random (ex122)", "ex122", "PCVdif ~ dose", "~ herd", lsm = "dose")
    , e("Example 1.2.3 / 2.3.2: herds within drug (ex123)", "ex123", "PCVdif ~ drug", "~ drug:herd", lsm = "drug")
    , e("Example 1.2.4 / 1.3.2: two sizes of experimental units (ex124)", "ex124", "PCVdif ~ drug + dose + drug:dose",
        "~ drug:herd", class = "herd", lsm = "drug:dose")
    , e("Example 1.2.6 / 2.3.2: ELISA, random animals and times (ex126)", "ex126", "OD ~ 1", "~ anim_id + time",
        class = "time")
    , e("Example 2.2.1.7: one-way analysis of variance (ex121)", "ex121", "PCVdiff ~ dose", lsm = "dose")
    , e("Example 2.4.2.2: split plot, REML (ex125)", "ex125", "Pcv ~ Drug + dose + Drug:dose", "~ Region + Region:Drug",
        lsm = "Drug:dose")
    , e("Example 2.4.2.2: split plot, ML (ex125)", "ex125", "Pcv ~ Drug + dose + Drug:dose", "~ Region + Region:Drug",
        method = "ML")
    , e("Example 2.4.3.1: sires, BLUP (ex127)", "ex127", "Ww ~ 1", "~ sire")
    , e("Examples 2.5 and 2.6: split plot, Satterthwaite (ex125)", "ex125", "Pcv ~ Drug + dose + Drug:dose",
        "~ Region + Region:Drug", ddfm = "satterth", lsm = "Drug:dose")
    , e("Example 3.1, Model 1: doses within drug (ex31)", "ex31", "PCV2 ~ drug + drug:dose", "~ drug:herd",
        ddfm = "satterth", class = "herd, dose", lsm = "drug:dose")
    , e("Example 3.1, Model 2: common slope on PCV1 (ex31)", "ex31", "PCV2 ~ PCV1 + drug + drug:dose", "~ drug:herd",
        ddfm = "satterth", class = "herd, dose", lsm = "drug:dose")
    , e("Example 3.1, Model 3: a slope per treatment (ex31)", "ex31", "PCV2 ~ drug + drug:dose + PCV1:drug:dose",
        "~ drug:herd", ddfm = "satterth", class = "herd, dose", lsm = "drug:dose")
    , e("Example 3.2: sires within breed (ex32)", "ex32", "Ww ~ sex + agew + breed", "~ breed:sire_id",
        ddfm = "satterth", class = "breed", lsm = "breed")
    , e("Example 3.3, Model 1: random animal (ex33)", "ex33", "PCV ~ breed + breed:time", "~ animal_id:breed")
    , e("Example 3.3, Model 1: compound symmetry (ex33)", "ex33", "PCV ~ breed + breed:time", rep_type = "cs",
        rep_sub = "~ animal_id:breed")
    , e("Example 3.3, Model 2: first-order autoregressive (ex33)", "ex33", "PCV ~ breed + breed:time", rep_type = "ar1",
        rep_sub = "~ animal_id:breed", rep_ord = "~ time")
    , e("Example 3.3, Model 3: random intercepts and slopes (ex33)", "ex33", "PCV ~ breed + breed:time",
        rc_eff = "~ 1 + time", rc_sub = "~ animal_id:breed", rc_type = "un")
    )
}

.vlm_app_datasets <- c("ex121", "ex122", "ex123", "ex124", "ex125", "ex126", "ex127", "ex31", "ex32", "ex33")

#-------------------------------------------------------------------------------------------------------------------
# pages
#-------------------------------------------------------------------------------------------------------------------
.vlm_app_ui <- function() {
  side <- function(...) bslib::sidebar(width = 340, ...)
  txt <- function(id, label, value = "", ...) shiny::textInput(id, label, value, ...)
  ex <- .vlm_app_examples()
  exl <- stats::setNames(seq_along(ex), vapply(ex, `[[`, "", "label"))
  bslib::page_navbar(
      title = "VetResearchLMM", id = "nav", theme = .vlm_app_theme(), fillable = FALSE, header = .vlm_app_head()
    , bslib::nav_panel("Home", .vlm_app_home())
    , bslib::nav_panel("Data", bslib::layout_sidebar(
          sidebar = side(
              shiny::radioButtons("dat_src", "Data", c(`A data set of the book` = "book", `CSV file` = "csv"))
            , shiny::conditionalPanel("input.dat_src == 'book'",
                shiny::selectInput("dat_book", "Data set", .vlm_app_datasets, selected = "ex125"))
            , shiny::conditionalPanel("input.dat_src == 'csv'", shiny::fileInput("dat_file", "CSV file", accept = ".csv")))
        , bslib::card(bslib::card_header("Data"), shiny::verbatimTextOutput("dat_str"), DT::DTOutput("dat_table"))))
    , bslib::nav_panel("Model", bslib::layout_sidebar(
          sidebar = side(
              shiny::selectInput("ex_pick", "Load an example of the book", c(`(choose)` = "", exl), selectize = FALSE)
            , txt("m_fixed", "Fixed effects (response ~ effects)", "Pcv ~ Drug + dose + Drug:dose")
            , txt("m_random", "Random variance components (~ terms; blank: none)", "~ Region + Region:Drug")
            , shiny::tags$details(shiny::tags$summary("Random coefficients per subject"),
                txt("m_rc_eff", "Effects (for example ~ 1 + time; blank: none)", ""),
                txt("m_rc_sub", "Subject (for example ~ animal_id:breed)", ""),
                shiny::selectInput("m_rc_type", "Covariance", c(`variance components (VC)` = "vc", `unstructured (UN)` = "un")))
            , shiny::tags$details(shiny::tags$summary("Residual covariance within a subject"),
                shiny::selectInput("m_rep_type", "Structure", c(`independent` = "none", `compound symmetry (CS)` = "cs",
                                                                `first-order autoregressive (AR(1))` = "ar1",
                                                                `spatial power (SP(POW))` = "sp_pow",
                                                                `unstructured (UN)` = "un")),
                txt("m_rep_sub", "Subject", ""), txt("m_rep_ord", "Order or time (for example ~ time)", ""))
            , shiny::selectInput("m_method", "Estimation", c("REML", "ML", "Type3"))
            , shiny::selectInput("m_ddfm", "Denominator df", c(`as SAS (default)` = "default", `containment` = "contain",
                                                               `residual` = "residual", `between-within` = "betwithin",
                                                               `Satterthwaite` = "satterth", `Kenward-Roger` = "kr"))
            , shiny::radioButtons("m_type", "Tests", c(`Type 3` = 3, `Type 1 (sequential)` = 1), inline = TRUE)
            , txt("m_class", "Numeric variables to treat as factors (comma separated)", "")
            , shiny::actionButton("m_run", "Fit", class = "btn-primary w-100", icon = shiny::icon("play")))
        , .vlm_result_tabs("fit", code = TRUE, extra = shiny::radioButtons("fit_plot", NULL, inline = TRUE,
              c(`Residuals` = "residuals", `Normal quantiles` = "qq", `Observed and fitted` = "observed")),
              tables = c(`Covariance parameters` = "covariance", `Fixed effects` = "fixed", `Tests` = "tests",
                         `Fit statistics` = "fit"))))
    , bslib::nav_panel("Means", bslib::layout_sidebar(
          sidebar = side(
              txt("lsm_specs", "Effect (for example Drug:dose)", "Drug:dose")
            , txt("lsm_at", "Covariate values (for example PCV1 = 18; blank: means)", "")
            , shiny::checkboxInput("lsm_diff", "Pairwise differences", TRUE)
            , shiny::selectInput("lsm_adjust", "Adjustment", c("tukey", "bonferroni", "sidak", "none"))
            , shiny::actionButton("lsm_run", "Compute", class = "btn-primary w-100"))
        , .vlm_result_tabs("lsm", tables = c(`Means` = "lsmeans", `Differences` = "diffs"))))
    , bslib::nav_panel("Estimates", bslib::layout_sidebar(
          sidebar = side(
              shiny::textAreaInput("est_L", "Estimates (label: effect coefficients ...), one per line",
                                   paste("drug dif: Drug -1 1 Drug:dose -0.5 -0.5 0.5 0.5",
                                         "Samorin mean: intercept 1 Drug 0 1 dose 0.5 0.5 Drug:dose 0 0 0.5 0.5",
                                         sep = "\n"), rows = 6)
            , shiny::textAreaInput("ct_L", "Contrasts (rows separated by commas), one per line",
                                   "all: Drug 1 -1 Drug:dose 0.5 0.5 -0.5 -0.5, dose 1 -1 Drug:dose 0.5 -0.5 0.5 -0.5, Drug:dose 0.5 -0.5 -0.5 0.5",
                                   rows = 4)
            , shiny::actionButton("est_run", "Compute", class = "btn-primary w-100"))
        , .vlm_result_tabs("est", tables = c(`Estimates` = "estimates")), .vlm_result_tabs("ct", plot = FALSE)))
    , bslib::nav_panel("Random effects", bslib::layout_sidebar(
          sidebar = side(shiny::actionButton("blup_run", "Predict", class = "btn-primary w-100"))
        , .vlm_result_tabs("blup")))
    , bslib::nav_panel("Expected mean squares", bslib::layout_sidebar(
          sidebar = side(
              txt("ems_fixed", "Every effect (response ~ effects)", "PCVdif ~ drug + drug:herd + dose + dose:drug")
            , txt("ems_random", "Random effects among them (~ terms)", "~ drug:herd")
            , txt("ems_class", "Numeric variables to treat as factors", "herd")
            , shiny::radioButtons("ems_type", "Sums of squares", c(`Type 3` = 3, `Type 1` = 1), inline = TRUE)
            , shiny::actionButton("ems_run", "Compute", class = "btn-primary w-100"))
        , .vlm_result_tabs("ems", plot = FALSE, tables = c(`Analysis of variance` = "anova",
                                                           `Coefficients` = "coefficients"))))
    , bslib::nav_panel("Compare", bslib::layout_sidebar(
          sidebar = side(
              shiny::helpText("Refits the fixed effects of the Model page with each structure for a subject.")
            , txt("cmp_sub", "Subject", "~ animal_id:breed")
            , txt("cmp_ord", "Order or time", "~ time")
            , shiny::checkboxGroupInput("cmp_set", "Structures", selected = c("ind", "cs", "ar1", "rc"),
                c(`independent` = "ind", `compound symmetry` = "cs", `AR(1)` = "ar1", `random intercept and slope (UN)` = "rc"))
            , shiny::actionButton("cmp_run", "Compare", class = "btn-primary w-100"))
        , .vlm_result_tabs("cmp")))
    , bslib::nav_panel("References", bslib::card(bslib::card_header("Sources of the methods"), .vlm_copy_bar("refs"),
                                                 shiny::verbatimTextOutput("refs")))
    )
}

.vlm_app_home <- function() {
  card <- function(title, text) bslib::card(bslib::card_header(title), shiny::p(text))
  shiny::tagList(
      shiny::h4("Linear mixed models with applications in veterinary research")
    , shiny::p(paste("The analyses of Duchateau, Janssen and Rowlands (1998), with an engine that gives the results",
                     "of SAS PROC MIXED: choose data, fit a model with random effects and a covariance structure, and",
                     "read the results in plain language. Every example of the book loads with one click on the Model",
                     "page."))
    , bslib::layout_column_wrap(width = 1 / 2,
          card("Data", "The ten data sets of the book, or your own CSV file.")
        , card("Model", "REML, ML or Type 3 estimation; random effects, random coefficients and residual structures; Type 3 tests with containment, Satterthwaite or Kenward-Roger degrees of freedom.")
        , card("Means", "Least-squares means with confidence limits and Tukey, Bonferroni or Sidak comparisons.")
        , card("Estimates", "ESTIMATE and CONTRAST statements typed as in SAS.")
        , card("Random effects", "Best linear unbiased predictions with their standard errors.")
        , card("Expected mean squares", "The analysis of variance with expected mean squares and synthesised F tests.")
        , card("Compare", "Covariance structures compared by information criteria and likelihood ratio tests.")
        , card("References", "The sources of the methods."))
    )
}

# SAS-like coefficient lines: "label: effect c c effect c c", rows of a contrast separated by commas
.vlm_app_parse_L <- function(text) {
  lines <- trimws(strsplit(text, "\n", fixed = TRUE)[[1L]])
  lines <- lines[nzchar(lines)]
  out <- list()
  for (ln in lines) {
    if (!grepl(":", ln, fixed = TRUE)) stop("each line must start with a label and a colon: ", ln, call. = FALSE)
    lab <- trimws(sub(":.*$", "", ln))
    body <- trimws(sub("^[^:]*:", "", ln))
    rows <- lapply(strsplit(body, ",", fixed = TRUE)[[1L]], function(r) {
      tok <- strsplit(trimws(r), "\\s+")[[1L]]
      res <- list()
      cur <- NULL
      for (t in tok) {
        v <- suppressWarnings(as.numeric(t))
        if (is.na(v)) { cur <- t; res[[cur]] <- numeric() } else {
          if (is.null(cur)) stop("a coefficient without an effect in: ", r, call. = FALSE)
          res[[cur]] <- c(res[[cur]], v)
        }
      }
      res
    })
    out[[lab]] <- if (length(rows) == 1L) rows[[1L]] else rows
  }
  out
}

.vlm_app_formula <- function(s) {
  s <- trimws(s)
  if (!nzchar(s)) return(NULL)
  stats::as.formula(s, env = globalenv())
}

.vlm_app_server <- function(input, output, session) {
  run <- function(expr) {
    r <- tryCatch(shiny::withProgress(message = "Computing", value = 0.5, expr), error = function(e) e)
    if (inherits(r, "error")) {
      shiny::showNotification(conditionMessage(r), type = "error", duration = 10)
      return(NULL)
    }
    r
  }
  book <- function(nm) {
    e <- new.env()
    utils::data(list = nm, package = "VetResearchLMM", envir = e)
    get(nm, envir = e)
  }
  dat <- shiny::reactive({
    if (identical(input$dat_src, "csv")) {
      shiny::req(input$dat_file)
      data.table::fread(input$dat_file$datapath, data.table = FALSE)
    } else book(input$dat_book)
  })
  output$dat_str <- shiny::renderPrint(utils::str(dat()))
  output$dat_table <- DT::renderDT(.vlm_dt(dat(), "data"))
  shiny::observeEvent(input$ex_pick, {
    if (!nzchar(input$ex_pick)) return()
    e <- .vlm_app_examples()[[as.integer(input$ex_pick)]]
    shiny::updateRadioButtons(session, "dat_src", selected = "book")
    shiny::updateSelectInput(session, "dat_book", selected = e$data)
    for (id in c("fixed", "random", "rc_eff", "rc_sub", "rep_sub", "rep_ord", "class")) {
      shiny::updateTextInput(session, paste0("m_", id), value = e[[id]])
    }
    shiny::updateSelectInput(session, "m_rc_type", selected = e$rc_type)
    shiny::updateSelectInput(session, "m_rep_type", selected = e$rep_type)
    shiny::updateSelectInput(session, "m_method", selected = e$method)
    shiny::updateSelectInput(session, "m_ddfm", selected = e$ddfm)
    if (nzchar(e$lsm)) shiny::updateTextInput(session, "lsm_specs", value = e$lsm)
  })
  spec <- function() {
    cls <- trimws(strsplit(input$m_class, ",", fixed = TRUE)[[1L]])
    rnd <- list()
    rf <- .vlm_app_formula(input$m_random)
    if (!is.null(rf)) rnd[[length(rnd) + 1L]] <- rf
    if (nzchar(trimws(input$m_rc_eff))) {
      rnd[[length(rnd) + 1L]] <- vlm_random(effects = .vlm_app_formula(input$m_rc_eff),
                                            subject = .vlm_app_formula(input$m_rc_sub), type = input$m_rc_type)
    }
    rep <- if (input$m_rep_type == "none") NULL else
      vlm_repeated(type = input$m_rep_type, subject = .vlm_app_formula(input$m_rep_sub),
                   order = .vlm_app_formula(input$m_rep_ord))
    list(fixed = .vlm_app_formula(input$m_fixed), random = if (!length(rnd)) NULL else if (length(rnd) == 1L) rnd[[1L]]
         else rnd, repeated = rep, class = if (length(cls) && any(nzchar(cls))) cls[nzchar(cls)] else NULL)
  }
  fit <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$m_run, {
    s <- spec()
    fit(run(vlm_fit(fixed = s$fixed, data = dat(), random = s$random, repeated = s$repeated, method = input$m_method,
                    ddfm = input$m_ddfm, type = as.integer(input$m_type), class = s$class)))
  })
  need_fit <- function() {
    f <- fit()
    if (is.null(f)) shiny::showNotification("Fit a model on the Model page first.", type = "warning")
    f
  }
  .vlm_result_server("fit", fit, function(x, w) x[[w]], function(x, i) plot(x, which = input$fit_plot),
                     shiny::reactive(.vlm_app_code(input)))
  lsm <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$lsm_run, {
    f <- need_fit()
    if (is.null(f)) return()
    at <- NULL
    if (nzchar(trimws(input$lsm_at))) {
      parts <- strsplit(strsplit(input$lsm_at, ",", fixed = TRUE)[[1L]], "=", fixed = TRUE)
      at <- stats::setNames(lapply(parts, function(p) as.numeric(trimws(p[2L]))),
                            vapply(parts, function(p) trimws(p[1L]), ""))
    }
    lsm(run(vlm_lsmeans(fit = f, specs = input$lsm_specs, at = at, diff = input$lsm_diff, adjust = input$lsm_adjust)))
  })
  .vlm_result_server("lsm", lsm, function(x, w) x[[w]], function(x, i) plot(x))
  est <- shiny::reactiveVal(NULL)
  ct <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$est_run, {
    f <- need_fit()
    if (is.null(f)) return()
    if (nzchar(trimws(input$est_L))) est(run(vlm_estimate(fit = f, L = .vlm_app_parse_L(input$est_L))))
    if (nzchar(trimws(input$ct_L))) ct(run(vlm_contrast(fit = f, L = .vlm_app_parse_L(input$ct_L))))
  })
  .vlm_result_server("est", est, function(x, w) x[[w]], function(x, i) plot(x))
  .vlm_result_server("ct", ct, function(x, w) x$contrasts)
  blup <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$blup_run, {
    f <- need_fit()
    if (is.null(f)) return()
    blup(run(vlm_blup(fit = f)))
  })
  .vlm_result_server("blup", blup, function(x, w) x$blup, function(x, i) plot(x))
  ems <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$ems_run, {
    cls <- trimws(strsplit(input$ems_class, ",", fixed = TRUE)[[1L]])
    ems(run(vlm_ems(fixed = .vlm_app_formula(input$ems_fixed), data = dat(),
                    random = .vlm_app_formula(input$ems_random), type = as.integer(input$ems_type),
                    class = if (any(nzchar(cls))) cls[nzchar(cls)] else NULL)))
  })
  .vlm_result_server("ems", ems, function(x, w) if (w == "coefficients") cbind(source = rownames(x[[w]]),
                                                                             as.data.frame(x[[w]])) else x[[w]])
  cmp <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$cmp_run, {
    s <- spec()
    sub <- .vlm_app_formula(input$cmp_sub)
    ord <- .vlm_app_formula(input$cmp_ord)
    f1 <- function(random = NULL, repeated = NULL) vlm_fit(fixed = s$fixed, data = dat(), random = random,
                                                           repeated = repeated, class = s$class)
    cmp(run({
      fits <- list()
      if ("ind" %in% input$cmp_set) fits$independent <- f1()
      if ("cs" %in% input$cmp_set) fits$CS <- f1(repeated = vlm_repeated("cs", sub))
      if ("ar1" %in% input$cmp_set) fits$AR1 <- f1(repeated = vlm_repeated("ar1", sub, ord))
      if ("rc" %in% input$cmp_set) {
        tv <- all.vars(ord)[1L]
        fits$RC <- f1(random = vlm_random(stats::as.formula(paste("~ 1 +", tv)), sub, "un"))
      }
      do.call(vlm_compare, fits)
    }))
  })
  .vlm_result_server("cmp", cmp, function(x, w) x$models, function(x, i) plot(x))
  output$refs <- shiny::renderPrint({
    op <- options(width = 110L)
    on.exit(options(op))
    print(vlm_cite())
  })
}

# the R code of the Model page, every argument on its own line
.vlm_app_code <- function(input) {
  q <- function(s) if (nzchar(trimws(s))) trimws(s) else "NULL"
  rnd <- c(if (nzchar(trimws(input$m_random))) trimws(input$m_random),
           if (nzchar(trimws(input$m_rc_eff))) sprintf("vlm_random(effects = %s, subject = %s, type = \"%s\")",
                                                     trimws(input$m_rc_eff), q(input$m_rc_sub), input$m_rc_type))
  rnd <- if (!length(rnd)) "NULL" else if (length(rnd) == 1L) rnd else paste0("list(", paste(rnd, collapse = ", "), ")")
  rep <- if (input$m_rep_type == "none") "NULL" else sprintf("vlm_repeated(type = \"%s\", subject = %s, order = %s)",
                                                             input$m_rep_type, q(input$m_rep_sub), q(input$m_rep_ord))
  cls <- trimws(strsplit(input$m_class, ",", fixed = TRUE)[[1L]])
  cls <- cls[nzchar(cls)]
  dname <- if (identical(input$dat_src, "csv")) "your_data" else input$dat_book
  vals <- c(fixed = trimws(input$m_fixed), data = dname, random = rnd, repeated = rep,
            method = sprintf("\"%s\"", input$m_method), ddfm = sprintf("\"%s\"", input$m_ddfm), type = input$m_type,
            class = if (length(cls)) paste0("c(", paste0("\"", cls, "\"", collapse = ", "), ")") else "NULL")
  w <- max(nchar(names(vals)))
  body <- paste0("    ", c(" ", rep(",", length(vals) - 1L)), " ", formatC(names(vals), width = -w), " = ", vals,
                 collapse = "\n")
  paste0("library(VetResearchLMM)\nfm <-\n  vlm_fit(\n", body, "\n    )\nfm\nplot(x = fm)\nvlm_interpret(\n    x = fm\n  )\n")
}
