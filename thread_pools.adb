with Future_Protected_Buffers; use Future_Protected_Buffers;
with Ada.Calendar; use Ada.Calendar;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Thread_Pools is

   protected body Thread_Pool is
      procedure Init (C : in Integer; M : in Integer; K : Duration) is
      begin
         Core_Pool_Size := C;
         Max_Pool_Size := M;
         Keep_Alive_Time := K;
      end Init;

      procedure Create 
        (F : Future; Force : Boolean; Thread : out Pool_thread_Access)
      is
      begin
         Thread := null;
         if (Size < Core_Pool_Size) or else
           (Force and Size < Max_Pool_Size)
         then
            Thread := new Pool_Thread ;
            Size := Size + 1;
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

      procedure Get_Keep_Alive_Time(K : out Duration) is
      begin
         K := Keep_Alive_Time;
      end Get_Keep_Alive_Time;

   end Thread_Pool;

   task body Pool_thread is
      R : Result_Access;
      S : Boolean := False;
      P : Thread_Pool_Access;
      Current_Future : Future;
      Current_Callable : Callable_Access;
      Future_Buffer : Buffer_Access;
      Keep_Alive_Duration : Duration;
      Current_time : Time;
      Time_to_wait : Time;
      Execution_Time : Duration;
      Start_Time : Time;
   begin
      accept Initialize (F : Future; Buffer : Buffer_Access; Pool : Thread_Pool_Access; T : Time) do
         Current_Future := F;
         Future_Buffer := Buffer;
         Start_Time := T;
         P := Pool;
         P.Get_Keep_Alive_Time (Keep_Alive_Duration);
         Execution_Time := Clock - Start_Time;
         Put("["); Put(Integer(Execution_Time * 1000.0),5); Put("]   ");
         Put_Line("Thread created");
      end Initialize;
      loop
         exit when (Current_Future = null);
         Current_Future.Get_Callable (Current_Callable);
         Current_Callable.Run(R,Start_Time);
         loop --periodic

            Current_Future.Set_Result(R);

            if (Current_Callable.Period = 0.0) then
               Current_Future.Set_Completed(True);
               exit;
            end if;

            Current_time := Clock;
            delay until(Current_Time + Current_Callable.Period);

            P.Get_Shutdown (S);
            if (S) then
               exit;
            end if;
         end loop;

         if (Integer(Keep_Alive_Duration) = -1) then 

            Current_Future := null;
            Future_Buffer.Get(Current_Future);

            if (Current_Future = null) then
               exit;
            end if;
         else
            Current_time := Clock;
            Time_to_wait := Current_time + Keep_Alive_Duration;
            Poll(Future_Buffer,Time_to_wait,Current_Future); 

            if (Current_Future = null) then
               exit;
            end if;
         end if;

         Add(Future_Buffer,null);
         
      end loop;
   end Pool_Thread;

end Thread_Pools;
