# Crop GWAS & GS Explorer -- Sampath Perumal
# Deploy: rsconnect::deployApp("shiny-app/")
# Expects gwas_results.rds (trait, marker, chr, pos, cum_pos, pvalue)
# and gs_results.rds (trait, model, observed, predicted). Demo data are
# simulated on first launch so the app runs out of the box.

library(shiny); library(bslib); library(plotly); library(DT); library(dplyr)

if (!file.exists("gwas_results.rds")) {
  set.seed(1)
  demo <- expand.grid(trait = c("Yield","Oil","Protein"), chr = 1:10) |>
    rowwise() |> do({
      n <- 400
      data.frame(trait = .$trait, chr = .$chr, pos = sort(runif(n, 0, 80e6)),
                 marker = paste0("S", .$chr, "_", 1:n),
                 pvalue = runif(n)^ifelse(.$chr == 3 & .$trait == "Yield", 6, 1))
    }) |> ungroup() |> group_by(trait) |> arrange(chr, pos) |>
    mutate(cum_pos = row_number()) |> ungroup()
  saveRDS(demo, "gwas_results.rds")
}
if (!file.exists("gs_results.rds")) {
  set.seed(2)
  gs <- expand.grid(trait = c("Yield","Oil","Protein"),
                    model = c("Ridge","BayesB","RandomForest")) |>
    rowwise() |> do({
      o <- rnorm(150); data.frame(trait = .$trait, model = .$model,
        observed = o, predicted = .6 * o + rnorm(150, 0, .8))
    }) |> ungroup()
  saveRDS(gs, "gs_results.rds")
}

gwas <- readRDS("gwas_results.rds"); gs <- readRDS("gs_results.rds")

ui <- page_navbar(
  title = "Crop GWAS & GS Explorer",
  theme = bs_theme(primary = "#159957"),
  nav_panel("GWAS",
    layout_sidebar(
      sidebar = sidebar(
        selectInput("trait", "Trait", unique(gwas$trait)),
        sliderInput("thr", "-log10(p) threshold", 2, 10, 5, step = .5)),
      card(card_header("Manhattan plot"), plotlyOutput("man", height = 380)),
      card(card_header("Markers above threshold"), DTOutput("tbl"))
    )),
  nav_panel("Genomic selection",
    layout_sidebar(
      sidebar = sidebar(
        selectInput("trait2", "Trait", unique(gs$trait)),
        selectInput("model", "Model", unique(gs$model))),
      card(card_header("Observed vs predicted"), plotlyOutput("obs", height = 420)),
      card(uiOutput("acc"))
    )),
  nav_panel("About",
    card(HTML("<p>Companion app to the <a href='https://sampathperumal.github.io/genomic-biostats-course/'>
      Genomic Biostatistics course</a>. Author: <b>Sampath Perumal</b>, NRC Saskatoon.</p>")))
)

server <- function(input, output, session) {
  gw <- reactive(filter(gwas, trait == input$trait))
  output$man <- renderPlotly({
    d <- gw()
    plot_ly(d, x = ~cum_pos, y = ~-log10(pvalue),
            color = ~factor(chr %% 2), colors = c("#159957", "#1e6bb8"),
            type = "scattergl", mode = "markers",
            text = ~paste0(marker, "<br>chr", chr), hoverinfo = "text+y") |>
      layout(showlegend = FALSE, xaxis = list(title = "Genome position (index)"),
             yaxis = list(title = "-log10(p)"),
             shapes = list(list(type = "line", x0 = 0, x1 = max(d$cum_pos),
                                y0 = input$thr, y1 = input$thr,
                                line = list(dash = "dot", color = "red"))))
  })
  output$tbl <- renderDT(gw() |> filter(-log10(pvalue) > input$thr) |>
                           arrange(pvalue) |> mutate(pvalue = signif(pvalue, 3)),
                         options = list(pageLength = 8))
  gsr <- reactive(filter(gs, trait == input$trait2, model == input$model))
  output$obs <- renderPlotly(
    plot_ly(gsr(), x = ~observed, y = ~predicted, type = "scatter",
            mode = "markers", marker = list(color = "#159957")) |>
      layout(shapes = list(list(type = "line",
        x0 = min(gsr()$observed), x1 = max(gsr()$observed),
        y0 = min(gsr()$observed), y1 = max(gsr()$observed),
        line = list(dash = "dot")))))
  output$acc <- renderUI(h4(sprintf("Predictive ability (r) = %.2f",
                                    cor(gsr()$observed, gsr()$predicted))))
}

shinyApp(ui, server)
