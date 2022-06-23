
package Futures is
   
   type Callable is tagged null record;
   
   --  Pointer to any deriived type of Callable
   type Callable_Access is access all Callable'Class;
   
   type Result is tagged null record;
   type Result_Access is access all Result'Class;
   
   protected type Protected_Future is
      entry Get_Result (R : out Result_Access);
      procedure Set_Result (R : in Result_Access);
      procedure Set_Completed (C : Boolean);
      procedure Set_Callable(C : Callable_Access);
      procedure Get_Callable(C : out Callable_Access);
   private   
      Callable  : Callable_Access;
      Result    : Result_Access;
      Completed : Boolean;
   end Protected_Future;

   type Future is access Protected_Future;

   Procedure Run(C : Callable; R : out Result_Access);

   type Periodic_Callable is new Callable with
   record
      Period : Duration;
   end record;
            
end Futures;