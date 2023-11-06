from minizinc import Instance, Model, Solver

def PUEnTe(dzn_file_path):
    # Load model from file
    model = Model("./PUEnTe/PUEnTe.mzn")
    # Find the MiniZinc solver configuration
    solver = Solver.lookup("coin-bc")
    
    # Create an Instance of the model
    instance = Instance(solver, model)
    instance.add_file(dzn_file_path)
    print("Solving instance")
    result = instance.solve()
    try:
        costoTotal = result["costoTotal"]
        P = result["P"]
        return({"costoTotal": costoTotal, "P": P})
    except:
        return({"message": "No se encontró solución"})
        