within Dimensionnement_chaudiere;
model Essaye_LQG

  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante1(k=0)
    annotation (Placement(transformation(extent={{154,68},{140,82}})));
  LQG lQG(
    Na=6,
    A=[-0.0325,-0.0510,0.0242,0.0134,0.0285,0.0343; -0.0497,-0.0927,0.0151,
        0.0151,0.0428,0.0626; 0.0238,0.0324,-0.0314,-0.0283,-0.0202,-0.0216;
        0.0130,0.0129,-0.0101,-0.0515,-0.0348,-0.0177; 0.0314,0.0353,-0.0379,-0.0204,
        -0.0362,-0.0266; 0.0349,0.0616,-0.0139,-0.0160,-0.0336,-0.0438],
    B=[43.0123,-4.9936; 14.9322,-16.4618; -49.3533,50.1204; 28.1344,-25.2495; -63.2412,
        11.8401; -16.3775,-35.4516],
    C=[0.0001,0.0003,-0.0001,-0.0002,0,-0.0002; 81.2587,-67.8040,-76.5881,
        45.1978,-27.3101,-129.5513],
    K=[1.5714,124.9474; 11.6000,-1.9828; -35.0287,-1.3599; 10.3581,26.6029;
        3.3795,-187.2163; 18.5237,-148.8923],
    L=[0.0022,-0.0026,-0.0020,0.0015,-0.0006,-0.0037; 0.0002,-0.0004,0,0.0001,0,
        -0.0005],
    M=[0.6094,1e-5; -4.0750,5e-6])
    annotation (Placement(transformation(extent={{102,56},{82,76}})));
  ThermoSysPro.Combustion.CombustionChambers.GenericCombustion
    genericCombustion
    annotation (Placement(transformation(extent={{-60,-62},{-28,-30}})));
  ThermoSysPro.Combustion.BoundaryConditions.FuelSourcePQ fuelSourcePQ(T0(
        displayUnit="K") = 300, Q0=0.141329)
    annotation (Placement(transformation(extent={{20,-84},{0,-64}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourcePQ sourcePQ(
    h0=104928,
    Q0=0.0170,
    P0=110000)
    annotation (Placement(transformation(extent={{-96,-48},{-76,-28}})));
  ThermoSysPro.FlueGases.BoundaryConditions.SourcePQ sourcePQ1(
    T0(displayUnit="K") = 300,
    Xco2=0.0006,
    Xh2o=0,
    Xo2=0.2314,
    Xso2=0,
    Q0=2.50943,
    P0=110000)
    annotation (Placement(transformation(extent={{-90,-86},{-70,-66}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante5(k=723029)
    annotation (Placement(transformation(extent={{-156,4},{-142,18}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante10(k=
        10.6793e5)
    annotation (Placement(transformation(extent={{-158,36},{-144,50}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante2(k=2.78)
    annotation (Placement(transformation(extent={{64,6},{50,20}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante8(k=
        2.7784e06)
    annotation (Placement(transformation(extent={{64,-20},{50,-6}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SinkQ sinkQ1
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP sourceP(option_temperature=
       2) annotation (Placement(transformation(extent={{-142,24},{-122,44}})));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(
    L=8,
    D=0.05,
    e=3.e-3,
    lambda=21.4,
    cpw=573,
    rhow(displayUnit="kg/m3") = 4579,
    ntubes=1400,
    Ns=10)
    annotation (Placement(transformation(extent={{-28,-18},{8,18}})));
  ThermoSysPro.FlueGases.HeatExchangers.StaticWallFlueGasesExchanger
    staticWallFlueGasesExchanger(
    L=8,
    Dext=0.05,
    exchanger_type=2,
    NbTub=1400,
    Ns=10,
    Tp0=471.06,
    Tm(start=fill(1250, 10)))
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  ThermoSysPro.FlueGases.BoundaryConditions.Sink sink
    annotation (Placement(transformation(extent={{20,-42},{40,-22}})));
  ThermoSysPro.WaterSteam.PressureLosses.ControlValve controlValve(Cvmax=115.84)
    annotation (Placement(transformation(extent={{-116,30},{-96,50}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante3(k=0.25)
    annotation (Placement(transformation(extent={{4,62},{-10,76}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{44,36},{24,56}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-24,42},{-44,62}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain gain(Gain=10)
    annotation (Placement(transformation(extent={{10,36},{-10,56}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Gain gain1(Gain=20.687)
    annotation (Placement(transformation(extent={{-110,-74},{-90,-54}})));
  ThermoSysPro.Combustion.Sensors.FuelMassFlowSensor fuelMassFlowSensor(Q(start=
          0.141329))
    annotation (Placement(transformation(extent={{-6,-72},{-26,-92}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante4(k=0.12812)
    annotation (Placement(transformation(extent={{92,-86},{78,-72}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  Dimensionnement_chaudiere.DynamicDrumAdapt
                   dynamicDrumAdapt(
    Vertical=false,
    R=1.25,
    L=8,
    Cevap=0.13,
    Xlo=0,
    L1=8,
    PasL=0.06,
    Dext=0.056,
    xl(start=0.0009455),
    xv(start=1),
    zl(start=1.8538),
    Kpa=0,
    NbTub=1400,
    Ns=10,
    steady_state=false,
    Vf0=0.65,
    P0=1047930,
    Tp(start=455.02),
    rhol(start=772.997),
    rhov(start=5.37))
    annotation (Placement(transformation(extent={{-20,14},{0,34}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante7(k=1.8538)
    annotation (Placement(transformation(extent={{70,42},{56,56}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-54,48},{-74,68}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Logique.Echelon echelon(
      startTime=0.9e5)
    annotation (Placement(transformation(extent={{126,-8},{106,12}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante9(k=1.8538)
    annotation (Placement(transformation(extent={{170,56},{156,70}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante constante11(k=
        3.62078e5)
    annotation (Placement(transformation(extent={{154,-12},{140,2}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe(
    Starttime=1.1e5,
    Duration=100,
    Finalvalue=0.1)
    annotation (Placement(transformation(extent={{134,84},{114,104}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add3(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{128,28},{114,42}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add4(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{142,50},{126,66}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.NonLineaire.Limiteur limiteur(
      maxval=1, minval=0)
    annotation (Placement(transformation(extent={{-82,48},{-102,68}})));
equation
  connect(genericCombustion.Cws,sourcePQ. C) annotation (Line(points={{-58.4,
          -44.4},{-58.4,-38},{-76,-38}},
                                     color={0,0,255}));
  connect(genericCombustion.Ca,sourcePQ1. C) annotation (Line(
      points={{-48.8,-60.4},{-60,-60.4},{-60,-76},{-70,-76}},
      color={0,0,0},
      thickness=1));
  connect(constante8.y,sinkQ1. ISpecificEnthalpy) annotation (Line(points={{49.3,
          -13},{31.65,-13},{31.65,-5},{32,-5}},    color={0,0,255}));
  connect(sourceP.IPressure,constante10. y) annotation (Line(points={{-137,34},
          {-140,34},{-140,43},{-143.3,43}},
                                        color={0,0,255}));
  connect(sinkQ1.IMassFlow,constante2. y)
    annotation (Line(points={{32,5},{32,13},{49.3,13}},  color={0,0,255}));
  connect(constante5.y,sourceP. ISpecificEnthalpy) annotation (Line(points={{-141.3,
          11},{-132.65,11},{-132.65,29},{-132,29}},    color={0,0,255}));
  connect(staticWallFlueGasesExchanger.CTh,heatExchangerWall. WT1)
    annotation (Line(points={{-10,-17},{-10,-3.6}},
                                               color={0,0,0}));
  connect(genericCombustion.Cfg,staticWallFlueGasesExchanger. C1) annotation (
      Line(
      points={{-48.8,-31.6},{-49.4,-31.6},{-49.4,-20},{-20,-20}},
      color={0,0,0},
      thickness=1));
  connect(staticWallFlueGasesExchanger.C2,sink. C) annotation (Line(
      points={{0,-20},{12,-20},{12,-32},{20.2,-32}},
      color={0,0,0},
      thickness=1));
  connect(sourceP.C,controlValve. C1)
    annotation (Line(points={{-122,34},{-116,34}},
                                                 color={0,0,255}));
  connect(add.u1,constante3. y) annotation (Line(points={{-23,58},{-18,58},{-18,
          69},{-10.7,69}},color={0,0,255}));
  connect(add.u2,gain. y)
    annotation (Line(points={{-23,46},{-11,46}},
                                               color={0,0,255}));
  connect(gain.u,feedback. y)
    annotation (Line(points={{11,46},{23,46}}, color={0,0,255}));
  connect(gain1.y,sourcePQ1. IMassFlow)
    annotation (Line(points={{-89,-64},{-80,-64},{-80,-71}}, color={0,0,255}));
  connect(genericCombustion.Cfuel,fuelMassFlowSensor. C2) annotation (Line(
        points={{-39.2,-60.4},{-32,-60.4},{-32,-74},{-26.2,-74}}, color={0,0,0}));
  connect(fuelMassFlowSensor.C1,fuelSourcePQ. C)
    annotation (Line(points={{-6,-74},{0,-74}}, color={0,0,0}));
  connect(fuelMassFlowSensor.Mesure,gain1. u) annotation (Line(points={{-16,
          -92.2},{-16,-96},{-120,-96},{-120,-64},{-111,-64}},
                                                            color={0,0,255}));
  connect(add1.y,fuelSourcePQ. IMassFlow)
    annotation (Line(points={{19,-60},{10,-60},{10,-69}}, color={0,0,255}));
  connect(sinkQ1.C,dynamicDrumAdapt. Cv)
    annotation (Line(points={{22,0},{14,0},{14,34},{0,34}},
                                               color={0,0,255}));
  connect(heatExchangerWall.WT2,dynamicDrumAdapt. Cth)
    annotation (Line(points={{-10,3.6},{-10,19}},
                                              color={0,0,0}));
  connect(dynamicDrumAdapt.yLevel,feedback. u2)
    annotation (Line(points={{1,29},{34,29},{34,35}},  color={0,0,255}));
  connect(controlValve.C2,dynamicDrumAdapt. Ce1)
    annotation (Line(points={{-96,34},{-20,34}},color={0,0,255}));
  connect(feedback.u1,constante7. y) annotation (Line(points={{45,46},{50,46},{
          50,49},{55.3,49}}, color={0,0,255}));
  connect(add.y,add2. u2)
    annotation (Line(points={{-45,52},{-53,52}}, color={0,0,255}));
  connect(add1.u2, constante4.y) annotation (Line(points={{41,-66},{60,-66},{60,
          -79},{77.3,-79}}, color={0,0,255}));
  connect(add1.u1, lQG.CommandePression) annotation (Line(points={{41,-54},{74,
          -54},{74,63},{81,63}}, color={0,0,255}));
  connect(lQG.CommandeNiveau, add2.u1) annotation (Line(points={{81,69},{40,69},
          {40,86},{-40,86},{-40,64},{-53,64}}, color={0,0,255}));
  connect(constante11.y, add3.u1) annotation (Line(points={{139.3,-5},{139.3,
          39.2},{128.7,39.2}}, color={0,0,255}));
  connect(dynamicDrumAdapt.yPression, add3.u2) annotation (Line(points={{1,25},
          {133.5,25},{133.5,30.8},{128.7,30.8}}, color={0,0,255}));
  connect(add3.y, lQG.SortiePression) annotation (Line(points={{113.3,35},{
          113.3,36},{108,36},{108,58},{103,58}}, color={0,0,255}));
  connect(add4.u1, constante9.y) annotation (Line(points={{142.8,62.8},{148,
          62.8},{148,63},{155.3,63}}, color={0,0,255}));
  connect(add4.u2, feedback.u2) annotation (Line(points={{142.8,53.2},{142,53.2},
          {142,52},{162,52},{162,46},{88,46},{88,30},{34,30},{34,35}}, color={0,
          0,255}));
  connect(add4.y, lQG.SortieNiveau) annotation (Line(points={{125.2,58},{120,58},
          {120,62},{103,62}}, color={0,0,255}));
  connect(echelon.yL, lQG.inputLogical)
    annotation (Line(points={{105,2},{92,2},{92,57}}, color={0,0,255}));
  connect(lQG.ConsignePression, constante1.y) annotation (Line(points={{103,70},
          {122,70},{122,75},{139.3,75}}, color={0,0,255}));
  connect(rampe.y, lQG.ConsigneNiveau) annotation (Line(points={{113,94},{108,
          94},{108,74},{103,74}}, color={0,0,255}));
  connect(add2.y, limiteur.u)
    annotation (Line(points={{-75,58},{-81,58}}, color={0,0,255}));
  connect(limiteur.y, controlValve.Ouv)
    annotation (Line(points={{-103,58},{-106,58},{-106,51}}, color={0,0,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-100},{180,100}})),
    Icon(coordinateSystem(extent={{-160,-100},{180,100}})));
end Essaye_LQG;
