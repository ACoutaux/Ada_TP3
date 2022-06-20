with Futures; use Futures;
with Jobs; use Jobs;

package Thread_Pools is
   
   protected type Thread_Pool is 

      procedure Init(C : in Integer; M : in Integer);
      procedure Pool_Shutdown;

      private
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Shutdown : Boolean;
      Size : Integer := 0;

      procedure Create(J : Job_Callable; F : Future; Force : Boolean);
      procedure Remove;

   end Thread_Pool;

   type Thread_Pool_Access is access Thread_Pool;

   task type Pool_thread is
      entry Initialize (J : Job_Callable);
   end Pool_thread;

   type Pool_thread_Access is access Pool_thread;
   
end Thread_Pools;