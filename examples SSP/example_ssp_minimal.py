from fmpy.ssp.simulation import simulate_ssp
from fmpy.util import plot_result


# Simulates the SSP file 'ControlledDrivetrain.ssp' with the default settings.
# The output is a numpy.ndarray containing a time series.
result = simulate_ssp('examples SSP\ControlledDrivetrain.ssp')


# Plot the result
plot_result(result)