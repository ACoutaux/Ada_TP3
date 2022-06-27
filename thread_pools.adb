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
      
      function Get_Size return Natural is
      begin
         return Size;
      end Get_Size;

      procedure Remove (Done : out Boolean) is
      begin
         Done := False;
         if (Size > Core_Pool_Size)
           or else (Shutdown_Activated)
         then
            Done := True;
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
      Passed_Time : Duration;
      Deadline : Time;
      Start_Time : Time;
      Keep_Alive_Time_Milli : duration;
      Period_Milli : Duration;
      Done : Boolean;
  begin
      accept Initialize (F : Future; Buffer : Buffer_Access; Pool : Thread_Pool_Access; T : Time) do
         Current_Future := F;
         Future_Buffer := Buffer;
         Start_Time := T;
         P := Pool;
         P.Get_Keep_Alive_Time (Keep_Alive_Duration);
         Passed_Time := Clock - Start_Time;
         Put("["); Put(Integer(Passed_Time * 1000.0),5); Put("]   ");
         Put_Line("Thread created");
      end Initialize;
      Deadline := Start_Time;
      while (Current_Future /= null) loop
         Current_Future.Get_Callable (Current_Callable);
         loop --periodic

            Current_Callable.Run(R,Start_Time);
            Current_Future.Set_Result(R);

            if (Current_Callable.Period = 0.0) then
               Current_Future.Set_Completed(True);
               exit;
            end if;
            Period_Milli := Current_Callable.Period/1000.0;
            Deadline := Deadline + Period_Milli;
            delay until Deadline;
            
            P.Get_Shutdown (S);
            exit when S;
         end loop;

         Current_Future := null;
         if (Integer(Keep_Alive_Duration) = -1) then 

            Future_Buffer.Get(Current_Future);
            if Current_Future = null then
               P.Remove (Done);
               exit;
            end if;
            
         else
            Current_Future := null;
            while Current_Future = null loop
               Current_time := Clock;
               Keep_Alive_Time_Milli := Keep_Alive_Duration/1000.0;
               Time_to_wait := Current_time + Keep_Alive_Time_Milli;
               Poll(Future_Buffer,Time_to_wait,Current_Future, Done);
               if not Done then -- no future
                  P.Remove (Done); -- complete
                                   -- (Keep_Alive_Time or Shutdown)
                  exit when Done;
               elsif Current_Future = null then
                  P.Remove(Done); -- shutdown future
                                  -- complete
                  exit;
               end if;
            end loop;
            exit when Current_Future = null;
         end if;
      end loop;
      Passed_Time := Clock - Start_Time;
      Put("["); Put(Integer(Passed_Time * 1000.0),5); Put("]   ");
      Put_Line("Thread completed");
   end Pool_Thread;

end Thread_Pools;
