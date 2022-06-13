with Ada.Calendar; use Ada.Calendar;

package Protected_Buffer is
   
   type Sem_Type is (Blocking, Non_Blocking, Timed);
   
   type Items is array (Natural range <>) of Integer;
   type Items_Access is access Items;
   
   protected type Shared_Items (Length : Natural) is
      entry Get (I : out Integer); 
      entry Put (I : in Integer); 
      private
      First : Natural := 0;
      Last : Natural := Length - 1;
      Size : Natural := 0;
      Buffer : Items_Access := new Items (0 .. Length - 1);
   end Shared_Items;

   type Shared_Items_Access is access Shared_Items;
   
   Full_Buffer_Exception : exception;
   Empty_Buffer_Exception : exception;
   
   procedure Add (Items : Shared_Items_Access; Value : Integer);
   procedure Offer (Items : Shared_Items_Access; Value : Integer; Deadline : Time);
   function Remove (Items : Shared_Items_Access) return Integer;
   function Poll (Items : Shared_Items_Access; Deadline : Time) return Integer;

end Protected_Buffer;