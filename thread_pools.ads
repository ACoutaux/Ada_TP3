with Futures; use Futures;
with Jobs; use Jobs;

package Thread_Pools is
   
   protected type Thread_Pool is 

      procedure Init(C : in Integer; M: in Integer; S : in Integer);
      private
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Size : Natural;

   end Thread_Pool;

   type Thread_Pool_Access is access Thread_Pool;

   task type Pool_thread is
      entry Initialize (J : Job_Callable);
   end Pool_thread;
   
end Thread_Pools;