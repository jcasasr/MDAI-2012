load("globals.sage");
load("../commons/graphs_functions.sage");
load("../commons/utils_list.sage");
load("../commons/print_info.sage");
load("../commons/utils_dict.sage");


rp_graphs[1] = [G_original];
gga_graphs[1] = [G_original];

##################
# average degree #
##################
rp_avdegree = [];
gga_avdegree = [];

for i in range(len(rp_graphs)):
    if not(rp_graphs[i] == []):
        value = rp_graphs[i][0].average_degree();
        rp_avdegree.append((i,value));
        
    if not(gga_graphs[i] == []):
        value = gga_graphs[i][0].average_degree();
        gga_avdegree.append((i,value));


# grafica de los totales
fig_rp = list_plot(rp_avdegree, plotjoined=true, color=plot_color_randPertur, linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_avdegree, plotjoined=true, color=plot_color_randSwitch, linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Average degree']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"average_degree.png", frame=false);

# grafica de los totales color
fig_rp = list_plot(rp_avdegree, plotjoined=true, color=colors[0], linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_avdegree, plotjoined=true, color=colors[1], linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Average degree']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"average_degree-color.png", frame=false);

####################
# average distance #
####################
rp_avdegree = [];
gga_avdegree = [];

for i in range(len(rp_graphs)):
    if not(rp_graphs[i] == []):
        value = rp_graphs[i][0].average_distance();
        rp_avdegree.append((i,value));
        
    if not(gga_graphs[i] == []):
        value = gga_graphs[i][0].average_distance();
        gga_avdegree.append((i,value));


# grafica de los totales
fig_rp = list_plot(rp_avdegree, plotjoined=true, color=plot_color_randPertur, linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_avdegree, plotjoined=true, color=plot_color_randSwitch, linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Average distance']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"average_distance.png", frame=false);

# grafica de los totales color
fig_rp = list_plot(rp_avdegree, plotjoined=true, color=colors[0], linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_avdegree, plotjoined=true, color=colors[1], linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Average distance']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"average_distance-color.png", frame=false);

############
# diameter #
############
rp_avdegree = [];
gga_avdegree = [];

for i in range(len(rp_graphs)):
    if not(rp_graphs[i] == []):
        value = rp_graphs[i][0].diameter();
        rp_avdegree.append((i,value));
        
    if not(gga_graphs[i] == []):
        value = gga_graphs[i][0].diameter();
        gga_avdegree.append((i,value));


# grafica de los totales
fig_rp = list_plot(rp_avdegree, plotjoined=true, color=plot_color_randPertur, linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_avdegree, plotjoined=true, color=plot_color_randSwitch, linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Diameter']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"diameter.png", frame=false);

# grafica de los totales colors
fig_rp = list_plot(rp_avdegree, plotjoined=true, color=colors[0], linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_avdegree, plotjoined=true, color=colors[1], linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Diameter']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"diameter-color.png", frame=false);
