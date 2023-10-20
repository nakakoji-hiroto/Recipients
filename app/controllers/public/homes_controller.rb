class Public::HomesController < ApplicationController
  def top
    @new_recipes = Recipe.order('id DESC').limit(4)
    now = Time.current
    @noticed_recipes = Recipe.includes(:view_counts).sort_by { |recipe| -recipe.view_counts.where(created_at: now.ago(6.days)..now).count }.first(4)
  end
end
