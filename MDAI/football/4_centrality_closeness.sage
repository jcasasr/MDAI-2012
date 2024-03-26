# import
load("globals.sage");
load("../commons/print_info.sage");
load("../commons/utils_list.sage");
load("../commons/utils_dict.sage");

# LOAD
rp_graphs = load(subdir_tmp+"rp_graphs");
gga_graphs = load(subdir_tmp+"gga_graphs");

##########################
# Closeness CENTRALITY #
##########################

logging.debug("Closeness centrality");

valores_rp_totales = [];
valores_gga_totales = [];
valores_rp_rms = [];
valores_gga_rms = [];

# Original
valores_ori = dict_to_list(G_original.centrality_closeness());
fig_ori = list_plot(valores_ori, plotjoined=true, color='grey', legend_label='Original');

valores_rp_totales.append(list_average(valores_ori));
valores_gga_totales.append(list_average(valores_ori));
valores_rp_rms.append(0);
valores_gga_rms.append(0);

# Data
def getData(graphs):
    res = [];
    for i in range(len(graphs)):
        if not(graphs[i] == []):
            g = graphs[i][0];
            res.append(dict_to_list(g.centrality_closeness()));
        if graphs[i] == []:
            res.append([]);
    
    return res;

logging.debug("RP Closeness centrality..." );
rp_bc = getData(rp_graphs);

logging.debug("GGA Closeness centrality..." );
gga_bc = getData(gga_graphs);

def getRMS(valores_ori, data):
    res = [];
    for i in range(len(data)):
        logging.debug("RMS ["+ str(i) +"/"+ str(len(data)) +"]" );
    
        # calcular RMS
        if not(data[i] == []):
            res.append(lists_RMS(valores_ori, data[i]));
        if data[i] == []:
            res.append([]);
    
    return res;

logging.debug("calculating RP RMS..." );
rp_rms = getRMS(valores_ori, rp_bc);
rp_rms[1] = 0;

logging.debug("calculating GGA RMS..." );
gga_rms = getRMS(valores_ori, gga_bc);
gga_rms[1] = 0;

# PLOT

def makePrintablePoints(a):
    res = [];

    for i in range(len(a)):
        if not(a[i]==[]):
            res.append((i,a[i]));

    return res;

## grafica de los totales
#fig_rp = list_plot(asd(valores_rp_totales), plotjoined=true, color=plot_color_randPertur, linestyle=plot_style_randPertur, legend_label='RP');
#fig_rs = list_plot(asd(valores_gga_totales), plotjoined=true, color=plot_color_randSwitch, linestyle=plot_style_randSwitch, legend_label='GGA');
#figure = (fig_rp + fig_rs);
#figure.axes_labels(['%','Betweenness centrality AV']);
#figure.set_legend_options(loc=0);
#figure.set_legend_options(font_size=tamano_fuente_legend);
#figure.fontsize(tamano_fuente);
#figure.save(subdir_results +"result_BC_todos_promedio.png", frame=false);

# grafica RMS
fig_rp = list_plot(makePrintablePoints(rp_rms), plotjoined=true, color=plot_color_randPertur, linestyle=plot_style_randPertur, legend_label='RP');
fig_rs = list_plot(makePrintablePoints(gga_rms), plotjoined=true, color=plot_color_randSwitch, linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_rs);
figure.axes_labels(['k','Closeness centrality RMS']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"result_CC_RMS.png", frame=false);

# grafica RMS color
fig_rp = list_plot(makePrintablePoints(rp_rms), plotjoined=true, color=colors[0], linestyle=plot_style_randPertur, legend_label='RP');
fig_rs = list_plot(makePrintablePoints(gga_rms), plotjoined=true, color=colors[1], linestyle=plot_style_randSwitch, legend_label='GGA');
figure = (fig_rp + fig_rs);
figure.axes_labels(['k','Closeness centrality RMS']);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"result_CC_RMS-color.png", frame=false);

logging.debug("[DONE] Closeness centrality");
