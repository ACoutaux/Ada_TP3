with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;

package Executors is

   protected type Executor is 
      Procedure Init(F : in Buffer_Access; K : Integer; P : in Thread_Pool_Access);
      private
      Futures : Buffer_Access;
      Keep_Alive_Time : Integer;
      Pool : Thread_Pool_Access := new Thread_Pool; --must declare new thread_pool to avoid limited type error
   end Executor;

   function submit(E : Executor; C : Callable_Access) return Future;

end Executors;