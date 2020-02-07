select
rpad(a.name,14,' ') as 'Name          ', rpad(c.Name,10,' ')  as 'Pokemon   ', b.distance as 'Dist', b.min_iv as 'minIV', b.max_iv as 'maxIV', b.min_cp as 'minCP', b.max_cp as 'maxCP', b.min_level as 'minLvl', b.max_level as 'maxLvl', b.atk, b.def, b.sta, b.min_weight as '<Weight', b.max_weight as '>Weight', b.form, b.maxAtk, b.maxDef, b.maxSta, b.gender 
from
poracle.humans a, poracle.monsters b, pogodb.PokemonList c
where
a.name = 'XXA' and
a.id = b.id and
b.pokemon_id = c.Number
;
