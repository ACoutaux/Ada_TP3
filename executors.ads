with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Ada.Calendar; use Ada.Calendar;

package Executors is

   protected type Executor is 
      procedure Init(F : Buffer_Access; P : Thread_Pool_Access);
      procedure Create
        (F : Future; Force : Boolean; Thread : out Pool_thread_Access);
      procedure Get_Pool(P : out Thread_Pool_Access);
      procedure Get_Buffer(B : out Buffer_Access);
      
   private
      Futures : Buffer_Access;
      Pool : Thread_Pool_Access;
   end Executor;

   type Executor_Access is access Executor;

   function Submit(E : Executor_Access; C : Callable_Access; Start_Time: Time) return Future;
   
   procedure Shutdown (E : Executor_Access);

end Executors;
