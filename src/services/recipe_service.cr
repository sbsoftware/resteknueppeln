class RecipeService
  def self.create_recipe(group : Group) : Recipe
    alcoholic_beverages = GroupBeverage.where({"group_id" => group.id}).map(&.beverage).select(&.alcoholic.value)
    non_alcoholic_beverages = GroupBeverage.where({"group_id" => group.id}).map(&.beverage).reject(&.alcoholic.value)

    name = generate_name
    recipe = Recipe.create(group_id: group.id, name: name)

    remaining_cl = 20
    while remaining_cl > 0
      current_cl = Random.new.rand(1..({remaining_cl, 4}.min))
      alc = Random.new.next_bool

      if alc && alcoholic_beverages.any?
        beverages = alcoholic_beverages
      elsif !alc && non_alcoholic_beverages.any?
        beverages = non_alcoholic_beverages
      elsif !alc && alcoholic_beverages.any?
        beverages = alcoholic_beverages
      elsif alc && non_alcoholic_beverages.any?
        beverages = non_alcoholic_beverages
      else
        remaining_cl = 0
        return recipe
      end

      index = Random.new.rand(0..(beverages.size - 1))
      beverage = beverages.delete_at(index)
      Ingredient.create(recipe_id: recipe.id, beverage_id: beverage.id, amount_cl: current_cl.to_i64)
      remaining_cl = remaining_cl - current_cl
    end

    recipe
  end

  NAME_PREFIXES = %w[Full Virgin Chaotic Yellow Half Despicable Favorite Simple Easy Generous Sparkling Mysterious Bloody Massive]
  NAME_MIDDLES = %w[Star Corner Table Head Maxi Sonja Lightning Boy Girl Sugar Felix Benny Mary Kevin Olga Maze Michelle Rapha Monja Steve Basti]
  NAME_SUFFIXES = %w[Thrower Tank Destroyer Footgun Separator Channeler Daddy Enlarger Womanizer]

  def self.generate_name
    "#{NAME_PREFIXES.sample} #{NAME_MIDDLES.sample} #{NAME_SUFFIXES.sample}"
  end
end
