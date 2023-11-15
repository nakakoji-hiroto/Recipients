class Public::HomesController < ApplicationController
  def top
    @new_recipes = Recipe.where(is_release: true).order('id DESC').limit(4)
    now = Time.current
    #注目レシピ >> 直近1週間の閲覧数が多かった順に投稿レシピを4つ表示する（公開状態のレシピのみ対象とする）
    @noticed_recipes = Recipe.where(is_release: true).includes(:view_counts).sort_by { |recipe| -recipe.view_counts.where(created_at: now.ago(6.days)..now).count }.first(4)
  end
end
