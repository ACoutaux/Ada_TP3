with Futures; use Futures;


package Jobs is


   type Job_Result is new Result with null record;
   
   type Job_Callable is new Callable with record
      Exec_Time : Duration;
   end record;

   procedure Run (J : Job_Callable; R : out Result_Access);

end Jobs;