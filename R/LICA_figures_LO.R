
mk_ortho_fig_perMod <- function(mod, sAX, sSAG, sCOR){ #delete IC just mo
   df3 <- mod@.Data#isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 == 0] <- NA
  
  df3 <- wiqid::standardize(df3, center= TRUE, scale=TRUE) #recentre
  df_abs <- df3 %>% abs()  
  
  ax <- as.data.frame(MNI@.Data[, , sAX])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  
  ax1 <- as.data.frame(df3[, , sAX])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))
  
  ax_fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = ax_gath$y, y = ax_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(ax_gath$value_scaled)))
  
    ax_fig <- ax_fig +
      geom_tile(data = subset(ax1_gath, value > 0), aes(fill=value, x=y, y=x)) + 
      scale_fill_gradientn(colours = rainbow(5), na.value = "gray93",
                           limits=c(0,1), breaks=c(0,0.5,1),labels=c(0,0.5,1), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
      theme(text = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            legend.text = element_text(size = 4),
            legend.title = element_blank(),
            legend.key.size = unit(0.2, "cm"),
            legend.margin = margin(-0.5,0,0,0, unit="cm"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border = element_blank())
    
    sag <- as.data.frame(MNI@.Data[sSAG, ,])
    sag$y <- paste0("y_", 1:nrow(sag))
    sag_gath <- sag %>% gather("x", "value", -y)
    sag_gath <- sag_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(sag)-1)))) %>%
      mutate(y = fct_relevel(y, paste0("y_", 1:nrow(sag))))
    sag_gath$value_scaled <- (sag_gath$value - min(sag_gath$value, na.rm =TRUE))/diff(range(sag_gath$value, na.rm =TRUE))
    
  sag1 <- as.data.frame(df3[sSAG, ,])
  sag1$y <- paste0("y_", 1:nrow(sag1))
  sag1_gath <- sag1 %>% gather("x", "value", -y)
  sag1_gath <- sag1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(sag1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(sag1))))
  
  sag_fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = sag_gath$y, y = sag_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(sag_gath$value_scaled)))
  
  sag_fig <- sag_fig + new_scale_fill() +
    geom_tile(data = subset(sag1_gath, value > 0), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colours = rainbow(5), na.value = "gray93",
                         limits=c(0,1), breaks=c(0,0.5,1), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), 
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_blank())
  
  
  cor <- as.data.frame(MNI@.Data[,sCOR, ])
  cor$y <- paste0("y_", 1:nrow(cor))
  cor_gath <- cor %>% gather("x", "value", -y)
  cor_gath <- cor_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(cor)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(cor))))
  cor_gath$value_scaled <- (cor_gath$value - min(cor_gath$value, na.rm =TRUE))/diff(range(cor_gath$value, na.rm =TRUE))
  
  cor1 <- as.data.frame(df3[, sCOR,])
  cor1$y <- paste0("y_", 1:nrow(cor1))
  cor1_gath <- cor1 %>% gather("x", "value", -y)
  cor1_gath <- cor1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(cor1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(cor1))))
  
  cor_fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = cor_gath$y, y = cor_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(cor_gath$value_scaled))) 
  
  cor_fig <- cor_fig + new_scale_fill() +
    geom_tile(data = subset(cor1_gath, value > 0), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colours = rainbow(5), na.value = "gray93",
                         limits=c(0, 1), breaks=c(0,0.5, 1), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), 
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_blank())
  
  figs <- plot_grid(sag_fig, cor_fig, ax_fig, ncol=3, rel_widths = c(1.2,1.0,1.1),
                    rel_heights = c(1.2,1.0,1.1), axis="t") 
  
  #fig_file <- file.path(outdir, paste0("/spatial_maps/alt_maps/SubG2_rh.ff_CTRL.png"))
  #ggsave(fig_file, figs, dpi=300, width=12, height = 6, units = "cm") 

  # in case a white to red gradient is desired use this: colors=c("#FDFEFE","#FFFF00","#FFC107","#FF0000")
  
  return(figs)
}

##############################################################################################
# function to display difference map of functional gradients

mk_ortho_diff_fig_perMod <- function(mod, sAX, sSAG, sCOR){ #delete IC just mod
  df3 <- mod@.Data#isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 == 0] <- NA
  
  df3 <- wiqid::standardize(df3, center= TRUE, scale=FALSE) #recentre
  df_abs <- df3 %>% abs() 

  ax <- as.data.frame(MNI@.Data[, , sAX])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  
  ax1 <- as.data.frame(df3[, , sAX])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))
  
  ax_fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = ax_gath$y, y = ax_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(ax_gath$value_scaled)))
  
  ax_fig <- ax_fig + new_scale_fill() +
  #  geom_tile(data = subset(ax1_gath, value > 0.001), aes(fill=value, x=y, y=x)) + 
  #  scale_fill_gradientn(colors=c("#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
  #                       limits=c(0.01,0.08), breaks=c(0.04,0.08),labels=c(0.04,0.08), guide = guide_colourbar(nbin = 1000))
  #ax_fig <- ax_fig + new_scale_fill() +
  #  geom_tile(data = subset(ax1_gath, value < 0.001), aes(fill=value, x=y, y=x)) + 
  #  scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF"), na.value = "gray93",
  #                       limits=c(-0.08,0.01), breaks=c(-0.08,-0.04),labels=c(-0.08,-0.04), guide = guide_colourbar(nbin = 1000)) + labs(fill = " ") +
    geom_tile(data = subset(ax1_gath, abs(value) > 0.001) , aes(fill=value, x=y, y=x)) + 
     scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
                       limits=c(-0.08,0.08), breaks=c(-0.08,0,0.08),labels=c(-0.08,0,0.08), 
                       oob=scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = " ") +
    theme(text = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          legend.text = element_text(size = 4),
          legend.title = element_blank(),
          legend.key.size = unit(0.2, "cm"),
          legend.margin = margin(-0.5,0,0,0, unit="cm"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank())
  
  sag <- as.data.frame(MNI@.Data[sSAG, ,])
  sag$y <- paste0("y_", 1:nrow(sag))
  sag_gath <- sag %>% gather("x", "value", -y)
  sag_gath <- sag_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(sag)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(sag))))
  sag_gath$value_scaled <- (sag_gath$value - min(sag_gath$value, na.rm =TRUE))/diff(range(sag_gath$value, na.rm =TRUE))
  
  sag1 <- as.data.frame(df3[sSAG, ,])
  sag1$y <- paste0("y_", 1:nrow(sag1))
  sag1_gath <- sag1 %>% gather("x", "value", -y)
  sag1_gath <- sag1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(sag1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(sag1))))
  
  sag_fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = sag_gath$y, y = sag_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(sag_gath$value_scaled)))
  
  sag_fig <- sag_fig + new_scale_fill() +
  #  geom_tile(data = subset(sag1_gath, value > 0.001), aes(fill=value, x=y, y=x)) + 
  #  scale_fill_gradientn(colors=c("#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
  #                       limits=c(0.01,0.08), breaks=c(0.04,0.08),labels=c(0.04,0.08), guide = guide_colourbar(nbin = 1000))
  #sag_fig <- sag_fig + new_scale_fill() +
  #  geom_tile(data = subset(sag1_gath, value < 0.001), aes(fill=value, x=y, y=x)) + 
  #  scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF"), na.value = "gray93",
  #                       limits=c(-0.08,0.01), breaks=c(-0.08,-0.04),labels=c(-0.08,-0.04), guide = guide_colourbar(nbin = 1000)) + labs(fill = " ") +
    geom_tile(data = subset(sag1_gath, abs(value) > 0.001), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
                         limits=c(-0.08,0.08), breaks=c(-0.08,0,0.08),labels=c(-0.08,0,0.08), oob=scales::squish, guide = guide_colourbar(nbin = 10000)) + labs(fill = " ") +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), 
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_blank())
  
  
  cor <- as.data.frame(MNI@.Data[,sCOR, ])
  cor$y <- paste0("y_", 1:nrow(cor))
  cor_gath <- cor %>% gather("x", "value", -y)
  cor_gath <- cor_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(cor)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(cor))))
  cor_gath$value_scaled <- (cor_gath$value - min(cor_gath$value, na.rm =TRUE))/diff(range(cor_gath$value, na.rm =TRUE))
  
  cor1 <- as.data.frame(df3[, sCOR,])
  cor1$y <- paste0("y_", 1:nrow(cor1))
  cor1_gath <- cor1 %>% gather("x", "value", -y)
  cor1_gath <- cor1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(cor1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(cor1))))
  
  cor_fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = cor_gath$y, y = cor_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(cor_gath$value_scaled))) 
  
  cor_fig <- cor_fig + new_scale_fill() +
  #  geom_tile(data = subset(cor1_gath, value > 0.001), aes(fill=value, x=y, y=x)) + 
  #  scale_fill_gradientn(colors=c("#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
  #                       limits=c(0.01,0.08), breaks=c(0.04,0.08),labels=c(0.04,0.08), guide = guide_colourbar(nbin = 1000))
  #cor_fig <- cor_fig + new_scale_fill() +
  #  geom_tile(data = subset(cor1_gath, value < 0.001), aes(fill=value, x=y, y=x)) + 
  #  scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF"), na.value = "gray93",
  #                       limits=c(-0.08,-0.01), breaks=c(-0.08,-0.04),labels=c(-0.08,-0.04), guide = guide_colourbar(nbin = 1000)) + labs(fill = " ") +
    geom_tile(data = subset(cor1_gath, abs(value) > 0.001), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
                         limits=c(-0.08,0.08), breaks=c(-0.08,0,0.08),labels=c(-0.08,0,0.08), oob=scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = " ") +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), 
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_blank())
  
  figs <- plot_grid(sag_fig, cor_fig, ax_fig, ncol=3, rel_widths = c(1.2,1.0,1.2),
                    rel_heights = c(1.2,1.0,1.2), axis="t") 
  
  fig_file <- file.path(outdir, paste0("/spatial_maps/alt_maps/subG2_rh.ff_diff.png"))
  ggsave(fig_file, figs, dpi=300, width=12, height = 6, units = "cm") 
  
  return(figs)
}

##############################################################################################
# code to create legend for gradient maps

mk_ortho_fig_leg <- function(mod, sAX){
  df3 <- mod@.Data#isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 == 0] <- NA
  
  df3 <- wiqid::standardize(df3, center= TRUE, scale=TRUE) #recentre
  df_abs <- df3 %>% abs() 
  
  ax <- as.data.frame(MNI@.Data[, , sAX])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  
  ax1 <- as.data.frame(df3[, , sAX])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))
    
    ax_fig <- ggplot() + coord_fixed() + 
      annotate(geom = 'raster', x = ax_gath$y, y = ax_gath$x, na.rm =TRUE,
               fill = (scales::colour_ramp(c("black", "white"))(ax_gath$value_scaled)))
    
    ax_fig <- ax_fig +
      geom_tile(data = subset(ax1_gath, value > 0), aes(fill=value, x=y, y=x)) + 
      scale_fill_gradientn(colours = rainbow(5), na.value = "gray93",
                           limits=c(0,1), breaks=c(0,0.5,1),labels=c(0,0.5,1), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
      theme(text = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            legend.text = element_text(size = 4),
            legend.title = element_blank(),
            legend.key.size = unit(0.2, "cm"),
            legend.margin = margin(-0.5,0,0,0, unit="cm"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border = element_blank())
  
    ax_fig_leg <- as_ggplot(get_legend(ax_fig))
    
  return(ax_fig_leg)
}

##############################################################################################
# code to create legend for orthogonal difference figure
mk_ortho_diff_leg <- function(mod, sAX){
  df3 <- mod@.Data#isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 == 0] <- NA
  
  df3 <- wiqid::standardize(df3, center= TRUE, scale=TRUE) #recentre
  df_abs <- df3 %>% abs() 
  
  ax <- as.data.frame(MNI@.Data[, , sAX])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  
  ax1 <- as.data.frame(df3[, , sAX])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))

ax_fig <- ggplot() + coord_fixed() + 
  annotate(geom = 'raster', x = ax_gath$y, y = ax_gath$x, na.rm =TRUE,
           fill = (scales::colour_ramp(c("black", "white"))(ax_gath$value_scaled)))

ax_fig <- ax_fig + new_scale_fill() +
  geom_tile(data = subset(ax1_gath, abs(value) > 0.001) , aes(fill=value, x=y, y=x)) + 
  scale_fill_gradientn(colors=c("#0033FF","#33FFFF","#FFFFFF","#FFFF00","#FF0000"), na.value = "gray93",
                       limits=c(-0.08,0.08), breaks=c(-0.08,0,0.08),labels=c("-0.08\nNon-Autistic",0,"Autistic\n0.08"), 
                       oob = scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = " ") +
  theme(text=element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.text = element_text(size = 4),
        legend.title = element_blank(),
        legend.key.size = unit(0.15, "cm"),
        legend.margin = margin(-0.5,0,0,0, unit="cm"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank())

ax_fig_leg <- as_ggplot(get_legend(ax_fig))

return(ax_fig_leg)
}



##############################################################################################
# grid gradient maps of two seperate gradients into one figure

mk_ortho_fig_grid <- function(mod1, mod2, mod3, sAX, sSAG, sCOR){

fig1 <- mk_ortho_fig_perMod(mod1, sAX, sSAG, sCOR)
#fig1_leg <- mk_ortho_fig_leg(mod1, sAX)
fig2 <- mk_ortho_fig_perMod(mod2, sAX, sSAG, sCOR)
#fig2_leg <- mk_ortho_fig_leg(mod2, sAX)
figdiff <- mk_ortho_diff_fig_perMod(mod3, sAX, sSAG, sCOR)
#figdiff_leg <- mk_ortho_diff_leg(mod3, sAX)

#labs <- c("Autism Group", "Control Group")

fig <- plot_grid(fig1, fig2, figdiff,  ncol = 1, nrow = 3, align= "hv",
                 labels=c("A: Autistic Group", "B: Non-Autistic Group", "C: Group Difference"), hjust = 0,
                 label_size = 6, rel_heights = c(1,1,1))
#fig_leg <- plot_grid(as_grob(fig1_leg) ,as_grob(fig2_leg), as_grob(figdiff_leg), ncol=1, nrow=3, align ="hv",
                  #labels= "", rel_heights = c(1,1,1))

#fig_final <- plot_grid(fig, fig_leg, ncol=2, align="hv", rel_width = c(2,1))

  fig_file <- file.path(outdir, paste0("/spatial_maps/alt_maps/subG2_rh.ff_full.png"))
  ggsave(fig_file, fig, dpi=300, width=12, height = 12, units = "cm") 

  return(fig)

}

##############################################################################################
mk_fig <- function(slice, df) {
  ax <- as.data.frame(MNI@.Data[, , slice])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  
  ax1 <- as.data.frame(df[, , slice])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))
  
  fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = ax_gath$y, y = ax_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(ax_gath$value_scaled))) 

    fig <- fig +
      geom_tile(data = subset(ax1_gath, value < 1), aes(fill=value, x=y, y=x)) + 
      scale_fill_gradientn(colors=c("#33FFFF","#0033FF"), na.value = "gray93",
                           limits=c(-5,-thr), breaks=c(-5, -(thr)), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) 
    fig <- fig + new_scale_fill() +
      geom_tile(data = subset(ax1_gath, value > 1), aes(fill=value, x=y, y=x)) + 
      scale_fill_gradientn(colors=c("#FF0000", "#FFFF00"), na.value = "gray93",
                           limits=c(thr,5), breaks=c(thr, 5), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
      theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), 
            legend.position = "none", panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_blank())
  return(fig)
}

##############################################################################################

mk_fig_tbss <- function(slice, df) {
  ax <- as.data.frame(MNI@.Data[, , slice])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  
  tbss <- as.data.frame(TBSS@.Data[, , slice])
  tbss$y <- paste0("y_", 1:nrow(tbss))
  tbss_gath <- tbss %>% gather("x", "value", -y)
  tbss_gath <- tbss_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(tbss)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(tbss))))

  ax1 <- as.data.frame(df[, , slice])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))
  
  fig <- ggplot() + coord_fixed() + 
    annotate(geom = 'raster', x = ax_gath$y, y = ax_gath$x, na.rm =TRUE,
             fill = (scales::colour_ramp(c("black", "white"))(ax_gath$value_scaled))) 
  
  fig <- fig + new_scale_fill() +
    geom_tile(data=subset(tbss_gath, value > 0), aes(fill="green", x=y, y=x)) + 
    scale_fill_manual(values = c("#009900"), na.value = "gray93", guide= NULL)
  
  fig <- fig +  new_scale_fill() +
    geom_tile(data = subset(ax1_gath, value < 1), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colors=c("#33FFFF","#0033FF"), na.value = "gray93",
                         limits=c(-5,-thr), breaks=c(-5, -(thr)), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) 
  fig <- fig + new_scale_fill() +
    geom_tile(data = subset(ax1_gath, value > 1), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colors=c("#FF0000", "#FFFF00"), na.value = "gray93",
                         limits=c(thr,5), breaks=c(thr, 5), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), 
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_blank())
  return(fig)
}
##############################################################################################

mk_fig_leg <- function(slice, df) {
  ax1 <- as.data.frame(df[, , slice])
  ax1$y <- paste0("y_", 1:nrow(ax1))
  ax1_gath <- ax1 %>% gather("x", "value", -y)
  ax1_gath <- ax1_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax1)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax1))))
  
  fig <- ggplot() + coord_fixed() + 
    geom_tile(data = subset(ax1_gath, value < 1), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colors=c("#33FFFF","#0033FF"), na.value = "gray93",
                         limits=c(-5,-thr), breaks=c(-5, -(thr)), oob = scales::squish, guide = guide_colourbar(nbin = 1000))  + labs(fill = " ")
  fig <- fig + new_scale_fill() +
    geom_tile(data = subset(ax1_gath, value > 1), aes(fill=value, x=y, y=x)) + 
    scale_fill_gradientn(colors=c("#FF0000", "#FFFF00"), na.value = "gray93",
                         limits=c(thr,5), breaks=c(thr, 5), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) +
    labs(fill = "Z") +
    theme(axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(), 
          panel.border = element_blank(),
          legend.text = element_text(size = 4),
          legend.title = element_text(size = 8),
          legend.key.size = unit(0.15, "cm"),
          legend.margin = margin(-0.5,0,0,0, unit="cm")) 
  
  return(fig)
}

##############################################################################################

mk_ax_fig_perIC <- function(IC, mod, sAX1, sAX2, sAX3, sAX4, sAX5){
  n <- sub("IC", "", IC) %>% as.numeric()  
  df3 <- mod@.Data[, , , n] #isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 ==0] <- NA
  df3 <- wiqid::standardize(df3, center= TRUE, scale=TRUE) #recentre
  df_abs <- df3 %>% abs()  
  df3[df_abs<thr] <- NA
  
  ax1_fig <- mk_fig(sAX1, df3) 
  ax2_fig <- mk_fig(sAX2, df3)
  ax3_fig <- mk_fig(sAX3, df3)
  ax4_fig <- mk_fig(sAX4, df3)
  ax5_fig <- mk_fig(sAX5, df3)
  
  
  figs <- plot_grid(ax1_fig, ax2_fig, ax3_fig, ax4_fig, ax5_fig, ncol=5,
                    labels = c("R","","","","L"), label_x = c(0,1,1,1,0.9), label_y =0.3, label_size = 6) 
  #+ theme(plot.background = element_rect(fill = "black")) #if you want black background instead
  return(figs)
}


##############################################################################################

mk_ax_fig <- function(mod, sAX1, sAX2, sAX3, sAX4, sAX5){
  df3 <- mod@.Data #isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 ==0] <- NA
  #df3 <- wiqid::standardize(df3, center= TRUE, scale=TRUE) #recentre
  df_abs <- df3 %>% abs()  
  df3[df_abs<thr] <- NA
  
  ax1_fig <- mk_fig(sAX1, df3) 
  ax2_fig <- mk_fig(sAX2, df3)
  ax3_fig <- mk_fig(sAX3, df3)
  ax4_fig <- mk_fig(sAX4, df3)
  ax5_fig <- mk_fig(sAX5, df3)
  
  
  figs <- plot_grid(ax1_fig, ax2_fig, ax3_fig, ax4_fig, ax5_fig, ncol=5, align = 'hv',
                    labels = c("R","","","","L"), label_x = c(0,1,1,1,0.9), label_y =0.3, label_size = 4) 
  #+ theme(plot.background = element_rect(fill = "black")) #if you want black background instead
  return(figs)
}
##############################################################################################


mk_ax_fig_tbss <- function(mod, sAX1, sAX2, sAX3, sAX4, sAX5){
  df3 <- mod@.Data #isolate 3d image for IC of interest #mod is the modality (VBM, gradients etc)
  df3[df3 ==0] <- NA
  #df3 <- wiqid::standardize(df3, center= TRUE, scale=TRUE) #recentre
  df_abs <- df3 %>% abs()  
  df3[df_abs<thr] <- NA
  
  ax1_fig <- mk_fig_tbss(sAX1, df3) 
  ax2_fig <- mk_fig_tbss(sAX2, df3)
  ax3_fig <- mk_fig_tbss(sAX3, df3)
  ax4_fig <- mk_fig_tbss(sAX4, df3)
  ax5_fig <- mk_fig_tbss(sAX5, df3)
  
  
  figs <- plot_grid(ax1_fig, ax2_fig, ax3_fig, ax4_fig, ax5_fig, ncol=5, align = 'hv',
                    labels = c("R","","","","L"), label_x = c(0,1,1,1,0.9), label_y =0.3, label_size = 4) 
  #+ theme(plot.background = element_rect(fill = "black")) #if you want black background instead
  return(figs)
}
##############################################################################################



mk_dwi_fig_perIC <- function(IC, df, nPCs, leg){
  df <- df %>% filter(comp == IC) #filter IC
  df[df == 0] <- NA
  df %<>% mutate(across(value, scale, center= TRUE, scale=TRUE)) #recentre
  PClist <- paste0("PC", 1:nPCs)
  df <- df %>% filter(PCs %in% PClist)
  df.val <- df %>% dplyr::select(value)
  df_abs <- df.val %>% abs()  
  df.val[df_abs< thr] <- NA
  df$value <- df.val$value
  
  fig <- df %>%
    mutate(ROI = fct_relevel(ROI, c("R_pallidum", "L_pallidum", 
                                    "R_hippocampus", "L_hippocampus", 
                                    "R_thalamus", "L_thalamus",
                                    "R_amygdala", "L_amygdala",
                                    "R_striatum", "L_striatum",
                                    "L_postcentral",  "R_postcentral", "L_ACC", "R_ACC",
                                    "L_fusiform", "R_fusiform"))) %>% 
    mutate(PCs = fct_relevel(PCs, PClist)) %>%
    ggplot(aes(x=PCs, y=ROI)) +
    geom_tile(fill = "grey93", height=0.9, width=0.9) +
    labs(x="", y="") + scale_x_discrete(position = "top")
  
fig <- fig +
    geom_tile(data = subset(df, value < 1), aes(fill=value, x=PCs, y=ROI), height=0.9, width=0.9) + 
    scale_fill_gradientn(colors=c("#33FFFF","#0033FF"), na.value = "gray93",
                                          limits=c(-5,-thr), breaks=c(-5, -(thr)), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = " ")
fig <- fig + new_scale_fill() +
      geom_tile(data = subset(df, value > 1), aes(fill=value, x=PCs, y=ROI), height=0.9, width=0.9) + 
      scale_fill_gradientn(colors=c("#FF0000", "#FFFF00"), na.value = "gray93",
                           limits=c(thr,5), breaks=c(thr, 5), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = "Z") + 
      theme(text=element_text(family="Arial"),
            axis.text.x = element_text(angle = 90, hjust= 0.2, size = 2.5), 
            axis.text.y = element_text(size=7),
            axis.ticks = element_blank(),
            legend.text = element_text(size = 4),
            legend.title = element_text(size = 8),
            legend.key.size = unit(0.15, "cm"),
            legend.margin = margin(-0.5,0,0,0, unit="cm"))

  if (leg == "noleg"){
    fig <- fig + theme(legend.position = "none")
  } else if (leg == "top"){
    fig <- fig + theme(legend.position = "top")
  }

return(fig)
}


mk_dwi_fig_perIC_LEAP <- function(IC, df, nPCs, leg){
  df <- df %>% filter(comp == IC) #filter IC
  df[df == 0] <- NA
  df %<>% mutate(across(value, scale, center= TRUE, scale=TRUE)) #recentre
  PClist <- paste0("PC", 1:nPCs)
  df <- df %>% filter(PCs %in% PClist)
  df.val <- df %>% dplyr::select(value)
  df_abs <- df.val %>% abs()  
  df.val[df_abs< thr] <- NA
  df$value <- df.val$value
  
  fig <- df %>%
    mutate(ROI = fct_relevel(ROI, c("L_postcentral",  "R_postcentral", "L_ACC", "R_ACC",
                                    "L_fusiform", "R_fusiform", "L_striatum","R_striatum",
                                    "L_amygdala", "R_amygdala"))) %>% 
    mutate(PCs = fct_relevel(PCs, PClist)) %>%
    ggplot(aes(x=PCs, y=ROI)) +
    geom_tile(fill = "grey93", height=0.9, width=0.9) +
    labs(x="", y="") + scale_x_discrete(position = "top")
  
  fig <- fig +
    geom_tile(data = subset(df, value < 1), aes(fill=value, x=PCs, y=ROI), height=0.9, width=0.9) + 
    scale_fill_gradientn(colors=c("#33FFFF","#0033FF"), na.value = "gray93",
                         limits=c(-5,-thr), breaks=c(-5, -(thr)), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = " ")
  fig <- fig + new_scale_fill() +
    geom_tile(data = subset(df, value > 1), aes(fill=value, x=PCs, y=ROI), height=0.9, width=0.9) + 
    scale_fill_gradientn(colors=c("#FF0000", "#FFFF00"), na.value = "gray93",
                         limits=c(thr,5), breaks=c(thr, 5), oob = scales::squish, guide = guide_colourbar(nbin = 1000)) + labs(fill = "Z") + 
    theme(text=element_text(family="Arial"),
          axis.text.x = element_text(angle = 90, hjust= 0.2, size = 2.5), 
          axis.text.y = element_text(size=7),
          axis.ticks = element_blank(),
          legend.text = element_text(size = 4),
          legend.title = element_text(size = 8),
          legend.key.size = unit(0.15, "cm"),
          legend.margin = margin(-0.5,0,0,0, unit="cm"),
          plot.margin = margin(5.5,0,5.5,5.5))
  
  if (leg == "noleg"){
    fig <- fig + theme(legend.position = "none")
  } else if (leg == "top"){
    fig <- fig + theme(legend.position = "top")
  }
  return(fig)
}

##############################################################################################

mk_spatial_fig_all <- function(x, nPCs){
  #var_name <- rownames(Stats_sig)
  tbl <- Stats_sig %>% dplyr::select(ends_with(x)) %>% filter(.[2] <0.05) %>% arrange(desc(.[[1]])) 
  tbl$var_name <- rownames(tbl)
  tbl[1] <- round(tbl[1], 2)
  tbl[2] <- round(tbl[2], 4) %>% format(nsmall =4, scientific=FALSE)
  # table <- kable(tbl, col.names = c("r", "p", "behaviour/demographic"),
  #                   align = c("c", "c", "l")) %>% kable_styling(bootstrap_options = c("hover", "condensed"), 
  #                                                              full_width = F, position = "left")
  
  table <- tableGrob(tbl, cols = c("R", "p", "behaviour/demographic"), 
                     theme = ttheme_minimal(core = list(fg_params = list(hjust = 0, x=0.1), padding =unit(c(2,2), "mm"),
                                                        colhead = list(fg_params = list(hjust=0, x=0.1)))),
                     rows = NULL)
  
  #table$widths <- unit(rep(1/ncol(table), ncol(table)), "npc")
  
  df <- mod_contrib_sig_gath %>% filter(comp == x)
  fig_comp <- ggplot(df, aes(fill=mod, y=contrib, x=comp)) + 
    geom_bar(position="stack", stat="identity") + coord_flip() + ylab("feature contribution") +
    theme(text=element_text(family="Arial"), legend.position="right", legend.title = element_blank(),
          legend.text = element_text(size = 8), legend.key.size = unit(0.15, "cm"), axis.title.y = element_blank()) +
    scale_fill_brewer(palette="Set3")
  
  fig_dwi <- mk_dwi_fig_perIC(x, spatial_gath, nPCs, "leg")
  fig_vbm <- mk_ortho_fig_perIC(x, VBM, sAX, sSAG, sCOR)
  #fig_cG1 <- mk_ortho_fig_perIC(x, cortG1, sAX, sSAG, sCOR)
  #fig_cG2 <- mk_ortho_fig_perIC(x, cortG2, sAX, sSAG, sCOR)
  fig_sG1 <- mk_ortho_fig_perIC(x, subG1, sAX, sSAG, sCOR)
  fig_sG2 <- mk_ortho_fig_perIC(x, subG2, sAX, sSAG, sCOR)
  fig_sG3 <- mk_ortho_fig_perIC(x, subG3, sAX, sSAG, sCOR)
  
  left <- plot_grid(fig_comp, table,
                    ncol = 1, labels=c("A","B"), label_size=8, rel_heights = c(1,4))
  right <- plot_grid(fig_dwi, fig_vbm, fig_sG1, fig_sG2, fig_sG3, ncol = 1, 
                     labels=c("DWI", "VBM", "fMRI G1", "fMRI G2", "fMRI G3"),
                     label_size = 8, label_x =0, hjust = 0)
  p <- plot_grid(left, right, ncol=2, rel_widths = c(1,1))
  
  # p <- plot_grid(table, right, ncol=2) # for IC79 because table is too big
  
  # now add the title
  title <- ggdraw() + 
    draw_label(x,
               fontface = 'bold',
               size= 14,
               x = 0,
               hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 5)
    )
  p_title <- plot_grid(
    title, p, ncol = 1,
    # rel_heights values control vertical title margins
    rel_heights = c(0.03, 1), label_x =0, hjust = 0
  )
  
  p_file <- file.path(outdir, paste0(x,"_thr", thr,"_full.png"))
  ggsave(p_file, p_title, dpi=300, width=18, height = 15, units = "cm")
  return(p_title)
}

##############################################################################################

mk_spatial_fig_all_ax <- function(x, nPCs){
  #var_name <- rownames(Stats_sig)
  tbl <- Stats_sig %>% dplyr::select(ends_with(x)) %>% filter(.[2] <0.05) %>% arrange(desc(.[[1]])) 
  tbl$var_name <- rownames(tbl)
  tbl[1] <- round(tbl[1], 2)
  tbl[2] <- round(tbl[2], 4) %>% format(nsmall =4, scientific=FALSE)
  
  table <- tableGrob(tbl, cols = c("R", "p", "behaviour/demographic"), 
                     theme = ttheme_minimal(core = list(fg_params = list(hjust = 0, x=0.1), padding =unit(c(2,2), "mm"),
                                                        colhead = list(fg_params = list(hjust=0, x=0.1)))),
                     rows = NULL)
  
  df <- mod_contrib_sig_gath %>% filter(comp == x)
  fig_comp <- ggplot(df, aes(fill=mod, y=contrib, x=comp)) + 
    geom_bar(position="stack", stat="identity") + coord_flip() + ylab("feature contribution") +
    theme(text=element_text(family="Arial"), legend.position="right", legend.title = element_blank(),
          legend.text = element_text(size = 8), legend.key.size = unit(0.15, "cm"), axis.title.y = element_blank()) +
    scale_fill_brewer(palette="Set3")
  
  #fig_cdwi <- mk_dwi_fig_perIC(x, spatial_gath_cort, 100, "leg")
  fig_sdwi <- mk_dwi_fig_perIC(x, spatial_gath_sub, nPCs, "leg")
  fig_vbm <- mk_ax_fig_perIC(x, VBM, sAX1, sAX2, sAX3, sAX4, sAX5)
  fig_cG1 <- mk_ax_fig_perIC(x, cortG1, sAX1, sAX2, sAX3, sAX4, sAX5)
  fig_cG2 <- mk_ax_fig_perIC(x, cortG2, sAX1, sAX2, sAX3, sAX4, sAX5)
  fig_sG1 <- mk_ax_fig_perIC(x, subG1, sAX1, sAX2, sAX3, sAX4, sAX5)
  fig_sG2 <- mk_ax_fig_perIC(x, subG2, sAX1, sAX2, sAX3, sAX4, sAX5)
  fig_sG3 <- mk_ax_fig_perIC(x, subG3, sAX1, sAX2, sAX3, sAX4, sAX5)
  
  #make labels
  df_lab <- mod_contrib_sig_gath %>% filter(comp == x)
  df_lab$contrib <- round((df_lab$contrib *100), 2)
  df_lab$names <- NA
  df_lab$names[df_lab$mod == "subcortical_dwi"] <- "DWI"
  df_lab$names[df_lab$mod == "subcortical_G1"] <- "fMRI G1"
  df_lab$names[df_lab$mod == "subcortical_G2"] <- "fMRI G2"
  df_lab$names[df_lab$mod == "subcortical_G3"] <- "fMRI G3"
  df_lab$names[df_lab$mod == "VBM"] <- "VBM"
  
  df_lab$labels <- paste0(df_lab$names, " (", df_lab$contrib, "%)")
  labs <- c("subcortical_dwi","VBM", "subcortical_G1", "subcortical_G2", "Subcortical_G3") #desired oreder
  df_lab <- df_lab %>%  mutate(mod =  factor(mod, levels = labs)) %>%
    arrange(mod)
  labels <- df_lab$labels
  
  left <- plot_grid(fig_comp, table,
                    ncol = 1, labels=c("A","B"), label_size=8, rel_heights = c(1,4))
  right <- plot_grid(fig_sdwi,fig_vbm, fig_sG1, fig_sG2, fig_sG3,  ncol = 1, 
                     labels=labels,
                     label_size = 7, label_x =0, hjust = 0)
  p <- plot_grid(left, right, ncol=2, rel_widths = c(1,1))
  
  # p <- plot_grid(table, right, ncol=2) # for IC79 because table is too big
  
  # now add the title
  title <- ggdraw() + 
    draw_label(x,
               fontface = 'bold',
               size= 14,
               x = 0,
               hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 5)
    )
  p_title <- plot_grid(
    title, p, ncol = 1,
    # rel_heights values control vertical title margins
    rel_heights = c(0.03, 1), label_x =0, hjust = 0
  )
  
  p_file <- file.path(outdir, paste0(x,"_thr", thr, "_AX_full.png"))
  ggsave(p_file, p_title, dpi=300, width=18, height = 17, units = "cm")
  return(p_title)
}

##############################################################################################

mk_spatial_fig <- function(x, nPCs){
  
  df <- mod_gather %>% filter(comp == x)
  fig_comp <- ggplot(df, aes(fill=mod, y=contrib, x=comp)) + 
    geom_bar(position="stack", stat="identity") + coord_flip() + ylab("feature contribution") +
    theme(text=element_text(family="Arial"), legend.position="right", legend.title = element_blank(),
          legend.text = element_text(size = 8), legend.key.size = unit(0.15, "cm"), axis.title.y = element_blank()) +
    scale_fill_brewer(palette="Set3")
  
  #make labels
  df_lab <- mod_gather %>% filter(comp == x)
  df_lab$contrib <- round((df_lab$contrib *100), 2)
  
  df_lab$names <- NA
  df_lab$names[df_lab$mod == "subcortical_dwi"] <- "DWI"
  df_lab$names[df_lab$mod == "subcortical_G1"] <- "fMRI G1"
  df_lab$names[df_lab$mod == "subcortical_G2"] <- "fMRI G2"
  df_lab$names[df_lab$mod == "subcortical_G3"] <- "fMRI G3"
  df_lab$names[df_lab$mod == "VBM"] <- "VBM"
  df_lab$labels <- paste0(df_lab$names, " (", df_lab$contrib, "%)")
  labs <- c("subcortical_dwi", "VBM", "subcortical_G1", "subcortical_G2", "subcortical_G3") #desired oreder
  df_lab <- df_lab %>%  mutate(mod =  factor(mod, levels = labs)) %>%
    arrange(mod)
  labels <- df_lab$labels
  
  # now add the title
  title <- ggdraw() + 
    draw_label(x,
               fontface = 'bold',
               size= 14,
               x = 0,
               hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 5)
    )
  
  sag_slice <- sag_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(sag)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(sag)))) %>%
    ggplot(aes(x=y, y=x, fill = value)) +
    geom_raster() + scale_fill_gradient(low="black", high="white", na.value = "white") +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(),
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank())
  
  fig_slice_loc <- sag_slice + geom_hline(aes(yintercept=sAX1, colour= "red")) +
    geom_hline(aes(yintercept=sAX2, colour= "red")) + 
    geom_hline(aes(yintercept=sAX3, colour= "red")) +
    geom_hline(aes(yintercept=sAX4, colour= "red")) +
    geom_hline(aes(yintercept=sAX5, colour= "red")) +
    theme(plot.margin= margin(5.5, 5.5, 5.5, 0)) +
    coord_fixed()
  
  if (nrow(df) == 5){
    fig_sdwi <- mk_dwi_fig_perIC(x, spatial_gath_sub, nPCs, "leg")
    fig_vbm <- mk_ax_fig_perIC(x, VBM,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG1 <- mk_ax_fig_perIC(x, subG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG2 <- mk_ax_fig_perIC(x, subG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG3 <- mk_ax_fig_perIC(x, subG3,  sAX1, sAX2, sAX3, sAX4, sAX5)
    
    p1 <-plot_grid(fig_sdwi, fig_slice_loc, ncol=2, rel_widths = c(1, 0.4), scale= c(1,0.8))
    
    p <- plot_grid(p1, fig_vbm, fig_sG1, fig_sG2, fig_sG3,  ncol = 1, 
                   labels=labels,
                   label_size = 7, label_x =0, hjust = 0)
    p_title <- plot_grid(title, p, ncol = 1,
      rel_heights = c(0.03, 1), label_x =0, hjust = 0)
    
    p_file <- file.path(outdir, paste0("spatial_maps/",x,"_thr", thr,"_full.png"))
    ggsave(p_file, p_title, dpi=300, width=12, height = 17, units = "cm")
    
    } else if (nrow(df) == 2){
      fig_sdwi <- mk_dwi_fig_perIC(x, spatial_gath_sub, nPCs, "leg")
      fig_vbm <- mk_ax_fig_perIC(x, VBM,  sAX1, sAX2, sAX3, sAX4, sAX5)
      
      p1 <-plot_grid(fig_sdwi, fig_slice_loc, ncol=2, rel_widths = c(1, 0.4), scale= c(1,0.8))
      
      p <- plot_grid(p1, fig_vbm, ncol = 1, 
                     labels=labels,
                     label_size = 7, label_x =0, hjust = 0)
      p_title <- plot_grid(title, p, ncol = 1,
                           rel_heights = c(0.03, 1), label_x =0, hjust = 0)
      
      p_file <- file.path(outdir, paste0("spatial_maps/",x,"_thr", thr,"_full.png"))
      ggsave(p_file, p_title, dpi=300, width=12, height = 6.5, units = "cm")
      
    }else if (nrow(df) == 7){
      fig_cdwi <- mk_dwi_fig_perIC(x, spatial_gath_cort, nPCs, "leg")
      fig_sdwi <- mk_dwi_fig_perIC(x, spatial_gath_sub, nPCs, "leg")
      fig_vbm <- mk_ax_fig_perIC(x, VBM,  sAX1, sAX2, sAX3, sAX4, sAX5)
      fig_cG1 <- mk_ax_fig_perIC(x, cortG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
      fig_cG2 <- mk_ax_fig_perIC(x, cortG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
      fig_sG1 <- mk_ax_fig_perIC(x, subG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
      fig_sG2 <- mk_ax_fig_perIC(x, subG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
      
      p <- plot_grid(fig_sdwi, fig_cdwi, fig_vbm, fig_sG1, fig_sG2, fig_cG1, fig_cG2, ncol = 1, 
                     labels=labels,
                     label_size = 7, label_x =0, hjust = 0)
      p_title <- plot_grid(title, p, ncol = 1,
                           rel_heights = c(0.03, 1), label_x =0, hjust = 0)
      
      p_file <- file.path(outdir, paste0("spatial_maps/",x,"_thr", thr,"_full.png"))
      ggsave(p_file, p_title, dpi=300, width=12, height = 20, units = "cm")
    }
  #return(p_title)
}

##############################################################################################

merge.png.pdf <- function(pdfFile, pngFiles, deletePngFiles=FALSE, height) {
  pdf(pdfFile)
  n <- length(pngFiles)
  
  for( i in 1:n) {
    pngFile <- pngFiles[i]
    pngRaster <- readPNG(pngFile)
    grid.raster(pngRaster, height= unit(height, "npc"), width= unit(height, "npc")) #0.75 for all mods #0.45 vbm_dwi
    if (i < n) plot.new()
  }
  
  dev.off()
  if (deletePngFiles) {
    unlink(pngFiles)
  }
}


##############################################################################################

get_pca_data <- function(ROI){ ###### THIS ISN'T GENERALISING #####
  pca <- read_csv(file.path(pcadir, paste0("probtrackX_atlas/", ROI, "_PCA.csv")))
  #ind <- read.table(file.path(pcadir, paste0("probtrackX_atlas/", ROI, "_PCA_ind.txt")), quote="\"", comment.char="", stringsAsFactors=FALSE)
  #eig <- pca[2:330,] %>% separate(eig, into = c("comp", "eigenvalue", "percentage of variance", "cumlative percentage of variance"), sep= ";") %>%
  #  mutate_at(c("eigenvalue", "percentage of variance", "cumlative percentage of variance"), as.numeric) 
  Row1 <- which(pca == "contrib", arr.ind=TRUE)[1] +2
  Rown <- which(pca == "ind", arr.ind=TRUE)[1] -1
  contrib <- pca[Row1:Rown ,] %>% separate(eig, into = c("ROIvox", paste0("dim", 1:50)), sep = ";") %>%
    mutate_at(c(paste0("dim", 1:50)), as.numeric) 
  #contrib <- contrib %>% separate(ROIvox, into =c("ROI", "vox"), sep = "_vo") 
  #pca <- list(eig, contrib, ind)
  return(contrib)
}

##############################################################################################

mk_dwi_fig_perPC <- function(df, PC, roi){
  # spatial <- spatial %>% select(IC, ROI, PCs)
  dfnonnum <- df %>% dplyr::select(ROI, vox, region, cortex, Cortex_ID, regionID)
  dfnum <- df %>% dplyr::select(starts_with("dim"))
  df_abs <- dfnum %>% abs() 
  perc95 <- df_abs[[ PC ]] %>% quantile(0.95)
  dfnum[df_abs < perc95] <- NA
  df <-  cbind(dfnum, dfnonnum)
  #df[df >= 20] <- 20
  #drop cols and rows with nothing interesting
  #df <- df %>% filter(abs(.[[ PC ]]) > 0)
  
  df$voxnum <- sub( "x", "", df$vox) %>% as.numeric()
  
  figPC <- df %>% 
    arrange(Cortex_ID)%>%
    mutate(ROI = factor(ROI, unique(ROI))) %>%
    #arrange(desc(.[[ PC ]])) %>%               # sort your dataframe
    #mutate(ROI = factor(ROI, unique(ROI))) %>%
    mutate(vox = fct_reorder(vox, voxnum)) %>%
    #mutate(vox = factor(vox, unique(vox))) %>%
    ggplot(aes(x=vox, y=ROI)) +
    geom_tile(aes_string(fill = PC))+
    labs(x="voxels", y="atlas ROIs") + 
    theme(text=element_text(family="Arial", size =4),
          axis.text = element_blank(),
          #axis.text.x = element_text(angle = 90, hjust= 0.2), 
          axis.title = element_text(size=8),
          axis.ticks = element_blank(),
          legend.text = element_text(size = 8), 
          legend.key.size = unit(0.4, "cm"),
          legend.title = element_blank()) +
    scale_fill_gradient(low="red", high = "yellow", na.value = "gray93") +
    #breaks=seq(-0,20, by=10))  + 
    scale_x_discrete(position = "top") +
    scale_y_discrete(limits = rev(levels(df$ROI)))
  
  
  legend_ord <- levels(with(df, reorder(cortex, Cortex_ID)))  
  figCortex <- df %>% dplyr::select(ROI, cortex, Cortex_ID) %>% unique() %>%
    arrange(Cortex_ID)%>%
    mutate(ROI = factor(ROI, unique(ROI))) %>% 
    ggplot(aes(x = ROI, y=1, fill=cortex)) +
    geom_bar(position="stack", stat="identity") + coord_flip() +
    scale_fill_igv(breaks=rev(legend_ord)) +
    theme(text=element_text(family="Arial"),
          axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks = element_blank(),
          legend.position = "left", 
          legend.text = element_text(size=4), 
          legend.key.size = unit(0.25, "cm"),
          legend.title = element_blank(),
          legend.margin=margin(),
          legend.box="horizontal", 
          panel.grid = element_blank(),
          panel.border = element_blank()) +
    guides(fill=guide_legend(ncol=1))
  
  figVox <- df %>% dplyr::select(vox, voxnum) %>% unique() %>%
    mutate(vox = fct_reorder(vox, voxnum)) %>% 
    ggplot(aes(x = vox, y=1, fill=voxnum)) +
    geom_bar(position="stack", stat="identity")  +
    scale_fill_gradient(low = "#0033FF", high= "#33FFFF", limits = c(0, max(df$voxnum))) +
    theme(text=element_text(family="Arial"),
          axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks = element_blank(),
          legend.position = "none", 
          panel.grid = element_blank(),
          panel.border = element_blank()) 
  
  fig  <- plot_spacer() +figVox + figCortex + figPC + 
    plot_layout(ncol=2, widths = c(0.03, 1), heights = c(0.03,1))
  #plot_grid(NULL, figVox, figCortex, figPC, rel_widths = c(0.3, 1, 0.3, 1),
  #                rel_heights = c(0.1, 1, 0.1, 1),
  #                 align= c("none", "hv", "hv", "hv"), axis = c("none", "tblr", "tblr", "tblr"), ncol=2)
  
  
  fig_file <- file.path("/project/3022035.03/HCP/stats/DWI_projections", paste0(roi, "_", PC,"_DWI.png"))
  ggsave(fig_file, fig, dpi=300, width=20, height = 12, units = "cm")
  
  return(fig)
}

##############################################################################################

mk_ax_slices <- function(slice) {
  ax <- as.data.frame(MNI@.Data[, , slice])
  ax$y <- paste0("y_", 1:nrow(ax))
  ax_gath <- ax %>% gather("x", "value", -y)
  ax_gath <- ax_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(ax)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(ax))))
  ax_gath$value_scaled <- (ax_gath$value - min(ax_gath$value, na.rm =TRUE))/diff(range(ax_gath$value, na.rm =TRUE))
  return(ax_gath)
}
##############################################################################################
mk_spatial_fig_LEAP <- function(x, nPCs){
  
  df <- mod_gather %>% filter(comp == x)
  fig_comp <- ggplot(df, aes(fill=mod, y=contrib, x=comp)) + 
    geom_bar(position="stack", stat="identity") + coord_flip() + ylab("feature contribution") +
    theme(text=element_text(family="Arial"), legend.position="right", legend.title = element_blank(),
          legend.text = element_text(size = 6), legend.key.size = unit(0.15, "cm"), axis.title.y = element_blank()) +
    scale_fill_brewer(palette="Set3")
  
  #make labels
  df_lab <- mod_gather %>% filter(comp == x)
  df_lab$contrib <- round((df_lab$contrib *100), 2)
  
  df_lab$names <- NA
  df_lab$names[df_lab$mod == "subcortical_dwi"] <- "subcortical DWI"
  df_lab$names[df_lab$mod == "cortical_dwi"] <- "cortical DWI"
  df_lab$names[df_lab$mod == "subcortical_G1"] <- "subcortical fMRI G1"
  df_lab$names[df_lab$mod == "subcortical_G2"] <- "subcortical fMRI G2"
  df_lab$names[df_lab$mod == "cortical_G1"] <- "cortical fMRI G1"
  df_lab$names[df_lab$mod == "cortical_G2"] <- "cortical fMRI G2"
  df_lab$names[df_lab$mod == "VBM"] <- "VBM"
  df_lab$labels <- paste0(df_lab$names, " (", df_lab$contrib, "%)")
  labs <- c("cortical_dwi", "subcortical_dwi", "VBM", "cortical_G1", "cortical_G2", "subcortical_G1", "subcortical_G2") #desired oreder
  df_lab <- df_lab %>%  mutate(mod =  factor(mod, levels = labs)) %>%
    arrange(mod)
  labels <- df_lab$labels
  
  #make title
  title <- ggdraw() + 
    draw_label(x,
               fontface = 'bold',
               size= 14,
               x = 0,
               hjust = 0
    ) +
    theme(
      # add margin on the left of the drawing canvas,
      # so title is aligned with left edge of first plot
      plot.margin = margin(0, 0, 0, 0)
    )
  
  sag_slice <- sag_gath %>% mutate(x = fct_relevel(x, paste0("V", 1:(ncol(sag)-1)))) %>%
    mutate(y = fct_relevel(y, paste0("y_", 1:nrow(sag)))) %>%
    ggplot(aes(x=y, y=x, fill = value)) +
    geom_raster() + scale_fill_gradient(low="black", high="white", na.value = "white") +
    theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(),
          legend.position = "none", panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), panel.background = element_blank())
  
  fig_slice_loc <- sag_slice + geom_hline(aes(yintercept=sAX1, colour= "red")) +
    geom_hline(aes(yintercept=sAX2, colour= "red")) + 
    geom_hline(aes(yintercept=sAX3, colour= "red")) +
    geom_hline(aes(yintercept=sAX4, colour= "red")) +
    geom_hline(aes(yintercept=sAX5, colour= "red")) +
    theme(plot.margin = margin(20, 5.5, 5.5, 0)) +
    coord_fixed()
  
  if (nrow(df) == 7){
    fig_cdwi <- mk_dwi_fig_perIC_LEAP(x, spatial_gath_cort, nPCs, "leg")
    fig_sdwi <- mk_dwi_fig_perIC_LEAP(x, spatial_gath_sub, nPCs, "noleg")
    fig_vbm <- mk_ax_fig_perIC(x, VBM,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_cG1 <- mk_ax_fig_perIC(x, cortG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_cG2 <- mk_ax_fig_perIC(x, cortG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG1 <- mk_ax_fig_perIC(x, subG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG2 <- mk_ax_fig_perIC(x, subG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
    
    pL <- plot_grid(fig_cdwi,fig_sdwi, ncol=1, 
                    align="hv", axis="rl", labels = labels[1:2], 
                    label_size = 7, label_x =0, hjust = 0, rel_heights = c(1,0.8))
    pR <- plot_grid(fig_slice_loc, NULL, ncol=1, rel_heights = c(1,0.8))
    p1 <-plot_grid(pL,pR, ncol=2, 
                   rel_widths = c(1, 0.2), scale= c(1,1), align="h", axis= "b")
    
    p <- plot_grid(p1, fig_vbm, fig_cG1, fig_cG2, fig_sG1, fig_sG2,  ncol = 1, 
                   labels=c("",labels[3:7]),
                   label_size = 7, label_x =0, hjust = 0, rel_heights = c(1.9,1,1,1,1,1))
    
    p_title <- plot_grid(
      title, p, ncol = 1,
      # rel_heights values control vertical title margins
      rel_heights = c(0.03, 1))
    
    p_file <- file.path(outdir, paste0("/spatial_maps/alt_maps/", x,"_full_LO.png"))
    #Cairo(width=12, height=24, units = "cm", dpi=300, file=p_file, type="png", bg="white")
    #p_title
    #dev.off()
    ggsave(p_file, p_title, dpi=300, width=12, height = 24, units = "cm") 
    #return(p_title)
    
  } else if (nrow(df) == 3){
    fig_cdwi <- mk_dwi_fig_perIC(x, spatial_gath_cort, nPCs, "leg")
    fig_sdwi <- mk_dwi_fig_perIC(x, spatial_gath_sub, nPCs, "leg")
    fig_vbm <- mk_ax_fig_perIC(x, VBM,  sAX1, sAX2, sAX3, sAX4, sAX5)
    
    pL <- plot_grid(fig_cdwi,fig_sdwi, ncol=1, 
                    align="hv", axis="rl", labels = labels[1:2], 
                    label_size = 7, label_x =0, hjust = 0, rel_heights = c(1,0.8))
    pR <- plot_grid(fig_slice_loc, NULL, ncol=1, rel_heights = c(1,0.8))
    p1 <-plot_grid(pL,pR, ncol=2, 
                   rel_widths = c(1, 0.2), scale= c(1,1), align="h", axis= "b")
   
     p <- plot_grid(p1, fig_vbm,  ncol = 1, 
                   labels=c(NULL, labels[3]),
                   label_size = 7, label_x =0, hjust = 0, rel_heights = c(1.9,1))
    p_title <- plot_grid(
      title, p, ncol = 1,
      # rel_heights values control vertical title margins
      rel_heights = c(0.03, 1))
    
    p_file <- file.path(outdir, paste0("/spatial_maps/alt_maps/", x,"_full_LO.png"))
    #Cairo(width=12, height=24, units = "cm", dpi=300, file=p_file, type="png", bg="white")
    #p_title
    #dev.off()
    ggsave(p_file, p_title, dpi=300, width=12, height = 12, units = "cm") 
    #return(p_title)
    
  } else if (nrow(df) == 4){
    fig_cG1 <- mk_ax_fig_perIC(x, cortG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_cG2 <- mk_ax_fig_perIC(x, cortG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG1 <- mk_ax_fig_perIC(x, subG1,  sAX1, sAX2, sAX3, sAX4, sAX5)
    fig_sG2 <- mk_ax_fig_perIC(x, subG2,  sAX1, sAX2, sAX3, sAX4, sAX5)
    
    p <- plot_grid(fig_cG1, fig_cG2, fig_sG1, fig_sG2,  ncol = 1, 
                   labels=c(NULL, labels[4]),
                   label_size = 7, label_x =0, hjust = 0, rel_heights = c(1,1,1,1))
    
    p_title <- plot_grid(
      title, p, ncol = 1,
      # rel_heights values control vertical title margins
      rel_heights = c(0.03, 1))
    
    p_file <- file.path(outdir, paste0("/spatial_maps/alt_maps/", x,"_full_LO.png"))
    #Cairo(width=12, height=24, units = "cm", dpi=300, file=p_file, type="png", bg="white")
    #p_title
    #dev.off()
    ggsave(p_file, p_title, dpi=300, width=12, height = 24, units = "cm") 
    #return(p_title)
  }
}

##############################################################################################