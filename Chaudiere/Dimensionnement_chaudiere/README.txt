Le fichier DynamicDrumAdapt correspond au modèle de la cavité utilisé pour la chaudière.

Le fichier Calculs est un modèle texte où on a saisi les équations des flux de chaleurs entre la cavité, 
les tubes et les parois des tubes et on a fixé les paramètres connus pour calculer le nombre de tubes 
nécessaire. Il n'y a pas d'affichage graphique, c'est juste du texte.

Le fichier bruleur_dimensionnement est un modèle texte où on a saisi les équations du brûleur et on a fixé
les paramètres connus pour calculer le débit de gaz, d'air et d'eau nécessaire pour avoir le point d'équilibre.
Il n'y a pas d'affichage graphique, c'est juste du texte.

Le fichier test_chaudiere_complete rassemble tous les éléments de la chaudière, avec les paramètres calculés
pour avoir l'équilibre dans le point de fonctionnement décrit dans le rapport. On peut le simuler à partir
de l'équilibre.

Le fichier test_chaudiere_complete_init en est une copie aux paramètres initiaux modifiés.

Le fichier test_chaudiere_complete_FMU en est une copie avec les ports d'entrée, sortie et conversion entre ThermoSysPro et
Modelica pour permettre la génération de FMU.

Le fichier test_chaudiere_complete_init_FMU en est une copie aux paramètres initiaux modifiés.

Le fichier test_chaudiere_complet_vanne correspond au modèle précédent avec une vanne entre la condition
limite d'eau alimentaire et la cavité. On n'arrive pas à le simuler à partir de l'équilibre.

Le fichier chaudiere_linéarisation contient le modèle de la chaudière avec la vanne, la commande proportionnelle
de niveau et des connecteurs entrées/sorties pour faire la linéarisation du modèle. La linéarisation doit être
faite juste après l'équilibre (environ 100000s). Dans ce modèle, on a déjà adapté les paramètres pour avoir
une dynamique plus rapide, comme décrit dans le rapport.

Le modèle test_reg_niveau-pression correspond au modèle de la chaudière dimensionnée avec la régulation PI 
pour le niveau et pour la pression. Les gains et les Ti des PI ont été calculés dans le rapport.

Le modèle LQG est le bloc d'un régulateur LQG avec deux entrées de mesure, deux entrées de consigne et deux 
sorties de commande. Il faut saisir les matrices d'état, le gain du retour d'état et de l'observateur pour
l'utiliser.

Le modèle Essaye_LQG utilise la commande proportionnelle et la commande LQG pour commander la chaudière. La
commande LQG est activée après que le point d'équilibre est atteint. C'est pour cela que la commande 
proportionnelle est aussi nécessaire dans ce modèle : amener le système au point d'équilibre.

Les modèles AdaptatorModelicaTSP et AdaptatorTSPModelica permettent la conversion entre Modelica et
ThermoSysPro.