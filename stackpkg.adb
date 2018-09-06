--Name: Chris Rand
--Date: March 20th, 2018
--Course: ITEC 320 Procedural Analysis and Design

--Purpose: This body implements the stack specification given
package body stackpkg is
   ----------------------------------------------------------
   -- Purpose: Checks if stack is empty 
   -- Parameters: s: the stack to check
   -- Precondition: the stack is valid
   -- Postcondition: Returns boolean of empty status
   ----------------------------------------------------------
   function isEmpty (s: Stack) return Boolean is
   empty: Boolean; --Holds stack status
   begin
      if s.Top = 0 then
         empty := true;
      else
         empty := false;
      end if;
      return empty;
   end isEmpty;
   ----------------------------------------------------------
   -- Purpose: Checks if stack is full 
   -- Parameters: s: stack to check
   -- Precondition: the stack is valid
   -- Postcondition: Returns boolean of full status
   ----------------------------------------------------------
   function isFull (s: Stack) return Boolean is
   full: Boolean; --Holds stack status
   begin
      if s.Top = 100 then
         full := true;
      else
         full := false;
      end if;
      return full;
   end isFull;
   ----------------------------------------------------------
   -- Purpose: Pushes item onto the stack
   -- Parameters: item: item to push, s: stack to push onto
   -- Precondition: item and stack type match
   -- Postcondition: Outputs stack with new element on top
   ----------------------------------------------------------
   procedure push (item: in ItemType; s: in out Stack) is
   begin
      if isFull(s) then
         raise Stack_Full;
      end if;
      s.Top := s.Top + 1;
      s.Elements(s.Top) := item;
   end push;
   ----------------------------------------------------------
   -- Purpose: Pops element off the stack 
   -- Parameters: s: stack to pop
   -- Precondition: stack is not empty
   -- Postcondition: Outputs stack with one less element
   ----------------------------------------------------------
   procedure pop (s: in out Stack) is
   begin
      if isEmpty(s) then
         raise Stack_Empty;
      end if;
      s.Top := s.Top - 1;
   end pop;
   ----------------------------------------------------------
   -- Purpose: Gets top element on the stack without removing
   -- Parameters: s: stack to check
   -- Precondition: stack is not empty
   -- Postcondition: Returns ItemType top element
   ----------------------------------------------------------
   function top (s: in Stack) return ItemType is
   begin
      if isEmpty(s) then
         raise Stack_Empty;
      end if;
      return s.Elements(s.Top);
   end top;

end stackpkg;

      