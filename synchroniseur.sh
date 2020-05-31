#!/bin/bash


function parcourir {
	if [[ -d $1 ]]; then
		cd $1
		for i in * ; do
			parcourir $i $2 $3 
		done
		cd ..
	else
		comparaison $1
		if [[ "$?" = "1" ]]; then
			#modification $1 $2 $3
			echo "ouais"
		fi
	fi
}

function comparaison
{
	fichier1=`ls -l $1 | grep $1`
	file_in_log=`grep $1 ~/.journal`
	if [[ "$fichier1" = "$file_in_log"  ]]; then		
		return 0
	else 	
		return 1
	fi
}


echo "entrer le nom du premier dossier a syncro"
read DossA
echo "entrer le nom du deuxieme dossier a syncro"
read DossB
pathA=`find ~ -type d -name $DossA` #voir pour les chemins
pathB=`find ~ -type d -name $DossB`

while [[ -z $pathA ]]; do
	echo "le premier dossier n'as pas été trouvé, merci de saisir a nouveau votre dossier"
	read DossA
	pathA=`find ~ -type d -name $DossA`
done
echo " premier trouvé"

while [[ -z $pathB ]]; do
	echo "le deuxieme dossier n'as pas été trouvé, merci de saisir a nouveau votre dossier"
	read DossB
	pathB=`find ~ -type d -name $DossB`
done
echo " deuxieme trouvé"
#path$1, nom arbre explorer, path arbre explorer, path autre arbre

if [[ ! -e .journal ]]; then
	echo -e "aucun journal de synchronisation trouvé, choissisez  quel dossier synchroniser \n1 pour le premier dossier\n2 pour le deuxieme dossier"
	read choix
	if [[ $choix = 1 ]]; then
		rm -rf DossB
		cp -pr DossA DossB
		touch .journal
		ls -lR DossA | grep ^- > .journal
		echo "Mise a niveau des dossiers et création du journal de synchronisation"
	else #ajouter une condition
		rm -rf DossA
		cp -pr DossB DossA
		touch .journal
		ls -lR DossB | grep ^- > .journal
		echo "Mise a niveau des dossiers et création du journal de synchronisation"
	fi
else
	#if [[ ! -e .modif ]]; then
	#	touch .modif
	#fi
	echo "le journal existe deja"
	echo "$pathA"
	echo "$pathB"
	echo -e "DossA\n"
	parcourir $pathA $pathA $pathB 
	#parcourir $pathB $pathB $pathA 
fi





