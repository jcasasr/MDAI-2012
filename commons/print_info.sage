load("../commons/utils.sage");
load("../commons/utils_dict.sage");

###
# Print graph info
###


# muestra informacion completa del grafo
# - g: grafo
#
def graph_info_complete(g, i, j, name, plot_color):
    graph_info(g, name +"["+ str(i) +"-"+ str(j) +"]", subdir_results_graphprop, name +"_"+ str(i) +"_"+ str(j));
    histogram_compare(G_original, g, subdir_results_graphprop, name +"_"+ str(i) +"_"+ str(j), plot_color);


# muestra informacion del grafo
# - g: grafo
#
def graph_info(g, descripcion, subdir, name):
    # write to file
    f1 = open(subdir + name +"_info.log","w");

    f1.write("Datos del grafo: "+ descripcion +"\n");
    f1.write("----------------\n");
    f1.write("   + Caracteristicas basicas: "+ str(g.num_verts()) +" nodos y "+ str(g.num_edges()) +" aristas \n");
    f1.write("   + Average degree = "+ str(round(g.average_degree(), 3)) +"\n");
    try:
        f1.write("   + Average distance = "+ str(round(g.average_distance(), 3)) +"\n");
    except:
        f1.write("   + Average distance = <ERROR>\n");

    f1.write("   + Diameter = "+ str(g.diameter()) +"\n");
    # degree histogram
    g_dh = g.degree_histogram();
    f1.write("   + Degree histogram = "+ str(g_dh) +"\n");
    f1.write("   + k-anonymity value = "+ str(getKAnonymityValueFromDegreeSequence(g.degree_sequence())) +"\n");

    fig1 = bar_chart(g_dh, width=0.6, rgbcolor=(0.8, 0.8, 0.8));
    fig1.axes_labels(['Degree','Number of nodes']);
    fig1.set_legend_options(font_size=tamano_fuente_legend);
    fig1.fontsize(tamano_fuente);
    # params: figsize=[12,4]
    fig1.save(subdir + name + "_degree_histogram.png", figsize=[12,4]);

    # close file descriptor
    f1.close();


# compara el histograma de grados
# - g_original: grafo original
# - g: grafo
#
def histogram_compare(g_original, g, subdir, name, plot_color):
    # degree histogram
    g_original_hist = g_original.degree_histogram();
    g_hist = g.degree_histogram();

    if(len(g_original_hist) > len(g_hist)):
        for i in range(len(g_original_hist) - len(g_hist)):
            g_hist.append(0);

    if(len(g_hist) > len(g_original_hist)):
        for i in range(len(g_hist) - len(g_original_hist)):
            g_original_hist.append(0);

    # plot
    fig1 = bar_chart(g_original_hist, width=0.6, rgbcolor=(0.8, 0.8, 0.8), legend_label='Original');
    fig2 = bar_chart(g_hist, width=0.3, color=plot_color, legend_label='Anonimizado');
    figure = (fig1 + fig2);
    figure.axes_labels(['Grado','# Nodos']);
    figure.set_legend_options(loc=0);
    figure.set_legend_options(font_size=tamano_fuente_legend);
    figure.fontsize(tamano_fuente);
    #params: figsize=(12,4)
    figure.save(subdir + name + "_degree_histogram_compared.png");


# centrality betweenness comparacion
# - g_original: grafo original
# - g: grafo
#
def centrality_betweenness_compare(g_original, g, subdir, name, plot_color):
    g_original_cb = g_original.centrality_betweenness();
    g_cb = g.centrality_betweenness();

    # plot
    fig1 = list_plot(g_original_cb, plotjoined=true, color='grey', legend_label='Original');
    fig2 = list_plot(g_cb, plotjoined=true, color=plot_color, legend_label='Anonimizado');
    figure = (fig1 + fig2);
    figure.axes_labels(['Num. nodo', 'Betweenness centrality']);
    figure.set_legend_options(loc=0);
    figure.set_legend_options(font_size=tamano_fuente_legend);
    figure.fontsize(tamano_fuente);
    figure.save(subdir + name + "_centrality_betweenness_compared.png");


# Calcula los 'tipos' para un array bidimensional de grafos
# - G: array bidimensional de grafos
# - tipo: 'centrality_betweenness', 'centrality_closeness','centrality_degree'
#
def obtener_valores(G, tipo):
    valores = [];

    for i in range(len(G)):
        valores_TMP = [];
        for j in range(len(G[i])):
            if tipo=='centrality_betweenness':
                valores_TMP.append(dict_to_list(G[i][j].centrality_betweenness()));
            if tipo=='centrality_closeness':
                valores_TMP.append(dict_to_list(G[i][j].centrality_closeness()));
            if tipo=='centrality_degree':
                valores_TMP.append(dict_to_list(G[i][j].centrality_degree()));

        valores.append(valores_TMP);

    return valores;

def get_CentralityMeasure(graphs, type):
    valores1 = [];
    
    # calcular el valor
    for k in graphs:
        tmp = [];
        for g in k:
            
            if type=='centrality_betweenness':
                tmp.append(g.centrality_betweenness());
            if type=='centrality_closeness':
                tmp.append(g.centrality_closeness());
            if type=='centrality_degree':
                tmp.append(g.centrality_degree());
        
        valores1.append(tmp);
        
    valores = [];
    
    # realizar el calculo del promedio
    for s in valores1:
        tmp = [];
        total = len(s);
        for v in s:
            tmp = sum_lists(tmp, v);
        tmp = div_list(tmp,total);
        
        valores.append(tmp);
        
    return valores;


# Obtiene el valor promedio de un conjunto tridimensional
# - j: numero de muestra en la segunda dimension
#
# TODO: cal canviar el valor del bucle z entre 0 i 1 segons l'id del primer node del graf
# Automatitzar aixo!!!!
#
def obtener_promedio(valores, j):
    # vars
    len_i = len(valores);
    len_z = len(valores[0][0]);

    # results
    promedios = [];

    #for z in range(1,len_z+1):
    for z in range(len_z):
        valor = 0;

        for i in range(len_i):
            valor += valores[i][j][z];

        #promedios.append(round(valor/len_i, 3));
        promedios.append(valor/len_i);

    return promedios;

#
#
#
def print_tablas(t1, t1name, t2, t2name, filename):
    f1 = open(subdir_results + filename +".csv","w");
    
    # header
    f1.write(";");
    for i in range(1,len(t1)):
        f1.write("k="+ str(i) +";");
    f1.write("\n");
    f1.flush();

    # row 1
    f1.write(t1name +";");
    for i in range(1,len(t1)):
        f1.write(str(t1[i]) +";");
    f1.write("\n");
    f1.flush();
    
    # row 2
    f1.write(t2name +";");
    for i in range(1,len(t2)):
        f1.write(str(t2[i]) +";");
    f1.write("\n");
    f1.flush();
    
    f1.close();
