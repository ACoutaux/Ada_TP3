with Futures; use Futures;
with Ada.Calendar; use Ada.Calendar;

package Jobs is

   type Job_Result is new Result with null record;
   
   type Job_Callable is new Callable with record
      Exec_Time : Duration;
   end record;

   type Job_Callable_Access is access Job_Callable;

   procedure Run (J : Job_Callable; R : out Result_Access; Time_Begin : Time);

end Jobs;