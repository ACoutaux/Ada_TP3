with Ada.Calendar; use Ada.Calendar;
generic
   type Element is private;
package Generic_Protected_Buffers is
   
   type Sem_Type is (Blocking, Non_Blocking, Timed);
   
   type Element_Table is array (Natural range <>) of Element;
   type Element_Table_Access is access Element_Table;
   
   protected type Buffer (Length : Natural) is
      entry Get (E : out Element); 
      entry Put (E : in Element); 
      private
      First : Natural := 0;
      Last : Natural := Length - 1;
      Size : Natural := 0;
      Table : Element_Table_Access := new Element_Table (0 .. Length - 1);
   end Buffer;
   type Buffer_Access is access Buffer;

   Full_Buffer_Exception : exception;
   Empty_Buffer_Exception : exception;
   
   procedure Add (B : in out Buffer; E : Element);
   procedure Offer (B : in out Buffer; E : Element; Deadline : Time);
   --procedure Remove (B : in out Buffer; E : out Element);
   -- Poll (B : in out Buffer; E : out Element; Deadline : Time);

end Generic_Protected_Buffers;