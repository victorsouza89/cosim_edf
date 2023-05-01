within Dimensionnement_chaudiere;

model test_reg_niveau_pression
  //import DynamicDrumAdapt;
  ThermoSysPro.Combustion.CombustionChambers.GenericCombustion genericCombustion annotation(
    Placement(transformation(extent = {{-68, -60}, {-36, -28}})));
  ThermoSysPro.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ( Q0 = 0.141329,T0(displayUnit = "K") = 300) annotation(
    Placement(transformation(extent = {{12, -82}, {-8, -62}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ sourcePQ(h0 = 104928, Q0 = 0.0170, P0 = 110000) annotation(
    Placement(transformation(extent = {{-104, -46}, {-84, -26}})));
  ThermoSysPro.FlueGases.BoundaryConditions.SourcePQ sourcePQ1(T0(displayUnit = "K") = 300, Xco2 = 0.0006, Xh2o = 0, Xo2 = 0.2314, Xso2 = 0, Q0 = 2.50943, P0 = 110000) annotation(
    Placement(transformation(extent = {{-98, -84}, {-78, -64}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante5(k = 723029) annotation(
    Placement(transformation(extent = {{-132, 6}, {-118, 20}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante10(k = 10.6793e5) annotation(
    Placement(transformation(extent = {{-134, 38}, {-120, 52}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2(k = 2.78) annotation(
    Placement(transformation(extent = {{168, 6}, {154, 20}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante8(k = 2.7784e06) annotation(
    Placement(transformation(extent = {{108, 6}, {94, 20}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SinkQ sinkQ1 annotation(
    Placement(transformation(extent = {{66, 16}, {86, 36}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP sourceP(option_temperature = 2) annotation(
    Placement(transformation(extent = {{-118, 26}, {-98, 46}})));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(L = 8, D = 0.05, e = 3.e-3, cpw = 573, rhow(displayUnit = "kg/m3") = 4579, ntubes = 1400, Ns = 10, lambda = 21.4) annotation(
    Placement(transformation(extent = {{-36, -16}, {0, 20}})));
  ThermoSysPro.FlueGases.HeatExchangers.StaticWallFlueGasesExchanger staticWallFlueGasesExchanger(L = 8, Dext = 0.05, exchanger_type = 2, NbTub = 1400, Ns = 10, Tm(start = fill(1250, 10)), Tp0 = 471.06) annotation(
    Placement(transformation(extent = {{-28, -28}, {-8, -8}})));
  ThermoSysPro.FlueGases.BoundaryConditions.Sink sink annotation(
    Placement(transformation(extent = {{14, -28}, {34, -8}})));
  ThermoSysPro.WaterSteam.PressureLosses.ControlValve controlValve(Cvmax = 115.84) annotation(
    Placement(transformation(extent = {{-82, 32}, {-62, 52}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante3(k = 0.25) annotation(
    Placement(transformation(extent = {{18, 80}, {4, 94}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante1(k = 1.8538) annotation(
    Placement(transformation(extent = {{132, 48}, {116, 64}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add annotation(
    Placement(transformation(extent = {{-12, 58}, {-32, 78}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain gain1(Gain = 20.687) annotation(
    Placement(transformation(extent = {{-118, -72}, {-98, -52}})));
  ThermoSysPro.Combustion.Sensors.FuelMassFlowSensor fuelMassFlowSensor(Q(start = 0.141329)) annotation(
    Placement(transformation(extent = {{-14, -70}, {-34, -90}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante4(k = 0.12812) annotation(
    Placement(transformation(extent = {{62, -36}, {48, -22}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(extent = {{110, -44}, {90, -64}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante6(k = 10.4793e5) annotation(
    Placement(transformation(extent = {{166, -80}, {150, -64}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add1 annotation(
    Placement(transformation(extent = {{34, -58}, {14, -38}})));
  Dimensionnement_chaudiere.DynamicDrumAdapt dynamicDrumAdapt(Cevap = 0.13, Dext = 0.056, Kpa = 0, L = 8, L1 = 8, Mp = 6.5e3, NbTub = 10, Ns = 10, P0 = 1047930, PasL = 0.06, R = 1.25, Tp(start = 455.02), Vertical = false, Vf0 = 0.65, Xlo = 0, rhol(start = 772.997), rhov(start = 5.37), steady_state = false, xl(start = 0.0009455), xv(start = 1), zl(start = 1.8538)) annotation(
    Placement(visible = true, transformation(extent = {{-28, 16}, {-8, 36}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Continu.PIsat pIsat(maxval = 0.75, minval = -0.25, k = 20, Ti = 200) annotation(
    Placement(transformation(extent = {{30, 52}, {10, 72}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Feedback feedback2 annotation(
    Placement(transformation(extent = {{62, 52}, {42, 72}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Continu.PIsat pIsat1(maxval = 0.1, minval = -0.1, k = 0.3e-6, Ti = 500) annotation(
    Placement(transformation(extent = {{82, -64}, {62, -44}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.NonLineaire.Limiteur limiteur(maxval = 1, minval = 0) annotation(
    Placement(transformation(extent = {{-38, 58}, {-58, 78}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add2 annotation(
    Placement(transformation(extent = {{136, -64}, {116, -44}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Echelon echelon(startTime = 15000, hauteur = 0) annotation(
    Placement(transformation(extent = {{168, -36}, {148, -16}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add3 annotation(
    Placement(transformation(extent = {{96, 52}, {76, 72}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Echelon echelon1(startTime = 10000, hauteur = 0) annotation(
    Placement(transformation(extent = {{126, 74}, {106, 94}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add4 annotation(
    Placement(transformation(extent = {{138, 22}, {118, 42}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Echelon echelon2(startTime = 15000, hauteur = 0) annotation(
    Placement(transformation(extent = {{170, 34}, {150, 54}})));
equation
  connect(genericCombustion.Cws, sourcePQ.C) annotation(
    Line(points = {{-66.4, -42.4}, {-66.4, -36}, {-84, -36}}, color = {0, 0, 255}));
  connect(genericCombustion.Ca, sourcePQ1.C) annotation(
    Line(points = {{-56.8, -58.4}, {-68, -58.4}, {-68, -74}, {-78, -74}}, color = {0, 0, 0}, thickness = 1));
  connect(constante8.y, sinkQ1.ISpecificEnthalpy) annotation(
    Line(points = {{93.3, 13}, {75.65, 13}, {75.65, 21}, {76, 21}}, color = {0, 0, 255}));
  connect(sourceP.IPressure, constante10.y) annotation(
    Line(points = {{-113, 36}, {-116, 36}, {-116, 45}, {-119.3, 45}}, color = {0, 0, 255}));
  connect(constante5.y, sourceP.ISpecificEnthalpy) annotation(
    Line(points = {{-117.3, 13}, {-108.65, 13}, {-108.65, 31}, {-108, 31}}, color = {0, 0, 255}));
  connect(staticWallFlueGasesExchanger.CTh, heatExchangerWall.WT1) annotation(
    Line(points = {{-18, -15}, {-18, -1.6}}, color = {0, 0, 0}));
  connect(genericCombustion.Cfg, staticWallFlueGasesExchanger.C1) annotation(
    Line(points = {{-56.8, -29.6}, {-57.4, -29.6}, {-57.4, -18}, {-28, -18}}, color = {0, 0, 0}, thickness = 1));
  connect(staticWallFlueGasesExchanger.C2, sink.C) annotation(
    Line(points = {{-8, -18}, {14.2, -18}}, color = {0, 0, 0}, thickness = 1));
  connect(sourceP.C, controlValve.C1) annotation(
    Line(points = {{-98, 36}, {-82, 36}}, color = {0, 0, 255}));
  connect(add.u1, constante3.y) annotation(
    Line(points = {{-11, 74}, {-8, 74}, {-8, 87}, {3.3, 87}}, color = {0, 0, 255}));
  connect(gain1.y, sourcePQ1.IMassFlow) annotation(
    Line(points = {{-97, -62}, {-88, -62}, {-88, -69}}, color = {0, 0, 255}));
  connect(genericCombustion.Cfuel, fuelMassFlowSensor.C2) annotation(
    Line(points = {{-47.2, -58.4}, {-40, -58.4}, {-40, -72}, {-34.2, -72}}, color = {0, 0, 0}));
  connect(fuelMassFlowSensor.C1, fuelSourcePQ.C) annotation(
    Line(points = {{-14, -72}, {-8, -72}}, color = {0, 0, 0}));
  connect(fuelMassFlowSensor.Mesure, gain1.u) annotation(
    Line(points = {{-24, -90.2}, {-24, -94}, {-128, -94}, {-128, -62}, {-119, -62}}, color = {0, 0, 255}));
  connect(add1.u1, constante4.y) annotation(
    Line(points = {{35, -42}, {40, -42}, {40, -29}, {47.3, -29}}, color = {0, 0, 255}));
  connect(add1.y, fuelSourcePQ.IMassFlow) annotation(
    Line(points = {{13, -48}, {2, -48}, {2, -67}}, color = {0, 0, 255}));
  connect(sinkQ1.C, dynamicDrumAdapt.Cv) annotation(
    Line(points = {{66, 26}, {30, 26}, {30, 36}, {-8, 36}}, color = {0, 0, 255}));
  connect(heatExchangerWall.WT2, dynamicDrumAdapt.Cth) annotation(
    Line(points = {{-18, 5.6}, {-18, 21}}));
  connect(pIsat.u, feedback2.y) annotation(
    Line(points = {{31, 62}, {41, 62}}, color = {0, 0, 255}));
  connect(controlValve.C2, dynamicDrumAdapt.Ce1) annotation(
    Line(points = {{-62, 36}, {-28, 36}}, color = {0, 0, 255}));
  connect(dynamicDrumAdapt.yPression, feedback1.u2) annotation(
    Line(points = {{-7, 27}, {20, 27}, {20, -6}, {100, -6}, {100, -43}}, color = {0, 0, 255}));
  connect(feedback1.y, pIsat1.u) annotation(
    Line(points = {{89, -54}, {83, -54}}, color = {0, 0, 255}));
  connect(add1.u2, pIsat1.y) annotation(
    Line(points = {{35, -54}, {61, -54}}, color = {0, 0, 255}));
  connect(add.y, limiteur.u) annotation(
    Line(points = {{-33, 68}, {-37, 68}}, color = {0, 0, 255}));
  connect(limiteur.y, controlValve.Ouv) annotation(
    Line(points = {{-59, 68}, {-72, 68}, {-72, 53}}, color = {0, 0, 255}));
  connect(dynamicDrumAdapt.yLevel, feedback2.u2) annotation(
    Line(points = {{-7, 31}, {51.5, 31}, {51.5, 51}, {52, 51}}, color = {0, 0, 255}));
  connect(pIsat.y, add.u2) annotation(
    Line(points = {{9, 62}, {-11, 62}}, color = {0, 0, 255}));
  connect(feedback1.u1, add2.y) annotation(
    Line(points = {{111, -54}, {115, -54}}, color = {0, 0, 255}));
  connect(add2.u2, constante6.y) annotation(
    Line(points = {{137, -60}, {144, -60}, {144, -72}, {149.2, -72}}, color = {0, 0, 255}));
  connect(add2.u1, echelon.y) annotation(
    Line(points = {{137, -48}, {142, -48}, {142, -26}, {147, -26}}, color = {0, 0, 255}));
  connect(add3.u1, echelon1.y) annotation(
    Line(points = {{97, 68}, {98, 68}, {98, 84}, {105, 84}}, color = {0, 0, 255}));
  connect(feedback2.u1, add3.y) annotation(
    Line(points = {{63, 62}, {75, 62}}, color = {0, 0, 255}));
  connect(add3.u2, constante1.y) annotation(
    Line(points = {{97, 56}, {115.2, 56}}, color = {0, 0, 255}));
  connect(add4.u1, echelon2.y) annotation(
    Line(points = {{139, 38}, {144, 38}, {144, 44}, {149, 44}}, color = {0, 0, 255}));
  connect(add4.y, sinkQ1.IMassFlow) annotation(
    Line(points = {{117, 32}, {76, 32}, {76, 31}}, color = {0, 0, 255}));
  connect(add4.u2, constante2.y) annotation(
    Line(points = {{139, 26}, {146, 26}, {146, 13}, {153.3, 13}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {180, 100}})),
    Icon(coordinateSystem(extent = {{-140, -100}, {180, 100}})));
end test_reg_niveau_pression;
