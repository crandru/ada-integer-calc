-- Name: Chris Rand
-- Date: March 20th, 2018
-- Course: ITEC 320 Procedural Analysis and Design

-- Purpose: This program performs calculations using the five basic math
-- operators & parentheses, in both left to right and in op/prec order.
-- Input: An expression of alternating Integer operands/operators ended with =
-- Output: Formatted calculation and value for both l-r and op/prec orders.
-- Example: Text file with following expressions
-- 2+3*5=
-- 2 * (3 + 4) =
-- 2-5=  16/3=
-- Printed output below:
-- 2 + 3 * 5 = 25
-- 2 + 3 * 5 = 17
-- 2 * (3 + 4) = 14
-- 2 * (3 + 4) = 14
-- 2 - 5 = -3
-- 2 - 5 = -3
-- 16 / 3 = 5
-- 16 / 3 = 5

-- Help received: Material from 320 Course page and Ada 2005 Textbook
-- no outside help.
-- Please forgive me for I have used the String approach
with ada.text_io; use ada.text_io;
with stackpkg;
with calcpkg; use calcpkg;

procedure do_calcs is
   package IntStackPk is new stackpkg(Size => 100, ItemType => Integer);
   package CharStackPk is new stackpkg(Size => 100, ItemType => Character);
   use IntStackPk, CharStackPk;
   ----------------------------------------------------------
   -- Purpose: Performs operation on two operands
   -- Parameters: intS, charS: stacks containing operands/operator
   -- Precondition: stacks have valid operands/operator
   -- Postcondition: result of operation placed on intS
   ----------------------------------------------------------
   procedure performOp(intS: in out IntStackPk.Stack;
      charS: in out CharStackPk.Stack) is
      left, right: Integer;
      operator: Character;
   begin
      right := top(intS);
      pop(intS);
      left := top(intS);
      pop(intS);
      operator := top(charS);
      pop(charS);

      case operator is
         when '+' => push(left + right, intS);
         when '-' => push(left - right, intS);
         when '/' => push(left / right, intS);
         when '*' => push(left * right, intS);
         when '^' =>
            if right >= 0 then
               push(left**right, intS);
            else
               push(0,intS);
            end if;
         when others => raise Program_Error;
      end case;
   end performOp;

   ----------------------------------------------------------
   -- Purpose: Converts Character into Integer
   -- Parameters: char: Character to convert
   -- Precondition: char is a valid char '0' .. '9'
   -- Postcondition: Returns Integer version of char
   ----------------------------------------------------------
   function convert(char: Character) return Integer is
      begin
         return Character'Pos(char) - 48;
   end convert;

   ----------------------------------------------------------
   -- Purpose: Performs calculation in left to right order
   -- Parameters: c: Calculation expression to process
   -- Precondition: Calculation is valid expression
   -- Postcondition: Returns Integer result of calculation
   ----------------------------------------------------------
   function left_to_right(calc: in Calculation) return Integer is
      pos: Integer := 1; --Position in string
      charIn: Character; --Holds current character
      intStack: IntStackPk.Stack; --Stack of operands
      charStack: CharStackPk.Stack; --Stack of operators
      intAmt: Integer := 0; --Determines when to performOp
      charAmt: Integer := 0; --Determines when to performOp
      firstParen: Boolean := false; --Identifies if first char is paren
      fullInt: Integer := 0; --Container for integer larger than 1 digit
      newPos, digit: Integer; --Tracks amount of digits & new position
   begin
      if getChar(calc, pos) = '(' then
         firstParen := true;
      end if;
      loop
         charIn := getChar(calc, pos);
         exit when charIn = '=';
         if charIn in '0' .. '9' then --handles any digits
            digit := 0;
            newPos := pos;
            fullInt := convert(charIn);
            while getChar(calc, newPos + 1) in '0' .. '9' loop
               digit := digit + 1;
               newPos := newPos + 1;
            end loop;
            fullInt := fullInt * (10 ** digit);
            digit := digit - 1;
            while digit >= 0 loop
               pos := pos + 1;
               charIn := getChar(calc, pos);
               fullInt := fullInt + (convert(charIn) * (10 ** digit));
               digit := digit - 1;
            end loop;
            push(fullInt, intStack);
            intAmt := intAmt + 1;
         else --handles operators or negates operands
            case charIn is
               when '(' =>
                  push(charIn, charStack);
                  intAmt := 0;
                  charAmt := 0;
               when ')' =>
                  if top(charStack) = '(' then
                     pop(charStack);
                  end if;
                  intAmt := 2;
                  charAmt := 1;
                  if not isEmpty(charStack) then
                     if top(charStack) = '(' then
                        intAmt := 1;
                        charAmt := 0;
                     end if;
                  end if;

                  if firstParen then
                     intAmt := 1;
                     charAmt := 0;
                     firstParen := false;
                  end if;
               when others =>
                  if charIn = '*' then
                     if getChar(calc, pos + 1) = '*' then
                        push('^', charStack);
                        pos := pos + 1;
                     else
                        push(charIn, charStack);
                     end if;
                     charAmt := charAmt + 1;
                  elsif pos /= 1 and charIn = '-' then
                     if getChar(calc, pos - 1) not in '0' .. '9' then
                        pos := pos + 1;
                        charIn := getChar(calc, pos);
                        digit := 0;
                        newPos := pos;
                        fullInt := convert(charIn);
                        while getChar(calc, newPos + 1) in '0' .. '9' loop
                           digit := digit + 1;
                           newPos := newPos + 1;
                        end loop;
                        fullInt := fullInt * (10 ** digit);
                        digit := digit - 1;
                        while digit >= 0 loop
                           pos := pos + 1;
                           charIn := getChar(calc, pos);
                           fullInt := fullInt +
                               (convert(charIn) * (10 ** digit));
                           digit := digit - 1;
                        end loop;
                        push(fullInt * (-1), intStack);
                        intAmt := intAmt + 1;
                     else
                        push(charIn, charStack);
                        charAmt := charAmt + 1;
                     end if;
                  elsif pos = 1 and charIn = '-' then
                     pos := pos + 1;
                     charIn := getChar(calc, pos);
                     digit := 0;
                     newPos := pos;
                     fullInt := convert(charIn);
                     while getChar(calc, newPos + 1) in '0' .. '9' loop
                        digit := digit + 1;
                        newPos := newPos + 1;
                       end loop;
                     fullInt := fullInt * (10 ** digit);
                     digit := digit - 1;
                     while digit >= 0 loop
                        pos := pos + 1;
                        charIn := getChar(calc, pos);
                        fullInt := fullInt + (convert(charIn) * (10 ** digit));
                        digit := digit - 1;
                     end loop;
                     push(fullInt * (-1), intStack);
                     intAmt := intAmt + 1;
                  else
                        push(charIn, charStack);
                        charAmt := charAmt + 1;
                  end if;
            end case;
         end if;
         if intAmt = 2 and charAmt = 1 then --empties remaining operators/opand
            if top(charStack) = '(' then
               pop(charStack);
            end if;
            performOp(intStack, charStack);
            intAmt := 1;
            charAmt := 0;
         end if;
         pos := pos + 1;
      end loop;
      return top(intStack);
   end left_to_right;

   ----------------------------------------------------------
   -- Purpose: Determines priority of character
   -- Parameters: op: character to check
   -- Precondition: op is one of 7 valid operators
   -- Postcondition: Returns Integer of op priority (0-3)
   ----------------------------------------------------------
   function priority(op: Character) return Integer is
   begin
      case op is
         when '!' | '(' => return 0;
         when '+' | '-' => return 1;
         when '*' | '/' => return 2;
         when '^' => return 3;
         when others => raise Program_Error;
      end case;
   end priority;

   ----------------------------------------------------------
   -- Purpose: Performs calculation in operator precedence order
   -- Parameters: calc: Calculation expression to process
   -- Precondition: Calculation is a valid expression
   -- Postcondition: result of operation placed on intS
   ----------------------------------------------------------
   function op_precedence(calc: in Calculation) return Integer is
      pos: Integer := 1; --Position in string
      charIn: Character; --Holds current character
      intStack: IntStackPk.Stack; --Stack of operands
      charStack: CharStackPk.Stack; --Stack of operators
      firstParen: Boolean := false; --Identifies if first char is paren
      fullInt: Integer := 0; --Container for integer larger than 1 digit
      newPos, digit: Integer; --Tracks amount of digits & new position
   begin
      push('!', charStack); --Identifies end of operations
      if getChar(calc, pos) = '(' then
         firstParen := true;
      end if;
      loop
         charIn := getChar(calc, pos);
         exit when charIn = '=';
         if charIn in '0' .. '9' then --handles any digits
            digit := 0;
            newPos := pos;
            fullInt := convert(charIn);
            while getChar(calc, newPos + 1) in '0' .. '9' loop
               digit := digit + 1;
               newPos := newPos + 1;
            end loop;
            fullInt := fullInt * (10 ** digit);
            digit := digit - 1;
            while digit >= 0 loop
               pos := pos + 1;
               charIn := getChar(calc, pos);
               fullInt := fullInt + (convert(charIn) * (10 ** digit));
               digit := digit - 1;
            end loop;
            push(fullInt, intStack);
         else --handles operators or negates operands
            case charIn is
               when '(' =>
                  push(charIn, charStack);
               when ')' =>
                  while top(charStack) /= '(' loop
                     performOp(intStack, charStack);
                  end loop;
                  pop(charStack);
                  if firstParen then
                     firstParen := false;
                  end if;
               when others =>
                  if charIn = '*' then
                     if getChar(calc, pos + 1) = '*' then
                        while priority('^') <= priority(top(charStack)) loop
                           performOp(intStack, charStack);
                        end loop;
                        push('^', charStack);
                        pos := pos + 1;

                     else
                        while priority(charIn) <= priority(top(charStack)) loop
                           performOp(intStack, charStack);
                        end loop;
                        push(charIn, charStack);
                     end if;
                  elsif pos /= 1 and charIn = '-' then
                     if getChar(calc, pos - 1) not in '0' .. '9' then
                        pos := pos + 1;
                        charIn := getChar(calc, pos);
                        digit := 0;
                        newPos := pos;
                        fullInt := convert(charIn);
                        while getChar(calc, newPos + 1) in '0' .. '9' loop
                           digit := digit + 1;
                           newPos := newPos + 1;
                        end loop;
                        fullInt := fullInt * (10 ** digit);
                        digit := digit - 1;
                        while digit >= 0 loop
                           pos := pos + 1;
                           charIn := getChar(calc, pos);
                           fullInt := fullInt +
                               (convert(charIn) * (10 ** digit));
                           digit := digit - 1;
                        end loop;
                        push(fullInt * (-1), intStack);
                     else
                        while priority(charIn) <= priority(top(charStack)) loop
                           performOp(intStack, charStack);
                        end loop;
                        push(charIn, charStack);
                     end if;
                  elsif pos = 1 and charIn = '-' then
                     pos := pos + 1;
                     charIn := getChar(calc, pos);
                     digit := 0;
                     newPos := pos;
                     fullInt := convert(charIn);
                     while getChar(calc, newPos + 1) in '0' .. '9' loop
                        digit := digit + 1;
                        newPos := newPos + 1;
                       end loop;
                     fullInt := fullInt * (10 ** digit);
                     digit := digit - 1;
                     while digit >= 0 loop
                        pos := pos + 1;
                        charIn := getChar(calc, pos);
                        fullInt := fullInt + (convert(charIn) * (10 ** digit));
                        digit := digit - 1;
                     end loop;
                     push(fullInt * (-1), intStack);
                  else
                     while priority(charIn) <= priority(top(charStack)) loop
                           performOp(intStack, charStack);
                     end loop;
                     push(charIn, charStack);
                  end if;
            end case;
         end if;
         pos := pos + 1; --advances string
      end loop;
      while top(charStack) /= '!' loop --empties remaining operands/operators
         performOp(intStack, charStack);
      end loop;
      return top(intStack);
   end op_precedence;

   c: Calculation;
begin
   while not end_of_file loop
         get(c);
         put(c, left_to_right(c));
         put(c, op_precedence(c));
   end loop;
end do_calcs;


