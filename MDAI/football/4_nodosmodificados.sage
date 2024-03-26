load("globals.sage");
load("../commons/graphs_functions.sage");
load("../commons/utils_list.sage");
load("../commons/print_info.sage");
load("../commons/utils_dict.sage");


rp_graphs[1] = [G_original];
gga_graphs[1] = [G_original];

#####################
# edge intersection #
#####################
rp_edge_int = [(1,100)];
gga_edge_int = [(1,100)];

f1 = open(subdir_results +"edge_intersection.log","w");

num_ori = G_original.num_edges();

for i in range(len(rp_graphs)):
    f1.write("K="+str(i)+"\n");
    
    if not(rp_graphs[i] == []):
        dif = edge_intersection(G_original, rp_graphs[i][0]);
        dif_per = round(dif/num_ori*100,2);
        rp_edge_int.append((i,dif_per));
        f1.write("   RP="+str(dif)+"/"+str(num_ori)+" --> "+str(dif_per)+"% \n");

    if not(gga_graphs[i] == []):
        dif = edge_intersection(G_original, gga_graphs[i][0]);
        dif_per = round(dif/num_ori*100,2);
        gga_edge_int.append((i,dif_per));
        f1.write("   GGA="+str(dif)+"/"+str(num_ori)+" --> "+str(dif_per)+"% \n");

f1.close();

# grafica de los totales
fig_rp = list_plot(rp_edge_int, plotjoined=true, color=plot_color_randPertur, linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_edge_int, plotjoined=true, color=plot_color_randSwitch, linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Edge intersection (%)']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"edge_intersection.png", frame=false, ymin=75, ymax=100);

# grafica de los totales color
fig_rp = list_plot(rp_edge_int, plotjoined=true, color=colors[0], linestyle=plot_style_randPertur, legend_label='RP');
fig_gga = list_plot(gga_edge_int, plotjoined=true, color=colors[1], linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_gga);
figure.axes_labels(['K','Edge intersection (%)']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"edge_intersection-color.png", frame=false, ymin=75, ymax=100);
