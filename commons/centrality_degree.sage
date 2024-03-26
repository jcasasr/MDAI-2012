# import
load("../commons/print_info.sage");
load("../commons/utils_list.sage");
load("../commons/utils_dict.sage");

# calcula el DC de un grafo
# @G: grafo
# @name: nombre utilizado para almacenar datos intermedios
#
def getDCValues(G, name):
    valores = [];

    for i in range(len(G)):
        valores_TMP = [];
        for j in range(len(G[i])):
            logging.debug("   calculating graph["+str(i)+","+str(j)+"]...");
            valores_TMP.append(dict_to_list(G[i][j].centrality_degree()));
            save(valores_TMP, subdir_tmp_details + name +"-DC-"+str(i)+"-"+str(j));
            
        valores.append(valores_TMP);
        save(valores_TMP, subdir_tmp_details + name +"-DC-"+str(i)+"-All");
    
    save(valores, subdir_tmp + name +"-DC");

    return valores;

#
#
def getDC(G_original, graphs, name):
    size_x = len(graphs);
    size_y = 0;
    if size_x > 0:
        size_y = len(graphs[0]);
    
    # calcular valores
    logging.debug("starting "+name+" Degree Centrality..." );
    logging.debug("   size "+name+" "+str(size_x)+" x "+str(size_y));
    valores = getDCValues(graphs, name);
    logging.debug("   ...done!");
    # variables
    valores_totales = [];
    valores_ori = dict_to_list(G_original.centrality_degree());
    valores_totales.append(average_list(valores_ori));
    valores_rms = [];
    valores_rms.append(0);

    # obtener promedios
    for j in range(num_items):
        logging.debug("average of row ["+ str(j) +"/"+ str(num_items) +"]" );
        # promedio
        valores_promedio = obtener_promedio(valores, j);
        # calculos totales
        valores_totales.append(average_list(valores_promedio));
        # calcular RMS
        valores_rms.append(lists_RMS(valores_ori, valores_promedio));
    
    save(valores_totales, subdir_tmp + name +"-DC-totals");
    save(valores_rms, subdir_tmp + name +"-DC-RMS");
    
    return valores_rms;
