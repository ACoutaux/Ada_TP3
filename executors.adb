with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Jobs; use Jobs;

package body Executors is

    protected body Executor is
       procedure Init(F : Buffer_Access; P : Thread_Pool_Access) is
       begin
          Futures := F;
          Pool := P;
       end Init;
              
       procedure Shutdown is
       begin
            Pool.Shutdown;
       end Shutdown;
       
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



    function Submit(E : Executor_Access; C : Callable_Access) return Future is
        F : Future := new Protected_Future;
        Pop_F : Future;
        P : Thread_Pool_Access;
        B : Buffer_Access;
        Buffer_Not_Full : Boolean;
        Buffer_Not_Empty : Boolean;
        Period :Duration;
        K : Duration;
        Thread : Pool_thread_Access;
    begin
        F.Set_Callable(C);
        F.Set_Completed(False);
        E.Get_Pool(P);
        P.Get_Keep_Alive_Time(K);
        E.Create(F, False, Thread);
        E.Get_Buffer (B);
        if (Thread /= null) then
            Thread.Initialize (F, B, P);
            return F;
        end if;
        Add(B,F,Buffer_Not_Full);
        if (Buffer_Not_Full) then
            return F;
        end if;
        Remove(B,Pop_F,Buffer_Not_Empty);
        if (Buffer_Not_Empty) then
            Add(B,F);
            F := Pop_F;
        end if;
        E.Create(F,True,Thread);
        Thread.Initialize (F, B, P);
        return F;
    end submit;
end Executors;
