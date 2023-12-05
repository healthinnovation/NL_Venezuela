# helpers for NL

## FUNCTION
library(scales)
library(tidyverse)

dual_plot <- function(data, x, y_left, y2_left = NULL, y_right, group=NULL, col_left, col_right,
                       name_legend = " ", labels_legend = c("a","b")) {
  # original: https://stackoverflow.com/questions/56426472/dual-axis-plot-with-automatically-calculated-sec-axis-formula-in-ggplot2
  x <- ensym(x)
  y_left <- ensym(y_left)
  y_right <- ensym(y_right)
  
  if (!is.null(y2_left)) {y2_left <- ensym(y2_left)} else {y2_left <- y2_left}
  if (!is.null(group)) {group <- ensym(group)} else {group <- group}
  
  # Introducing ranges
  left_range <- range(data %>% pull(!!y_left))
  right_range <- range(data %>% pull(!!y_right))
  
  if (!is.null(group) & !is.null(y2_left)) {data1 <- data %>% select(!!x, !!y_left, !!y_right, !!group, !!y2_left)}
  if (!is.null(group) & is.null(y2_left)) {data1 <- data %>% select(!!x, !!y_left, !!y_right, !!group)}
  if (is.null(group) & !is.null(y2_left)) {data1 <- data %>% select(!!x, !!y_left, !!y_right, !!y2_left)}
  if (is.null(group) & is.null(y2_left)) {data1 <- data %>% select(!!x, !!y_left, !!y_right)}
  
  # Transform
  data1 %>%
    mutate(!!y_right := scales::rescale(!!y_right, to=left_range)) %>%
    gather(k, v, -!!x, -!!group) %>%
    ggplot() +
    geom_line(aes(!!x, v, colour = k, linetype=k)) +
    # Change secondary axis scaling and label
    scale_y_continuous(sec.axis = sec_axis(~ scales::rescale(., to=right_range),
                                           name = rlang::as_string(y_right))) +
    {if(!is.null(y2_left)) {scale_color_manual(values = c(col_left,col_left,col_right))}
      else{scale_color_manual(values = c(col_left,col_right))}} +
    {if(!is.null(y2_left)) {scale_linetype_manual(breaks = c(y_left, y2_left), name = name_legend,
                                                  values = c("solid","dashed","dotted"), labels = labels_legend)}
      else{scale_linetype_manual(values = c("solid","dashed"))}} +
    {if(!is.null(y2_left)) {guides(color = F)}
      else{guides(color = F, linetype = F)}} +
    theme_few() +
    theme(axis.title.y = element_text(color = col_left, size=13),
          #axis.line.y = element_line(color = col_left),
          axis.text.y = element_text(color = col_left),
          axis.ticks.y = element_line(color = col_left),
          axis.title.y.right = element_text(color = col_right, size=13),
          #axis.line.y.right = element_line(color = priceColor),
          axis.text.y.right = element_text(color = col_right),
          axis.ticks.y.right = element_line(color = col_right),
          legend.position = "top"
    ) +
    facet_wrap(vars(!!group), scales = "free")
}

var_plot <- function(dat, group = NULL) {
  
  if (!is.null(group)) {group <- ensym(group)} else {group <- group}
  
  dat %>%
    # mutate(PV = PV + 1,
    #        PF = PF + 1,
    #        r.pv = PV/pop,
    #        r.pf = PF/pop) %>%
    mutate_at(.vars = c("r.pv", "r.pf", "viirs"), 
              ~100*((./last(.))-1)) %>%
    select(Year, viirs, r.pv, r.pf, !!group) %>%
    gather(var, val, viirs:r.pf) %>%
    mutate(var = case_when(var == "viirs" ~ "VIIRS",
                           var == "r.pv" ~ "malaria rate: vivax",
                           var == "r.pf" ~ "malaria rate: falciparum")) %>%
    ggplot(aes(x = Year, y = val, col = var,
               linetype = rev(var))) +
    geom_line() +
    scale_color_manual(values = c("#CD3700", "#8B4789", "#69b3a2")) +
    labs(y = "% variation", col = "") +
    theme_few() +
    theme(legend.position = "top") +
    guides(linetype = F)
  
}

bi_plot <- function(dat, trans_x = T, f_range = T,limits_y) {
  
  f3a.p <- dat %>%
    ggplot(aes(viirs, rate, col = type, fill = type)) +
    geom_point(alpha=.2) +
    labs(y= "Malaria rate (x. 1000 hab.)",
         x = "VIIRS (Average DNB radiance)") +
    {if(isTRUE(trans_x)) {
      scale_x_log10(
        breaks = scales::trans_breaks("log10", function(x) 10^x),
        labels = scales::trans_format("log10",
                                      scales::math_format(10^.x))
      )
      }}  +
    
    {if(isTRUE(trans_x)) {
        scale_y_log10(
          breaks = scales::trans_breaks("log10", function(x) 10^x),
          labels = scales::trans_format("log10",
                                        scales::math_format(10^.x))
        )
    }} +
    
    #geom_smooth(method = "lm") +
    geom_smooth(method = "lm" , #formula = y ~ poly(x, 2), 
                fullrange = f_range) +
    theme_bw() +
    scale_color_manual(values = c("#025955", "#e84545"), labels = c("P. falciparum", "P. vivax")) +
    scale_fill_manual(values = c("#025955", "#e84545"), labels = c("P. falciparum", "P. vivax")) +
    labs(color = "Malaria species", fill = "Malaria species") +
    theme(legend.position = "bottom")  +
    ggplot2::scale_y_continuous(limits = limits_y)
  
  
  
  f3a <- ggMarginal(f3a.p, 
                    xparams = list(fill = "#787878", 
                                   col = "#787878", alpha=.3),
                    #margins = 'x',
                    type = "histogram",
                    yparams = list(fill = "#787878", 
                                   col = "#787878", alpha=.3))
  
  return(f3a)
  
}
