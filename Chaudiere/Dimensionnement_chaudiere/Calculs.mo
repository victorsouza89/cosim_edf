within Dimensionnement_chaudiere;
model Calculs

protected
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Real Optl=ThermoSysPro.Correlations.Misc.WBCorrectiveDiameterCoefficient(1.32,0.66,0.05)
    "Geometrical parameter";
  parameter Modelica.SIunits.Area Sgaz=100*(1 - 0.05/0.066)
    "Geometrical parameter";

public
  Modelica.SIunits.Temperature Tpl "External temperature";
  Modelica.SIunits.Temperature Tp "External temperature";
  Modelica.SIunits.Temperature Tpgazes "External temperature";
  Modelica.SIunits.Temperature TFilm "External temperature";
  Modelica.SIunits.Temperature DeltaT "External temperature";
  Modelica.SIunits.Power W "Total power exchanged on the liquid ";
  Modelica.SIunits.DynamicViscosity mult
    "liquid dynamic viscosity at wall ";
  Real ntubes "Number of pipes in parallel";
  Modelica.SIunits.CoefficientOfHeatTransfer K
    "Total heat exchange coefficient";
  Modelica.SIunits.CoefficientOfHeatTransfer Kcc
    "Convective heat exchange coefficient";
  Modelica.SIunits.CoefficientOfHeatTransfer Krr
    "Radiative heat exchange coefficient";

equation

  W = 5.639e6;

  /*Partie cavité*/
  mult = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(773, Tpl);
  W = -0.36*0.55864/0.056 *2670.43^0.55 *0.918669^0.3333 *(1.15336e-4/mult)^0.14*pi*0.056*8*ntubes*(455.05 - Tpl);

  /*Partie tubes*/
  W = - 2*pi*8*ntubes*21.4/0.023912157*(Tpl - Tp);
  W = 2*pi*8*ntubes*21.4/0.025305865*(Tpgazes - Tp);

  /*Partie fumees*/
  Kcc = ThermoSysPro.Correlations.Thermal.WBLongitudinalCurrentConvectiveHeatTransferCoefficient(TFilm, 750, 3.02, 5, Sgaz, Sgaz*6.36436/ntubes);
  Krr = ThermoSysPro.Correlations.Thermal.WBRadiativeHeatTransferCoefficient(DeltaT, Tpgazes, 0.080655, 0.066031181, Optl);
  K = Kcc + Krr;
  DeltaT = 1250 - Tpgazes;
  TFilm = 0.5*(1250 + Tpgazes);
  W = pi*0.05*8*ntubes*K*(1250 - Tpgazes);

  annotation ();
end Calculs;
