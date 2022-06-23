with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;

package Executors is

   protected type Executor is 
      procedure Init(F : Buffer_Access; K : Integer; P : Thread_Pool_Access);
      procedure Shutdown;
      procedure Create
        (F : Future; Force : Boolean; Done : out Boolean);
   private
      Futures : Buffer_Access;
      Keep_Alive_Time : Integer;
      Pool : Thread_Pool_Access;
      -- must declare new thread_pool to avoid limited type error
      -- procedure get_callable_result(F : in Future; R : out Result_Access);
   end Executor;

   type Executor_Access is access Executor;

   function submit(E : Executor_Access; C : Callable_Access) return Future;

end Executors;
