from fmpy import read_model_description, extract
from fmpy.fmi2 import FMU2Slave
import numpy as np
import shutil

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
