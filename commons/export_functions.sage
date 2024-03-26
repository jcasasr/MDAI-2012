###
# Export functions
###

# Export to RRW format
# - g: graph
# - filename: file name
#
def export_to_RRW(g, filename):
    debug = False;
    
    if(debug):
        logging.debug("Export to RRW: "+filename);
    
    # open file
    f1 = open(filename, "w");
    
    # export
    for e in g.edges():
        source = e[0];
        target = e[1];
        value = e[2];
        if value == {}:
            value = 1;
        f1.write(str(source) +"\t"+ str(target) +"\t"+ str(value) +"\n");
    
    f1.close();
    
    logging.info("[DONE]Export to RRW");
    return 1;


# Export to MCL format
# - g: graph
# - filename: file name
#
def export_to_MCL(g, filename):
    debug = False;
    
    if(debug):
        logging.debug("Export to MCL: "+filename);
    
    # open file
    f1 = open(filename, "w");
    
    # export
    for e in g.edges():
        source = e[0];
        target = e[1];
        value = e[2];
        if value == {}:
            value = "";
        f1.write(str(source) +" "+ str(target) +" "+ str(value) +"\n");
    
    f1.close();
    
    if(debug):
        logging.debug("[DONE]Export to MCL");
    
    return 1;


# Export to SPARSE6 format
# - g: graph
# - filename: file name
#
def export_to_Sparse6(g, filename):

    logging.debug("Export to Sparse6");
    
    # open file
    f1 = open(filename, "w");
    
    # export
    f1.write(g.sparse6_string());
    
    f1.close();
    
    logging.info("[DONE]Export to Sparse6");
    return 1;


# Export to    GRAPHVIZ format
# -    g: graph
# -    filename: file name
#
def export_to_Graphviz(g, filename):
    
    logging.debug("Export to Graphviz");
    
    # open file
    f1 = open(filename, "w");
    
    # edge labels?
    edgelabels = True;
    
    if g.edges()[0][2] == {}:
        edgelabels = False;

    
    # export
    f1.write(g.graphviz_string(edge_labels=edgelabels));
    
    f1.close();
    
    logging.info("[DONE]Export to Graphviz");
    return 1;



# Exporta un grafo SAGE a un archivo
# - G: grafo en formato SAGE
# - file: Nombre del fichero
def export_to_GML(G,file):
    debug = False;
    
    if(debug):
        logging.debug("Export to GML: "+filename);
    
    f1 = open(file,"w");
    f1.write("graph ["+"\n");
    
    for n in G.vertices():
        f1.write("\t"+"node ["+"\n");
        f1.write("\t\t"+"id "+ str(n)+"\n");
        f1.write("\t\t"+"label \""+ str(n)+"\"\n");
        f1.write("\t"+"]"+"\n");
        
    f1.write("\n");
    
    for e in G.edges():        
        key=str(e[0])+"-"+str(e[1])
        f1.write("\t"+"edge ["+"\n");
        f1.write("\t\t"+"source " + str(e[0])+"\n");
        f1.write("\t\t"+"target " + str(e[1])+"\n");
        f1.write("\t\t"+"label \""+ key+"\"\n");
        f1.write("\t"+"]"+"\n");
        
    f1.write("]");
    
    f1.close();
    
    if(debug):
        logging.debug("[DONE]Export to GML");


# Exporta un grafo SAGE a un archivo GraphML
# - G: grafo en formato SAGE
# - file: Nombre del fichero
def export_to_GraphML(G,file):
    logging.debug("Export to GraphML");
    
    f1 = open(file,"w");
   
    f1.write("<graphml>\n");
    f1.write("\t"+"<graph>\n");

    
    for n in G.vertices():
        f1.write("\t\t"+"<node id=\""+ str(n)+"\"/>"+"\n");
        
    f1.write("\n");
    
    for e in G.edges():
        key=str(e[0])+"-"+str(e[1])
        f1.write("\t\t"+"<edge id=\""+key +"\" source=\"" + str(e[0])+"\" target=\"" + str(e[1])+"\" directed=\"true\">\n");
        f1.write("\t\t\t<data key=\"d"+key+"\">"+str(e[2])+"</data>\n");
        f1.write("\t\t</edge>\n");        
    f1.write("\t"+"</graph>\n");
    f1.write("</graphml>");
    
    f1.close();
    
    logging.debug("[DONE]Export to GraphML");
    
    
# Exporta un grafo SAGE a un archivo Pajek NET
# - G: grafo en formato SAGE
# - file: Nombre del fichero
def export_to_PajekNET(G,file):
    logging.debug("Export to Pajek NET");
    
    f1 = open(file,"w");
   
    f1.write("*Vertices "+str(G.num_verts())+"\n");
    for n in G.vertices():
        f1.write(str(n)+" \""+str(n)+"\"\n");
        
    f1.write("\n");
    f1.write("*arcs\n");
    
    for e in G.edges():
        f1.write(str(e[0])+" "+str(e[1])+" "+str(e[2])+"\n");
    
    f1.close();
    
    logging.debug("[DONE]Export to Pajek NET");


def export_to_AdjacencyMatrix(G,file):
    debug = False;
    
    if(debug):
        logging.debug("Export to Adjacency Matrix");
    
    f1 = open(file,"w");
   
    f1.write(str(G.num_verts())+"\n");
    f1.write(str(G.num_edges())+"\n");
    
    A = G.adjacency_matrix();
    
    for i in range(A.nrows()):
        for j in range(A.ncols()):
            f1.write(str(A[i,j]));
            if(j<A.ncols()-1):
                f1.write(";");
        f1.write("\n");
    
    f1.close();
    
    if(debug):
        logging.debug("[DONE]Export to Adjacency Matrix");


def export_to_TxtFile(G,file):
    debug = False;
    
    if(debug):
        logging.debug("Export to Text File");
    
    f1 = open(file,"w");
   
    f1.write(str(G.num_verts())+"\n");
    f1.write(str(G.num_edges())+"\n");
    
    dif = 0;
    if(G_original.has_vertex(0)):
        dif = 1;
    
    edges = G.edges();
    
    for e in edges:
        f1.write(str(e[0]+dif)+" "+str(e[1]+dif)+"\n");
    
    f1.close();
    
    if(debug):
        logging.debug("[DONE]Export to Text File");
