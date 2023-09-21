Hello! Thanks for checking out my BCNF decomposition program. It can decompose any valid relation with various functional dependencies.

Please only interact with the main() method part of this program. To decompose any relation please input your relation where it says 'relation = ' and functional dependencies where it says 'func-depend = '.
Please also keep in the mind the various formatting constraints with this program. They are listed below with examples. Thank you!

def main():
    relation = ['A','B','C','D','E'] #input your relation here of format (ex: ['A', 'B', 'C', 'D', 'E'])
    func_depend = ["A -> C", "C -> B,D"] #input the array of functional dependencies here of format (ex: ["A -> B", "A,B -> B,C"])