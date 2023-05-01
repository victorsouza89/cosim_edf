Le fichier DynamicDrumAdapt correspond au mod�le de la cavit� utilis� pour la chaudi�re.

Le fichier Calculs est un mod�le texte o� on a saisi les �quations des flux de chaleurs entre la cavit�, 
les tubes et les parois des tubes et on a fix� les param�tres connus pour calculer le nombre de tubes 
n�cessaire. Il n'y a pas d'affichage graphique, c'est juste du texte.

Le fichier bruleur_dimensionnement est un mod�le texte o� on a saisi les �quations du br�leur et on a fix�
les param�tres connus pour calculer le d�bit de gaz, d'air et d'eau n�cessaire pour avoir le point d'�quilibre.
Il n'y a pas d'affichage graphique, c'est juste du texte.

Le fichier test_chaudiere_complete rassemble tous les �l�ments de la chaudi�re, avec les param�tres calcul�s
pour avoir l'�quilibre dans le point de fonctionnement d�crit dans le rapport. On peut le simuler � partir
de l'�quilibre.

Le fichier test_chaudiere_complete_init en est une copie aux param�tres initiaux modifi�s.

Le fichier test_chaudiere_complete_FMU en est une copie avec les ports d'entr�e, sortie et conversion entre ThermoSysPro et
Modelica pour permettre la g�n�ration de FMU.

Le fichier test_chaudiere_complete_init_FMU en est une copie aux param�tres initiaux modifi�s.

Le fichier test_chaudiere_complet_vanne correspond au mod�le pr�c�dent avec une vanne entre la condition
limite d'eau alimentaire et la cavit�. On n'arrive pas � le simuler � partir de l'�quilibre.

Le fichier chaudiere_lin�arisation contient le mod�le de la chaudi�re avec la vanne, la commande proportionnelle
de niveau et des connecteurs entr�es/sorties pour faire la lin�arisation du mod�le. La lin�arisation doit �tre
faite juste apr�s l'�quilibre (environ 100000s). Dans ce mod�le, on a d�j� adapt� les param�tres pour avoir
une dynamique plus rapide, comme d�crit dans le rapport.

Le mod�le test_reg_niveau-pression correspond au mod�le de la chaudi�re dimensionn�e avec la r�gulation PI 
pour le niveau et pour la pression. Les gains et les Ti des PI ont �t� calcul�s dans le rapport.

Le mod�le LQG est le bloc d'un r�gulateur LQG avec deux entr�es de mesure, deux entr�es de consigne et deux 
sorties de commande. Il faut saisir les matrices d'�tat, le gain du retour d'�tat et de l'observateur pour
l'utiliser.

Le mod�le Essaye_LQG utilise la commande proportionnelle et la commande LQG pour commander la chaudi�re. La
commande LQG est activ�e apr�s que le point d'�quilibre est atteint. C'est pour cela que la commande 
proportionnelle est aussi n�cessaire dans ce mod�le : amener le syst�me au point d'�quilibre.

Les mod�les AdaptatorModelicaTSP et AdaptatorTSPModelica permettent la conversion entre Modelica et
ThermoSysPro.