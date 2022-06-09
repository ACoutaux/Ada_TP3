with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;

package Executors is
   
   type Executor is record
      Futures : Buffer_Access;
      Keep_Alive_Time : Duration;
      Pool : Thread_Pool;
   end record;

end Executors;
