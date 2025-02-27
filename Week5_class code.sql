select *
from wordle

/*

%	match any string of zero or more characters
_	matches a single character
[]	match a single character listed within the brackets
[ - ]	match a single character within a given range
[ ^ ]	matches single character nmot lister after the caret

*/

select word, occurrence
from wordle
where word not like '%[wteod]%' -- letters not in the target word
	and word not like '%r' -- "r" is not the last letter
	and word not like '%r_' -- "r" is not the 4th letter
	and word not like '_r%' -- "r" is not the 2nd letter
	and word not like '_a%'	-- "a" is not the 2nd letter
	and word not like '__a%'	-- "a" is not 3rd character
	and word not like '%a_%'	-- "a" is not 4th character
	and word not like 'b%'	-- "b" is not first character
	and word not like '__b%'	-- "b" is not 3rd character
	and word not like 'u%'	-- "u" not the first character
	and word like '%a%'
	and word like '%r%'
	and word like '%b%'
	and word like '%u%'
order by occurrence desc
