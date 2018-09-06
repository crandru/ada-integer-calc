--Name: Chris Rand
--Date: March 20th, 2018
--Course: ITEC 320 Procedural Analysis and Design

--Purpose: Creates the public facing Calculation package
package calcpkg is

	type Calculation is private;

	procedure get(c: in out Calculation);
	procedure put(c: in Calculation; result: in Integer);
	function getChar(c: in Calculation; position: in Integer) return Character;
	function getLen(c: in Calculation) return Integer;

private
	type calculation is record
		inputExp: String(1..100); --Expression in string form
		pos: Positive := 1; --Length of expression string
	end record;
end calcpkg;