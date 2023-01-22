from fmpy import read_model_description, extract
from fmpy.fmi2 import FMU2Slave
from fmpy.util import plot_result, download_test_file
import numpy as np
import shutil


def simulate_custom_input(show_plot=True):

    # define reference parameters
    ref_t = 0.9
    ref_v = 1.0
    ref_0 = 0.0

    # define the model name and simulation parameters
    fmu_filename = 'integrator.fmu'
    start_time = 0.0
    threshold = 2.0
    stop_time = 5.0
    step_size = 0.2

    # read the model description
    model_description = read_model_description(fmu_filename)

    # collect the value references
    vrs = {}
    for variable in model_description.modelVariables:
        vrs[variable.name] = variable.valueReference

    # get the value references for the variables we want to get/set
    vr_input = vrs['In1']
    vr_out1 = vrs['Out1'] 
    #vr_input = vrs['outputs']
    #vr_out1 = vrs['outputs'] 

    # extract the FMU
    unzipdir1 = extract(fmu_filename)
    unzipdir2 = extract(fmu_filename)

    fmu1 = FMU2Slave(guid=model_description.guid,
                    unzipDirectory=unzipdir1,
                    modelIdentifier=model_description.coSimulation.modelIdentifier,
                    instanceName='instance1')
    
    fmu2 = FMU2Slave(guid=model_description.guid,
                    unzipDirectory=unzipdir2,
                    modelIdentifier=model_description.coSimulation.modelIdentifier,
                    instanceName='instance2')

    for fmu in [fmu1, fmu2]:
        # initialize
        fmu.instantiate()
        fmu.setupExperiment(startTime=start_time)
        fmu.enterInitializationMode()
        fmu.exitInitializationMode()
        
    time = start_time

    rows = []  # list to record the results
    last_output = 0.0

    # simulation loop 1
    while time < stop_time:

        # NOTE: the FMU.get*() and FMU.set*() functions take lists of
        # value references as arguments and return lists of values

        # set the input
        step_ref = [ref_0 if time < ref_t else ref_v]
        closedloop_control = [s - last_output for s in step_ref]

        # set the input
        fmu1.setReal([vr_input], step_ref)
        fmu2.setReal([vr_input], closedloop_control)

        # perform one step
        fmu1.doStep(currentCommunicationPoint=time, communicationStepSize=step_size)
        fmu2.doStep(currentCommunicationPoint=time, communicationStepSize=step_size)

        # advance the time
        time += step_size

        # get the values for 'inputs' and 'outputs[4]'
        inputs1, outputs1 = fmu1.getReal([vr_input, vr_out1])
        inputs2, outputs2 = fmu2.getReal([vr_input, vr_out1])

        # append the results
        rows.append((time, inputs1, outputs1, inputs2, outputs2))
        
        last_output = outputs2

    fmu.terminate()
    fmu.freeInstance()

    # clean up
    shutil.rmtree(unzipdir1, ignore_errors=True)
    shutil.rmtree(unzipdir2, ignore_errors=True)

    # convert the results to a structured NumPy array
    result = np.array(rows, dtype=np.dtype([('time', np.float64), ('input1', np.float64), ('output1', np.float64), ('input2', np.float64), ('output2', np.float64)]))

    # plot the results
    if show_plot:
        plot_result(result)

    return time


if __name__ == '__main__':

    simulate_custom_input()