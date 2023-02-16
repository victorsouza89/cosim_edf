exportToFMU2CS('very_simple_tf')
exportToFMU2CS('integrator')
exportToFMU2CS('proportional_control')


p = slproject.create() 
copyfile('./proportional_control.slx') 
p.addFile('./proportional_control.slx')
Simulink.fmuexport.ExportSimulinkProjectToFMU(p,'proportional_control.slx','-fmuname','proportional_control_project_FMU')