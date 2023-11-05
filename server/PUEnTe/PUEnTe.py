from minizinc import Instance, Model, Solver

def PUEnTe(dzn_file_path):
    # Load model from file
    model = Model("./PUEnTe/PUEnTe.mzn")
    # Find the MiniZinc solver configuration for Gecode
    gecode = Solver.lookup("gecode")
    # Create an Instance of the model for Gecode
    instance = Instance(gecode, model)
    instance.add_file(dzn_file_path)
    
    result = instance.solve()
    costoTotal = result["costoTotal"]
    P = result["P"]
    # Output the array q
    return({"costoTotal": costoTotal, "P": P})