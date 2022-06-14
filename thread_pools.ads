with Futures; use Futures;
with Jobs; use Jobs;

package Thread_Pools is
   
   type Thread_Pool is record
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Size : Natural;
   end record;

   task type Pool_thread is
      entry Initialize (J : Job_Callable);
   end Pool_thread;

end Thread_Pools;