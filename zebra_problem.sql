--- zebra problem
--- from :  https://en.wikipedia.org/wiki/Zebra_Puzzle
  with house
    as (select 1 as houseID union all select 2 union all select 3 union all select 4 union all select 5),
       houseColor
    as (select 'yellow' as color union all select 'blue' union all 
	    select 'red' union all select 'ivory' union all select 'green'),
       nationality
    as (select 'Norwegian' as nationality union all select 'Ukrainian' union all 
	    select 'Englishman' union all select 'Spaniard' union all select 'Japanese'),
       drink
    as (select 'Water' as drink union all select 'Tea' union all 
	    select 'Milk' union all select 'Orange juice' union all select 'Coffee'),
       smoke
    as (select 'Kools' as brandName union all select 'Chesterfield' union all 
	    select 'Old Gold' union all select 'Lucky Strike' union all select 'Parliment'),
       pet
    as (select 'fox' as pet union all select 'horse' union all 
	    select 'snails' union all select 'dog' union all select 'zebra'),
       solutionUniverse
    as (select houseID, color, nationality, drink, brandName as smoke, pet 
          from house a
               cross join houseColor
               cross join nationality
               cross join drink
               cross join smoke
               cross join pet),
       singleHouseClues
    as (select * 
          from solutionUniverse
         where 1 = 1
           -- clue 2
           and not (nationality = 'Englishman' and color != 'red')
           and not (color = 'red' and nationality != 'Englishman')
           -- clue 3
           and not (nationality = 'Spaniard' and pet != 'dog')
           and not (pet = 'dog' and nationality != 'Spaniard')
           -- clue 4
           and not (drink = 'coffee' and color != 'green')
           and not (color = 'green' and drink != 'coffee')
           -- clue 5
           and not (nationality = 'Ukrainian' and drink != 'coffee')
           and not (drink = 'coffee' and nationality != 'Ukrainian')
           -- clue 7
           and not (smoke = 'Old Gold' and pet != 'snails')
           and not (pet = 'snails' and smoke != 'Old Gold')
           -- clue 8
           and not (smoke = 'Kools' and color != 'yellow')
           and not (color = 'yellow' and smoke != 'Kools')
           -- clue 9  - "middle house" is houseID = 3
           and not (drink = 'milk' and houseID != 3)
           and not (houseID = 3 and drink != 'milk')
           -- clue 13
           and not (smoke = 'Lucky Strike' and drink != 'Orange juice')
           and not (drink = 'Orange juice' and smoke != 'Lucky Strike')
           -- clue 14
           and not (nationality = 'Japanese' and smoke != 'Parliment')
           and not (smoke = 'Parliment' and nationality != 'Japanese')), 
     -- Still need to do the following  "multi-house clues"
       -- clue 6
	   -- clue 10
       -- clue 11
       -- clue 12
	   -- clue 15
     -- put the remaining houses into all possible orders
       fiveHouseOrderings
    as (select a.color as house1color, a.nationality as house1nationality,
	           a.drink as house1drink, a.smoke as house1smoke, a.pet as house1pet,
			   b.color as house2color, b.nationality as house2nationality,
	           b.drink as house2drink, b.smoke as house2smoke, b.pet as house2pet,
			   c.color as house3color, c.nationality as house3nationality,
	           c.drink as house3drink, c.smoke as house3smoke, c.pet as house3pet,
			   d.color as house4color, d.nationality as house4nationality,
	           d.drink as house4drink, d.smoke as house4smoke, d.pet as house4pet,
			   e.color as house5color, e.nationality as house5nationality,
	           e.drink as house5drink, e.smoke as house5smoke, e.pet as house5pet
	      from (select color, nationality, drink, smoke, pet
		          from singleHouseClues
				 where houseID = 1) a
               cross join
               (select color, nationality, drink, smoke, pet
		          from singleHouseClues
				 where houseID = 2) b
               cross join
               (select color, nationality, drink, smoke, pet
		          from singleHouseClues
				 where houseID = 3) c
               cross join
               (select color, nationality, drink, smoke, pet
		          from singleHouseClues
				 where houseID = 4) d
               cross join
               (select color, nationality, drink, smoke, pet
		          from singleHouseClues
				 where houseID = 5) e
         -- ensure no repeated colors, nationalities, drink, etc
	/*	 where a.color <> b.color and a.color <> c.color and a.color <> d.color and a.color <> e.color
           and b.color <> c.color and b.color <> d.color and b.color <> e.color
           and c.color <> d.color and c.color <> e.color
           and d.color <> e.color
           and a.nationality <> b.nationality and a.nationality <> c.nationality and a.nationality <> d.nationality and a.nationality <> e.nationality
           and b.nationality <> c.nationality and b.nationality <> d.nationality and b.nationality <> e.nationality
           and c.nationality <> d.nationality and c.nationality <> e.nationality
           and d.nationality <> e.nationality
           and a.drink <> b.drink and a.drink <> c.drink and a.drink <> d.drink and a.drink <> e.drink
           and b.drink <> c.drink and b.drink <> d.drink and b.drink <> e.drink
           and c.drink <> d.drink and c.drink <> e.drink
           and d.drink <> e.drink
           and a.smoke <> b.smoke and a.smoke <> c.smoke and a.smoke <> d.smoke and a.smoke <> e.smoke
           and b.smoke <> c.smoke and b.smoke <> d.smoke and b.smoke <> e.smoke
           and c.smoke <> d.smoke and c.smoke <> e.smoke
           and d.smoke <> e.smoke
           and a.pet <> b.pet and a.pet <> c.pet and a.pet <> d.pet and a.pet <> e.pet
           and b.pet <> c.pet and b.pet <> d.pet and b.pet <> e.pet
           and c.pet <> d.pet and c.pet <> e.pet
           and d.pet <> e.pet */
		   )
select *
  from fiveHouseOrderings
 where 1=1
   -- clue 6  The green house is immediately to the right of the ivory house.
   and (
         (house1color = 'ivory' and house2color = 'green') OR
         (house2color = 'ivory' and house3color = 'green') OR
         (house3color = 'ivory' and house4color = 'green') OR
         (house4color = 'ivory' and house5color = 'green')
       )
   -- clue 10  The Norwegian lives in the first house.
   and house1nationality = 'Norwegian'
   -- clue 11  The man who smokes Chesterfields lives in the house next to the man with the fox.
   and (
         (house1smoke = 'Chesterfield' and house2pet = 'fox') OR
         (house2smoke = 'Chesterfield' and (house1pet = 'fox' OR house3pet = 'fox')) OR
         (house3smoke = 'Chesterfield' and (house2pet = 'fox' OR house4pet = 'fox')) OR
         (house4smoke = 'Chesterfield' and (house3pet = 'fox' OR house5pet = 'fox')) OR
         (house5smoke = 'Chesterfield' and house4pet = 'fox')
       )
   -- clue 12  Kools are smoked in the house next to the house where the horse is kept.
   and (
         (house1smoke = 'Kools' and house2pet = 'horse') OR
         (house2smoke = 'Kools' and (house1pet = 'horse' OR house3pet = 'horse')) OR
         (house3smoke = 'Kools' and (house2pet = 'horse' OR house4pet = 'horse')) OR
         (house4smoke = 'Kools' and (house3pet = 'horse' OR house5pet = 'horse')) OR
         (house5smoke = 'Kools' and house4pet = 'horse')
       )
   -- clue 15  The Norwegian lives next to the blue house.
   and (
         (house1nationality = 'Norwegian' and house2color = 'blue') OR
         (house2nationality = 'Norwegian' and (house1color = 'blue' OR house3color = 'blue')) OR
         (house3nationality = 'Norwegian' and (house2color = 'blue' OR house4color = 'blue')) OR
         (house4nationality = 'Norwegian' and (house3color = 'blue' OR house5color = 'blue')) OR
         (house5nationality = 'Norwegian' and house4color = 'blue')
	   )
;

/* CLUES
1. There are five houses.
2. The Englishman lives in the red house.
3. The Spaniard owns the dog.
4. Coffee is drunk in the green house.
5. The Ukrainian drinks tea.
6. The green house is immediately to the right of the ivory house.
7. The Old Gold smoker owns snails.
8. Kools are smoked in the yellow house.
9. Milk is drunk in the middle house.
10. The Norwegian lives in the first house.
11. The man who smokes Chesterfields lives in the house next to the man with the fox.
12. Kools are smoked in the house next to the house where the horse is kept.
13. The Lucky Strike smoker drinks orange juice.
14. The Japanese smokes Parliaments.
15. The Norwegian lives next to the blue house.
*/