with Future_Protected_Buffers; use Future_Protected_Buffers;
with Ada.Calendar; use Ada.Calendar;

package body Thread_Pools is

   protected body Thread_Pool is
      procedure Init (C : in Integer; M : in Integer) is
      begin
         Core_Pool_Size := C;
         Max_Pool_Size := M;
      end Init;

      procedure Create 
        (F : Future; Force : Boolean; Done : out Boolean; Buffer : Buffer_Access; Keep_Alive_Time : Duration)
      is
         Thread : Pool_Thread_Access;
      begin
         Done := False;
         if (Size < Core_Pool_Size) or else
           (Force and Size < Max_Pool_Size)
         then
            Thread := new Pool_Thread;
            Size := Size + 1;
            Done := True;
            Thread.Initialize(F,Buffer,Keep_Alive_Time);
         end if;
      end Create;

      procedure Shutdown is 
      begin
         Shutdown_Activated := True;
      end;

      procedure Remove is
      begin
         if (Size > Core_Pool_Size)
           or else (Shutdown_Activated)
         then
            Size := Size - 1;
         end if;
      end Remove;

      procedure Get_Shutdown(S : out Boolean) is
      begin
         S := Shutdown_Activated;
      end Get_Shutdown;

   end Thread_Pool;

   task body Pool_thread is
      R : Result_Access;
      S : Boolean := False;
      --P : Thread_Pool_Access;
      Current_Future : Future;
      Current_Callable : Callable_Access;
      Future_Buffer : Buffer_Access;
      Keep_Alive_Duration : Duration;
      Current_time : Time := Clock;
      Time_to_wait : Time;
   begin
      accept Initialize (F : Future; Buffer : Buffer_Access; Keep_Alive_Time : Duration) do
         Current_Future := F;
         Future_Buffer := Buffer;
         Keep_Alive_Duration := Keep_Alive_Time;
      end Initialize;
      loop
         Current_Future.Get_Callable (Current_Callable);
         Current_Callable.Run(R);

         --P.Get_Shutdown(S);
         Current_Future.Set_Result(R);

         --if (Current_Callable.Period = 0) then
         --   null;
         --end if;

         if (Integer(Keep_Alive_Duration) = -1) then 

            Future_Buffer.Get(Current_Future);
         else
            Time_to_wait := Current_time + Keep_Alive_Duration;
            Poll(Future_Buffer,Time_to_wait,Current_Future); 
         end if;

         --exit when S;
      end loop;
   end Pool_Thread;

end Thread_Pools;
