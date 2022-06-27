with Future_Protected_Buffers; use Future_Protected_Buffers;
with Futures; use Futures;
with Jobs; use Jobs;
with Ada.Calendar; use Ada.Calendar;

package Thread_Pools is

   type Thread_Pool;
   type Thread_Pool_Access is access Thread_Pool;

   task type Pool_thread is
      entry Initialize (F: Future; Buffer : Buffer_Access; Pool : Thread_Pool_Access; T : Time);
   end Pool_thread;

   type Pool_thread_Access is access Pool_thread;

   protected type Thread_Pool is 

      procedure Init(C : in Integer; M : in Integer; K : Duration);
      procedure Shutdown;

      procedure Create
        (F : Future; Force : Boolean; Thread : out Pool_thread_Access);
      procedure Remove;

      procedure Get_Shutdown(S : out Boolean);
      procedure Get_Keep_Alive_Time(K : out Duration);
      
      function Get_Size return Natural;

   private
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Shutdown_Activated : Boolean := False;
      Size : Integer := 0;
      Keep_Alive_Time : Duration;
   end Thread_Pool;

end Thread_Pools;
