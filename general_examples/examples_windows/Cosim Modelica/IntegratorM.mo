model IntegratorM
  Modelica.Blocks.Interfaces.RealInput In1 annotation(
    Placement(visible = true, transformation(origin = {-84, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-74, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Out1 annotation(
    Placement(visible = true, transformation(origin = {52, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {50, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator System annotation(
    Placement(visible = true, transformation(origin = {-12, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(System.u, In1) annotation(
    Line(points = {{-24, 2}, {-84, 2}}, color = {0, 0, 127}));
  connect(System.y, Out1) annotation(
    Line(points = {{0, 2}, {52, 2}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "3.2.3")));
end IntegratorM;
