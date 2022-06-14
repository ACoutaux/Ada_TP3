with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;

package Executors is

   type Executor is record
      Futures : Buffer_Access;
      Keep_Alive_Time : Duration;
      Pool : Thread_Pool;
   end record;

   function submit(E : Executor; C : Callable_Access) return Future;

end Executors;