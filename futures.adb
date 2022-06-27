with Ada.Calendar; use Ada.Calendar;

package body Futures is

   protected body Protected_Future is
      entry Get_Result (R : out Result_Access) when Completed is
      begin
         R := Result;
      end Get_Result;

      procedure Set_Result (R : in Result_Access) is
      begin
         Result := R;
         Completed := True;
      end Set_Result;

      procedure Set_Completed (C : Boolean) is
      begin
         Completed := C;
      end Set_Completed;

      procedure Set_Callable(C : Callable_Access) is
      begin
         Callable := C;
      end Set_Callable;

      procedure Get_Callable(C : out Callable_Access) is
      begin
         C := Callable;
      end Get_Callable;

   end Protected_Future;

   procedure Run(C : Callable; R : out Result_Access; Start_Time : Time) is
   begin
        null;
   end Run;

   
end Futures;
