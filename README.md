# cosim_edf

## Cosim with FMPy

Le code utilisé peut être trouvé dans un fichier zip envoyé avec ce rapport, ou sous ce répertoire. Il est divisé en trois dossiers correspondant aux différentes parties du projet. 

Le dossier Generation contient un sous dossier pour la génération de FMU en Matlab/SIMULINK et un dossier pour la génération en Modelica.

Le dossier Exploration\_Cosim contient un sous dossier pour chaque plateforme sur laquelle la cosimulation a été effectuée pour l'intégrateur. Les fichiers à utiliser sont pour la cosimulation sont :

- ` Cosim\_Simulink.slx` pour la cosimulation en Simulink

- `SSPTest.ssp` pour la cosimulation en Modelica

- `example\_cosim.py et fmu\_handle.py` pour la cosimulation en Python

- `Example\_daccosim.simx`: pour la cosimulation en Daccosim

Les autres fichiers de ces dossiers correspondent aux FMU utilisées ou à des exportations de résultats.

Le dossier Chaudiere est en deux parties. La partie Dimensionnement\_Chaudière contient les modèles Modelica de la chaudière. Le dossier Cosim contient la FMU de la chaudière et le modèle Simulink l'exploitant.
