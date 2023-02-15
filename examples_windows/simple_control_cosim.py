from fmpy import read_model_description, extract
from fmpy.fmi2 import FMU2Slave
import numpy as np
import shutil
import matplotlib.pyplot as plt

class FMU:
    def __init__(self, fmu_filename, inputs, outputs):
        # store the filename
        self.filename = fmu_filename

        # read the model description
        self.model_description = read_model_description(fmu_filename)

        # collect the value references
        self.vrs = {}
        for variable in self.model_description.modelVariables:
            self.vrs[variable.name] = variable.valueReference

        # get the inputs and outputs
        self.vrs_input = []
        for i in inputs:
            self.vrs_input.append(self.vrs[i])
        self.vrs_output = []
        for o in outputs:
            self.vrs_output.append(self.vrs[o])

        # extract the FMU
        self.unzipdir = extract(fmu_filename)

        # instantiate the FMU
        self.fmu = FMU2Slave(guid=self.model_description.guid,
                             unzipDirectory=self.unzipdir,
                             modelIdentifier=self.model_description.coSimulation.modelIdentifier,
                             instanceName='instance')


    def initialize(self, start_time):
        # initialize the FMU
        self.fmu.instantiate()
        self.fmu.setupExperiment(startTime=start_time)
        self.fmu.enterInitializationMode()
        self.fmu.exitInitializationMode()

        # initialize the input and output arrays
        self.passed_in = np.array([])
        self.passed_out = np.array([])

    def setInputs(self, inputs):
        # set the inputs
        self.fmu.setReal(self.vrs_input, inputs)
        self.now_input = inputs

    def getOutputs(self):
        # get the outputs
        return self.fmu.getReal(self.vrs_output)

    def doStep(self, time, step_size):
        # perform one step
        self.fmu.doStep(currentCommunicationPoint=time, communicationStepSize=step_size)
        # store the input and output
        self.passed_in = np.append(self.passed_in, self.now_input)
        self.now_output = self.getOutputs()
        self.passed_out = np.append(self.passed_out, self.now_output)
        # return the output
        return self.now_output

    def terminate(self):
        # terminate the FMU
        self.fmu.terminate()
        self.fmu.freeInstance()
        # remove the extracted FMU
        shutil.rmtree(self.unzipdir)

def simulate_controlled_plant(show_plot=True):
    # define the model information
    plant_filename = 'integrator.fmu'
    inputs = ['In1']
    outputs = ['Out1']

    # define the control information
    controller_filename = 'proportional_control.fmu'
    controller_inputs = ['reference', 'real']
    controller_outputs = ['control_signal']

    # define the simulation parameters
    start_time = 0.0
    stop_time = 5.0
    step_size = 0.01
    times = np.arange(start_time, stop_time, step_size)

    # define reference parameters
    ref_t = 1.0 - 0.5 * step_size
    ref_v = 1.0
    ref_0 = 0.0
    step_ref = np.array([ref_v if time > ref_t else ref_0 for time in times]).T
    reference = step_ref

    # instantiate the plant
    plant = FMU(plant_filename, inputs, outputs)
    plant.initialize(start_time)

    # instantiate the controller
    controller = FMU(controller_filename, controller_inputs, controller_outputs)
    controller.initialize(start_time)

    # initialize the simulation
    actual_step = 0
    actual_output = [0.0]

    # simulation loop
    for time in times:
        # get the actual reference
        ref_now = reference[actual_step]

        # set the controller inputs
        controller.setInputs([ref_now, actual_output[0]])

        # get the controlled input
        controlled_input = controller.doStep(time, step_size)

        # set the plant input
        plant.setInputs(controlled_input)

        # perform one step
        actual_output = plant.doStep(time, step_size)

        # increment the time
        actual_step += 1

    # terminate
    plant.terminate()
    controller.terminate()
    
    # prepare the result
    labels = ['time', 'input', 'output', 'reference']
    result = np.array([times, plant.passed_in, plant.passed_out, step_ref]).T
    result = {label: result[:, i] for i, label in enumerate(labels)}
   
    # plot inputs and outputs in separate subplots
    if show_plot:
        # create a figure with two subplots
        fig, axs = plt.subplots(2)
        fig.suptitle('Controlled System')
        # plot the inputs
        axs[0].plot(result['time'], result['input'], label='input')
        axs[0].legend()
        # plot the outputs
        axs[1].plot(result['time'], result['reference'], label='reference')
        axs[1].plot(result['time'], result['output'], label='output')
        axs[1].legend()
        # show the plot
        plt.show()

    return result

if __name__ == '__main__':
    simulate_controlled_plant()