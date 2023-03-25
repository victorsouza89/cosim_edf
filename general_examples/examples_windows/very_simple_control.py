from fmpy import read_model_description, extract
from fmpy.fmi2 import FMU2Slave
from fmpy.util import plot_result
import numpy as np
import shutil

def simulate_custom_input(show_plot=True):

    # define the model name and simulation parameters
    fmu_filename = 'integrator.fmu'
    start_time = 0.0
    stop_time = 5.0
    step_size = 0.01

    # define reference parameters
    ref_t = 1.0 - 0.5 * step_size
    ref_v = 1.0
    ref_0 = 0.0

    # controls
    without_control = lambda step_ref, passed_outputs = None : step_ref
    proportional_control = lambda step_ref, passed_outputs, K=1 : [K*(s - passed_outputs[-1]) for s in step_ref]
    controls_functions = {
        "without control" : without_control, 
        "closed loop" : proportional_control
    }

    # read the model description
    model_description = read_model_description(fmu_filename)

    # collect the value references
    vrs = {}
    for variable in model_description.modelVariables:
        vrs[variable.name] = variable.valueReference

    # get the value references for the variables we want to get/set
    vr_input = vrs['In1']
    vr_out1 = vrs['Out1']

    # initialize
    fmus = {}
    unzipdirs = {}
    for i in controls_functions:
        #extract the FMU
        unzipdirs[i] = extract(fmu_filename)
        fmu = FMU2Slave(guid=model_description.guid,
                        unzipDirectory=unzipdirs[i],
                        modelIdentifier=model_description.coSimulation.modelIdentifier,
                        instanceName='instance'+str(i))

        # initialize
        fmu.instantiate()
        fmu.setupExperiment(startTime=start_time)
        fmu.enterInitializationMode()
        fmu.exitInitializationMode()

        fmus[i] = fmu
        
    
    time = start_time # initial time
    rows = []  # list to record the results
    passed_outputs = {i : [0.0] for i in controls_functions} # list to record the outputs
    passed_inputs = {i : [0.0] for i in controls_functions} # list to record the inputs

    # simulation loop
    while time < stop_time:

        # NOTE: the FMU.get*() and FMU.set*() functions take lists of
        # value references as arguments and return lists of values

        for i in controls_functions:
            # get the control function
            control = controls_functions[i]
            step_ref = [ref_v if time > ref_t else ref_0]

            # set the input
            fmus[i].setReal([vr_input], control(step_ref, passed_outputs[i]))

            # perform one step
            fmus[i].doStep(currentCommunicationPoint=time, communicationStepSize=step_size)

        # advance the time
        time += step_size
        row = [time]

        for i in controls_functions:
            # get the values for 'inputs' and 'outputs'
            inputs, outputs = fmus[i].getReal([vr_input, vr_out1])

            # append the outputs
            passed_outputs[i].append(outputs)

            # append the inputs
            passed_inputs[i].append(inputs)

            # append the results
            row.append(inputs)
            row.append(outputs)

        # append the results
        rows.append(tuple(row))

    # terminate
    for fmu in fmus.values():
        fmu.terminate()
        fmu.freeInstance()

    # clean up
    for unzipdir in unzipdirs.values():
        shutil.rmtree(unzipdir)
        
    # convert the results to a structured NumPy array
    list_types = [('time', np.float64)]
    for i in controls_functions:
        list_types.append(('in - '+str(i), np.float64))
        list_types.append(('out - '+str(i), np.float64))
    result = np.array(rows, dtype=np.dtype(list_types))

    # plot the results
    if show_plot:
        plot_result(result)

    return time

if __name__ == '__main__':
    simulate_custom_input()