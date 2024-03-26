########################
# DICTIONARY FUNCTIONS #
########################

# Convierte un 'dictionary' a una 'list'
# @dict_var: {index1: value1, index2: value2, etc}
# @return: [value1, value2, etc]
def dict_to_list(dict_var):
    list_var = [];
    
    for i in dict_var:
        list_var.append(dict_var[i]);
        
    return list_var;

