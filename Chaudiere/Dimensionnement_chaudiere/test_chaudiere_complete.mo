within Dimensionnement_chaudiere;
model test_chaudiere_complete
  //import DynamicDrumAdapt;
  //import Dimensionnement_chaudiere;
  ThermoSysPro.Combustion.CombustionChambers.GenericCombustion
    genericCombustion
    annotation (Placement(transformation(extent={{-58,-46},{-26,-14}})));
  ThermoSysPro.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(T0(
        displayUnit="K") = 300, Q0=0.12812)
    annotation (Placement(transformation(extent={{-2,-68},{-22,-48}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ sourcePQ(
    h0=104928,
    P0=110000,
    Q0=0.0170)
    annotation (Placement(transformation(extent={{-94,-38},{-74,-18}})));
  ThermoSysPro.FlueGases.BoundaryConditions.SourcePQ sourcePQ1(
    T0(displayUnit="K") = 300,
    Xco2=0.0006,
    Xh2o=0,
    Xo2=0.2314,
    Xso2=0,
    Q0=2.65042,
    P0=110000)
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
    annotation (Placement(transformation(extent={{-16,-2},{20,34}})));
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
  ThermoSysPro.FlueGases.BoundaryConditions.Sink sink
    annotation (Placement(transformation(extent={{34,-14},{54,6}})));
  DynamicDrumAdapt dynamicDrumAdapt(
    
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
    annotation (Placement(transformation(extent={{-8,30},{12,50}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2(k = 2.78) annotation(
    Placement(visible = true, transformation(extent = {{72, 56}, {58, 70}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante8(k = 2.7784e06) annotation(
    Placement(visible = true, transformation(extent = {{72, 30}, {58, 44}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante5(k = 773.5e3) annotation(
    Placement(visible = true, transformation(extent = {{-62, 18}, {-48, 32}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante10(k = 10.4793e5) annotation(
    Placement(visible = true, transformation(extent = {{-72, 48}, {-58, 62}}, rotation = 0)));
equation
  connect(genericCombustion.Cfuel, fuelSourcePQ.C) annotation(
    Line(points = {{-37.2, -44.4}, {-30, -44.4}, {-30, -58}, {-22, -58}}, color = {0, 0, 0}));
  connect(genericCombustion.Cws, sourcePQ.C) annotation(
    Line(points = {{-56.4, -28.4}, {-56.4, -28}, {-74, -28}}, color = {0, 0, 255}));
  connect(genericCombustion.Ca, sourcePQ1.C) annotation(
    Line(points = {{-46.8, -44.4}, {-58, -44.4}, {-58, -60}, {-68, -60}}, color = {0, 0, 0}, thickness = 1));
  connect(staticWallFlueGasesExchanger.CTh, heatExchangerWall.WT1) annotation(
    Line(points = {{2, -1}, {2, 12.4}}, color = {0, 0, 0}));
  connect(genericCombustion.Cfg, staticWallFlueGasesExchanger.C1) annotation(
    Line(points = {{-46.8, -15.6}, {-47.4, -15.6}, {-47.4, -4}, {-8, -4}}, color = {0, 0, 0}, thickness = 1));
  connect(staticWallFlueGasesExchanger.C2, sink.C) annotation(
    Line(points = {{12, -4}, {34.2, -4}}, color = {0, 0, 0}, thickness = 1));
  connect(sourceP.C, dynamicDrumAdapt.Ce1) annotation(
    Line(points = {{-24, 50}, {-8, 50}}, color = {0, 0, 255}));
  connect(sinkQ1.C, dynamicDrumAdapt.Cv) annotation(
    Line(points = {{30, 50}, {12, 50}}, color = {0, 0, 255}));
  connect(heatExchangerWall.WT2, dynamicDrumAdapt.Cth) annotation(
    Line(points = {{2, 19.6}, {2, 35}}, color = {0, 0, 0}));
  connect(sinkQ1.IMassFlow, constante2.y) annotation(
    Line(points = {{40, 55}, {40, 63}, {57.3, 63}}, color = {0, 0, 255}));
  connect(constante8.y, sinkQ1.ISpecificEnthalpy) annotation(
    Line(points = {{57.3, 37}, {39.65, 37}, {39.65, 45}, {40, 45}}, color = {0, 0, 255}));
  connect(constante5.y, sourceP.ISpecificEnthalpy) annotation(
    Line(points = {{-47.3, 25}, {-34.65, 25}, {-34.65, 45}, {-34, 45}}, color = {0, 0, 255}));
  connect(sourceP.IPressure, constante10.y) annotation(
    Line(points = {{-39, 50}, {-42, 50}, {-42, 55}, {-57.3, 55}}, color = {0, 0, 255}));
end test_chaudiere_complete;
