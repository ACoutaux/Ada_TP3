with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Jobs; use Jobs;
with Ada.Text_IO; use Ada.Text_IO;
                  
package body Executors is

    protected body Executor is
       procedure Init(F : Buffer_Access; P : Thread_Pool_Access) is
       begin
          Futures := F;
          Pool := P;
       end Init;
              
       procedure Create
         (F : Future; Force : Boolean; Thread : out Pool_thread_Access)
       is
       begin
          Pool.Create(F, Force,Thread);
       end Create;

        procedure Get_Pool(P : out Thread_Pool_Access) is 
        begin
            P := Pool;
        end Get_Pool;

        procedure Get_Buffer(B : out Buffer_Access) is
        begin
            B := Futures;
        end Get_Buffer;

    end Executor;

    function Submit(E : Executor_Access; C : Callable_Access; Start_Time : Time) return Future is
        F : Future := new Protected_Future;
        Prev_F : Future;
        P : Thread_Pool_Access;
        B : Buffer_Access;
        Buffer_Not_Full : Boolean;
        Buffer_Not_Empty : Boolean;
        K : Duration;
        T : Pool_Thread_Access;
    begin
        F.Set_Callable(C);
        F.Set_Completed(False);
        E.Get_Pool(P);
        P.Get_Keep_Alive_Time(K);
        E.Create(F, False, T);
        E.Get_Buffer (B);
        if (T /= null) then
            T.Initialize (F, B, P, Start_Time);
            return F;
        end if;
        Add(B, F, Buffer_Not_Full);
        if (Buffer_Not_Full) then
            return F;
        end if;
        Remove(B, Prev_F, Buffer_Not_Empty);
        if (Buffer_Not_Empty) then
            Add(B, F);
            F := Prev_F;
        end if;
        E.Create(F, True, T);
        T.Initialize (F, B, P, Start_Time);
        return F;
    end Submit;
    
    procedure Shutdown (E : Executor_Access) is
       Shutdown_Future : Future := null;
       Done : Boolean;
       P : Thread_Pool_Access;
       B : Buffer_Access;
    begin
       E.Get_Pool(P);
       P.Shutdown;
       E.Get_Buffer(B);
       while P.Get_Size > 0 loop
          Add (B, Shutdown_Future, Done);
          delay 0.1;
       end loop;
    end Shutdown;

end Executors;
