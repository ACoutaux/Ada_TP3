package Protected_Buffer is

   Length : Natural := 10; -- importer length du buffer en I/O
   type Items is array (0 .. Length - 1) of Integer;
   
   protected Shared_Items is
      entry Get (I : out Integer); 
      entry Set (I : in Integer); 
      private
      First : Natural := 0;
      Last : Natural := Length;
      Size : Natural := 0;
      Buffer : Items;
   end Shared_Items;

end Protected_Buffer;
