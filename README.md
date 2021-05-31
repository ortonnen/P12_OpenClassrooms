# WaWe (What are We eating)

WaWe est une application de cuisine qui permet de rechercher des recettes à partir d'ingrédients, en ayant la possibilité d'ajouter des filtres.
On peut également conserver ses recettes préférées en favoris, et créer ses propres recettes.
L'application est donc divisée en plusieurs parties : 
 - la recherche 
 - la création de recette
 - la consultation des recettes
 - les favoris

On peut naviguer grâce à une barre d'onglets ("Tab bar"), et des boutons

   <img width="315" alt="Capture d’écran 2021-05-27 à 10 00 49" src="https://user-images.githubusercontent.com/57671772/119814462-b7c99c00-beea-11eb-8931-25a4cac30150.png">

***
## La recherche

Voici comment l'utilisateur peut effectuer une recherche :

<img width="315" alt="Capture d’écran 2021-05-27 à 10 01 54" src="https://user-images.githubusercontent.com/57671772/120165339-c28e7480-c1fb-11eb-9a2c-22d43ee4f338.png">.           .<img width="315" alt="Capture d’écran 2021-05-27 à 10 02 08" src="https://user-images.githubusercontent.com/57671772/120165366-cae6af80-c1fb-11eb-99ad-f143a979a242.png">

#### L'utilisateur choisi ses ingrédients

* Un champ de texte lui permet d’ajouter ses ingrédients les uns
après les autres.
* L'appui sur la touche "entrée" ajoute un ingrédient à la liste.
* Si l'utilisateur à la possibilité d'effacer les ingredients cellules par cellules en effectuant un swipe lateral.
* L'appuis sur le bouton "Filtre" envois sur un modal View, qui permet de selectionner des critères de recherches.
* L'appui sur le bouton "Rechercher" lance la recherche de
recettes.

## La création de recette

Pour créer unen recette, l'utilisateur à la possiblité d'entrer certain champs.

<img width="315" alt="Capture d’écran 2021-05-27 à 10 35 52" src="https://user-images.githubusercontent.com/57671772/120167450-0da98700-c1fe-11eb-803e-e555a2eee735.png">.   .<img width="315" alt="Capture d’écran 2021-05-27 à 10 40 23" src="https://user-images.githubusercontent.com/57671772/120167604-3af63500-c1fe-11eb-8208-71d9c7dd28e8.png">


#### l'utilisateur entres les informations nécessaire pour sa recette

* Le bouton "Ajouter une photo" permet à l'utilisateur de choisir dans sa bibliothèque de photo, une image à associer à la recette
* Plusieurs champs de texte permettent de saisir:
  - le titre de la recette: ce champs et indispensable pour valider la création de la recette
  - le nombre de portion prévus pour cette recette
* Des ingrédients peuvent être ajouter:
  - Trois champs de texte permettent de saisir le nom, la quantité, et l'unité souhaiter.
  - Le bouton "Ajouter un ingrédient" permet d'enregistrer l'ingrédient.
  - La suppression d'ingrédient peut se faire soit ligne par ligne, soit en appuyant sur le bouton "Effacer les ingrédients"
* Le bouton "Ajouter des instructions" permet à l'utilisateur d'ajouter des détails sur la réalisation de sa recette.
* Le bouton "Créer la recette" permet de valider la création de la recette

## Consulter les recettes

L'affichage des recettes, que se soit après lancement de la recherche, la consultation des recettes crées ou les favoris, se présente toujours de la même manière.

<img width="314" alt="Capture d’écran 2021-05-31 à 11 07 31" src="https://user-images.githubusercontent.com/57671772/120170051-dbe5ef80-c200-11eb-92f4-06bc8a9f4f69.png">.  <img width="315" alt="Capture d’écran 2021-05-27 à 10 03 35" src="https://user-images.githubusercontent.com/57671772/120170087-e43e2a80-c200-11eb-863c-6f2798388160.png">.  <img width="315" alt="Capture d’écran 2021-05-27 à 11 01 16" src="https://user-images.githubusercontent.com/57671772/120170111-ea340b80-c200-11eb-897d-4b0994cbc18d.png">

#### L'affichage des recettes

L'affichage des recettes se fait dans une tableView, on y retrouve:
 - Le titre de la recette
 - l'image de la recette

#### Le détail des recettes

Pour avoir le détail d'une recette, il faut selectionner celle-ci dans la tableView.
Le détail de la recette contient tous les élèments nécessaire à sa réalisation:
 - Le titre et l'image
 - Le temps de préparation estimé
 - le nombre de portion prévu
 - la liste des ingrédients utilisés
 - le détail de la recette
 
##### Les Favoris

On accède aux favoris via la tab Bar. Lorsque l'utilisateur lance la recherche de recette il a la possibilité:
 - D'ajouter la recette à ses favoris via le bouton "Ajouter aux favoris" situé dans la barre de navigation.
 - Une fois celle-ci ajoutée, le bouton "retirer des favoris" remplace le précédent

##### Les recettes créées

On accède aux favoris via le bouton "Consulter mes recettes". 
Lorsque l'utilisateur consulte ses recettes il a la possibilité de supprimer la recette crées via le bouton "supprimer la recette" situé dans la barre de navigation.

#### La Map View

L'utilisateur à la possibilité de consulter les magasin proche de lui. Pour cela il peut:
 - Appuyer sur le bouton "Où trouver mes produits" qui le renvois sur une map
 - Activer la géolocalisation afin de trouver les commerces proche de lui
 - Consulter via les puces affichées les commerces qui l’intéresse près de lui 



