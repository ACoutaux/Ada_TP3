with Future_Protected_Buffers; use Future_Protected_Buffers;
with Futures; use Futures;
with Jobs; use Jobs;

package Thread_Pools is
   
   protected type Thread_Pool is 

      procedure Init(C : in Integer; M : in Integer);
      procedure Shutdown;

      procedure Create
        (F : Future; Force : Boolean; Done : out Boolean; Buffer : Buffer_Access);
      procedure Remove;

      procedure Get_Shutdown(S : out Boolean);

   private
      Core_Pool_Size : Natural;
      Max_Pool_Size : Natural;
      Shutdown_Activated : Boolean := False;
      Size : Integer := 0;
   end Thread_Pool;

   type Thread_Pool_Access is access Thread_Pool;

   task type Pool_thread is
      entry Initialize (F: Future; Buffer : Buffer_Access);
   end Pool_thread;

   type Pool_thread_Access is access Pool_thread;

   
end Thread_Pools;
