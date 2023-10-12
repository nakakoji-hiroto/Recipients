class Public::HomesController < ApplicationController
  def top
    @new_recipes = Recipe.order('id DESC').limit(3)
  end
end
