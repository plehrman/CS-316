import pandas as pd
from itertools import combinations

def main():
    relation = ['A','B','C','D','E','F','G'] #input your relation here of format (ex: ['A', 'B', 'C', 'D', 'E'])
    func_depend = ["A,B -> C,D", "B -> E", "C,D,E -> F", "F -> G", "A -> C,G"] #input the array of functional dependencies here of format (ex: ["A -> B", "A,B -> B,C"])
    all_func_depend = all_fds(func_depend) #finds all functional dependencies given Armstong's rules.
    bcnf_answer = []

    keys = (find_keys(relation, func_depend))
    recursive(relation, all_func_depend, bcnf_answer, keys)
                             
def recursive(relation, all_func_depend, bcnf_answer, keys):
    
    func_depend = func_select(relation, all_func_depend)
    if func_depend != None:
        if bcnf_valid(relation, func_depend, keys):
            bcnf_answer.append(relation)
            print('BCNF :', bcnf_answer)
            return
        decomposition = decompose(relation, func_depend)
        print(f'Decompose: {relation} by {func_depend} into {decomposition}')
        bcnf_answer.append(decomposition[0])
        recursive(decomposition[1], all_func_depend, bcnf_answer, keys)

    else:
        bcnf_answer.append(relation)
        print('BCNF: ',bcnf_answer)
        return

def func_select(relation, func_depend):
    for func in func_depend:
        left = func.split(' -> ')[0].split(',')
        right = func.split(' -> ')[1].split(',')
        fd_attributes = left + right

        if all(element in relation for element in fd_attributes):
            return func
    return None
                    
def bcnf_valid(relation, func_depend, keys): #df refers to relation (ex: [A,B,C,D,E]) and func_depend refers to functional dependency of type string (ex:"A,B -> C,D")
    
    left_side = func_depend.split(' -> ')[0].split(',')
    right_side = func_depend.split(' -> ')[1].split(',')

    func_attributes = left_side + right_side

    if all(item in func_attributes for item in relation) or all(item in keys for item in relation):
        return True
    else:
        return False

def decompose(relation, func_depend): #df refers to relation (ex: [A,B,C,D,E]) and func_depend refers to functional dependency of type string (ex:"A,B -> C,D")
    part_one = func_depend.split(' -> ')[0].split(',') + func_depend.split(' -> ')[1].split(',')
    part_two = func_depend.split(' -> ')[0].split(',') + [item for item in relation if item not in part_one]

    return part_one, part_two

def find_keys(relation, func_depend): #func_depend refers to an array of string type functional dependencies (ex: ['A -> B', 'B -> C'])
    right_side = set()
    relation = set(relation)

    for func in func_depend:
        new_func = func.split(' -> ')[1].split(',')
        for element in new_func:
            right_side.update(element)
    
    return relation.difference(right_side)

def all_fds(func_depend): #func_depend refers to functional dependency of type string (ex:"A,B -> C,D")
    state = True

    while state:
        func_depend = fd_transitive(fd_combo(func_depend))
        second_fd = fd_transitive(fd_combo(func_depend))

        if len(func_depend) == len(second_fd):
            state = False
    
    for func in func_depend:
        right_side = func.split(' -> ')[1]
        left_side = func.split(' -> ')[0]
        if (right_side == left_side):
            func_depend.remove(func)

    return(set(func_depend))

def fd_combo(func_depend):
    new_fds = []

    for func in func_depend:
        left = func.split(' -> ')[0]
        right = [func.split(' -> ')[1]]
        right_side = func.split(' -> ')[1].split(',')
        
        right_side_combos= []
        counter = 1
        
        while (len(right_side) - counter > 0):
            len_minus_1 = len(right_side) - counter
            right_side_combos.extend(list(combinations(right_side, len_minus_1)))
            counter +=1

        for combo in right_side_combos:
            new_string = ','.join(str(x) for x in combo)
            new_fds.append(f'{left} -> {new_string}')

    func_depend.extend(new_fds)

    return(func_depend)

def fd_transitive(func_depend):
    new_fds = []
        
    for func in func_depend:
        right_side = func.split(' -> ')[1]
        left_side = func.split(' -> ')[0]
        for func in func_depend:
            left = func.split(' -> ')[0]
            right = func.split(' -> ')[1]
            if (right_side == left):
                new_fds.append(f'{left_side} -> {right}')
    
    func_depend.extend(new_fds)
    return(func_depend)

if __name__ == "__main__":
    main()
