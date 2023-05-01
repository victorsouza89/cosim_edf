within Dimensionnement_chaudiere;
model test_chaudiere_complete_FMU
  //import DynamicDrumAdapt;
  //import Dimensionnement_chaudiere;
  ThermoSysPro.Combustion.CombustionChambers.GenericCombustion genericCombustion annotation(
    Placement(transformation(extent = {{-58, -46}, {-26, -14}})));
  ThermoSysPro.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ( Q0=0.12812,T0(
        displayUnit="K") = 500)
    annotation (Placement(transformation(extent={{-2,-68},{-22,-48}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ sourcePQ(
    h0=104928,
    P0=110000,
    Q0=0.0170)
    annotation (Placement(transformation(extent={{-94,-38},{-74,-18}})));
  ThermoSysPro.FlueGases.BoundaryConditions.SourcePQ sourcePQ1(
    
    P0=110000,
    Q0=2.65042,T0(displayUnit="K") = 500,
    Xco2=0.0006,
    Xh2o=0,
    Xo2=0.2314,
    Xso2=0)
    annotation (Placement(transformation(extent={{-88,-70},{-68,-50}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SinkQ sinkQ1
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP sourceP(option_temperature=
       2) annotation (Placement(transformation(extent={{-44,40},{-24,60}})));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(
    L=8,
    D=0.05,
    e=3.e-3,
    lambda=21.4,
    cpw=573,
    rhow(displayUnit="kg/m3") = 4579,
    ntubes=1400,
    Ns=10)
    annotation (Placement(visible = true, transformation(extent = {{-16, -2}, {20, 34}}, rotation = 0)));
  ThermoSysPro.FlueGases.HeatExchangers.StaticWallFlueGasesExchanger
    staticWallFlueGasesExchanger(
    L=8,
    Dext=0.05,
    exchanger_type=2,
    NbTub=1400,
    Ns=10,
    Tm(start=fill(1250, 10)),
    Tp0=471.06)
    annotation (Placement(transformation(extent={{-8,-14},{12,6}})));
  ThermoSysPro.FlueGases.BoundaryConditions.Sink sink(C(T(start = 600)))
    annotation (Placement(transformation(extent={{34,-14},{54,6}})));
  Dimensionnement_chaudiere.DynamicDrumAdapt dynamicDrumAdapt(
    
    Cevap=0.13,
    Dext=0.056,
    Kpa= 25,
    L=8,
    L1=8,
    NbTub=1400,
    Ns=10,
    P0=1047930,
    PasL=0.06,
    R=1.25,
    Tp(start=455.02),Vertical=false,
    Vf0=0.7951,
    Xlo=0,
    rhol(start=772.997),
    rhov(start=5.37),
    steady_state=true,
    xl(start=0.0009455),
    xv(start=1),
    zl(start=1.8538))
    annotation (Placement(visible = true, transformation(extent = {{-8, 30}, {12, 50}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput realInput1(start = 0.12812) annotation(
    Placement(visible = true, transformation(origin = {44, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-82, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput realInput4(start = 2.65042) annotation(
    Placement(visible = true, transformation(origin = {-92, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-82, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dimensionnement_chaudiere.AdaptorModelicaTSP adaptorModelicaTSP31 annotation(
    Placement(visible = true, transformation(origin = {17, -45}, extent = {{-5, -7}, {5, 7}}, rotation = 180)));
  Dimensionnement_chaudiere.AdaptorModelicaTSP adaptorModelicaTSP4 annotation(
    Placement(visible = true, transformation(origin = {-92, -71}, extent = {{-6, -5}, {6, 5}}, rotation = 90)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante10(k = 10.4793e5) annotation(
    Placement(visible = true, transformation(extent = {{-78, 50}, {-64, 64}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante5(k = 773.5e3) annotation(
    Placement(visible = true, transformation(extent = {{-62, 20}, {-48, 34}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante8(k = 2.7784e06) annotation(
    Placement(visible = true, transformation(extent = {{72, 32}, {58, 46}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2(k = 2.78) annotation(
    Placement(visible = true, transformation(extent = {{72, 58}, {58, 72}}, rotation = 0)));
  Dimensionnement_chaudiere.AdaptorTSPModelica adaptorTSPModelica annotation(
    Placement(visible = true, transformation(origin = {32, 31}, extent = {{-4, -5}, {4, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {54, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {50, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(genericCombustion.Cfuel, fuelSourcePQ.C) annotation(
    Line(points = {{-37.2, -44.4}, {-30, -44.4}, {-30, -58}, {-22, -58}}, color = {0, 0, 0}));
  connect(genericCombustion.Cws, sourcePQ.C) annotation(
    Line(points = {{-56.4, -28.4}, {-56.4, -28}, {-74, -28}}, color = {0, 0, 255}));
  connect(genericCombustion.Ca, sourcePQ1.C) annotation(
    Line(points = {{-46.8, -44.4}, {-58, -44.4}, {-58, -60}, {-68, -60}}, color = {0, 0, 0}, thickness = 1));
  connect(staticWallFlueGasesExchanger.CTh, heatExchangerWall.WT1) annotation(
    Line(points = {{2, -1}, {2, 12.4}}));
  connect(genericCombustion.Cfg, staticWallFlueGasesExchanger.C1) annotation(
    Line(points = {{-46.8, -15.6}, {-47.4, -15.6}, {-47.4, -4}, {-8, -4}}, color = {0, 0, 0}, thickness = 1));
  connect(staticWallFlueGasesExchanger.C2, sink.C) annotation(
    Line(points = {{12, -4}, {34.2, -4}}, color = {0, 0, 0}, thickness = 1));
  connect(sourceP.C, dynamicDrumAdapt.Ce1) annotation(
    Line(points = {{-24, 50}, {-8, 50}}, color = {0, 0, 255}));
  connect(sinkQ1.C, dynamicDrumAdapt.Cv) annotation(
    Line(points = {{30, 50}, {12, 50}}, color = {0, 0, 255}));
  connect(heatExchangerWall.WT2, dynamicDrumAdapt.Cth) annotation(
    Line(points = {{2, 19.6}, {2, 35}}));
  connect(fuelSourcePQ.IMassFlow, adaptorModelicaTSP31.outputReal) annotation(
    Line(points = {{-12, -52}, {11.5, -52}, {11.5, -45}}, color = {0, 0, 255}));
  connect(realInput1, adaptorModelicaTSP31.u) annotation(
    Line(points = {{44, -44}, {24, -44}}, color = {0, 0, 127}));
  connect(realInput4, adaptorModelicaTSP4.u) annotation(
    Line(points = {{-92, -94}, {-92, -78}}, color = {0, 0, 127}));
  connect(sourcePQ1.IMassFlow, adaptorModelicaTSP4.outputReal) annotation(
    Line(points = {{-78, -54}, {-85, -54}, {-85, -64}, {-92, -64}}, color = {0, 0, 255}));
  connect(sourceP.ISpecificEnthalpy, constante5.y) annotation(
    Line(points = {{-34, 46}, {-34, 27}, {-47, 27}}, color = {0, 0, 255}));
  connect(sourceP.IPressure, constante10.y) annotation(
    Line(points = {{-38, 50}, {-63, 50}, {-63, 57}}, color = {0, 0, 255}));
  connect(sinkQ1.IMassFlow, constante2.y) annotation(
    Line(points = {{40, 56}, {40, 65}, {57, 65}}, color = {0, 0, 255}));
  connect(sinkQ1.ISpecificEnthalpy, constante8.y) annotation(
    Line(points = {{40, 46}, {40, 39}, {57, 39}}, color = {0, 0, 255}));
  connect(dynamicDrumAdapt.yPression, adaptorTSPModelica.inputReal) annotation(
    Line(points = {{13, 41}, {22, 41}, {22, 31}, {28, 31}}, color = {0, 0, 255}));
  connect(adaptorTSPModelica.y, y) annotation(
    Line(points = {{37, 31}, {54, 31}, {54, 18}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_chaudiere_complete_FMU;
