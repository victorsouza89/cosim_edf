# cosim_edf

## Cosim with FMPy

To facilitate the use of the FMPy library, a class called FMU is constructed and available in the file `fmu_handle.py` for the implementation of co-simulation with FMPy.

The FMU class has five main methods:

- `__init__`: This method is called when an FMU object is created. It takes as input the filename of an FMU, a list of inputs, and a list of outputs. The method reads the model description, collects value references for inputs and outputs, extracts the FMU, and uses the `FMU2Slave` function to place it in the context of FMPy.

- `initialize`: This method initializes the FMU for simulation. It instantiates the FMU, configures simulation parameters, and puts it in initialization mode.

- `setInputs`: This method sets input values for the FMU.

- `getOutputs`: This method returns the values of defined outputs for the FMU.

- `doStep`: This method performs a simulation step for the FMU with the current time and specified step size. It retrieves output values and stores input and output values.

The FMU class also has a `terminate` method to end the simulation and release used resources.

To test the functionality and demonstrate the use of the created class, an example has been developed, the function `simulate_controlled_plant()`, available in the file `example_cosim.py`.

The `simulate_controlled_plant()` function simulates a control system using two FMUs: one for the system to be controlled (the "plant") and one for the controller. The system to be controlled is represented by the file `integrator.fmu`, while the controller is represented by the file `proportional_control.fmu`.

The function begins by defining the input and output names for each FMU and simulation parameters such as start time, stop time, and step size.

The example function then prepares the reference for the system to be controlled by creating a vector that contains a reference pulse. The function also creates instances of the FMU for the plant and the controller, initializes the simulation, and starts a simulation loop for each time instant in the defined time range.

At each time instant, the function follows these steps:
- Gets the current reference for the system to be controlled
- Sets the inputs for the controller using the current reference and the current output of the system to be controlled
- Gets the output of the controller (the control signal)
- Sets the input of the system to be controlled using the output of the controller
- Performs a simulation step for the system to be controlled
- Increments time and moves to the next time instant.

The function records the inputs and outputs of the plant in a results array, then displays a graph with the inputs and outputs of the plant and the reference. Finally, the function terminates both FMUs and returns the results array.
