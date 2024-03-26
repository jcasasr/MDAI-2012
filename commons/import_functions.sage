###
# Import functions to create graphs
###

#Importamos el modulo
from xml.dom import minidom


# Import from SPARSE6 format
# - filename: file name
#
def import_from_Sparse6(filename):
    
    logging.debug("Import " + filename + "[Sparse6]");
    # open file
    f1 = open(dir + filename, "r");
    
    # import
    g = Graph(f1.read(), weighted=True);
    
    f1.close();
    
    return g;


# Import from GML format
# - filename: file name
#
def create_from_GML(filename):
    
    logging.debug("Import " + filename + "[GML]");
    # crear grafo vacio
    g1 = graphs.EmptyGraph();
    # informar
    g1.allow_loops(False);
    g1.allow_multiple_edges(False);
    g1.weighted(False);
    # contadores
    num_nodos = 0;
    num_aristas = 0;
    num_isertadas = 0;
    num_repetidas = 0;
    
    # abrir fichero para lectura
    f = open(filename,'r');
    
    l = nueva_linia(f);
    
    while len(l) > 0:
        
        if l.startswith('node'):
            #nueva_linia(f);
            l = nueva_linia(f);
            if l.startswith('id') == True:
                l_id = l[3:len(l)];
            l_label = nueva_linia(f);
            #l_value = nueva_linia(f);
            nueva_linia(f);
            
            #print("*** node: "+str(l_id));
            num_nodos = num_nodos + 1;
            
            g1.add_vertex(int(l_id));
        
        if l.startswith('edge'):
            #nueva_linia(f);
            l = nueva_linia(f);
            if l.startswith('source') == True:
                l_source = l[7:len(l)];
            l = nueva_linia(f);
            if l.startswith('target') == True:
                l_target = l[7:len(l)];
            nueva_linia(f);
            
            arista = (int(l_source), int(l_target),{});
            num_aristas = num_aristas + 1;
            
            #print("+++ edge: "+str(arista));
            
            if g1.has_edge(arista):
                num_repetidas = num_repetidas + 1;
                print("    duplicate edge: "+str(arista));
            
            if not(g1.has_edge(arista)):
                g1.add_edge(arista);
                num_isertadas = num_isertadas + 1;
        
        l = nueva_linia(f);
    
    print("NODES = "+str(num_nodos));
    print("EDGES = "+str(num_aristas));
    print("INSERTED EDGES = "+str(num_isertadas));
    print("DUPLICATE EDGES = "+str(num_repetidas));
    
    return g1;

# Create new line in a a file (aux function)
# - f: file name
#
def nueva_linia(f):
    l = f.readline();
    l = l.lstrip();
    l = l.rstrip();
    
    return l;


# Import from NET format
# - filename: file name
#
def create_from_NET(filename):
    
    logging.debug("Import " + filename + "[NET]");
    # crear grafo vacio
    g1 = graphs.EmptyGraph();
    # informar
    g1.allow_loops(False);
    g1.allow_multiple_edges(False);
    g1.weighted(True);
    
    #
    f = open(filename,'r');
    
    l = nueva_linia(f);
    num_duplicats = 0;
    
    while len(l) > 0:
        
        if l.startswith('*'):
            print(str(l));
        
        if not(l.startswith('*')):
            l_source = l.split()[0];
            l_target = l.split()[1];
            
            if not(g1.has_vertex(l_source)):
                g1.add_vertex(int(l_source));
            if not(g1.has_vertex(l_target)):
                g1.add_vertex(int(l_target));
            
            if g1.has_edge(int(l_source), int(l_target),{}):
                num_duplicats += 1;
            
            g1.add_edge(int(l_source), int(l_target),{});
            
            print("+++ edge: ("+str(l_source)+","+str(l_target)+",{})")
        
        l = nueva_linia(f);
    
    print("Num duplicats="+str(num_duplicats));
    
    return g1;

#
#
def create_from_GraphML(filename):
    
	logging.debug("Import " + filename + "[GraphML]");

	# crear grafo vacio
	g1 = graphs.EmptyGraph();
	# informar
	g1.allow_loops(False);
	g1.allow_multiple_edges(False);

	g1.weighted(True);

	dom = minidom.parse(filename)

	#Leemos los nodos
	elements = dom.getElementsByTagName("node")
	if len(elements) > 0:
            for n in elements:
                vertex=n.attributes["id"].value
                logging.debug(str(vertex));
                g1.add_vertex(int(vertex));
	else:
            logging.error("ERROR: No tiene nodos")

	#Leemos los ejes
	elements = dom.getElementsByTagName("edge")
	if len(elements) > 0:
            for n in elements:
                id = n.attributes["id"].value
                source = n.attributes["source"].value
                target = n.attributes["target"].value
                if n.hasChildNodes:
                    data = n.getElementsByTagName("data")[0]			
                    peso =  data.lastChild.nodeValue
                else:
                    peso = 1

                logging.debug(str(id)+":"+str(source)+"->"+str(target)+ " peso="+str(peso))

                g1.add_edge(int(source), int(target),int(peso));
	else:
            logging.error("ERROR: No tiene edges")

	return g1

#
#
def create_from_GraphVizDot(filename):
    # crear grafo vacio
    g1 = graphs.EmptyGraph();
    # informar
    g1.allow_loops(False);
    g1.allow_multiple_edges(False);
    logging.debug("Import " + filename + "[GraphVizDot]");
    
    f = open(filename,'r');
    
    for l in f:
        l = l.lstrip();
        l = l.rstrip();
        l.replace("\t","");
        l.replace("  "," ");
        tags = l.split(" ");
        print tags
        if len(tags) > 0:
            peso = 1
            print "Origen:"+str(tags[0]);
            if len(tags) > 1:
                #if	tags[1]=="--":
                #	print "--"+str(tags[2]);
                #elif tags[1]=="->":				
                #	print "->"+str(tags[2]);
        
                if len(tags) > 2:
                    tagPeso = tags[3].lower();
                    if "label" in tagPeso:
                        tagPeso=tagPeso.replace("[","");
                        tagPeso=tagPeso.replace("]","");
                        tagPeso=tagPeso.replace("data","");
                        tagPeso=tagPeso.replace("=","");
                        tagPeso=tagPeso.replace("\"","");
                        print "Otros:"+tagPeso;
        
                g1.add_edge(int(tags[0]), int(tags[1]),int(peso));

	logging.debug("[DONE]Import " + filename + "[GraphVizDot]");
	return g1


# Import from Adjacency Matrix format
# - A: Adjacency matrix
#
def create_from_AdjacencyMatrix(A):
    
    logging.debug("Generating Graph from matrix");
    # crear grafo vacio
    g1 = graphs.EmptyGraph();
    # informar
    g1.allow_loops(False);
    g1.allow_multiple_edges(False);
    g1.weighted(False);
    
    i_max = A.nrows();
    j_max = A.ncols();
    
    # add vertices
    for i in range(i_max):
        g1.add_vertex(i);
    
    # add edges
    for i in range(i_max):
        for j in range(i+1, j_max):
            if A[i,j]==1:
                arista = (i,j,{});
                g1.add_edge(arista);
    
    return g1;
 
