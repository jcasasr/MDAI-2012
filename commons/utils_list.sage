##################
# LIST FUNCTIONS #
##################

# Suma dos listas (pueden ser de distinto tama–o)
# @list1: [a,b,c]
# @list2: [d,e,f,g]
# @return: list (con el tama–o de la mayor)
def lists_sum(list1, list2):
    i_max = max(len(list1), len(list2));
    res = [];
    
    for i in range(i_max):
        value1 = 0;
        if len(list1) > i:
            value1 = list1[i];
            
        value2 = 0;
        if len(list2) > i:
            value2 = list2[i];
         
        res.append(value1 + value2);
        
    return res;

def lists_sum_multiples(listOfLists):
    res = [];
    
    for l in listOfLists:
        res = lists_sum(res, l);
        
    num_total = len(listOfLists);
    res = list_divide(res, num_total);
    
    return res;

# Resta en valor absoluto dos listas (pueden ser de distinto tama–o)
# @list1: [a,b,c]
# @list2: [d,e,f,g]
# @return: list (con el tama–o de la mayor)
def lists_diff_valorabsoluto(list1, list2):
    i_max = max(len(list1), len(list2));
    res = [];
    
    for i in range(i_max):
        value1 = 0;
        if len(list1) > i:
            value1 = list1[i];
            
        value2 = 0;
        if len(list2) > i:
            value2 = list2[i];
         
        res.append(abs(value1 - value2));
        
    return res;

# Resta dos listas (pueden ser de distinto tama–o)
# @list1: [a,b,c]
# @list2: [d,e,f,g]
# @return: list (con el tama–o de la mayor)
def lists_diff(list1, list2):
    i_max = max(len(list1), len(list2));
    res = [];
    
    for i in range(i_max):
        value1 = 0;
        if len(list1) > i:
            value1 = list1[i];
            
        value2 = 0;
        if len(list2) > i:
            value2 = list2[i];
         
        res.append(value1 - value2);
        
    return res;

# Calcula la distancia cuadratica media (RMS, root mean square)
# @list1: [x1, y1, z1, etc]
# @list2: [x2, y2, z2, etc]
# @return: double
def lists_RMS(list1, list2):
    tmp1 = lists_diff_valorabsoluto(list1, list2);
    tmp2 = [a^2 for a in tmp1];
    tmp3 = list_sum_allvalues(tmp2);
    tmp4 = tmp3 / max(len(list1), len(list2));
    tmp5 = sqrt(tmp4);
    
    return tmp5;

# Divide una lista por un numero 
# @list1: [1,2,3,4]
# @numero: double
# @return: list
def list_divide(list1, numero):
    for i in range(len(list1)):
        list1[i] = list1[i] / numero;
        
    return list1;


# realizar el calculo del promedio
# @list: [1,2,3,4]
# @return: double
#
def list_average(list):
    total = 0;
    qtt = len(list);
    
    # si es una lista vacia, devolver []
    if qtt == 0:
        return [];
    
    for item in list:
        total += item;
        
    return total/qtt;

#
#
def list_sum_allvalues(list1):
    total = 0;
    
    for item in list1:
        total += item;
        
    return total;
