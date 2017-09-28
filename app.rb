require 'bundler/setup'
Bundler.require(:default)
require 'pry'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file}


get ('/') do
  @recipes = Recipe.all
  erb(:index)
end

post('/') do
  name = params.fetch("name")
  recipe = Recipe.create({:name => name})
  @recipes = Recipe.all
  erb(:index)
end

get('/recipes/:id') do
  @recipe = Recipe.find(params.fetch(:id).to_i)
  @ingredients = @recipe.ingredients
  erb(:recipes)
end

get('/recipe/:id/edit') do
  @recipe = Recipe.find(params[:id].to_i)
  @ingredients = @recipe.ingredients
  erb(:recipe_edit)
end

post('/recipe/:id/edit') do
  @recipe = Recipe.find(params[:id].to_i)
  @ingredients = Ingredient.create({:food => params.fetch('food')})
  @recipe.ingredients.push(@ingredients)
  @recipe.save
  erb(:recipe_edit)
end

post('/recipe/:id/add_instruction') do
  @recipe = Recipe.find(params[:id].to_i)
  @recipe.instruction = params.fetch('instructions')
  @recipe.save
  erb(:recipe_edit)
end

delete('/recipe/:id/delete') do
  @recipe = Recipe.find(params[:id].to_i)
  @recipe.destroy
  redirect '/'
end

delete('/recipe/:id/edit/delete') do
  @recipe = Recipe.find(params[:id].to_i)
  @ingredients = @recipe.ingredients
  ingredient_ids = params.fetch('ingredient_ids')
  ingredient_ids.each do |ingredient_id|
  checked_ingredient = Ingredient.find(ingredient_id)
  @recipe.ingredients.destroy(checked_ingredient)
  end
  # checked_ingredients = Recipe.find(params[:ingredient_ids])
  # checked_ingredients.where(:ingredient_ids [params:id]).destroy_all
  @recipe.save
  erb(:recipes)
end
