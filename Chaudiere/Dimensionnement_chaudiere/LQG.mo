within Dimensionnement_chaudiere;
model LQG

  parameter Integer Na = 6 "Dimension de la matrice A";
  parameter Integer Nb = 2 "Nombre d'entrées de commande";
  parameter Integer Nc = 2 "Nombre de sorties";
  parameter Real A[Na,Na] "Matrice d'état";
  parameter Real B[Na,Nb] "Matrice de commande";
  parameter Real C[Nc,Na] "Matrice d'observation";
  parameter Real K[Na,Nc] "Gain de l'observateur";
  parameter Real L[Nb,Na] "Gain du retour d'état";
  parameter Real M[Nb,Nc] "Gain du retour d'état";

public
  Real X[Na] "Etat du système";
  Real U[Nb] "Entrees de commande";
  Real Z[Nc] "Sorties du système";
  Real Yc[Nc] "Consignes";

  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal ConsignePression
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal CommandePression
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal SortieNiveau
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal ConsigneNiveau
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal SortiePression
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal CommandeNiveau
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  ThermoSysPro.InstrumentationAndControl.Connectors.InputLogical inputLogical
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
initial equation
  U = fill(0,Nc);

equation
  Yc = {ConsigneNiveau.signal, ConsignePression.signal};
  Z = {SortieNiveau.signal, SortiePression.signal};
  U = {CommandeNiveau.signal, CommandePression.signal};

  if inputLogical.signal then
    U = -L*X + M*Yc;
    der(X) = (A-K*C)*X + B*U + K*Z;
  else
    CommandeNiveau.signal = 0;
    CommandePression.signal = 0;
    der(X) = fill(0,Na);
  end if;

  //der(X) = (A-K*C)*X + B*U + K*Z;

  annotation ();
end LQG;
