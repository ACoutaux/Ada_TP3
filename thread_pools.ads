with Runnables;
use Runnables;

package Thread_Pools is
   
   type Thread_Pool is record
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Size : Natural;
   end record;

   task type Exec_Runnable is
      entry Initialize (R: Runnable);
   end Exec_Runnable;

end Thread_Pools;