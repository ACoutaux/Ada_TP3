package Protected_Buffer is


   --Length : constraint := 5; -- importer length du buffer en I/O

   type Items is array (Natural range <>) of Integer;
   type Items_Access is access Items;
   
   protected type Shared_Items (Length : Natural) is
      entry Get (I : out Integer); 
      entry Set (I : in Integer); 
      private
      First : Natural := 0;
      Last : Natural := Length - 1;
      Size : Natural := 0;
      Buffer : Items_Access := new Items (0 .. Length - 1);
   end Shared_Items;

   type Shared_Items_Access is access Shared_Items;

end Protected_Buffer;
