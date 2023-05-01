within Dimensionnement_chaudiere;
model chaudiere_linearisation
  ThermoSysPro.Combustion.CombustionChambers.GenericCombustion
    genericCombustion
    annotation (Placement(transformation(extent={{-42,-60},{-10,-28}})));
  ThermoSysPro.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(T0(
        displayUnit="K") = 300, Q0=0.141329)
    annotation (Placement(transformation(extent={{38,-82},{18,-62}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ sourcePQ(
    h0=104928,
    Q0=0.0170,
    P0=110000)
    annotation (Placement(transformation(extent={{-78,-46},{-58,-26}})));
  ThermoSysPro.FlueGases.BoundaryConditions.SourcePQ sourcePQ1(
    T0(displayUnit="K") = 300,
    Xco2=0.0006,
    Xh2o=0,
    Xo2=0.2314,
    Xso2=0,
    Q0=2.50943,
    P0=110000)
    annotation (Placement(transformation(extent={{-72,-84},{-52,-64}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante5(k=723029)
    annotation (Placement(transformation(extent={{-124,6},{-110,20}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante10(k=
        10.6793e5)
    annotation (Placement(transformation(extent={{-128,40},{-114,54}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2(k=2.78)
    annotation (Placement(transformation(extent={{88,20},{74,34}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante8(k=
        2.7784e06)
    annotation (Placement(transformation(extent={{88,-6},{74,8}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SinkQ sinkQ1
    annotation (Placement(transformation(extent={{46,4},{66,24}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP sourceP(option_temperature=
       2) annotation (Placement(transformation(extent={{-110,26},{-90,46}})));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(
    L=8,
    D=0.05,
    lambda=21.4,
    cpw=573,
    rhow(displayUnit="kg/m3") = 4579,
    ntubes=1400,
    Ns=10,
    e=1.e-3)
    annotation (Placement(transformation(extent={{-10,-16},{26,20}})));
  ThermoSysPro.FlueGases.HeatExchangers.StaticWallFlueGasesExchanger
    staticWallFlueGasesExchanger(
    L=8,
    Dext=0.05,
    exchanger_type=2,
    NbTub=1400,
    Ns=10,
    Tm(start=fill(1250, 10)),
    Coeff=0.95,
    Tp0=471.06)
    annotation (Placement(transformation(extent={{-2,-28},{18,-8}})));
  ThermoSysPro.FlueGases.BoundaryConditions.Sink sink
    annotation (Placement(transformation(extent={{40,-28},{60,-8}})));
  ThermoSysPro.WaterSteam.PressureLosses.ControlValve controlValve(Cvmax=115.84)
    annotation (Placement(transformation(extent={{-84,32},{-64,52}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante3(k=0.25)
    annotation (Placement(transformation(extent={{48,74},{34,88}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{58,52},{38,72}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{2,58},{-18,78}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain gain(Gain=16)
    annotation (Placement(transformation(extent={{30,52},{10,72}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain gain1(Gain=20.687)
    annotation (Placement(transformation(extent={{-92,-72},{-72,-52}})));
  ThermoSysPro.Combustion.Sensors.FuelMassFlowSensor fuelMassFlowSensor(Q(start=
          0.141329))
    annotation (Placement(transformation(extent={{12,-70},{-8,-90}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante4(k=0.12812)
    annotation (Placement(transformation(extent={{110,-46},{96,-32}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{58,-68},{38,-48}})));
  Dimensionnement_chaudiere.DynamicDrumAdapt
                   dynamicDrumAdapt(
    Vertical=false,
    R=1.25,
    L=8,
    Xlo=0,
    L1=8,
    PasL=0.06,
    xl(start=0.0009455),
    xv(start=1),
    zl(start=1.8538),
    Kpa=0,
    NbTub=1400,
    Ns=10,
    Vf0=0.65,
    steady_state=false,
    Mp=6.5e3,
    COPl=10,
    Dext=0.052,
    P0=1047930,
    Tp(start=455.02),
    rhol(start=772.997),
    rhov(start=5.37))
    annotation (Placement(transformation(extent={{-2,16},{18,36}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.NonLineaire.Limiteur limiteur(maxval=1,
      minval=0)
    annotation (Placement(transformation(extent={{-50,64},{-70,84}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante1(k=1.8538)
    annotation (Placement(transformation(extent={{92,56},{78,70}})));
  input ThermoSysPro.InstrumentationAndControl.Connectors.InputReal
    entreeNiveau
    annotation (Placement(transformation(extent={{6,82},{-14,102}})));
  output ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal
    sortieNiveau
    annotation (Placement(transformation(extent={{104,24},{124,44}})));
  output ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal
    sortiePression
    annotation (Placement(transformation(extent={{104,-22},{124,-2}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-24,64},{-44,84}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain gain2(Gain=1e-5)
    annotation (Placement(transformation(extent={{68,-22},{88,-2}})));
  input ThermoSysPro.InstrumentationAndControl.Connectors.InputReal entreePression
    annotation (Placement(transformation(extent={{106,-82},{86,-62}})));
equation
  connect(genericCombustion.Cws,sourcePQ. C) annotation (Line(points={{-40.4,
          -42.4},{-40.4,-36},{-58,-36}},
                                     color={0,0,255}));
  connect(genericCombustion.Ca,sourcePQ1. C) annotation (Line(
      points={{-30.8,-58.4},{-42,-58.4},{-42,-74},{-52,-74}},
      color={0,0,0},
      thickness=1));
  connect(constante8.y,sinkQ1. ISpecificEnthalpy) annotation (Line(points={{73.3,1},
          {55.65,1},{55.65,9},{56,9}},             color={0,0,255}));
  connect(sourceP.IPressure,constante10. y) annotation (Line(points={{-105,36},
          {-108,36},{-108,47},{-113.3,47}},
                                        color={0,0,255}));
  connect(sinkQ1.IMassFlow,constante2. y)
    annotation (Line(points={{56,19},{56,27},{73.3,27}}, color={0,0,255}));
  connect(constante5.y,sourceP. ISpecificEnthalpy) annotation (Line(points={{-109.3,
          13},{-100.65,13},{-100.65,31},{-100,31}},    color={0,0,255}));
  connect(staticWallFlueGasesExchanger.CTh,heatExchangerWall. WT1)
    annotation (Line(points={{8,-15},{8,-1.6}},color={0,0,0}));
  connect(genericCombustion.Cfg,staticWallFlueGasesExchanger. C1) annotation (
      Line(
      points={{-30.8,-29.6},{-31.4,-29.6},{-31.4,-18},{-2,-18}},
      color={0,0,0},
      thickness=1));
  connect(staticWallFlueGasesExchanger.C2,sink. C) annotation (Line(
      points={{18,-18},{40.2,-18}},
      color={0,0,0},
      thickness=1));
  connect(sourceP.C,controlValve. C1)
    annotation (Line(points={{-90,36},{-84,36}}, color={0,0,255}));
  connect(add.u1,constante3. y) annotation (Line(points={{3,74},{10,74},{10,81},
          {33.3,81}},     color={0,0,255}));
  connect(add.u2,gain. y)
    annotation (Line(points={{3,62},{9,62}},   color={0,0,255}));
  connect(gain.u,feedback. y)
    annotation (Line(points={{31,62},{37,62}}, color={0,0,255}));
  connect(gain1.y,sourcePQ1. IMassFlow)
    annotation (Line(points={{-71,-62},{-62,-62},{-62,-69}}, color={0,0,255}));
  connect(genericCombustion.Cfuel,fuelMassFlowSensor. C2) annotation (Line(
        points={{-21.2,-58.4},{-14,-58.4},{-14,-72},{-8.2,-72}},  color={0,0,0}));
  connect(fuelMassFlowSensor.C1,fuelSourcePQ. C)
    annotation (Line(points={{12,-72},{18,-72}},color={0,0,0}));
  connect(fuelMassFlowSensor.Mesure,gain1. u) annotation (Line(points={{2,-90.2},
          {2,-94},{-102,-94},{-102,-62},{-93,-62}},         color={0,0,255}));
  connect(add1.u1,constante4. y) annotation (Line(points={{59,-52},{74,-52},{74,
          -39},{95.3,-39}}, color={0,0,255}));
  connect(add1.y,fuelSourcePQ. IMassFlow)
    annotation (Line(points={{37,-58},{28,-58},{28,-67}}, color={0,0,255}));
  connect(sinkQ1.C,dynamicDrumAdapt. Cv)
    annotation (Line(points={{46,14},{34,14},{34,36},{18,36}},
                                               color={0,0,255}));
  connect(heatExchangerWall.WT2,dynamicDrumAdapt. Cth)
    annotation (Line(points={{8,5.6},{8,21}}, color={0,0,0}));
  connect(dynamicDrumAdapt.yLevel,feedback. u2)
    annotation (Line(points={{19,31},{48,31},{48,51}}, color={0,0,255}));
  connect(controlValve.C2,dynamicDrumAdapt. Ce1)
    annotation (Line(points={{-64,36},{-2,36}}, color={0,0,255}));
  connect(limiteur.y,controlValve. Ouv)
    annotation (Line(points={{-71,74},{-74,74},{-74,53}}, color={0,0,255}));
  connect(sortieNiveau, feedback.u2) annotation (Line(points={{114,34},{114,46},
          {48,46},{48,51}}, color={0,0,255}));
  connect(feedback.u1, constante1.y) annotation (Line(points={{59,62},{60,62},{
          60,63},{77.3,63}}, color={0,0,255}));
  connect(add.y, add2.u2)
    annotation (Line(points={{-19,68},{-23,68}}, color={0,0,255}));
  connect(add2.y, limiteur.u)
    annotation (Line(points={{-45,74},{-49,74}}, color={0,0,255}));
  connect(entreeNiveau, add2.u1) annotation (Line(points={{-4,92},{-20,92},{-20,
          80},{-23,80}}, color={0,0,255}));
  connect(dynamicDrumAdapt.yPression, gain2.u) annotation (Line(points={{19,27},
          {30.5,27},{30.5,-12},{67,-12}}, color={0,0,255}));
  connect(gain2.y, sortiePression)
    annotation (Line(points={{89,-12},{114,-12}}, color={0,0,255}));
  connect(add1.u2, entreePression) annotation (Line(points={{59,-64},{72,-64},{
          72,-72},{96,-72}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-140,-100},{140,100}})), Icon(
        coordinateSystem(extent={{-140,-100},{140,100}})));
end chaudiere_linearisation;
