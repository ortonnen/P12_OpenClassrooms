# WaWe (What are We eating)

WaWe is a cooking application that allows you to search for recipes based on ingredients, with the possibility of adding filters.
You can also keep your favorite recipes as favorites, and create your own recipes.

The application is therefore divided into several parts:
 - 🔎 the research
 - 🥙 recipe creation
 - 📖 consultation of recipes
 - ⭐️ favorites

You can navigate using a tab bar, and buttons

   <img width="315" alt="Capture d’écran 2021-05-27 à 10 00 49" src="https://user-images.githubusercontent.com/57671772/119814462-b7c99c00-beea-11eb-8931-25a4cac30150.png">

***
## 🔎 Research

Here's how the user can search:

<img width="315" alt="Capture d’écran 2021-05-27 à 10 01 54" src="https://user-images.githubusercontent.com/57671772/120165339-c28e7480-c1fb-11eb-9a2c-22d43ee4f338.png">.           .<img width="315" alt="Capture d’écran 2021-05-27 à 10 02 08" src="https://user-images.githubusercontent.com/57671772/120165366-cae6af80-c1fb-11eb-99ad-f143a979a242.png">

#### 🥦 The user chooses their ingredients

* A text field allows him to add his ingredients one by one
after the others.
* Pressing the "enter" key adds an ingredient to the list.
* If the user has the possibility of erasing the ingredients cell by cell by performing a lateral swipe.
* Pressing the "Filter" button sends on a View modal, which allows you to select search criteria.
* Pressing the "Search" button starts the search for
recipes.

## 🥙 The recipe creation

To create a recipe, the user can enter certain fields.

<img width="315" alt="Capture d’écran 2021-05-27 à 10 35 52" src="https://user-images.githubusercontent.com/57671772/120167450-0da98700-c1fe-11eb-803e-e555a2eee735.png">.   .<img width="315" alt="Capture d’écran 2021-05-27 à 10 40 23" src="https://user-images.githubusercontent.com/57671772/120167604-3af63500-c1fe-11eb-8208-71d9c7dd28e8.png">


#### ℹ️ the user enters the information necessary for his recipe

* The "Add a photo" button allows the user to choose from his photo library, an image to associate with the recipe
* Several text fields allow you to enter:
  - the title of the recipe: this field is essential to validate the creation of the recipe
  - the number of portions provided for this recipe
* Ingredients can be added:
  - Three text fields allow you to enter the name, the quantity and the desired unit.
  - The "Add an ingredient" button allows you to save the ingredient.
  - Ingredient deletion can be done either line by line, or by pressing the "Delete ingredients" button
* The button "Add instructions" allows the user to add details on the realization of his recipe.
* The "Create recipe" button allows you to validate the creation of the recipe

## 📖 Consult the recipes

The display of recipes, whether after launching the search, consulting the recipes created or favorites, always looks the same.

<img width="314" alt="Capture d’écran 2021-05-31 à 11 07 31" src="https://user-images.githubusercontent.com/57671772/120170051-dbe5ef80-c200-11eb-92f4-06bc8a9f4f69.png">.  <img width="315" alt="Capture d’écran 2021-05-27 à 10 03 35" src="https://user-images.githubusercontent.com/57671772/120170087-e43e2a80-c200-11eb-863c-6f2798388160.png">.  <img width="315" alt="Capture d’écran 2021-05-27 à 11 01 16" src="https://user-images.githubusercontent.com/57671772/120170111-ea340b80-c200-11eb-897d-4b0994cbc18d.png">

#### 📋 The recipe display

The recipes are displayed in a tableView, we find there:
 - The title of the recipe
 - the image of the recipe

#### 📝 Details of the recipes

To have the detail of a recipe, it is necessary to select it in the tableView.
The detail of the recipe contains all the elements necessary for its realization:
 - Title and image
 - The estimated preparation time
 - the number of portions planned
 - the list of ingredients used
 - the detail of the recipe
 
##### ⭐️ Favorites

Favorites are accessed via the Bar tab. When the user launches the recipe search he has the possibility:
 - Add the recipe to your favorites via the "Add to favorites" button located in the navigation bar.
 - Once this has been added, the "remove from favorites" button replaces the previous one

##### 🥗 The recipes created

You can access your favorites via the "Consult my recipes" button.
When the user consults his recipes he has the possibility to delete the created recipe via the button "delete the recipe" located in the navigation bar.

#### 🌎 The Map View

The user has the possibility of consulting the stores close to him. For this he can:
 - Press the button "Where to find my products" which refers it to a map
 - Activate geolocation to find businesses near him
 - Consult via the displayed bullets the businesses which interests him near him


