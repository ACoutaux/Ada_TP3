with Future_Protected_Buffers; use Future_Protected_Buffers;
with Thread_Pools; use Thread_Pools;
with Futures; use Futures;
with Jobs; use Jobs;

package body Executors is

    protected body Executor is
       procedure Init(F : Buffer_Access; K : Integer; P : Thread_Pool_Access) is
       begin
          Futures := F;
          Keep_Alive_Time := K;
          Pool := P;
       end Init;
       
       --procedure get_callable_result(F : in Future; R : out Result_Access) is
       
       procedure Shutdown is
       begin
          Pool.Shutdown;
       end Shutdown;
       
       procedure Create
         (C : Callable_Access; F : Future; Force : Boolean; Done : out Boolean)
       is
       begin
          Pool.Create(C, F, Force, Done);
       end Create;

    end Executor;

    function Submit(E : Executor_Access; C : Callable_Access) return Future is
        F : Future;
        Done : Boolean;
    begin
        F.Callable := C;
        F.Completed := False;
        E.Create(C, F, False, Done);
        if (Done) then
            return F;
        end if;
        return F;
    end submit;
end Executors;
