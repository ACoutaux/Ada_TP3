with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;

package Executors is

   protected type Executor is 
      Procedure Init(F : in Buffer_Access; K : in Duration; P : in Thread_Pool_Access);
      private
      Futures : Buffer_Access;
      Keep_Alive_Time : Duration;
      Pool : Thread_Pool;
   end Executor;

   function submit(E : Executor; C : Callable_Access) return Future;

end Executors;