model IntegratorModelica
  Modelica.Blocks.Continuous.Integrator System annotation(
    Placement(visible = true, transformation(origin = {2, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput In1 annotation(
    Placement(visible = true, transformation(origin = {-86, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-78, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Out1 annotation(
    Placement(visible = true, transformation(origin = {82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(System.y, In) annotation(
    Line(points = {{14, -2}, {-88, -2}}, color = {0, 0, 127}));
  connect(System.y, Out) annotation(
    Line(points = {{14, -2}, {82, -2}}, color = {0, 0, 127}));
  connect(System.u, In1) annotation(
    Line(points = {{-10, -2}, {-86, -2}}, color = {0, 0, 127}));
  connect(System.y, Out1) annotation(
    Line(points = {{14, -2}, {82, -2}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "3.2.3")));
end IntegratorModelica;
