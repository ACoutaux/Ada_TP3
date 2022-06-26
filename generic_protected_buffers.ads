with Ada.Calendar; use Ada.Calendar;

generic
   type Element is private;
package Generic_Protected_Buffers is
      
   type Element_Table is array (Natural range <>) of Element;
   type Element_Table_Access is access Element_Table;
   
   protected type G_Buffer (Length : Natural) is
      entry Get (E : out Element); 
      entry Put (E : in Element); 
   private
      First : Natural := 0;
      Last : Natural := Length - 1;
      Size : Natural := 0;
      Table : Element_Table_Access := new Element_Table (0 .. Length - 1);
      Buffer : Element_Table_Access := new Element_Table (0 .. Length - 1);
   end G_Buffer;
   type Buffer_Access is access G_Buffer;

   procedure Get (B : Buffer_Access; E : out Element);
   procedure Remove (B : Buffer_Access; E: out Element); -- raise exception
   procedure Remove (B : Buffer_Access; E: out Element; Done : out Boolean);
   procedure Add (B: Buffer_Access; E : element; Done : out Boolean);
   procedure Add (B : Buffer_Access; E : element); --raise exception
   procedure Poll (B : Buffer_Access; T : Time; E: out Element); -- raise exception
   procedure Poll (B : Buffer_Access; T : Time; E: out Element; Done : out Boolean);
   procedure Offer (B : Buffer_Access; T : Time; E : element); --raise exception
   procedure Offer(B : Buffer_Access; T : Time; E : element; Done : out Boolean);

   Full_Buffer_Exception : exception;
   Empty_Buffer_Exception : exception;

end Generic_Protected_Buffers;
