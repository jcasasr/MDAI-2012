############################################
# Utils functions which can be used anywhere
############################################
import csv;

# @DEPRECATED
# calcula el numero de items de un array
# - set: array
#
def calcular_num_items(set):
    num_total_items = 0;
    for i in range(len(set)):
        num_total_items += len(set[i]);

    return num_total_items;

def sum_lists(list1, list2):
    return lists_sum(list1, list2);

def div_list(vector, div):
    return list_div(vector, div);

# @DEPRECATED
# realizar el calculo del promedio
# @list:
#
def average_list_items(list):
    valores = [];
    
    for items in list:
        tmp = 0;
        total = len(items);
        for item in items:
            tmp += item;
        if total > 0:
            tmp = round(tmp / total, 3);
        
        valores.append(tmp);
        
    return valores;

# @DEPRECATED
# realizar el calculo del promedio
# @list: [1,2,3,4]
# @return: double
#
def average_list(list):
    total = 0;
    qtt = len(list);
    
    for item in list:
        total += item;
        
    return round(total/qtt, 6);

# @DEPRECATED
def crear_lista_punts_plot(llista):
    res = [];
    
    for i in range(len(llista)):
        if llista[i] > 0:
            res.append((i,llista[i]));
            
    return res;


# Import data file
# - filename: file name
#
def import_from_txtfile(filename):
    logging.debug("Import from TXT file: " + filename);
    
    res = [];
    
    # abrir fichero para lectura
    f = open(filename,'r');
    
    l = nueva_linia(f);
    while len(l) > 0:
        res.append(float(l));
        l = nueva_linia(f);
    
    return res;

# Create new line in a a file (aux function)
# - f: file name
#
def nueva_linia(f):
    l = f.readline();
    l = l.lstrip();
    l = l.rstrip();
    
    return l;

# Export data to txt file
#
def export_to_txtfile(data, filename):
    logging.debug("Export to TXT file: " + filename);
    
    # abrir fichero para escritura
    f = open(filename,'w');
    
    for d in data:
        f.write(str(d)+"\n")
    
    f.close();

# Export data to CSV file
#
def export_to_csvfile(data, filename):
    logging.debug("Export to CSV file: " + filename);
    
    # abrir fichero para escritura
    writefile = csv.writer(open(filename, 'w'))
    
    for i in range(0,len(data)): 
        writefile.writerow(data[i]);

