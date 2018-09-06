--Name: Chris Rand
--Date: March 20th, 2018
--Course: ITEC 320 Procedural Analysis and Design

--Purpose: This body implements the stack specification given
with ada.text_io;
with ada.integer_text_io;

package body calcpkg is
   ----------------------------------------------------------
   -- Purpose: Gets the next expression from input 
   -- Parameters: c: Calculation to hold expression
   -- Precondition: Expression is valid
   -- Postcondition: Outputs the full expression in c w/o spaces
   ----------------------------------------------------------
	procedure get(c: in out Calculation) is
		use ada.text_io;
		char: Character; --Holds current character
	begin
		c.pos := 1;
		loop
			get(char);
			if char /= ' ' then
				c.inputExp(c.pos) := char;
				c.pos := c.pos + 1;
			end if;
			exit when char = '=';
		end loop;
	end get;

	----------------------------------------------------------
	-- Purpose: Prints the formatted calculation and the result 
	-- Parameters: c: Calculation to format and result: Integer result
	-- Precondition: calculation/result are valid
	-- Postcondition: Printed output of calculation/result
	----------------------------------------------------------
	procedure put(c: in Calculation; result: in Integer) is
		use ada.text_io, ada.integer_text_io;
	begin
		for i in 1 .. c.pos - 1 loop --determines where to put spaces below
			put(c.inputExp(i));
			if c.inputExp(i) = '*' and c.inputExp(i+1) /= '*' then
				put(' ');
			elsif c.inputExp(i) = '-' and i = 1 then
				null;
			elsif c.inputExp(i) = '-' and i /= 1 then
				if c.inputExp(i-1) in '0' .. '9' and c.inputExp(i) = '-' then
					put(' ');
				end if;
			elsif c.inputExp(i) in '0' .. '9' and 
				c.inputExp(i+1) not in '0' .. '9' 
				then
				put(' ');
			elsif c.inputExp(i) /= '*' and c.inputExp(i) /= '(' and 
				c.inputExp(i) /= ')' and c.inputExp(i) 
			not in '0' .. '9'  then
				put(' ');
			elsif c.inputExp(i) = '(' and c.inputExp(i+1) /= '(' then
				put(' ');
			elsif c.inputExp(i) = ')' and c.inputExp(i+1) /= ')' then
				put(' ');
			end if;
		end loop;
		put(result, Width => 1);
		new_line;
	end put;
	
	----------------------------------------------------------
	-- Purpose: Get the desired character from the expression string 
	-- Parameters: c: expression string, position: pos of character
	-- Precondition: position is within string range
	-- Postcondition: Returns character from the expression at position
	----------------------------------------------------------
	function getChar(c: in Calculation; position: in Integer) 
		return Character is
	char: Character; --Holder for current character
	begin
		char := c.inputExp(position);
		return char;
	end getChar;
	
	----------------------------------------------------------
	-- Purpose: Returns the expression length
	-- Parameters: c: expression string
	-- Precondition: expression string is not empty
	-- Postcondition: Returns Integer of expression length
	----------------------------------------------------------	
	function getLen(c: in Calculation) return Integer is
	len: Integer; --Length of expression string
	begin
		len := c.pos;
		return len;
	end getLen;
	
end calcpkg;
		