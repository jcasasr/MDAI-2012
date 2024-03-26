load("../commons/import_functions.sage");
load("../commons/export_functions.sage");

#################################################
# Script to convert graph in differents formats #
#################################################

# Convierte un grafo 'networkx' a un grafo 'graphs'
# - G: grafo 'networkx'
#
def networkx_to_graphs(G):
    logging.debug("Convert networkx to graphs ");
    # crear grafo vacio
    g1 = graphs.EmptyGraph();
    # informar
    g1.allow_loops(False);
    g1.allow_multiple_edges(False);
    g1.weighted(True);
    
    # copiar los nodos
    for n in G.nodes():
        g1.add_vertex(n);
    
    # copiar las aristas
    for e in G.edges():
        g1.add_edge(e);
    logging.info("[DONE]Convert networkx to graphs");
    
    return g1;
	
#Conversiones desde GML
# - file1, nombre del archivo origen en GML
# - file2, nombre del archivo destino
def convert_GML_to_GraphML(file1,file2):
    logging.debug("Convert: "+file1+"[GML]-> "+file2+"[GraphML]");
    g=create_from_GML(file1);
    export_to_GraphML(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[GML]-> "+file2+"[GraphML]");

def convert_GML_to_PajekNET(file1,file2):
    logging.debug("Convert: "+file1+"[GML]-> "+file2+"[PajekNET]");
    g=create_from_GML(file1);
    export_to_PajekNET(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[GML]-> "+file2+"[PajekNET]");

def convert_GML_to_Graphviz(file1,file2):
    logging.debug("Convert: "+file1+"[GML]-> "+file2+"[Graphviz]");
    g=create_from_GML(file1);
    export_to_Graphviz(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[GML]-> "+file2+"[Graphviz]");




#Conversiones desde GraphML
# - file1, nombre del archivo origen en GraphML
# - file2, nombre del archivo destino	
def convert_GraphML_to_GML(file1,file2):
    logging.debug("Convert: "+file1+"[GraphML]-> "+file2+"[GML]");
    g=create_from_GraphML(file1);
    export_to_GML(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[GraphML]-> "+file2+"[GML]");


def convert_GraphML_to_PajekNET(file1,file2):
    logging.debug("Convert: "+file1+"[GraphML]-> "+file2+"[PajekNET]");
    g=create_from_GraphML(file1);
    export_to_PajekNET(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[GraphML]-> "+file2+"[PajekNET]");

def convert_GraphML_to_Graphviz(file1,file2):
    logging.debug("Convert: "+file1+"[GraphML]-> "+file2+"[Graphviz]");
    g=create_from_GraphML(file1);
    export_to_Graphviz(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[GraphML]-> "+file2+"[Graphviz]");


#Conversiones desde PajekNET
# - file1, nombre del archivo origen en PajekNET
# - file2, nombre del archivo destino	
def convert_PajekNET_to_GML(file1,file2):
    logging.debug("Convert: "+file1+"[PajekNET]-> "+file2+"[GML]");
    g=create_from_NET(file1);
    export_to_GML(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[PajekNET]-> "+file2+"[GML]");

def convert_PajekNET_to_GraphML(file1,file2):
    logging.debug("Convert: "+file1+"[PajekNET]-> "+file2+"[GraphML]");
    g=create_from_NET(file1);
    export_to_GraphML(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[PajekNET]-> "+file2+"[GraphML]");

def convert_PajekNET_to_Graphviz(file1,file2):
    logging.debug("Convert: "+file1+"[PajekNET]-> "+file2+"[Graphviz]");
    g=create_from_NET(file1);
    export_to_PajekNET(g,file2);
    logging.debug("[DONE]Convert: "+file1+"[PajekNET]-> "+file2+"[Graphviz]");
