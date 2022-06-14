
package Futures is
   
   type Callable is tagged null record;
   
   --  Pointer to any deriived type of Callable
   type Callable_Access is access all Callable'Class;
   
   type Result is tagged null record;
   type Result_Access is access all Result'Class;
   
   type Future is record
      Callable  : Callable_Access;
      Result    : Result_Access;
      Completed : Boolean;
   end record;

   procedure Run(C : Callable; R : out Result_Access);

   type Periodic_Callable is new Callable with
      record
         Period : Duration;
      end record;
   
end Futures;